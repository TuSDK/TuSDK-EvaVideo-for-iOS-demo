//
//  DownLoadFileModel.m
//  TuSDKEvaDemo
//
//  Created by KK on 2019/9/25.
//  Copyright © 2019 TuSdk. All rights reserved.
//

#import "DownLoadFileModel.h"
#import "DownLoadManager.h"
#import <CommonCrypto/CommonDigest.h>

// 缓存主文件夹，所有下载下来的文件都放在这个文件夹下
#define kCacheDirectory [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"eva_cache_dir"]

@interface DownLoadFileModel()

@end

@implementation DownLoadFileModel

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    if (self = [super init]) {
        if (dictionary) {
            _width = [[dictionary valueForKey:@"width"] integerValue];
            _height = [[dictionary valueForKey:@"height"] integerValue];
            _fileName = [dictionary valueForKey:@"path"];
            _image = [dictionary valueForKey:@"image"];
            _name = [dictionary valueForKey:@"name"];
            _filePath = [DownLoadFileModel checkDownLoadWithFile:_fileName];
            _status = _filePath != nil ? DownloadStateCompleted : DownloadStateNone;
        }
    }
    return self;
}



/// 重置方法
- (void)reset {
    _dataTask = nil;
    _fileHandle = nil;
    self.status = DownloadStateError;
    if (_temFilePath) {
       [[NSFileManager defaultManager] removeItemAtPath:_temFilePath error:nil];
        _temFilePath = nil;
    }
    // 标记也清除掉
    [DownLoadFileModel checkDownLoadWithFile:_fileName];
    _fileLength = 0;
    _cacheLength = 0;
}


#pragma mark - getter setter
/// 监听status改变
/// @param status 状态
- (void)setStatus:(DownloadState)status {
    _status = status;
    
    // 下载完成，赋值完整文件路径
    if (_status == DownloadStateCompleted) {
        _filePath = _temFilePath;
        [DownLoadFileModel saveDownloadFilePath:self];
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(downloadFileModel:statusChanged:)]) {
        [self.delegate downloadFileModel:self statusChanged:status];
    }
}


/// 监听下载长度改变
/// @param cacheLength 当前缓存长度
- (void)setCacheLength:(NSInteger)cacheLength {
    _cacheLength = cacheLength;
    if (_fileLength == 0) {
        return;
    }
    float progress = (float)cacheLength/(float)_fileLength;
    if (self.delegate && [self.delegate respondsToSelector:@selector(downloadFileModel:progressChanged:)]) {
        [self.delegate downloadFileModel:self progressChanged:progress];
    }
}


/// 获取临时文件
- (NSString *)temFilePath {
    if (!_temFilePath) {
        NSString *path = [NSString stringWithFormat:@"%@/%@", kCacheDirectory, _fileName];
        NSFileManager *fileManager = [[NSFileManager alloc] init]; // default is not thread safe
        if (![fileManager fileExistsAtPath:path]) {
            [fileManager createFileAtPath:path contents:nil attributes:nil];
        }
        _temFilePath = path;
        NSError *error = nil;
        NSDictionary *fileDict = [fileManager attributesOfItemAtPath:path error:&error];
        if (!error && fileDict) {
            _cacheLength = [fileDict fileSize];
        }
    }
    return _temFilePath;
}


/// 获取临时文件写入器
- (NSFileHandle *)fileHandle {
    if (!_fileHandle) {
        _fileHandle = [NSFileHandle fileHandleForWritingAtPath:self.temFilePath];
    }
    return _fileHandle;
}


#pragma mark - file本地保存与获取
// 查看模板文件
+ (NSString *)checkDownLoadWithFile:(NSString *)fileName {
    
    // 查看项目中是否有, 如果有，直接返回
    NSString *bundleString = [[NSBundle mainBundle] pathForResource:@"TuSDK" ofType:@"bundle"];
    NSString *file = [NSString stringWithFormat:@"%@/eva/%@", [[NSBundle bundleWithPath:bundleString] bundlePath], fileName];
    if ([[NSFileManager defaultManager] fileExistsAtPath:file]) {
        return file;
    }
    
    // 加密的key
    NSString *key = [self encryptFileNameWithMD5:fileName];
    
    // 本地是否有此路径
    file = [[NSUserDefaults standardUserDefaults] stringForKey:key];
    if (file == nil) {
        return nil;
    }
    
    // 本地缓存了链接，但实际文件不一定有，需要查看下
    NSFileManager *fileManager = [[NSFileManager alloc] init]; // default is not thread safe
    BOOL isFile = [fileManager fileExistsAtPath:file];
    if (!isFile) {
        [[NSUserDefaults standardUserDefaults] setValue:nil forKey:key];
        return nil;
    }
    return file;
}


/// 将下载好的文件路径保存到本地
/// @param fileModel 模板数据

+ (void)saveDownloadFilePath:(DownLoadFileModel *)fileModel {
    // 加密的key
    NSString *key = [self encryptFileNameWithMD5:fileModel.fileName];
    if (fileModel.filePath == nil) {
        return;
    }
    [[NSUserDefaults standardUserDefaults] setValue:fileModel.filePath forKey:key];
}


/**
 将文件名md5加密
 */
+ (NSString *)encryptFileNameWithMD5:(NSString *)str
{
    //要进行UTF8的转码
    const char* input = [str UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(input, (CC_LONG)strlen(input), result);
    
    NSMutableString *digest = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for (NSInteger i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [digest appendFormat:@"%02x", result[i]];
    }
    
    return digest;
}

@end
