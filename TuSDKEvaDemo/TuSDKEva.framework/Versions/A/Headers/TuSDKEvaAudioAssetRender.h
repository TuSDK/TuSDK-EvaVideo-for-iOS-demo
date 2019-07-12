//
//  TuSDKEvaAudioAssetRender.h
//  TuSDKEva
//
//  Created by sprint on 2019/6/10.
//  Copyright © 2019 TuSdk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TuSDKEvaAssetRender.h"
#import "TuSDKEvaAudioAsset.h"
#include "EvaAsset.hh"

NS_ASSUME_NONNULL_BEGIN

/**
 音频渲染
 @since v1.0.0
 */
@interface TuSDKEvaAudioAssetRender : NSObject <TuSDKEvaAssetRender>

/**
 初始化音频资产渲染器
 
 @param audioAsset 音频资产
 @return TuSDKEvaAudioAssetRender
 @sicne v1.0.0
 */
- (instancetype)initWithInputAudioAsset:(TuSDKEvaAudioAsset *)audioAsset;

/**
 输入的音频资源
 @since v1.0.0
 */
@property (nonatomic,readonly)TuSDKEvaAudioAsset *inputAudioAsset;

/**
 * 播放器的音频播放量，从0.0到1.0的线性范围。
 * @since  v1.0.0
 */
@property(nonatomic) float volume;

@end

NS_ASSUME_NONNULL_END
