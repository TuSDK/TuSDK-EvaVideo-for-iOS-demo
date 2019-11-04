//
//  TuSDKEvaExportSessionSettings.h
//  TuSDKEva
//
//  Created by sprint on 2019/6/10.
//  Copyright © 2019 TuSdk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TuSDKEvaImport.h"

NS_ASSUME_NONNULL_BEGIN

@interface TuSDKEvaExportSessionSettings : NSObject

/**
 导出的地址
 @since v1.0.0
 */
@property (nonatomic) NSURL * _Nullable outputURL;

/**
 输出的视频size
 @since v1.0.0
 */
@property (nonatomic) CGSize outputSize;

/**
 保存到系统相册 (默认保存, 当设置为NO时, 保存到临时目录)
 @since v1.0.0
 */
@property (nonatomic) BOOL saveToAlbum;

/**
 输出的文件类型
 @since v1.0.0
 */
@property (nonatomic) lsqFileType outputFileType;

/**
 输出的视频画质
 @since v1.0.0
 */
@property (nonatomic) TuSDKVideoQuality * _Nullable outputVideoQuality;

/**
 输出区域
 @since v1.0.0
 */
@property (nonatomic) CGRect outputRegion;

/**
 视频输出方向
 @since v1.0.0
 */
@property (nonatomic) CGAffineTransform outputTransform;

#pragma mark 相册

/**
 设置水印图片 最大：500*500
 @since v1.0.0
 */
@property (nonatomic, retain) UIImage * _Nullable waterMarkImage;

/**
 水印位置，默认 lsqWaterMarkBottomRight 若视频有位置相关旋转 应在设置videoOrientation后调用该setter方法
 @since v3.0
 */
@property (nonatomic) lsqWaterMarkPosition waterMarkPosition;

/**
 *  生成临时文件路径
 *
 *  @return 文件路径
 */
- (NSString *) generateTempFile;

@end

NS_ASSUME_NONNULL_END
