//
//  TuSDKPlaceholderTextAsset.h
//  TuSDKEva
//
//  Created by sprint on 2019/5/30.
//  Copyright © 2019 TuSdk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TuSDKEvaDocument.h"

/** 文本资源内容 @since v1.0.0 */
typedef NSString* TuSDKEvaAssetText;

NS_ASSUME_NONNULL_BEGIN

/**
 AE 模板文本占位资源
 */
@interface TuSDKEvaTextAsset : NSObject

/**
 根据占位内容初始化 TuSDKPlaceholderTextAsset

 @param evaTextAsset 默认AE占位内容
 @return TuSDKPlaceholderTextAsset
 
 @since v1.0.0
 */
-(instancetype)initWithEvaTextDocument:(TuSDKEvaDocument *)document;

/**
 输入的 Eva 文字
 @since v1.0.0
 */
@property (nonatomic,readonly) TuSDKEvaDocument* document;

/**
 占位文本内容
 
 @since v1.0.0
 */
@property (nonatomic,copy,readonly) TuSDKEvaAssetText defaultAssetText;

/**
 最终展示的文本内容 默认： placeholderText
 
 @since v1.0.0
 */
@property (nonatomic,copy) TuSDKEvaAssetText text;

/**
 该资源是否为占位资源，资源可以替换
 
 @return true/false
 @since v1.0.0
 */
- (BOOL)isPlaceholderAsset;

@end

NS_ASSUME_NONNULL_END
