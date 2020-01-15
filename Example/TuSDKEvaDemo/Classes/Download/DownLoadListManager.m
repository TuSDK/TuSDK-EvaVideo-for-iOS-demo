//
//  DownLoadListData.m
//  TuSDKEvaDemo
//
//  Created by tutu on 2019/12/26.
//  Copyright © 2019 TuSdk. All rights reserved.
//

#import "DownLoadListManager.h"
#import <UIKit/UIKit.h>
#import <ImageIO/ImageIO.h>
#define evaHost @"http://files.tusdk.com/eva/"

@interface DownLoadListManager ()

@property (nonatomic,strong) NSMutableArray *listArr;
@end

@implementation DownLoadListManager

static DownLoadListManager *_manager;

+ (instancetype)manager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _manager = [[self alloc] init];
    });
    return _manager;
}

- (NSMutableArray *)listArr{
    if (!_listArr) {
        _listArr = [NSMutableArray array];
    }
    return _listArr;
}

- (void)downLoadFileCompletionHandler:(void (^)(NSMutableArray *modelArr))handler;{
    
    // 从服务器上读取
    //NSURL* url = [NSURL URLWithString:@"http://files.tusdk.com/eva/139.jpg"];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@eva.json",evaHost]];
    // 得到session对象
    NSURLSession* session = [NSURLSession sharedSession];
    // 创建任务
    NSURLSessionDownloadTask* downloadTask = [session downloadTaskWithURL:url completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
        
//        NSLog(@"error--%@",error);
//        NSLog(@"location---%@",location);
//        NSLog(@"response---%@",response.suggestedFilename);
//        NSLog(@"location.path---%@",location.path);
        
        //将文件迁移到指定路径下
        NSString *caches = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
        NSString *filePath = [caches stringByAppendingPathComponent:response.suggestedFilename];
        // 将临时文件剪切或者复制Caches文件夹
        NSFileManager *fileManager = [NSFileManager defaultManager];
//        NSLog(@"filePath:%@",filePath);
        // 缓存数组
        NSMutableArray *cacheArr = [NSMutableArray array];
        
        if (error) {//无网络情况下，用之前下载的数据
            filePath = [caches stringByAppendingPathComponent:@"eva.json"];
            if([[NSFileManager defaultManager] fileExistsAtPath:filePath]){//存在
                cacheArr = [self returnListsWithFilepath:filePath];
                self.listArr = [self generateListArr:cacheArr];
            }
            handler(self.listArr);
            return ;
        }
  
        // 会被干掉的临时数据
        NSMutableArray *tmpArr = [self returnListsWithFilepath:location.path];

        if([[NSFileManager defaultManager] fileExistsAtPath:filePath]){//存在
            // 缓存起来的本地数据
            NSMutableArray *cacheArr = [self returnListsWithFilepath:filePath];
            // 比较缓存的数据与线上数据是否一致，不一致更新isChange
            [tmpArr enumerateObjectsUsingBlock:^(NSMutableDictionary *tmpDic, NSUInteger idx, BOOL * _Nonnull stop) {
                NSString *tmpIdStr = [NSString stringWithFormat:@"%@",tmpDic[@"id"]];
                NSString *tmpVStr = [NSString stringWithFormat:@"%@",tmpDic[@"v"]];
//                if (tmpIdStr.integerValue == 42 || tmpIdStr.integerValue == 43) {
//                    tmpVStr = @"57739f7fb3fd9d8e7249db1bf490d33a";
//                }
                [cacheArr enumerateObjectsUsingBlock:^(NSMutableDictionary *cacheDic, NSUInteger idx, BOOL * _Nonnull stop) {
                    NSString *cacheIdStr = [NSString stringWithFormat:@"%@",cacheDic[@"id"]];
                    NSString *cacheVStr = [NSString stringWithFormat:@"%@",cacheDic[@"v"]];

                    if ([tmpIdStr isEqualToString:cacheIdStr]) {

                        if (![tmpVStr isEqualToString:cacheVStr]) {

                            [tmpDic setValue:@(YES) forKeyPath:@"isChange"];
                        }else{

                            [tmpDic setValue:@(NO) forKeyPath:@"isChange"];
                        }
                        *stop = YES;
                    }
                }];
            }];
            // 之前存储的文件要先移除，后面的临时文件才能移动到该沙盒路径下存储，达到更新数据的目的
            [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
        }
        //NSLog(@"tmpArr---%@",tmpArr);
        // AtPath : 剪切前的文件路径
        // ToPath : 剪切后的文件路径
        [fileManager moveItemAtPath:location.path toPath:filePath error:nil];
        self.listArr = [self generateListArr:tmpArr];
        handler(self.listArr);
      
    }];
    // 开始任务
    [downloadTask resume];
}


- (NSMutableArray *)generateListArr:(NSArray *)cacheArr{
    
    NSMutableArray *listArr = [NSMutableArray array];
    @autoreleasepool {
        for (NSDictionary *dic in cacheArr) {
            NSMutableDictionary *listDic = [NSMutableDictionary dictionary];
            NSString *idStr = dic[@"id"];
            NSString *evaStr = [NSString stringWithFormat:@"lsq_eva_%@.eva",idStr];
            NSString *name = dic[@"nm"];
            NSString *imageURL = [NSString stringWithFormat:@"%@%@.jpg",evaHost,idStr];
            
            [listDic setValue:name forKey:@"name"];
            [listDic setValue:evaStr forKey:@"path"];
            [listDic setValue:@(450) forKey:@"width"];
            [listDic setValue:@(800) forKey:@"height"];
            [listDic setValue:imageURL forKey:@"image"];
            [listDic setValue:dic[@"isChange"] forKey:@"isChange"];
            [listArr addObject:listDic];
        }
    }
    return listArr;
}

- (NSMutableArray *)returnListsWithFilepath:(NSString *)filepath{
    
    NSString *optionListStr = [NSString stringWithContentsOfFile:filepath encoding:NSUTF8StringEncoding error:nil];
    NSData *optionListData = [optionListStr dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableArray *listArr = [NSJSONSerialization JSONObjectWithData:optionListData options:NSJSONReadingMutableContainers error:nil];
    return listArr;
}

@end
