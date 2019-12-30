//
//  TuSDKEvaImageAssetRender.h
//  TuSDKEva
//
//  Created by sprint on 2019/6/6.
//  Copyright © 2019 TuSdk. All rights reserved.
//

#import "TuSDKEvaAssetRender.h"
#import "TuSDKEvaImageAsset.h"
#include "EvaImageImpl.hh"
#include "EvaAsset.hh"
#import "TuSDKEvaMediaAsset.h"

NS_ASSUME_NONNULL_BEGIN

/**
 图片资产渲染器
 @sicne v1.0.0
 */
@interface TuSDKEvaImageAssetRender : NSObject <TuSDKEvaAssetRender>

/**
 初始化图片资产渲染器

 @param imageAsset 图片资产
 @return TuSDKEvaImageAssetRender
 @sicne v1.0.0
 */
- (instancetype)initWithInputImageAsset:(TuSDKEvaImageAsset *)imageAsset;

/**
 输入的图片资源
 @since v1.0.0
 */
@property (nonatomic,readonly) TuSDKEvaImageAsset *inputImageAsset;

/**
 imageAsset 图片资产图片指针
 @since v1.0.0
 */
@property (nonatomic, readonly) tutu::EvaImageImplPtr evaImagePtr;

/**
 imageAsset 资产图片
 @since v1.0.0
 */
@property (nonatomic, strong, readonly) TuSDKEvaMediaAsset *evaMediaAsset;

@end

NS_ASSUME_NONNULL_END
