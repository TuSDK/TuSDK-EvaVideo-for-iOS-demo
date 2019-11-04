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

@class TuSDKEvaTemplate;

/**
 Eva 音频资源管理器
 @since v1.0.0
 */
@interface TuSDKEvaAudioAssetManager : NSObject

/**
 初始化 TuSDKEvaAudioAssetManager

 @param evaTemplate eva模板
 @return TuSDKEvaAudioAssetManager
 @since v1.0.0
 */
- (instancetype)initWithEvaTemplate:(TuSDKEvaTemplate *)evaTemplate evaAudios:(std::map<std::string, std::shared_ptr<tutu::EvaAudioAsset>>)audios;

/**
 资源模板
 
 @since v1.0.0
 */
@property (nonatomic, weak, readonly) TuSDKEvaTemplate *evaTemplate;

/**
 资源文件加载进度
 
 @since v1.0.0
 */
@property (nonatomic, assign, readonly) CGFloat progress;


/**
 AE 模板中所有的音频资源
 
 @since v1.0.2
 */
@property (nonatomic, readonly) NSDictionary *allPlaceholderAudioAssets;

/**
 AE 模板中是否有
 
 @since v1.0.2
 */
@property (nonatomic, readonly) BOOL isContainAudio;

/**
 AE 模板中需要替换的图片资源列表
 
 @since v1.0.0
 */
@property (nonatomic,readonly) NSArray<TuSDKEvaAudioAsset *> *placeholderAssets;

/**
 evaCompositions
 */
@property (nonatomic,readonly) NSArray<TuSDKEvaAudioAssetRender *> *renders;

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
