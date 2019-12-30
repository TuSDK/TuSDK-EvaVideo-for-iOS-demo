//
//  DownLoadFileModel.h
//  TuSDKEvaDemo
//
//  Created by KK on 2019/9/25.
//  Copyright © 2019 TuSdk. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/** 下载的状态 */
typedef NS_ENUM(NSInteger, DownloadState) {
    DownloadStateNone = 0,      // 还没下载
    DownloadStateResumed,       // 下载中
    DownloadStateWait,          // 等待中
    DownloadStateStoped,        // 暂停中
    DownloadStateCompleted,     // 已经完全下载完毕
    DownloadStateError,         // 下载出错
    DownloadStateErrorNotFoundResouse          // 下载出错
};


@class DownLoadFileModel;
@protocol DownLoadFileModelDelegate <NSObject>

// 进度通知
- (void)downloadFileModel:(DownLoadFileModel *)fileModel progressChanged:(float)progress;

// 状态通知
- (void)downloadFileModel:(DownLoadFileModel *)fileModel statusChanged:(DownloadState)status;

@end




@interface DownLoadFileModel : NSObject

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

/** 代理 */
@property (nonatomic, weak) id<DownLoadFileModelDelegate> delegate;

/** 模版是否更新*/
@property (nonatomic, assign, readonly) BOOL isChange;

/** 图片地址 */
@property (nonatomic, strong, readonly) NSString *image;

/** 模板名称 */
@property (nonatomic, strong, readonly) NSString *name;

/** 模板路径名称 */
@property (nonatomic, strong, readonly) NSString *fileName;

/** 模板地址 */
@property (nonatomic, strong, readonly) NSString *filePath;

/** 模板宽度 */
@property (nonatomic, assign, readonly) NSInteger width;

/** 模板高度 */
@property (nonatomic, assign, readonly) NSInteger height;

/** 下载状态 */
@property (nonatomic, assign) DownloadState status;

/** 临时下载文件地址 */
@property (nonatomic, strong) NSString *temFilePath;

/** 文件写入器 */
@property (nonatomic, strong) NSFileHandle *fileHandle;

/** 下载任务器 */
@property (nonatomic, strong, nullable) NSURLSessionDataTask *dataTask;

/** 文件总长度 */
@property (nonatomic, assign) NSInteger fileLength;

/** 当前缓冲的总长度 */
@property (nonatomic, assign) NSInteger cacheLength;


/// 失败后重置数据
- (void)reset;
@end

NS_ASSUME_NONNULL_END
