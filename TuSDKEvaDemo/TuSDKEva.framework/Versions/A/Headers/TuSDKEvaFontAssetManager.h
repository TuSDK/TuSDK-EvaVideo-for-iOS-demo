//
//  TuSDKFontAssetManager.h
//  TuSDKEva
//
//  Created by sprint on 2019/5/29.
//  Copyright © 2019 TuSdk. All rights reserved.
//

#import <UIKit/UIKit.h>
#include <tuple>
#include "EvaFont.hh"
//#include "EvaAssetManager.hh"


NS_ASSUME_NONNULL_BEGIN

/** 字体资源key @since v1.0.0 */
typedef NSString* TuSDKFontAssetID;
/** 字体资源名称 [需要在 assetPathDir 目录下] @since v1.0.0 */
typedef NSString* TuSDKFontAssetFileName;

// 资源释放接口
typedef void(*AssetReleaseProc)(const void* ptr, void* context);

// 返回资源结果
typedef std::tuple<void *, size_t, AssetReleaseProc> AssetResut;

@class TuSDKEvaTemplate;

/**
 图片资源管理器
 @since v1.0.0
 */
@interface TuSDKEvaFontAssetManager : NSObject

/**
 根据 evaTemplate 初始化
 
 @param evaTemplate 模板
 @since v1.0.0
 */
- (instancetype)initWithEvaTemplate:(TuSDKEvaTemplate *)evaTemplate evaFonts:(std::map<std::string, std::shared_ptr<tutu::EvaFontInfo>>)fonts;

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
 返回供 EVA 使用的 AssetResut
 
 @return AssetResut
 @since v1.0.0
 */
- (AssetResut)loadEvaFontAsset:(tutu::EvaFontInfoPtr)fontInfo;

@end

NS_ASSUME_NONNULL_END
