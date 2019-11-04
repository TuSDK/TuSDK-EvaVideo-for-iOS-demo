//
//  TuSDKAssetManager.h
//  TuSDKEva
//
//  Created by sprint on 2019/5/28.
//  Copyright © 2019 TuSdk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TuSDKEvaImageAssetManager.h"
#import "TuSDKEvaFontAssetManager.h"
#import "TuSDKEvaTextAssetManager.h"
#import "TuSDKEvaAudioAssetManager.h"

#define TuSDKEvaTemplateLoadResourceProgressNotification @"TuSDKEvaTemplateLoadResourceProgressNotification"
#define kTuSDKEvaTemplateTimeBase 1000000000.f

@protocol TuSDKEvaTemplateDelegate;
@class TuSDKEvaTemplateOptions;

NS_ASSUME_NONNULL_BEGIN

/**
 AE 模板
 @since v1.0.0
 */
@interface TuSDKEvaTemplate : NSObject

/**
 根据 evaBundlePath 初始化
 
 evaBundlePath 资源路径
 @since v1.0.0
 */
+ (instancetype)initWithEvaBundlePath:(NSString *)evaBundlePath;


/**
 模板配置选项
 
 @since v1.0.0
 */
@property (nonatomic, strong) TuSDKEvaTemplateOptions *options;

/**
 模板事件委托
 @since v1.0.0
 */
@property (nonatomic,weak)id<TuSDKEvaTemplateDelegate> delegate;

/**
 资源文件根目录
 
 @since v1.0.0
 */
@property (nonatomic, copy, readonly) NSString *evaBundlePath;

/**
 资源文件管理器
 
 @since v1.0.0
 */
@property (nonatomic, strong, readonly) TuSDKAOFile *file;


/**
 配置文件内容
 
 @since v1.0.0
 */
@property (nonatomic,copy,readonly) NSString *jsonString;

/**
 模板视频宽高
 
 @since v1.0.0
 */
@property (nonatomic,readonly) CGSize videoSize;

/**
 图片资源管理器
 @since v1.0.0
 */
@property (nonatomic, nonnull,readonly) TuSDKEvaImageAssetManager *imageAssetManager;

/**
 字体资源管理器
 @since v1.0.0
 */
@property (nonatomic, nonnull,readonly) TuSDKEvaFontAssetManager *fontAssetManager;

/**
 文字资源管理器
 @since v1.0.0
 */
@property (nonatomic, nonnull,readonly) TuSDKEvaTextAssetManager *textAssetManager;

/**
 音频资源管理器
 @since v1.0.0
 */
@property (nonatomic, nonnull,readonly) TuSDKEvaAudioAssetManager *audioAssetManager;

/**
 重置模板占位资源
 @since v1.0.0
 */
- (void)resetTemplate;


/**
 帧持续时间
 @since v1.0.2
 */
@property (nonatomic,readonly) CMTime frameDuration;

/**
 帧率
 @since v1.0.2
 */
@property (nonatomic,readonly) CGFloat frameRate;

/**
 总时长
 @since v1.0.2
 */
@property (nonatomic,readonly) CMTime durationTime;

@end

#pragma mark TuSDKEvaTemplateDelegate

/**
 模板事件委托
 @since v1.0.0
 */
@protocol TuSDKEvaTemplateDelegate <NSObject>

/**
 模板加载进度监听事件

 @param evaTemplate 当前模板
 @param progress 当前已加载进度
 @since v1.0.0
 */
- (void)evaTemplate:(TuSDKEvaTemplate *)evaTemplate loadedProgress:(CGFloat)progress;

@end




/**
 AE 模板 选项
 @since v1.0.0
 */
@interface TuSDKEvaTemplateOptions : NSObject

/**
 视频可替换的最大数量, 默认9个
 
 @since v1.0.0
 */
@property (nonatomic, assign) NSInteger replaceMaxVideoCount;

/**
 图片渲染时图片的压缩比，用于适配低配置的手机尤其是6p及以下，默认是1.0
 
 @since v1.0.0
 */
@property (nonatomic, assign) float scale;

/**
 已经替换的视频数量
 @since v1.0.0
 */
@property (nonatomic, assign) NSInteger alreadyReplaceVideoCount;

/**
 是否还能替换视频
 @since v1.0.0
 */
@property (nonatomic, assign, readonly) BOOL isCanReplaceVideo;

@end

NS_ASSUME_NONNULL_END
