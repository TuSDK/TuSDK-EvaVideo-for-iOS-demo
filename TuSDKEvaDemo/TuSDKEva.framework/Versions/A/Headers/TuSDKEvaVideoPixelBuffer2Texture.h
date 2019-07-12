//
//  TuSDKEvaVideoPixelBuffer2Texture.h
//  TuSDKVideo
//
//  Created by sprint on 04/05/2018.
//  Copyright © 2018 TuSDK. All rights reserved.
//

#import "TuSDKEvaImport.h"

/**
 PixelBuffer 上传到 GPU
 @since  v1.0.0
 */
@interface TuSDKEvaVideoPixelBuffer2Texture : SLGPUImageOutput

/**
 输入的画面方向
 @since v1.0.0
 */
@property (nonatomic) LSQGPUImageRotationMode inputRotation;

/**
 输出的画面方向
 @since  v1.0.0
 */
@property (nonatomic) LSQGPUImageRotationMode outputRotation;

/**
 * 输入的采样数据类型
 * 支持： kCVPixelFormatType_420YpCbCr8BiPlanarFullRange | kCVPixelFormatType_420YpCbCr8BiPlanarVideoRange kCVPixelFormatType_32BGRA
 *  @since v1.0.0
 */
@property (nonatomic) OSType inputPixelFormatType;

/**
 输入的视频宽高
 @since  v1.0.0
 */
@property (nonatomic,readonly) CGSize inputSize;

/**
 设置材质坐标计算接口
 
 @since 3.1.2
 */
@property (nonatomic,readonly) TuSDKTextureCoordinateCropBuilder *textureCoordinateBuilder;

/**
 输入的视频宽高
 @since  v1.0.0
 */
@property (nonatomic) CGSize outputSize;

/**
 输出比例与输入比例不一致时，是否自适应画布
 @since  v1.0.0
 */
@property (nonatomic) BOOL aspectOutputRatioInSideCanvas;

/**
 设置画面显示区域 默认：（CGRectMake(0,0,1,1) 完整画面） aspectOutputRatioInSideCanvas
 aspectOutputRatioInSideCanvas 为 NO 时可用
 @since  v1.0.0
 */
@property (nonatomic) CGRect textureRect;

/**
 处理媒体数据
 
 @param sampleBufferRef CMSampleBufferRef
 @param outputTime 当前媒体数据输出时间
 @since  v1.0.0
 */
- (void)processSampleBufferRef:(CMSampleBufferRef)sampleBufferRef outputTime:(CMTime)outputTime;

/**
 新的视频数据可用
 
 @param pixelBufferRef 视频帧数据
 @param outputTime 当前媒体数据输出时间
 */
- (void)processProcessPixelBuffer:(CVPixelBufferRef)pixelBufferRef outputTime:(CMTime)outputTime;

@end
