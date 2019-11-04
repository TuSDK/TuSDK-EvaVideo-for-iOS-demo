//
//  DownLoadManager.m
//  TuSDKEvaDemo
//
//  Created by KK on 2019/9/25.
//  Copyright © 2019 TuSdk. All rights reserved.
//

#import "DownLoadManager.h"
#import "DownLoadFileModel.h"

#define kHost @"http://files.tusdk.com/eva/"
// 缓存主文件夹，所有下载下来的文件都放在这个文件夹下
#define kCacheDirectory [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"eva_cache_dir"]


@interface DownLoadManager()<NSURLSessionDataDelegate>

/** 正在下载的模板 */
@property (nonatomic, strong) NSMutableArray *downloadings;

/** 等待下载的模板 */
@property (nonatomic, strong) NSMutableArray *downWaitings;

/** session */
@property (nonatomic, strong) NSURLSession *session;

@end



@implementation DownLoadManager

static DownLoadManager *_manager;

+ (instancetype)defaultManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _manager = [[self alloc] init];
    });
    return _manager;
}

- (instancetype)init {
    if (self = [super init]) {
        NSFileManager *manager = [NSFileManager defaultManager];
        BOOL isDic = false;
        BOOL isDirExist = [manager fileExistsAtPath:kCacheDirectory isDirectory:&isDic];
        if (!isDic && !isDirExist) {
            //创建文件夹存放下载的文件
            [manager createDirectoryAtPath:kCacheDirectory withIntermediateDirectories:YES attributes:nil error:nil];
        }
        _maxDownloadCount = 3;
        [self addNotification];
    }
    return self;
}

#pragma mark - notification
- (void)addNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enterBackground) name:UIApplicationWillResignActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(becomeActivity) name:UIApplicationDidBecomeActiveNotification object:nil];
}

- (void)dealloc {
    // 移除监听
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)enterBackground {
    for (DownLoadFileModel *fileModel in self.downloadings) {
        // 取消下载
        [fileModel.dataTask cancel];
        fileModel.dataTask = nil;
        fileModel.status = DownloadStateStoped;
    }
    
    for (DownLoadFileModel *fileModel in self.downWaitings) {
        // 取消下载
        [fileModel.dataTask cancel];
        fileModel.dataTask = nil;
        fileModel.status = DownloadStateStoped;
    }
}

- (void)becomeActivity {
    
    NSMutableArray *allDownloads = [NSMutableArray array];
    [allDownloads addObjectsFromArray:self.downloadings];
    [allDownloads addObjectsFromArray:self.downWaitings];
    [self.downloadings removeAllObjects];
    [self.downWaitings removeAllObjects];
    
    for (DownLoadFileModel *fileModel in allDownloads) {
        // 继续下载
        [self downLoadWithFile:fileModel];
    }
}



#pragma mark - 任务管理
// 下载模板文件
- (void)downLoadWithFile:(DownLoadFileModel *)fileModel {
    
    // 创建任务
    if (fileModel.dataTask == nil) {
        fileModel.dataTask = [self creatDownloadTask:fileModel];
    }
    
    // 等待队列是否有
    if (self.downWaitings.count == 0 && self.downloadings.count < _maxDownloadCount) {
        if (![self.downloadings containsObject:fileModel]) {
            [self.downloadings addObject:fileModel];
        }
        [fileModel.dataTask resume];
        fileModel.status = DownloadStateResumed;
    } else {
        if (![self.downWaitings containsObject:fileModel]) {
            [self.downWaitings addObject:fileModel];
        }
        fileModel.status = DownloadStateWait;
    }
}


// stop
- (void)stopDownLoadWithFile:(DownLoadFileModel *)fileModel {
    if (fileModel.dataTask == nil) return;
    [fileModel.dataTask cancel];
    // 是否在下载队列，移除掉
    if ([self.downloadings containsObject:fileModel]) {
        [self.downloadings removeObject:fileModel];
    }
    
    // 是否在等待队列，移除掉
    if ([self.downWaitings containsObject:fileModel]) {
        [self.downWaitings removeObject:fileModel];
    }
    fileModel.dataTask = nil;
    fileModel.status = DownloadStateStoped;
}


