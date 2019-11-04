//
//  TuSDKEvaDocument.h
//  TuSDKEva
//
//  Created by tutu on 2019/7/5.
//  Copyright © 2019 TuSdk. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TuSDKEvaDocument : NSObject

/**
 开始帧
 */
@property (nonatomic, assign) float startFrame;

/**
 结束关键帧
 */
@property (nonatomic, assign) float endFrame;

/**
 内容
 */
@property (nonatomic, strong) NSString *text;

/**
 是否的可替换标识
 */
@property (nonatomic, strong) NSString *refid;

/**
 唯一标识id
 */
@property (nonatomic, strong) NSString *fid;

@end

NS_ASSUME_NONNULL_END
