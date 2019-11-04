//
//  TuSDKPlaceholderTextAsset.h
//  TuSDKEva
//
//  Created by sprint on 2019/5/30.
//  Copyright © 2019 TuSdk. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import "TuSDKEvaDocument.h"

/** 文本资源内容 @since v1.0.0 */
typedef NSString* TuSDKEvaAssetText;

/** 文字资源key @since v1.0.0 */
typedef NSString* TuSDKEvaTextAssetID;


NS_ASSUME_NONNULL_BEGIN

@class TuSDKEvaTemplate;

/**
 AE 模板文本占位资源
 */
@interface TuSDKEvaTextAsset : NSObject


/**
 初始化 TuSDKEvaImageAsset
 
 @param evaTemplate eva模板
 @param evaTextDocument eva text模板
 @return TuSDKEvaTextAsset
 @since v1.0.2
 */
- (instancetype)initWithEvaTemplate:(TuSDKEvaTemplate* _Nullable)evaTemplate evaTextDocument:(TuSDKEvaDocument *)document;


/**
 资源包目录
 @since v1.0.2
 */
@property (nonatomic, weak, readonly) TuSDKEvaTemplate* evaTemplate;

/**
 输入的 Eva 文字
 @since v1.0.0
 */
@property (nonatomic,readonly) TuSDKEvaDocument* document;

/**
 播放时长
 @since v1.0.2
 */
@property (nonatomic, assign, readonly) CMTime duration;

/**
 播放开始的时间
 @since v1.0.2
 */
@property (nonatomic, assign, readonly) CMTime startTime;

/**
 播放介绍的时间
 @since v1.0.2
 */
@property (nonatomic, assign, readonly) CMTime endTime;

/**
 资产id
 @since v1.0.2
 */
@property (nonatomic,readonly) TuSDKEvaTextAssetID assetId;


/**
 占位文本内容
 
 @since v1.0.0
 */
@property (nonatomic,copy,readonly) TuSDKEvaAssetText defaultAssetText;

/**
 最终展示的文本内容 默认： placeholderText
 
 @since v1.0.0
 */
@property (nonatomic,copy) TuSDKEvaAssetText text;

/**
 该资源是否为占位资源，资源可以替换
 
 @return true/false
 @since v1.0.0
 */
- (BOOL)isPlaceholderAsset;

@end

NS_ASSUME_NONNULL_END
