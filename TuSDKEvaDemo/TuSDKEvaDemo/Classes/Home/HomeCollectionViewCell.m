//
//  HomeCollectionViewCell.m
//  TuSDKEvaDemo
//
//  Created by tutu on 2019/6/26.
//  Copyright © 2019 TuSdk. All rights reserved.
//

#import "HomeCollectionViewCell.h"

@implementation HomeCollectionViewCell


- (void)awakeFromNib {
    [super awakeFromNib];
    self.image.layer.cornerRadius = 5;
    self.image.layer.masksToBounds = YES;
}

@end
