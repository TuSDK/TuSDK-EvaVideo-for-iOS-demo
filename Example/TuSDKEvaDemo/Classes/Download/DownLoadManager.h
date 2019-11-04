//
//  DownLoadManager.h
//  TuSDKEvaDemo
//
//  Created by KK on 2019/9/25.
//  Copyright © 2019 TuSdk. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class DownLoadFileModel;
@interface DownLoadManager : NSObject

+ (instancetype)defaultManager;

/** 最大并发下载量，默认三个 */
@property (nonatomic, assign) NSInteger maxDownloadCount;

// download
- (void)downLoadWithFile:(DownLoadFileModel *)fileModel;

// stop
- (void)stopDownLoadWithFile:(DownLoadFileModel *)fileModel;

// pause
- (void)pauseDownLoadWithFile:(DownLoadFileModel *)fileModel;

@end

NS_ASSUME_NONNULL_END
