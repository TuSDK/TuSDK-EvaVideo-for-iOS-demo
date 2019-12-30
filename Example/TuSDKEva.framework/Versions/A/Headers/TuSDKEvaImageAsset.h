//
//  TuSDKEvaAsset.h
//  TuSDKEva
//
//  Created by sprint on 2019/5/30.
//  Copyright © 2019 TuSdk. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#include "EvaAsset.hh"
#import "TuSDKEvaMediaAsset.h"

FOUNDATION_EXPORT NSString * const KTuSDKPlaceholderImagePrefixKey;
FOUNDATION_EXPORT NSString * const KTuSDKPlaceholderVideoPrefixKey;

FOUNDATION_EXPORT NSString * const KTuSDKPlaceholderMediaPrefixKey;
FOUNDATION_EXPORT NSString * const KTuSDKPlaceholderMaskVVideoPrefixKey;

FOUNDATION_EXPORT NSString * const KTuSDKPlaceholderMaskHVideoPrefixKey;


/** 图片资源key @since v1.0.0 */
typedef NSString* TuSDKEvaImageAssetID;
/** 图片资源名称完整路径 @since v1.0.0 */
typedef NSURL* TuSDKEvaImageAssetURL;


/** mask填充方向 @since v1.0.2 */
typedef enum TuSDKEvaMaskVideoOrientation: NSUInteger {
    TuSDKEvaMaskVideoOrientationNone = 0, // 没有
    TuSDKEvaMaskVideoOrientationHorizontal, // 横向
    TuSDKEvaMaskVideoOrientationVertical, // 纵向
} TuSDKEvaMaskVideoOrientation;

NS_ASSUME_NONNULL_BEGIN

@class TuSDKEvaTemplate;

/**
 AE 模板图片占位资源
 */
@interface TuSDKEvaImageAsset : NSObject

/**
 初始化 TuSDKEvaImageAsset

 @param evaTemplate eva模板
 @param evaMediaAsset eva资源
 @return TuSDKEvaImageAsset
 @since v1.2.2
 */
- (instancetype)initWithEvaTemplate:(TuSDKEvaTemplate*)evaTemplate evaMediaAsset:(TuSDKEvaMediaAsset *)evaMediaAsset;

/**
 mediaAsset
 @since v1.2.2
 */
@property (nonatomic, strong, readonly) TuSDKEvaMediaAsset *evaMediaAsset;

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
 开始帧位置
 @since v1.2.2
 */
@property (nonatomic, assign, readonly) int startFrame;

/**
 结束帧位置
 @since v1.2.2
*/
@property (nonatomic, assign, readonly) int endFrame;

/**
 资产id
 @since v1.0.0
 */
@property (nonatomic,readonly) TuSDKEvaImageAssetID assetId;

/**
 资源包目录
 @since v1.0.0
 */
@property (nonatomic, weak, readonly) TuSDKEvaTemplate* evaTemplate;


/**
 是否替换了
 @since v1.0.0
 */
@property (nonatomic, assign, readonly) BOOL isReplace;

/**
 资源完整路径
 @since v1.0.0 ([NSURL fileURLWithPath])
 */
@property (nonatomic) TuSDKEvaImageAssetURL assetURL;

/**
 标记是否需要重新加载模板
 @since v1.0.0
 */
@property (nonatomic)BOOL needRelaod;

/**
 默认资源完整路径
 @since v1.0.0 ([NSURL fileURLWithPath])
 */
@property (nonatomic,readonly) TuSDKEvaImageAssetURL defaultAssetURL;

/**
 资产宽高
 @since v1.0.0
 */
@property (nonatomic,readonly)CGSize size;

/**
 该资源是否为占位资源，资源可以替换
 
 @return true/false
 @since v1.0.0
 */
- (BOOL)isPlaceholderAsset;

/**
 是否为图像资源
 
 @return true/false
 @since v1.0.0
 */
- (BOOL)isPlaceholderImageAsset;

/**
 是否为图像资源
 
 @return true/false
 @since v1.0.0
 */
- (BOOL)isPlaceholderVideoAsset;


/**
是否需要裁剪拼接alpha通道

@return true/false
@since v1.0.2
*/
- (BOOL)isPlaceholderMaskVideoAsset;


/**
mask视频的填充方向

@return TuSDKEvaMaskVideoOrientation
@since v1.0.2
*/
- (TuSDKEvaMaskVideoOrientation)maskOrientation;

/**
 该资产是否需要 Video 渲染器
 @since v1.0.0
 */
- (BOOL)needVideoRenderer;

/**
 请求图片资产

 @param resultHandler 完成回调
 @since v1.0.0
 */
- (void)requestImageWithResultHandler:(void (^)(UIImage *__nullable result))resultHandler;

 /**
  请求视频资产

  @param resultHandler 完成回调
  @since v1.0.0
  */
 - (void)requestAVAssetVideoWithResultHandler:(void (^)(AVAsset *__nullable asset))resultHandler;
@end

NS_ASSUME_NONNULL_END