// pause
- (void)pauseDownLoadWithFile:(DownLoadFileModel *)fileModel {
    [self stopDownLoadWithFile:fileModel];
//    if (fileModel.status != DownloadStateResumed && fileModel.status != DownloadStateWait) return;
//    if (fileModel.dataTask == nil) return;
//    [fileModel.dataTask suspend];
//    // 是否在下载队列，移除掉
//    if ([self.downloadings containsObject:fileModel]) {
//        [self.downloadings removeObject:fileModel];
//    }
//
//    // 是否在等待队列，移除掉
//    if ([self.downWaitings containsObject:fileModel]) {
//        [self.downWaitings removeObject:fileModel];
//    }
//    fileModel.status = DownloadStateStoped;
}


// 创建任务
- (NSURLSessionDataTask *)creatDownloadTask:(DownLoadFileModel *)fileModel {
    
    NSString *path = [NSString stringWithFormat:@"%@%@", kHost, fileModel.fileName];
    NSURL *url = [NSURL URLWithString:path];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    // 设置HTTP请求头中的Range
    if (fileModel.cacheLength == 0) {
        [fileModel temFilePath];
    }
    NSString *range = [NSString stringWithFormat:@"bytes=%zd-", fileModel.cacheLength];
    [request setValue:range forHTTPHeaderField:@"Range"];

    NSURLSessionDataTask *task = [self.session dataTaskWithRequest:request];
    return task;
}

// 根据task获取文件类型
- (DownLoadFileModel *)getFileModel:(NSURLSessionDataTask *)dataTask {
    for (DownLoadFileModel *fileModel in self.downloadings) {
        if (dataTask == fileModel.dataTask) {
            return fileModel;
        }
    }
    return nil;
}


#pragma mark - <NSURLSessionDataDelegate> 实现方法
/**
 * 接收到响应的时候：创建一个空的沙盒文件
 */
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler
{
    // 记录总长度
    DownLoadFileModel *fileModel = [self getFileModel:dataTask];
    NSHTTPURLResponse *response_ = (NSHTTPURLResponse *)response;
    if (response_.statusCode == 404) {
        // 文件长度为0,异常，不能下载
        [self stopDownLoadWithFile:fileModel];
        fileModel.status = DownloadStateErrorNotFoundResouse;
        return;
    }
    
    fileModel.fileLength = response.expectedContentLength + fileModel.cacheLength;
    fileModel.status = DownloadStateResumed;
    // 允许处理服务器的响应，才会继续接收服务器返回的数据
    completionHandler(NSURLSessionResponseAllow);
}

/**
 * 接收到具体数据：把数据写入沙盒文件中
 */
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data
{
    DownLoadFileModel *fileModel = [self getFileModel:dataTask];
    
    // 指定数据的写入位置 -- 文件内容的最后面
    [fileModel.fileHandle seekToEndOfFile];
    
    // 向沙盒写入数据
    [fileModel.fileHandle writeData:data];
    
    // 设置当前长度
    fileModel.cacheLength = fileModel.cacheLength + data.length;
}

/**
 *  下载完文件之后调用：关闭文件、清空长度
 */
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error
{
    DownLoadFileModel *fileModel = [self getFileModel:(NSURLSessionDataTask *)task];
    
    // 关闭fileHandle
    [fileModel.fileHandle closeFile];
    
    [self.downloadings removeObject:fileModel];
    // 通知结果
    if (error) {
        [fileModel reset];
    } else {
        // 完成回调
        fileModel.status = DownloadStateCompleted;
    }
    
    // 继续处理等待的
    if (self.downWaitings.count > 0) {
        DownLoadFileModel *fileModel = [self.downWaitings firstObject];
        [self.downWaitings removeObject:fileModel];
        [self.downloadings addObject:fileModel];
        [fileModel.dataTask resume];
    }
}



#pragma mark - getter setter
- (NSMutableArray *)downloadings {
    if (!_downloadings) {
        _downloadings = [NSMutableArray array];
    }
    return _downloadings;
}

- (NSMutableArray *)downWaitings {
    if (!_downWaitings) {
        _downWaitings = [NSMutableArray array];
    }
    return _downWaitings;
}


/**
 * session的懒加载
 */
- (NSURLSession *)session
{
    if (!_session) {
        _session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    }
    return _session;
}
@end
