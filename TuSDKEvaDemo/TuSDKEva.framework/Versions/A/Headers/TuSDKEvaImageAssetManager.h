//
//  TuSDKImageAssetManager.h
//  TuSDKEva
//
//  Created by sprint on 2019/5/28.
//  Copyright © 2019 TuSdk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TuSDKEvaImageAsset.h"
#import "TuSDKEvaImageAssetRender.h"
#include "EvaAsset.hh"
#include <map>
#include <string>


NS_ASSUME_NONNULL_BEGIN

@class TuSDKEvaTemplate;

/**
 图片资源管理器
 @since v1.0.0
 */
@interface TuSDKEvaImageAssetManager : NSObject


/**
 初始化 TuSDKImageAssetManager 可配置参数
 
 @return eva 图片集合
 @since v1.0.0
 */
- (instancetype)initWithEvaTemplate:(TuSDKEvaTemplate *)evaTemplate evaImages:(std::map<std::string, std::shared_ptr<tutu::EvaImageAsset>>)images;

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
 AE 模板中需要替换的图片资源列表
 
 @since v1.0.0
 */
@property (nonatomic,readonly) NSArray<TuSDKEvaImageAsset *> *placeholderAssets;

/**
 evaCompositions
 */
@property (nonatomic,readonly) NSArray<TuSDKEvaImageAssetRender *> *renders;

/**
 返回供 EVA 使用的 EvaImagePtr
 
 @return EvaImagePtr
 @since v1.0.0
 */
- (tutu::EvaImageImplPtr)loadEvaAssetImage:(tutu::EvaImageAssetPtr)evaImageAsset;

/**
 还原占位资源，放弃修改项
 @since v1.0.0
 */
- (void)resetPlaceholderAssets;

@end

NS_ASSUME_NONNULL_END
