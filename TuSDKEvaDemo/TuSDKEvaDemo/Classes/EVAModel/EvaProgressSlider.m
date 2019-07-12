//
//  EvaProgressSlider.m
//  TuSDKEvaDemo
//
//  Created by tutu on 2019/7/3.
//  Copyright © 2019 TuSdk. All rights reserved.
//

#import "EvaProgressSlider.h"

@implementation EvaProgressSlider

- (CGRect)trackRectForBounds:(CGRect)bounds {
    return CGRectMake(1, 20, bounds.size.width-2, 4);
}

@end
