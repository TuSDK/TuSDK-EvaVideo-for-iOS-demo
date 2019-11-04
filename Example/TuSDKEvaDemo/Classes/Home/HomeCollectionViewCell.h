//
//  HomeCollectionViewCell.h
//  TuSDKEvaDemo
//
//  Created by tutu on 2019/6/26.
//  Copyright © 2019 TuSdk. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class DownLoadFileModel;
@interface HomeCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UILabel *text;
@property (weak, nonatomic) IBOutlet UIButton *actionButton;

/* model */
@property (nonatomic, assign) DownLoadFileModel *model;

- (void)willDisplay;

- (void)clickButton;
@end

NS_ASSUME_NONNULL_END
