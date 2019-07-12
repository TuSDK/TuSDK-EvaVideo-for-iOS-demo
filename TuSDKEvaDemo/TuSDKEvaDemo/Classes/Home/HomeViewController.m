//
//  HomeViewController.m
//  TuSDKEvaDemo
//
//  Created by tutu on 2019/6/26.
//  Copyright © 2019 TuSdk. All rights reserved.
//

#import "HomeViewController.h"
#import "CollectionViewLayout.h"
#import "HomeCollectionViewCell.h"
#import "EVAPreviewViewController.h"


#define kColumMargin 12.0
#define kRowMargin   15.0
#define kItemWidth   (([UIScreen mainScreen].bounds.size.width - kColumMargin*3) * 0.5)


@interface HomeViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, CollectionViewLayoutDelegate>

@property (weak, nonatomic) IBOutlet CollectionViewLayout *collectionViewLayout;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

/**
 models
 */
@property (nonatomic, strong) NSArray *models;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];
    [self.collectionView registerNib:[UINib nibWithNibName:@"HomeCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"HomeCollectionViewCell"];
    self.collectionViewLayout.delegate = self;
    
    _models = @[@{@"name":@"九宫格",@"path":@"01-jiugongge", @"width": @(800), @"height": @(450), @"image":@"01-cover"},
                @{@"name":@"趣味夏天旅行",@"path":@"03-quweixiatlianlvxing", @"width": @(800), @"height": @(1422), @"image":@"03-cover"},
                @{@"name":@"十里桃花",@"path":@"02-shilitaohua", @"width": @(800), @"height": @(450), @"image":@"02-cover"},
                @{@"name":@"Happy Wedding 1",@"path":@"04-happywedding", @"width": @(800), @"height": @(1422), @"image":@"04-cover"},
                @{@"name":@"Happy Wedding 1",@"path":@"05-happywedding", @"width": @(800), @"height": @(1422), @"image":@"05-cover"},
                @{@"name":@"亮缘节",@"path":@"07-liangyuanjie", @"width": @(800), @"height": @(450), @"image":@"07-cover"},
                @{@"name":@"生日快乐",@"path":@"08-happybirthday", @"width": @(800), @"height": @(1422), @"image":@"08-cover"},
                @{@"name":@"时尚潮流",@"path":@"09-shishangchaoliu", @"width": @(800), @"height": @(450), @"image":@"09-cover"},
//                @{@"name":@"电影胶片",@"path":@"10-dianyingjiaopian", @"width": @(450), @"height": @(800), @"image":@"10-cover"},
                ];
}



#pragma mark - UICollectionViewDataSource, UICollectionViewDelegate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _models.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    HomeCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HomeCollectionViewCell" forIndexPath:indexPath];
    NSDictionary *model = _models[indexPath.row];
    cell.text.text = model[@"name"];
    cell.image.image = [UIImage imageWithContentsOfFile: [[NSBundle mainBundle] pathForResource:model[@"image"] ofType:@"jpg"]];
    return cell;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    EVAPreviewViewController *vc = [[EVAPreviewViewController alloc] initWithNibName:nil bundle:nil];
    NSDictionary *model = _models[indexPath.row];
    vc.jsonDataPath = [NSString stringWithFormat:@"%@/jsonModel/%@.zip", [[NSBundle mainBundle] bundlePath], model[@"path"]];
    vc.modelTitle = model[@"name"];
    [self showViewController:vc sender:nil];
}



#pragma mark - CollectionViewLayoutDelegate

- (CGFloat)waterFallLayout:(CollectionViewLayout *)waterFallLayout heightForItemAtIndexPath:(NSUInteger)indexPath itemWidth:(CGFloat)itemWidth {
    NSDictionary *model = _models[indexPath];
    CGFloat width = [model[@"width"] floatValue];
    CGFloat height = [model[@"height"] floatValue];
    return kItemWidth * (height/width) + 25.0; // 25 是文字高度
}

- (NSUInteger)columnCountInWaterFallLayout:(CollectionViewLayout *)waterFallLayout {
    return 2;
}

- (CGFloat)rowMarginInWaterFallLayout:(CollectionViewLayout *)waterFallLayout {
    return kRowMargin;
}

- (CGFloat)columnMarginInWaterFallLayout:(CollectionViewLayout *)waterFallLayout {
    return kColumMargin;
}

- (UIEdgeInsets)edgeInsetdInWaterFallLayout:(CollectionViewLayout *)waterFallLayout {
    return UIEdgeInsetsMake(10, kColumMargin, 20, kColumMargin);
}

@end
