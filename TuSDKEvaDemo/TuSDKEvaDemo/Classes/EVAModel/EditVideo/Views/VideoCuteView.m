//
//  VideoCuteView.m
//  TuSDKEvaDemo
//
//  Created by tutu on 2019/6/28.
//  Copyright © 2019 TuSdk. All rights reserved.
//

#import "VideoCuteMaskView.h"
#import "VideoCuteView.h"

@interface VideoCuteView()<UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet VideoCuteMaskView *maskView;

/**
 contentView
 */
@property (nonatomic, strong) UIView *contentView;

@end

@implementation VideoCuteView

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    
    
    if ([super initWithCoder:aDecoder]) {
        
        UIView *contentView = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil] firstObject];
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
    self.backgroundColor = [UIColor clearColor];
    self.scrollView.zoomScale = 1.0;
    return self;
}


- (void)layoutSubviews {
    [super layoutSubviews];
    if (CGSizeEqualToSize(CGSizeZero, _videoSize)) return;
    
    // size 的宽高比
    if (_videoSize.width/_videoSize.height > _regionRatio) {
        // 当视频的宽高比大于目的宽高比 , 高度固定左右移动
        if (_regionRatio > 1.0) {
            // 宽度大于高度 --- 左右移动 x= 0  y 下移动
            _scrollView.frame = CGRectMake(0, self.maskView.cutFrame.origin.y, self.maskView.cutFrame.size.width, self.maskView.cutFrame.size.height);
            _displayView.frame = CGRectMake(0, 0, self.maskView.cutFrame.size.height * _videoSize.width/_videoSize.height, self.maskView.cutFrame.size.height);
        } else {
            // 宽度小于高度 --- 左右移动 x= 右移  y= 0
            _scrollView.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
            _displayView.frame = CGRectMake(0, 0, self.maskView.cutFrame.size.height * _videoSize.width/_videoSize.height, self.maskView.cutFrame.size.height);
        }
    } else {
        // 当视频的宽高比大于目的宽高比  宽度固定 上下移动
        if (_regionRatio > 1.0) {
            // 宽度大于高度 --- 上下移动
            _scrollView.frame = CGRectMake(0, 0, self.maskView.cutFrame.size.width, self.bounds.size.height);
            _displayView.frame = CGRectMake(0, 0, self.maskView.cutFrame.size.width, self.maskView.cutFrame.size.width * (_videoSize.height/ _videoSize.width));
        } else {
            // 宽度小于高度 --- 上下移动
            _scrollView.frame = CGRectMake(self.maskView.cutFrame.origin.x, 0, self.maskView.cutFrame.size.width, self.bounds.size.height);
            _displayView.frame = CGRectMake(0, 0, self.maskView.cutFrame.size.width, self.maskView.cutFrame.size.width * (_videoSize.height/ _videoSize.width));
        }
    }
    
    [self calContentSize];
    [self.scrollView setZoomScale:1.0 animated:NO];
}

- (void)calContentSize {
    // size 的宽高比
    CGRect cutRect = _maskView.cutFrame;
    if (_videoSize.width/_videoSize.height > _regionRatio) {
        // 当视频的宽高比大于目的宽高比 , 高度固定左右移动
        if (_regionRatio > 1.0) {
            // 宽度大于高度 --- 左右移动 x= 0  y 下移动
//            _scrollView.contentSize = CGSizeMake(self.maskView.cutFrame.size.height * _videoSize.width/_videoSize.height, self.maskView.cutFrame.size.height);
//            _scrollView.contentInset = UIEdgeInsetsMake(cutRect.origin.y, cutRect.origin.x, cutRect.origin.y, cutRect.origin.x);
        } else {
            // 宽度小于高度 --- 左右移动 x= 右移  y= 0
//            _scrollView.contentSize = CGSizeMake((self.maskView.cutFrame.size.height * _videoSize.width/_videoSize.height + (self.bounds.size.width - self.maskView.cutFrame.size.width)), self.maskView.cutFrame.size.height );
            _scrollView.contentInset = UIEdgeInsetsMake(cutRect.origin.y, cutRect.origin.x, cutRect.origin.y, cutRect.origin.x);
        }
    } else {
        // 当视频的宽高比大于目的宽高比  宽度固定 上下移动
        if (_regionRatio > 1.0) {
            // 宽度大于高度 --- 上下移动
//            _scrollView.contentSize = CGSizeMake(self.maskView.cutFrame.size.width, (self.maskView.cutFrame.size.width * (_videoSize.height/ _videoSize.width) + (self.bounds.size.height - self.maskView.cutFrame.size.height)));
//            _scrollView.contentInset = UIEdgeInsetsMake((self.bounds.size.height - self.maskView.cutFrame.size.height) * 0.5, 0, -(self.bounds.size.height - self.maskView.cutFrame.size.height) * 0.5, 0);
            _scrollView.contentInset = UIEdgeInsetsMake(cutRect.origin.y, cutRect.origin.x, cutRect.origin.y, cutRect.origin.x);
        } else {
            // 宽度小于高度 --- 上下移动
//            _scrollView.contentSize = CGSizeMake(self.maskView.cutFrame.size.width * self.scrollView.zoomScale, self.maskView.cutFrame.size.width * (_videoSize.height/ _videoSize.width) * self.scrollView.zoomScale);
//            _scrollView.contentInset = UIEdgeInsetsMake(cutRect.origin.y, cutRect.origin.x, cutRect.origin.y, cutRect.origin.x);
        }
    }
}

//- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    NSLog(@"-----contentSize: width: %f, height:%f", scrollView.contentSize.width, scrollView.contentSize.height);
//    NSLog(@"-------scrollContentOffset: x: %f, y: %f", scrollView.contentOffset.x, scrollView.contentOffset.y);
//    CGRect cut = self.cutFrame;
//    NSLog(@"cut---x: %f, y: %f, width: %f, height: %f", cut.origin.x, cut.origin.y, cut.size.width, cut.size.height);
//}


- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    [self calContentSize];
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return _displayView;
}


- (void)setVideoSize:(CGSize)videoSize {
    _videoSize = videoSize;
}


- (void)setRegionRatio:(CGFloat)regionRatio {
    _regionRatio = regionRatio;
    self.maskView.regionRatio = regionRatio;
}

- (CGRect)cutFrame {
    CGFloat contentOffsetX = (_scrollView.contentOffset.x + _scrollView.contentInset.left)/_scrollView.zoomScale;
    CGFloat contentOffsetY = (_scrollView.contentOffset.y + _scrollView.contentInset.top)/_scrollView.zoomScale;
    CGSize contentSize = _displayView.bounds.size;
    CGFloat scaleX = _videoSize.width/contentSize.width;
    CGFloat scaleY = _videoSize.height/contentSize.height;
    
    CGFloat width  = _maskView.cutFrame.size.width * scaleX/_scrollView.zoomScale /_videoSize.width;
    CGFloat height = _maskView.cutFrame.size.height * scaleY/_scrollView.zoomScale / _videoSize.height;
    CGFloat x = MAX((contentOffsetX * scaleX)/_videoSize.width, 0.0);
    CGFloat y = MAX((contentOffsetY * scaleY)/_videoSize.height, 0.0);
    
    return CGRectMake(x, y, width + x > 1.0 ? 1 - x : width, height + y > 1.0 ? 1 - y : height);
}

- (CGSize)cutSize {
    CGRect cutFrame = self.cutFrame;
    return CGSizeMake((int)(cutFrame.size.width * _videoSize.width), (int)(cutFrame.size.height * _videoSize.height));
}

@end
