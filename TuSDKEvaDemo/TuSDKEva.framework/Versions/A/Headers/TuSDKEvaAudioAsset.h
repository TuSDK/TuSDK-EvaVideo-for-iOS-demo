//
//  TuSDKEvaAudioAsset.h
//  TuSDKEva
//
//  Created by sprint on 2019/6/10.
//  Copyright © 2019 TuSdk. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#include "EvaAsset.hh"

/** 音频资源key @since v1.0.0 */
typedef NSString* TuSDKEvaAudioAssetID;
/** 音频资源名称完整路径 @since v1.0.0 */
typedef NSURL* TuSDKEvaAudioAssetURL;


NS_ASSUME_NONNULL_BEGIN

@class TuSDKEvaTemplate;

@interface TuSDKEvaAudioAsset : NSObject

/**
 EvaImageAsset
 
 @param evaTemplate 资源模板
 @return TuEvaSDKImageAsset
 */
- (instancetype)initWithEvaTemplate:(TuSDKEvaTemplate* )evaTemplate evaAudioAsset:(tutu::EvaAudioAssetPtr)evaAudioAsset;

/**
 资源模板
 @since v1.0.0
 */
@property (nonatomic, weak, readonly)TuSDKEvaTemplate* evaTemplate;


/**
 是否替换了
 @since v1.0.0
 */
@property (nonatomic, assign, readonly) BOOL isReplace;

/**
 输入的 Eva 音效
 @since v1.0.0
 */
@property (nonatomic,readonly) tutu::EvaAudioAssetPtr inputEvaAudioAssetPtr;

/**
 资产id
 @since v1.0.0
 */
@property (nonatomic,readonly) TuSDKEvaAudioAssetID assetId;

/**
 资源完整路径
 @since v1.0.0
 */
@property (nonatomic) TuSDKEvaAudioAssetURL assetURL;

/**
 默认资源完整路径
 @since v1.0.0 ([NSURL fileURLWithPath])
 */
@property (nonatomic,readonly) TuSDKEvaAudioAssetURL defaultAssetURL;

/**
 标记是否需要重新加载模板
 @since v1.0.0
 */
@property (nonatomic) BOOL needRelaod;

/**
 该资源是否为占位资源，资源可以替换
 
 @return true/false
 @since v1.0.0
 */
- (BOOL)isPlaceholderAsset;

/* 请求音频资产

@param resultHandler 完成回调
@since v1.0.0
*/
- (void)requestAssetAudioWithResultHandler:(void (^)(AVAsset *__nullable asset))resultHandler;
@end

NS_ASSUME_NONNULL_END
