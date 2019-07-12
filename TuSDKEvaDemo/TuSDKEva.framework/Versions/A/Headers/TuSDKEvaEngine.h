//
//  TuSDKEvaEngine.h
//  TuSDKEva
//
//  Created by sprint on 2019/6/3.
//  Copyright © 2019 TuSdk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TuSDKEvaImport.h"
#import "TuSDKEvaTemplate.h"

NS_ASSUME_NONNULL_BEGIN

/**
 EVA 引擎，用以加载 AE 模板
 @since v1.0.0
 */
@interface TuSDKEvaEngine : NSObject

/**
 初始化 TuSDKEvaEngine

 @param evaTemplate AE 模板
 @return TuSDKEvaEngine
 @since v1.0.0
 */
- (instancetype)initWithEvaTemplate:(TuSDKEvaTemplate *)evaTemplate;

/**
 引擎持有的 Eva 模板
 @since v1.0.0
 */
@property (nonatomic,readonly)TuSDKEvaTemplate *evaTemplate;

/**
 加载引擎
 @since v1.0.0
 */
- (void)load;

/**
 添加接收者

 @param newTarget 接收者
 @param textureLocation
 @since v1.0.0
 */
- (void)addTarget:(id<SLGPUImageInput>)newTarget atTextureLocation:(NSInteger)textureLocation;

/**
 设置当前引擎进度
 @since v1.0.0
 */
@property (nonatomic,readonly)CGFloat progress;

/**
 输出尺寸
 @since v1.0.0
 */
@property (nonatomic,readonly)CGSize canvasSize;

/**
 帧持续时间
 @since v1.0.0
 */
@property (nonatomic,readonly)CMTime frameDuration;

/**
 帧率
 @since v1.0.0
 */
@property (nonatomic,readonly)CGFloat frameRate;

/**
 总时长
 @since v1.0.0
 */
@property (nonatomic,readonly)CMTime durationTime;

/**
 当前播放时长
 @since v1.0.0
 */
@property (nonatomic,readonly)CMTime outputTime;

/**
 获取当前引擎已播放的总帧数
 
 @since v1.0.0
 */
@property (nonatomic,readonly)CGFloat outputFrames;

/**
 根据帧索引计算帧时间

 @param frameIndex 帧索引
 @return 帧所在时间
 @since v1.0.0
 */
- (CMTime)frameTimeAtFrameIndex:(NSUInteger)frameIndex;

/**
 绘制指定帧

 @param time 帧时间
 @since v1.0.0
 */
- (void)draw:(CMTime)time;

/**
 通知绘制结束
 
 @since v1.0.0
 */
- (void)endDraw;

@end


// TuSDKEvaEngine 委托事件

#pragma mark TuSDKEvaEngineDelegateDelegate

@protocol TuSDKEvaEngineDelegate  <NSObject>


@end

NS_ASSUME_NONNULL_END
