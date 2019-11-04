//
//  ImageEditView.m
//  TuSDKEvaDemo
//
//  Created by tutu on 2019/6/28.
//  Copyright © 2019 TuSdk. All rights reserved.
//

#import "ImageEditView.h"

@implementation ImageEditView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.regionRatio = 1.0;
        self.cutRegionView.edgeSideColor = [UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0];
        self.cutRegionView.edgeMaskColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
    }
    return self;
}


@end
