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
@protocol TuSDKEvaTemplateDelegate;

NS_ASSUME_NONNULL_BEGIN

/**
 AE 模板
 @since v1.0.0
 */
@interface TuSDKEvaTemplate : NSObject

/**
 根据 bundlePath 初始化 (fileName 的根目录)

 evaAudioAssetPath 资源根目录
 @since v1.0.0
 */
- (instancetype)initWithBundlePath:(NSString *)bundlePath jsonFileName:(NSString *)fileName;

/**
 加载一个 zip 模板

 @param zipFileBundlePath zip 模板地址
 @param fileName json 文件名称
 @param progressHandler 进度回调
 @param completionHandler 完成回调
 */
+ (void)loadWithZipFileBundlePath:(NSString *)zipFileBundlePath jsonFileName:(NSString *)fileName progressHandler:(void (^)(CGFloat progress))progressHandler completionHandler:(void (^)(TuSDKEvaTemplate* evaTemplate, NSError * _Nullable error))completionHandler;

/**
 模板事件委托
 @since v1.0.0
 */
@property (nonatomic,weak)id<TuSDKEvaTemplateDelegate> delegate;

/**
 资源文件根目录
 
 @since v1.0.0
 */
@property (nonatomic,copy,readonly)NSString *bundlePath;

/**
 json 资源文件名称
 
 @since v1.0.0
 */
@property (nonatomic,copy,readonly)NSString *fileName;

/**
 配置文件内容
 
 @since v1.0.0
 */
@property (nonatomic,copy,readonly)NSString *jsonString;

/**
 模板视频宽高
 
 @since v1.0.0
 */
@property (nonatomic,readonly)CGSize videoSize;

/**
 图片资源管理器
 @since v1.0.0
 */
@property (nonnull,readonly)TuSDKEvaImageAssetManager *imageAssetManager;

/**
 字体资源管理器
 @since v1.0.0
 */
@property (nonnull,readonly)TuSDKEvaFontAssetManager *fontAssetManager;

/**
 文字资源管理器
 @since v1.0.0
 */
@property (nonnull,readonly)TuSDKEvaTextAssetManager *textAssetManager;

/**
 音频资源管理器
 @since v1.0.0
 */
@property (nonnull,readonly)TuSDKEvaAudioAssetManager *audioAssetManager;

/**
 重置模板占位资源
 @since v1.0.0
 */
- (void)resetTemplate;

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

NS_ASSUME_NONNULL_END
