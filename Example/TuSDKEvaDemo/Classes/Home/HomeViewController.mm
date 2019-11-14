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
#import "DownLoadManager.h"
#import "DownLoadFileModel.h"
#import "TuSDKFramework.h"


#define kColumMargin 12.0
#define kRowMargin   12.0
#define kItemWidth   (([UIScreen mainScreen].bounds.size.width - kColumMargin*3) * 0.5)


@interface HomeViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, CollectionViewLayoutDelegate>

@property (weak, nonatomic) IBOutlet CollectionViewLayout *collectionViewLayout;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

/**
 models
 */
@property (nonatomic, strong) NSMutableArray *models;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithRed:19.0/255.0 green:19.0/255.0 blue:19.0/255.0 alpha:1.0];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];
    [self.collectionView registerNib:[UINib nibWithNibName:@"HomeCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"HomeCollectionViewCell"];
    self.collectionViewLayout.delegate = self;
    self.collectionView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
    NSArray *models =  @[
        @{@"name":@"说爱你",@"path":@"lsq_eva_42.eva", @"width": @(450), @"height": @(800), @"image":@"42-cover"},
        @{@"name":@"字幕快闪",@"path":@"lsq_eva_43.eva", @"width": @(800), @"height": @(450), @"image":@"43-cover"},
        @{@"name":@"产品推广护肤品",@"path":@"lsq_eva_44.eva", @"width": @(450), @"height": @(800), @"image":@"44-cover"},
        @{@"name":@"视频MV",@"path":@"lsq_eva_45.eva", @"width": @(450), @"height": @(800), @"image":@"45-cover"},
        @{@"name":@"照片展示",@"path":@"lsq_eva_46.eva", @"width": @(450), @"height": @(800), @"image":@"46-cover"},
        @{@"name":@"童趣",@"path":@"lsq_eva_47.eva", @"width": @(800), @"height": @(450), @"image":@"47-cover"},
        @{@"name":@"简单视频展示",@"path":@"lsq_eva_48.eva", @"width": @(400), @"height": @(300), @"image":@"48-cover"},
        @{@"name":@"人员介绍",@"path":@"lsq_eva_49.eva", @"width": @(400), @"height": @(600), @"image":@"49-cover"},
        @{@"name":@"汽车介绍",@"path":@"lsq_eva_50.eva", @"width": @(800), @"height": @(450), @"image":@"50-cover"},
        @{@"name":@"九宫格",@"path":@"lsq_eva_24.eva", @"width": @(800), @"height": @(450), @"image":@"01-cover"},
        @{@"name":@"趣味夏天旅行",@"path":@"lsq_eva_26.eva", @"width": @(800), @"height": @(1422), @"image":@"03-cover"},
        @{@"name":@"十里桃花",@"path":@"lsq_eva_25.eva", @"width": @(800), @"height": @(450), @"image":@"02-cover"},
        @{@"name":@"新婚快乐-蓝",@"path":@"lsq_eva_27.eva", @"width": @(800), @"height": @(1422), @"image":@"04-cover"},
        @{@"name":@"新婚快乐-粉",@"path":@"lsq_eva_28.eva", @"width": @(800), @"height": @(1422), @"image":@"05-cover"},
        @{@"name":@"婚礼纪念日",@"path":@"lsq_eva_29.eva", @"width": @(800), @"height": @(1422), @"image":@"06-cover"},
        @{@"name":@"时尚潮流",@"path":@"lsq_eva_30.eva", @"width": @(800), @"height": @(450), @"image":@"09-cover"},
        @{@"name":@"电影胶片",@"path":@"lsq_eva_31.eva", @"width": @(800), @"height": @(1422), @"image":@"10-cover"},
        @{@"name":@"涂图视频融合介绍",@"path":@"lsq_eva_23.eva", @"width": @(800), @"height": @(600), @"image":@"08-cover"},
    ];
    _models = [NSMutableArray arrayWithCapacity:models.count];
    for (NSDictionary *dict in models) {
        [_models addObject:[[DownLoadFileModel alloc] initWithDictionary:dict]];
    }
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
    DownLoadFileModel *model = _models[indexPath.row];
    cell.model = model;
    return cell;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    DownLoadFileModel *model = _models[indexPath.row];
    if (model.status == DownloadStateCompleted) {
        // 已经下载的
        EVAPreviewViewController *vc = [[EVAPreviewViewController alloc] initWithNibName:nil bundle:nil];
        vc.evaPath = model.filePath;
        vc.modelTitle = model.name;
        vc.fileName = model.fileName;
        [self showViewController:vc sender:nil];
        __weak typeof(model) weakModel = model;
        __weak typeof(self) weakSelf = self;
        [vc setLoadTempleError:^{
            [weakModel reset];
            [weakSelf.collectionView reloadData];
        }];
        return;
    }
    
    if (model.status == DownloadStateResumed || model.status == DownloadStateWait) {
        // 下载中或者等待下载
        [[TuSDK shared].messageHub showToast:@"等待下载完成后再点击进行预览、使用"];
    } else {
        // 需要继续下载
//        [[TuSDK shared].messageHub showToast:@"请点击下载，完成后方可预览、使用"];
        HomeCollectionViewCell *cell = (HomeCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
        [cell clickButton];
    }
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    [(HomeCollectionViewCell*)cell willDisplay];
}


#pragma mark - CollectionViewLayoutDelegate

- (CGFloat)waterFallLayout:(CollectionViewLayout *)waterFallLayout heightForItemAtIndexPath:(NSUInteger)indexPath itemWidth:(CGFloat)itemWidth {
    DownLoadFileModel *model = _models[indexPath];
    CGFloat width = model.width;
    CGFloat height = model.height;
    return kItemWidth * (height/width) + 0.0; // 0.0 是文字高度 暂时隐藏
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
    return UIEdgeInsetsMake(0, kColumMargin, kRowMargin, kColumMargin);
}


@end
