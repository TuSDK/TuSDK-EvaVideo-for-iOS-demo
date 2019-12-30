//
//  DownLoadListData.h
//  TuSDKEvaDemo
//
//  Created by tutu on 2019/12/26.
//  Copyright © 2019 TuSdk. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DownLoadListManager : NSObject

+ (instancetype)manager;

- (void)downLoadFileCompletionHandler:(void (^)(NSMutableArray *modelArr))handler;

@end

NS_ASSUME_NONNULL_END
