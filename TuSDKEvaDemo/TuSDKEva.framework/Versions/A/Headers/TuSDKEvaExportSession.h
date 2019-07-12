//
//  TuSDKEvaTemplateExportSession.h
//  TuSDKEva
//
//  Created by sprint on 2019/6/3.
//  Copyright © 2019 TuSdk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TuSDKEvaExportSession.h"
#import "TuSDKEvaImport.h"
#import "TuSDKEvaTemplate.h"
#import "TuSDKEvaExportSessionSettings.h"

@protocol TuSDKEvaExportSessionDelegate;

NS_ASSUME_NONNULL_BEGIN

/**
 EVA 模板视频导出
 @since v1.0.0
 */
@interface TuSDKEvaExportSession : NSObject

/**
 初始化
 
 @param evaTemplate AE 模板
 @return TuSDKEvaExportSession
 @since v1.0.0
 */
- (instancetype)initWithEvaTemplate:(TuSDKEvaTemplate *)evaTemplate exportOutputSettings:(nullable TuSDKEvaExportSessionSettings * )exportOutputSettings;

/**
 TuSDKEvaExportSession 事件委托
 @since     v1.0.0
 */
@property (nonatomic,weak) id<TuSDKEvaExportSessionDelegate> _Nullable delegate;

/**
 当前状态
 @since      v3.0
 */
@property (nonatomic,readonly)TuSDKMediaExportSessionStatus status;

/**
 开始导出
 @since     v1.0.0
 */
- (void)startExport;

/**
 完成导出
 @since     v1.0.0
 */
- (void)stopExport;

/**
 取消导出
 @since     v1.0.0
 */
- (void)cancelExport;

/**
 销毁
 @since v1.0.0
 */
- (void)destory;

@end

#pragma mark TuSDKEvaExportSessionDelegate

@protocol TuSDKEvaExportSessionDelegate <NSObject>

@required

/**
 进度改变事件
 
 @param exportSession TuSDKEvaExportSession
 @param percent (0 - 1)
 @param outputTime 当前帧所在持续时间
 @since      v1.0.0
 */
- (void)mediaEvaExportSession:(TuSDKEvaExportSession *_Nonnull)exportSession progressChanged:(CGFloat)percent outputTime:(CMTime)outputTime;

/**
 播放器状态改变事件
 
 @param exportSession 当前
 @param status 当前导出状态
 @since      v1.0.0
 */
- (void)mediaEvaExportSession:(TuSDKEvaExportSession *_Nonnull)exportSession statusChanged:(TuSDKMediaExportSessionStatus)status;

/**
 播放器状态改变事件
 
 @param exportSession 当前
 @param result TuSDKVideoResult
 @param error 错误信息
 @since      v1.0.0
 */
- (void)mediaEvaExportSession:(TuSDKEvaExportSession *_Nonnull)exportSession result:(TuSDKVideoResult *_Nonnull)result error:(NSError *_Nonnull)error;

@end

NS_ASSUME_NONNULL_END
