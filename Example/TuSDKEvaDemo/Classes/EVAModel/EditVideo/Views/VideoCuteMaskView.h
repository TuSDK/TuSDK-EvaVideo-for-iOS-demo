//
//  VideoSizeCuteView.h
//  TuSDKEvaDemo
//
//  Created by tutu on 2019/6/28.
//  Copyright © 2019 TuSdk. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface VideoCuteMaskView : UIView


/**
 设置剪切框比例, 快高比
 */
@property (nonatomic, assign) CGFloat regionRatio;

/**
 cut frame
 */
@property (nonatomic, assign, readonly) CGRect cutFrame;

@end

NS_ASSUME_NONNULL_END
