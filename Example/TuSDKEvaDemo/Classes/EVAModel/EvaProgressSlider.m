//
//  EvaProgressSlider.m
//  TuSDKEvaDemo
//
//  Created by tutu on 2019/7/3.
//  Copyright © 2019 TuSdk. All rights reserved.
//

#import "EvaProgressSlider.h"

@interface EvaProgressSlider()

/** desc */
@property (nonatomic, strong) UIView *leftView;
/** desc */
@property (nonatomic, strong) UIView *rightView;

@end

@implementation EvaProgressSlider

//- (void)awakeFromNib {
//    [super awakeFromNib];
//    _leftView = [[UIView alloc] initWithFrame:CGRectZero];
//    _leftView.backgroundColor = [UIColor colorWithRed:0 green:122.0/255.0 blue:1.0 alpha:1.0];
//    [self addSubview:_leftView];
//    _rightView = [[UIView alloc] initWithFrame:CGRectZero];
//    _rightView.backgroundColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.6];
//    [self addSubview:_rightView];
//}
//
//- (void)layoutSubviews {
//    [super layoutSubviews];
//    _leftView.frame = CGRectMake(1.5, 20, 2, 4);
//    _rightView.frame = CGRectMake(self.bounds.size.width - 4, 20, 2, 4);
//}


- (void)awakeFromNib {
    [super awakeFromNib];
    self.minimumTrackTintColor = [UIColor clearColor];
    self.maximumTrackTintColor = [UIColor clearColor];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if (self.subviews.count > 1) {
        self.subviews[1].backgroundColor = [UIColor colorWithRed:0 green:122.0/255.0 blue:1.0 alpha:1.0];
        self.subviews[0].backgroundColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.6];
    }
}

- (CGRect)trackRectForBounds:(CGRect)bounds {
    return CGRectMake(1.5, 20, bounds.size.width - 3.5, 4);
}

//
//- (CGRect)minimumValueImageRectForBounds:(CGRect)bounds {
//    return CGRectMake(1.5, 20, 4, 4);
//}

//- (CGRect)maximumValueImageRectForBounds:(CGRect)bounds {
//    return CGRectMake(self.bounds.size.width - 2.5, 20, 1, 4);
//}

// 使用颜色获取Image对象
//+ (UIImage *) imageFromColor:(UIColor *)color
//{
//    CGRect rect = CGRectMake(0, 0, 40, 40);
//    UIGraphicsBeginImageContext(rect.size);
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    CGContextSetFillColorWithColor(context, [color CGColor]);
//    CGContextFillRect(context, rect);
//    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    return img;
//}

@end
