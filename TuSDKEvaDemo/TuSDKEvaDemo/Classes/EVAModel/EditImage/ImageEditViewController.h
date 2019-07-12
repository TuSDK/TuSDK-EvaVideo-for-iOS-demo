//
//  ImageEditViewController.h
//  TuSDKEvaDemo
//
//  Created by tutu on 2019/6/26.
//  Copyright © 2019 TuSdk. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ImageEditViewController : UIViewController

/**
 imageURL
 */
@property (nonatomic, strong) UIImage *inputImage;


/**
 选用裁剪的长宽
 */
@property (nonatomic, assign) CGSize cutSize;


/**
 图片的下标
 */
@property (nonatomic, assign) NSInteger index;

/**
 选择确定后的回调
 */
@property (nonatomic, copy) void(^editCompleted)(NSURL *);

@end

NS_ASSUME_NONNULL_END
