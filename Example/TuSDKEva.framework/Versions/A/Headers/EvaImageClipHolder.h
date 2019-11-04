//
//  EvaImageClipHolder.h
//  TuSDKEva
//
//  Created by sprint on 2019/6/4.
//  Copyright © 2019 TuSdk. All rights reserved.
//

#import "TuSDKEvaImport.h"

NS_ASSUME_NONNULL_BEGIN

@interface EvaImageClipHolder : SLGPUImageOutput

/**
 初始化

 @param outputSize 输出宽高
 @return EvaImageClipHolder
 @since v1.0.0
 */
-(instancetype)initWithImage:(UIImage *)image outputSize:(CGSize)outputSize;

/**
 开始处理图片
 @since v1.0.0
 */
- (void)processImage;

/**
 输出宽高
 @since v1.0.0
 */
@property (nonatomic,readonly)CGSize outputSize;

@end

NS_ASSUME_NONNULL_END
