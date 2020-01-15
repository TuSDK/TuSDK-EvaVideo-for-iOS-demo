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
#import "DownLoadListManager.h"


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

- (void)updateUI;
{
    if (self.models.count == 0) {

        // 下载中或者等待下载
        [[TuSDK shared].messageHub showError:@"网络异常，请检查网络并重试！"];
    }else{
        [[TuSDK shared].messageHub dismiss];
        [self.collectionView reloadData];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithRed:19.0/255.0 green:19.0/255.0 blue:19.0/255.0 alpha:1.0];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];
    [self.collectionView registerNib:[UINib nibWithNibName:@"HomeCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"HomeCollectionViewCell"];
    self.collectionViewLayout.delegate = self;
    self.collectionView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
    [[TuSDK shared].messageHub setStatus:@"正在加载"];
    [[DownLoadListManager manager] downLoadFileCompletionHandler:^(NSMutableArray * modelArr) {

        // 将 modelArr 转成 DownLoadFileModel 数组
        self.models = [NSMutableArray arrayWithCapacity:modelArr.count];
        for (NSDictionary *dict in modelArr) {
            [self.models addObject:[[DownLoadFileModel alloc] initWithDictionary:dict]];
        }
       [self performSelectorOnMainThread:@selector(updateUI) withObject:nil waitUntilDone:NO];
    }];
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
    //NSLog(@"width,height--%f,%f",width,height);
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
