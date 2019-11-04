//
//  TSDEDMusicViewController.h
//  TuSDKEvaDemo
//
//  Created by tutu on 2019/6/26.
//  Copyright © 2019 TuSdk. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MusicView : UIView

/**
 已经选择的路径
 */
@property (nonatomic, strong, nullable) NSString *selectedMusicPath;

/**
 选择确定后的回调
 */
@property (nonatomic, copy) void(^selectedMusic)(NSString *);

@end

NS_ASSUME_NONNULL_END
