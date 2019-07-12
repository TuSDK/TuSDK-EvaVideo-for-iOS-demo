//
//  TuSDKEvaAudioAssetManager.h
//  TuSDKEva
//
//  Created by sprint on 2019/6/10.
//  Copyright © 2019 TuSdk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TuSDKEvaAudioAssetRender.h"
#import "TuSDKEvaAudioAsset.h"
#include "EvaAsset.hh"
#include <map>
#include <string>

NS_ASSUME_NONNULL_BEGIN

/**
 Eva 音频资源管理器
 @since v1.0.0
 */
@interface TuSDKEvaAudioAssetManager : NSObject

/**
 初始化 TuSDKEvaAudioAssetManager

 @param bundlePath 音频资源根目录
 @return TuSDKEvaAudioAssetManager
 @since v1.0.0
 */
- (instancetype)initWithBundlePath:(NSString *)bundlePath evaAudios:(std::map<std::string, std::shared_ptr<tutu::EvaAudioAsset>>)audios;

/**
 资源文件根目录
 
 @since v1.0.0
 */
@property (nonatomic,copy,readonly)NSString *bundlePath;

/**
 AE 模板中所有音频资源
 
 @since v1.0.0
 */
@property (nonatomic,readonly)NSArray<TuSDKEvaAudioAsset *> *assets;

/**
 AE 模板中需要替换的图片资源列表
 
 @since v1.0.0
 */
@property (nonatomic,readonly)NSArray<TuSDKEvaAudioAsset *> *placeholderAssets;

/**
 evaCompositions
 */
@property (nonatomic,readonly)NSArray<TuSDKEvaAudioAssetRender *> *renders;

/**
 返回供 EVA 使用的 EvaAudioAssetPtr
 
 @since v1.0.0
 */
- (void)loadEvaAssetAudio:(tutu::EvaAudioAssetPtr)evaAudioAsset;

/**
 还原占位资源，放弃修改项
 @since v1.0.0
 */
- (void)resetPlaceholderAssets;

@end

NS_ASSUME_NONNULL_END
