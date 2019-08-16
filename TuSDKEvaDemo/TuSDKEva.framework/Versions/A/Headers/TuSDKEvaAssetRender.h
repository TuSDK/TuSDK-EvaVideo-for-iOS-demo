//
//  TuSDKEvaAssetRender.h
//  TuSDKEva
//
//  Created by sprint on 2019/6/6.
//  Copyright © 2019 TuSdk. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
@class TuSDKEvaEngine;

NS_ASSUME_NONNULL_BEGIN

/**
 资产渲染器
 @since v1.0.0
 */
@protocol TuSDKEvaAssetRender <NSObject>

/**
 设置当前 Render 是否被启用
 @since v1.0.0
 */
@property (nonatomic) BOOL enableRender;

/**
 绘制一帧数据

 @param engine 当前引擎
 @since v1.0.0
 */
- (void)draw:(TuSDKEvaEngine *)engine;

/**
 快速切换视频帧
 
 @param time 帧时间
 @since v1.0.0
 */
- (void)seekTo:(CMTime)time engine:(TuSDKEvaEngine *)engine;

/**
 暂停渲染
 @since v1.0.0
 */
- (void)endDraw;


@end

NS_ASSUME_NONNULL_END
