//
//  VideoEditViewController.h
//  TuSDKEvaDemo
//
//  Created by tutu on 2019/6/26.
//  Copyright © 2019 TuSdk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>

NS_ASSUME_NONNULL_BEGIN

@interface VideoEditViewController : UIViewController


/**
 选用裁剪的长宽
 */
@property (nonatomic, assign) CGSize cutSize;

/**
 选取的视频
 */
@property (nonatomic, strong) NSArray<AVURLAsset *> *inputAssets;

/**
 时长
 */
@property (nonatomic, assign) CMTime duration;

/**
 选择确定后的回调
 */
@property (nonatomic, copy) void(^editCompleted)(NSURL *);

@end

NS_ASSUME_NONNULL_END
