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

@protocol TuSDKEvaEngineDelegate;

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
@property (nonatomic, strong, readonly) TuSDKEvaTemplate *evaTemplate;

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
@property (nonatomic,readonly) CGFloat progress;

/**
 输出尺寸
 @since v1.0.0
 */
@property (nonatomic,readonly) CGSize canvasSize;

/**
 帧持续时间
 @since v1.0.0
 */
@property (nonatomic,readonly) CMTime frameDuration;

/**
 帧率
 @since v1.0.0
 */
@property (nonatomic,readonly) CGFloat frameRate;

/**
 总时长
 @since v1.0.0
 */
@property (nonatomic,readonly) CMTime durationTime;

/**
 当前播放时长
 @since v1.0.0
 */
@property (nonatomic,readonly) CMTime outputTime;

/**
 获取当前引擎已播放的总帧数
 
 @since v1.0.0
 */
@property (nonatomic,readonly) CGFloat outputFrames;

/**
 获取当前渲染需要的时间
 
 @since v1.0.2
 */
@property (nonatomic,readonly) CGFloat drawDuration;

/**
 设置帧数值数组，可以通过该帧数值，可以用来获取该帧数值下的视频帧图片，目的：为了实时展示模版视频的缩略图。
 举例：取10张：_currentFrames = @[@(30),@(60),@(90),@(120),@(150),@(180),@(210),@(240),@(270),@(300)];
 @since v1.2.4
 */
@property (nonatomic,strong,readwrite) NSArray <NSNumber *> *extractedAllFrameValues;

/**
 获取当前渲染截帧图片
 
 @since v1.2.4
 */
@property (nonatomic,readonly) UIImage *outputFrameImage;

/**
 EvaEngine 截帧事件委托（从绘制帧数据中截取视频帧回调）,该回调 需设置 extractedAllFrameValues
 @since     v1.2.4
 */
@property (nonatomic,weak) id<TuSDKEvaEngineDelegate> _Nullable delegate;

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

#pragma mark TuSDKEvaEngineDelegate

@protocol TuSDKEvaEngineDelegate  <NSObject>

@optional
/**
 截取模版处理引擎的视频帧，该帧图片是在播放中实时获取的
 
 @param player 当前模版处理引擎
 @param currentFrame 当前帧数值
 @param outputTime 当前播放时间值
 @param currentFrameImage 当前帧数值下的截帧图片
 @since v1.2.4
 */
- (void)evaEngine:(TuSDKEvaEngine *_Nonnull)engine currentFrame:(CGFloat)currentFrame currentOutputTime:(CMTime)outputTime currentFrameImage:(UIImage *)currentFrameImage;

@end

NS_ASSUME_NONNULL_END
