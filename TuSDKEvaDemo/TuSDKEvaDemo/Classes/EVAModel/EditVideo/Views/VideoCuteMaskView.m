//
//  VideoSizeCuteView.m
//  TuSDKEvaDemo
//
//  Created by tutu on 2019/6/28.
//  Copyright © 2019 TuSdk. All rights reserved.
//

#import "VideoCuteMaskView.h"

@interface VideoCuteMaskView()

@property (nonatomic, weak) IBOutlet UIView *centerView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cWidth;

/**
 contentView
 */
@property (nonatomic, strong) UIView *contentView;

@end

@implementation VideoCuteMaskView

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    
    
    if ([super initWithCoder:aDecoder]) {
        
        UIView *contentView = [[[NSBundle mainBundle] loadNibNamed: NSStringFromClass([self class]) owner:self options:nil] firstObject];
        [self addSubview:contentView];
        //不将停靠模式转化为自动布局
        self.translatesAutoresizingMaskIntoConstraints=NO;
        contentView.translatesAutoresizingMaskIntoConstraints=NO;
        // 这里不能没有约束 及时xib里面有约束 如果这里不写约束，出来的效果也是奇形怪状，只有在xib 之前尝试用masonry布局修改这部分代码但是没有成功。
        [self addConstraint: [NSLayoutConstraint constraintWithItem: contentView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem: self attribute:NSLayoutAttributeLeft multiplier: 1.0 constant: 0]];
        [self addConstraint: [NSLayoutConstraint constraintWithItem: contentView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem: self attribute:NSLayoutAttributeRight multiplier: 1.0 constant: 0]];
        [self addConstraint: [NSLayoutConstraint constraintWithItem: contentView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem: self attribute:NSLayoutAttributeTop multiplier: 1.0 constant: 0]];
        [self addConstraint: [NSLayoutConstraint constraintWithItem: contentView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem: self attribute:NSLayoutAttributeBottom multiplier: 1.0 constant: 0]];
        
    }
    self.centerView.layer.borderWidth = 2;
    self.centerView.layer.borderColor = [UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0].CGColor;
    self.backgroundColor = [UIColor clearColor];
    self.regionRatio = 1.0;
    return self;
}

- (void)setRegionRatio:(CGFloat)regionRatio {
    _regionRatio = regionRatio;
    [self layoutIfNeeded];
    if (_regionRatio > 1.0) {
        _cWidth.constant = self.bounds.size.width;
        _cHeight.constant = _cWidth.constant/_regionRatio;
    } else {
        _cHeight.constant = self.bounds.size.height;
        _cWidth.constant = _cHeight.constant*_regionRatio;
    }
    [self layoutIfNeeded];
    
}

- (CGRect)cutFrame {
    return _centerView.frame;
}

@end
