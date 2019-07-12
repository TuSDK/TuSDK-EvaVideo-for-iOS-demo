//
//  TuSDKTextAssetManager.h
//  TuSDKEva
//
//  Created by sprint on 2019/5/29.
//  Copyright © 2019 TuSdk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TuSDKEvaTextAsset.h"
#include "TuSDKEvaDocument.h"
#include <vector>


NS_ASSUME_NONNULL_BEGIN


/**
 文本资源管理器
 
 @since v1.0.0
 */
@interface TuSDKEvaTextAssetManager : NSObject

/**
 初始化
 @since v1.0.0
 */
- (instancetype)initWithTexts:(NSArray<TuSDKEvaDocument *> *) docments;

/**
 AE 模板中需要替换的文本资源列表
 
 @since v1.0.0
 */
@property (nonatomic,readonly)NSArray<TuSDKEvaTextAsset *> *placeholderAssets;

/**
 还原占位资源，放弃修改项
 @since v1.0.0
 */
- (void)resetPlaceholderAssets;

/**
 根据 wsting asset id 返回替换的文本内容

 @return 新的文本内容
 @since v1.0.0
 */
- (std::wstring)loadText:(std::wstring)assetId;


@end

NS_ASSUME_NONNULL_END
