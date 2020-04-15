//
//  TuSDKEvaPlayer.h
//  TuSDKEva
//
//  Created by sprint on 2019/6/4.
//  Copyright © 2019 TuSdk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TuSDKEvaImport.h"
#import "TuSDKEvaTemplate.h"

@protocol TuSDKEvaPlayerDelegate, TuSDKEvaPlayerLoadDelegate, TuSDKEvaPlayerExtractDelegate;

NS_ASSUME_NONNULL_BEGIN

/**
 EVA 播放器，用以加载播放 AE 模板
 @since v1.0.0
 */
@interface TuSDKEvaPlayer : NSObject <TuSDKMediaPlayer>

/**
 初始化
 
 @param evaTemplate AE 模板
 @return TuSDKEvaPlayer
 @since v1.0.0
 */
- (instancetype)initWithEvaTemplate:(TuSDKEvaTemplate *)evaTemplate inHolderView:(UIView *)holderView;

/**
 总输出时长
 @since v1.0.0
 */
@property (nonatomic,readonly) CMTime durationTime;

/**
 播放第一帧的开始时间,如果设置了预览时间范围的开始时间大于0，则需要传人该值，该值为预览的开始时间
 @since v1.2.2
 */
@property (nonatomic,readonly) CMTime firstFrameStartTime;

/**
 EvaPlayer 事件委托
 @since     v1.0.0
 */
@property (nonatomic,weak) id<TuSDKEvaPlayerDelegate> _Nullable delegate;

/**
 EvaPlayer 加载资源事件委托
 @since     v1.0.0
 */
@property (nonatomic,weak) id<TuSDKEvaPlayerLoadDelegate> _Nullable loadDelegate;

/**
 设置帧数值数组，可以通过该帧数值，可以用来获取该帧数值下的视频帧图片，目的：为了实时展示模版视频的缩略图。
 举例：取10张：_currentFrames = @[@(30),@(60),@(90),@(120),@(150),@(180),@(210),@(240),@(270),@(300)];
 @since v1.2.4
 */
@property (nonatomic,strong) NSArray <NSNumber *> *extractedAllFrameValues;

/**
 EvaPlayer 截帧事件委托（从绘制帧数据中截取视频帧回调）,该回调 需设置 extractedAllFrameValues
 @since     v1.2.4
 */
@property (nonatomic,weak) id<TuSDKEvaPlayerExtractDelegate> _Nullable extractDelegate;

/**
 当前视频播放器状态
 @since v1.0.0
 */
@property (atomic,readonly) TuSDKMediaPlayerStatus status;

/**
 设置输出音量 默认：1
 @since v1.0.0
 */
@property (nonatomic) float volume;

/**
 @property processQueue
 @discussion
 Decoding run queue
 @since v1.0.0
 */
@property (nonatomic, strong) dispatch_queue_t _Nullable processQueue;

/**
 重新加载模板.
 如果替换了模板内容需要调用 reloadTemplate 重新加载模板内容
 @since  v1.0.0
 */
- (void)reloadTemplate;

/**
 重置预览时间范围
 @since v1.2.2
 */
- (void)resetPreviewTimeRange;

@end


#pragma mark TuSDKEvaPlayerDelegate

@protocol TuSDKEvaPlayerDelegate <NSObject>

@required

/**
 进度改变事件
 
 @param player 当前播放器
 @param percent (0 - 1)
 @param outputTime 当前帧所在持续时间
 @since v1.0.0
 */
- (void)evaPlayer:(TuSDKEvaPlayer *_Nonnull)player progressChanged:(CGFloat)percent outputTime:(CMTime)outputTime;

/**
 播放器状态改变事件
 
 @param player 当前播放器
 @param status 当前播放器状态
@since      v1.0.0
 */
- (void)evaPlayer:(TuSDKEvaPlayer *_Nonnull)player statusChanged:(TuSDKMediaPlayerStatus)status;

@end


@protocol TuSDKEvaPlayerLoadDelegate <NSObject>

/**
 进度改变事件
 
 @param player 当前播放器
 @param percent (0 - 1)
 @since v1.0.0
 */
- (void)evaPlayer:(TuSDKEvaPlayer *_Nonnull)player loadProgressChanged:(CGFloat)percent;

/**
 播放器状态改变事件
 
 @param player 当前播放器
 @param status 当前播放器状态
 @since      v1.0.0
 */
- (void)evaPlayer:(TuSDKEvaPlayer *_Nonnull)player loadStatusChanged:(TuSDKMediaPlayerLoadStatus)status;

@end

/**
EvaPlayer 截帧事件委托（从绘制帧数据中截取视频帧回调）,该回调 需设置 currentFrames
@since     v1.2.4
*/
@protocol TuSDKEvaPlayerExtractDelegate <NSObject>

@optional
/**
 截取播放器的视频帧，该帧图片是在播放中实时获取的
 
 @param player 当前播放器
 @param currentFrame 当前帧数值
 @param outputTime 当前播放时间值
 @param currentFrameImage 当前帧数值下的截帧图片
 @since v1.2.4
 */
- (void)evaPlayer:(TuSDKEvaPlayer *_Nonnull)player currentFrame:(CGFloat)currentFrame currentOutputTime:(CMTime)outputTime currentFrameImage:(UIImage *)currentFrameImage;

@end

NS_ASSUME_NONNULL_END
