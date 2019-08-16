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

@protocol TuSDKEvaPlayerDelegate, TuSDKEvaPlayerLoadDelegate;

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
 当前视频播放器状态
 @since v1.0.0
 */
@property (atomic,readonly) TuSDKMediaPlayerStatus status;

/**
 设置输出音量 默认：1
 @since v1.0.0
 */
@property (nonatomic) CGFloat volume;

/**
 @property processQueue
 @discussion
 Decoding run queue
 @since v1.0.0
 */
@property (nonatomic) dispatch_queue_t _Nullable processQueue;

/**
 重新加载模板.
 如果替换了模板内容需要调用 reloadTemplate 重新加载模板内容
 @since  v1.0.0
 */
- (void)reloadTemplate;

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

NS_ASSUME_NONNULL_END
