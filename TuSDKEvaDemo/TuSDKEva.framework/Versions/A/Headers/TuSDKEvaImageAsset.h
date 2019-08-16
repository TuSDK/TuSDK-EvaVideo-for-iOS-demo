//
//  TuSDKEvaAsset.h
//  TuSDKEva
//
//  Created by sprint on 2019/5/30.
//  Copyright © 2019 TuSdk. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#include "EvaAsset.hh"

/** 图片资源key @since v1.0.0 */
typedef NSString* TuSDKEvaImageAssetID;
/** 图片资源名称完整路径 @since v1.0.0 */
typedef NSURL* TuSDKEvaImageAssetURL;

NS_ASSUME_NONNULL_BEGIN

@class TuSDKEvaTemplate;

/**
 AE 模板图片占位资源
 */
@interface TuSDKEvaImageAsset : NSObject

/**
 初始化 TuSDKEvaImageAsset

 @param evaTemplate eva模板
 @return TuSDKEvaImageAsset
 @since v1.0.0
 */
- (instancetype)initWithEvaTemplate:(TuSDKEvaTemplate*)evaTemplate evaImageAsset:(tutu::EvaImageAssetPtr)evaImageAsset;

/**
 输入的 Eva 图片
 @since v1.0.0
 */
@property (nonatomic,readonly) tutu::EvaImageAssetPtr inputEvaImageAssetPtr;

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
