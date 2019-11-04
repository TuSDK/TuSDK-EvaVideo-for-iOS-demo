//
//  TuSDKEvaVideoAlphaFilter.h
//  TuSDKEva
//
//  Created by KK on 2019/10/15.
//  Copyright © 2019 TuSdk. All rights reserved.
//

#import "TuSDKEvaImport.h"

NS_ASSUME_NONNULL_BEGIN

typedef enum TuSDKEvaVideoAlphaOrientation: NSUInteger {
    TuSDKEvaVideoAlphaOrientationHorizontal,
    TuSDKEvaVideoAlphaOrientationVertical,
} TuSDKEvaVideoAlphaOrientation;


@interface TuSDKEvaVideoAlphaFilter : SLGPUImageFilter

- (instancetype)initWithAlphaOrientation:(TuSDKEvaVideoAlphaOrientation)orientation framebufferSize:(CGSize)size;

@end

NS_ASSUME_NONNULL_END
