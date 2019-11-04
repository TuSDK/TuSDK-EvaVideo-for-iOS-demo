//
//  EVAPreviewViewController.h
//  TuSDKEvaDemo
//
//  Created by tutu on 2019/6/26.
//  Copyright © 2019 TuSdk. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


/**
 预览类
 */
@interface EVAPreviewViewController : UIViewController

/**
 资源文件路径
 */
@property (nonatomic, strong) NSString *evaPath;

/**
 模板名称
 */
@property (nonatomic, strong) NSString *modelTitle;


/** 模板文件名称 */
@property (nonatomic, strong) NSString *fileName;

// 资源加载失败回调
@property (nonatomic, strong) void(^loadTempleError)();

@end

NS_ASSUME_NONNULL_END
