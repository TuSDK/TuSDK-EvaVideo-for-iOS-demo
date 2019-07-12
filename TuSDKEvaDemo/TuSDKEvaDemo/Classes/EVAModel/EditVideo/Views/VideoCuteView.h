//
//  VideoCuteView.h
//  TuSDKEvaDemo
//
//  Created by tutu on 2019/6/28.
//  Copyright © 2019 TuSdk. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface VideoCuteView : UIView

@property (weak, nonatomic) IBOutlet UIView *displayView;

/**
 设置剪切框比例, 快高比
 */
@property (nonatomic, assign) CGFloat regionRatio;

/**
 选择的视频的宽高
 */
@property (nonatomic, assign) CGSize videoSize;

/**
 最终选取的截取区域
 */
@property (nonatomic, assign, readonly) CGRect cutFrame;

/**
 最终截取的大小
 */
@property (nonatomic, assign, readonly) CGSize cutSize;

@end

NS_ASSUME_NONNULL_END
