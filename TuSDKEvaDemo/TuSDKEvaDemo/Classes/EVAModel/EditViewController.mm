//
//  EditViewController.m
//  TuSDKEvaDemo
//
//  Created by tutu on 2019/6/26.
//  Copyright © 2019 TuSdk. All rights reserved.
//

#import "EditViewController.h"
#import "EditCollectionViewCell.h"
#import "MusicViewController.h"
#import "VideoEditViewController.h"
#import "ImageEditViewController.h"
#import "MultiAssetPicker.h"

@interface EditViewController ()<UICollectionViewDelegate, UICollectionViewDataSource,
TuSDKEvaPlayerDelegate, MultiPickerDelegate, UITextFieldDelegate, TuSDKEvaExportSessionDelegate, UIGestureRecognizerDelegate>

{
    BOOL _saving;
    NSMutableDictionary *_replaceText;
    NSInteger _index;
    
    TuSDKEvaExportSession *_session;
}

@property (weak, nonatomic) IBOutlet UIView *previewSuperView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *previewWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *previewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *sliderWidth;

@property (weak, nonatomic) IBOutlet UIView *preview;
@property (weak, nonatomic) IBOutlet UIButton *playBtn;
@property (weak, nonatomic) IBOutlet UISlider *evaSlider;
@property (weak, nonatomic) IBOutlet UIButton *changeMusicBtn;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UISlider *volmSlider;
@property (weak, nonatomic) IBOutlet UIButton *resetBtn;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textFiledBottom;

/**
 已经选择的路径
 */
@property (nonatomic, strong) NSString *selectedMusicPath;

/**
 orgResources
 */
@property (nonatomic, strong) NSMutableArray *orgResources;

/**
 eva 播放器
 */
@property (nonatomic, strong) TuSDKEvaPlayer *evaPlayer;

//@property (strong, nonatomic) NSMutableArray *originTexts;
//@property (strong, nonatomic) NSMutableArray *originImages;
//@property (strong, nonatomic) NSMutableArray *originMusics;

/**
 slider Befor
 */
@property (nonatomic, assign) BOOL sliderBefore;
/**
 是否seek
 */
@property (nonatomic, assign) BOOL isSeek;

@end


@implementation EditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self commonInit];
}


/**
 对象消耗回调
 */
- (void)dealloc {
    if (self.evaPlayer) {
        [self.evaPlayer stop];
        [self.evaPlayer destory];
        [self.evaTemplate resetTemplate];
        self.evaPlayer = nil;
    }
    
    if (_saving) {
        [[TuSDK shared].messageHub dismiss];
        [_session cancelExport];
    }
    
    if (_session) {
        [_session destory];
    }
}

- (void)commonInit {
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];
    self.navigationItem.title = @"融合预览";
    
    UIButton *save = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 40)];
    [save setTitle:@"保存" forState:UIControlStateNormal];
    [save setTitleColor:[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0] forState:UIControlStateNormal];
    [save addTarget:self action:@selector(save) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:save];
    
    [self resetOrgResoures];
    _replaceText = [NSMutableDictionary dictionary];
    
    [self.evaSlider setThumbImage:[UIImage imageNamed:@"slider_thum_icon"] forState:UIControlStateNormal];
    self.evaSlider.value = 0.0;
    
    self.changeMusicBtn.layer.cornerRadius = 4;
    self.changeMusicBtn.layer.masksToBounds = YES;
    self.resetBtn.layer.cornerRadius = 4;
    self.resetBtn.layer.masksToBounds = YES;
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"EditCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"EditCollectionViewCell"];
    [self.collectionView reloadData];
    
    
    // 监听键盘
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
}


/**
 在这里适配下视频视图
 */
- (void)viewDidAppear:(BOOL)animated {
    if (self.evaTemplate == nil) return;
    if (_evaPlayer == nil) {
        // 页面布局
        // 视频预览视图宽高
        CGFloat sWidth  = self.previewSuperView.bounds.size.width;
        CGFloat sHeight = self.previewSuperView.bounds.size.height;
        CGFloat vWidth  = self.evaTemplate.videoSize.width;
        CGFloat vHeight = self.evaTemplate.videoSize.height;
        
        if (sWidth/sHeight > vWidth/vHeight) {
            // 视频偏宽
            if (sWidth * (vHeight/vWidth) > sHeight) {
                self.previewHeight.constant = sHeight;
                self.previewWidth.constant = sHeight * (vWidth/vHeight);
            } else {
                self.previewWidth.constant = sWidth;
                self.previewHeight.constant = sWidth * (vHeight/vWidth);
            }
        } else {
            if (sHeight * (vWidth/vHeight) > sWidth) {
                self.previewWidth.constant = sWidth;
                self.previewHeight.constant = sWidth * (vHeight/vWidth);
            } else {
                self.previewHeight.constant = sHeight;
                self.previewWidth.constant = sHeight * (vWidth/vHeight);
            }
        }
        self.sliderWidth.constant = self.previewWidth.constant;
        [self.view layoutIfNeeded];
        
        self.evaPlayer = [[TuSDKEvaPlayer alloc] initWithEvaTemplate:self.evaTemplate inHolderView:self.preview];
        self.evaPlayer.delegate = self;
        
        [self.evaPlayer load];
        self.volmSlider.value = 1.0;
    }
}



#pragma mark - UICollectionDatasouce, UICollectionDelegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _orgResources.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    EditCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"EditCollectionViewCell" forIndexPath:indexPath];
    id model = _orgResources[indexPath.row];
    if ([model isKindOfClass:[TuSDKEvaTextAsset class]]) {
        // 文本
        cell.backgroundImage.hidden = YES;
        cell.typeText.hidden = YES;
        cell.text.hidden = NO;
        
        TuSDKEvaTextAsset *news = (TuSDKEvaTextAsset *)model;
        if (_replaceText[[NSString stringWithFormat:@"%ld",indexPath.row]] == nil) {
            // 没有替换的
            cell.text.textColor = [UIColor colorWithRed:102.0/255.0 green:102.0/255.0 blue:102.0/255.0 alpha:1];
        } else {
            // 替换的
            cell.text.textColor = [UIColor whiteColor];
        }
        cell.text.text = news.text;
    } else {
        // 图片，视频
        cell.backgroundImage.hidden = NO;
        cell.typeText.hidden = NO;
        cell.text.hidden = YES;
        TuSDKEvaImageAsset *origin = model;
        if (origin.isPlaceholderImageAsset && origin.isPlaceholderVideoAsset) {
            // 视频，图像
//            cell.typeImage.image = [UIImage imageNamed:@"picvideo_ic"];
            cell.typeText.text = @"图片/视频 ";
            
        } else if (origin.isPlaceholderImageAsset) {
            // 图像的
//            cell.typeImage.image = [UIImage imageNamed:@"pic_ic"];
            cell.typeText.text = @" 图片 ";
        } else if (origin.isPlaceholderVideoAsset) {
            // 视频的
//            cell.typeImage.image = [UIImage imageNamed:@"video_ic"];
            cell.typeText.text = @" 视频 ";
        }
        cell.backgroundImage.image = [UIImage imageWithContentsOfFile:origin.assetURL.path];
        if (cell.backgroundImage.image == nil) {
            cell.backgroundImage.image = [self getVideoPreViewImage:origin.assetURL];
        }
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    _index = indexPath.row;
    [self stopEvaPlayer];
    id model = _orgResources[indexPath.row];
    if ([model isKindOfClass:[TuSDKEvaTextAsset class]]) {
        // 去编辑文本
        TuSDKEvaTextAsset *textAsset = (TuSDKEvaTextAsset *)model;
        _textField.text = textAsset.text;
        [_textField becomeFirstResponder];
    } else {
        // 去编辑图片、视频
        MultiAssetPicker *picker = [MultiAssetPicker picker];
        picker.disableMultipleSelection = YES;
        TuSDKEvaImageAsset *origin = (TuSDKEvaImageAsset*)model;
        if (origin.isPlaceholderVideoAsset && origin.isPlaceholderImageAsset) {
            picker.fetchMediaTypes = @[@(PHAssetMediaTypeImage),@(PHAssetMediaTypeVideo)];
        } else if (origin.isPlaceholderVideoAsset) {
            picker.fetchMediaTypes = @[@(PHAssetMediaTypeVideo)];
        } else if (origin.isPlaceholderImageAsset) {
            picker.fetchMediaTypes = @[@(PHAssetMediaTypeImage)];
        }
        picker.navigationItem.title = @"素材选择";
        picker.delegate = self;
        picker.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];
        [self showViewController:picker sender:nil];
    }
}



#pragma mark - MultiPickerDelegate
- (void)picker:(MultiAssetPicker *)picker didTapItemWithIndexPath:(NSIndexPath *)indexPath phAsset:(PHAsset *)phAsset {
    
    TuSDKEvaImageAsset *asset = _orgResources[_index];
    __weak typeof(asset)weakAsset = asset;
    __weak typeof(self)weakSelf = self;
    [self requestAVAsset:phAsset completion:^(PHAsset *inputPhAsset, NSObject *returnValue) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (inputPhAsset.mediaType == PHAssetMediaTypeVideo) {
                // 去进行视频编辑
                VideoEditViewController *edit = [[VideoEditViewController alloc] initWithNibName:nil bundle:nil];
                edit.inputAssets = @[(AVAsset *)returnValue];
                edit.cutSize = weakAsset.size;
                [edit setEditCompleted:^(NSURL * _Nonnull outputUrl) {
                    [weakSelf.navigationController popToViewController:weakSelf animated:YES];
                    weakAsset.assetURL = outputUrl;
                    [weakSelf.collectionView reloadData];
                    [weakSelf resetEvaTemplate];
                }];
                [picker showViewController:edit sender:nil];
            } else if (inputPhAsset.mediaType == PHAssetMediaTypeImage) {
                // 去图片编辑
                ImageEditViewController *edit = [[ImageEditViewController alloc] initWithNibName:nil bundle:nil];
                edit.inputImage = (UIImage *)returnValue;
                edit.index = self->_index;
                edit.cutSize = weakAsset.size;
                [edit setEditCompleted:^(NSURL * _Nonnull outputUrl) {
                    [weakSelf.navigationController popToViewController:weakSelf animated:YES];
                    weakAsset.assetURL = outputUrl;
                    [weakSelf.collectionView reloadData];
                    [weakSelf resetEvaTemplate];
                }];
                [picker showViewController:edit sender:nil];
            }
        });
    }];
}


#pragma mark - TuSDKEvaPlayerDelegate
- (void)evaPlayer:(TuSDKEvaPlayer *)player statusChanged:(TuSDKMediaPlayerStatus)status {
    self.playBtn.hidden = self.evaPlayer.status == TuSDKMediaPlayerStatusPlaying;
}

- (void)evaPlayer:(TuSDKEvaPlayer *)player progressChanged:(CGFloat)percent outputTime:(CMTime)outputTime {
    self.evaSlider.value = percent;
}



#pragma mark - actions

// 音量改变
- (IBAction)volmValueChanged:(UISlider *)sender {
    self.evaPlayer.volume = sender.value;
}

// 进度条值改变
- (IBAction)evaPregressValueChanged:(UISlider *)sender {
    if (self.evaPlayer == nil ) return;
    if (!_isSeek) {
        _isSeek = YES;
        _sliderBefore = self.evaPlayer.status == TuSDKMediaPlayerStatusPlaying;
    }
    CMTime duration = self.evaPlayer.durationTime;
    CMTime seek = CMTimeMake(sender.value * duration.value, duration.timescale);
    [self.evaPlayer seekToTime:seek];
}


// 进度条滑动完成
- (IBAction)evaSliderCompeleted:(UISlider *)sender {
    if (self.evaPlayer == nil ) return;
    if (_sliderBefore) {
        [self.evaPlayer play];
    }
    _isSeek = NO;
}


/**
 选择音乐
 */
- (IBAction)changeMusic:(UIButton *)sender {
    
    if (_evaTemplate == nil || _evaTemplate.audioAssetManager.placeholderAssets.count == 0) {
        [[TuSDK shared].messageHub showToast:@"此资源不支持替换背景音乐"];
        return;
    }
    
    MusicViewController *vc = [[MusicViewController alloc] initWithNibName:nil bundle:nil];
    vc.selectedMusicPath = _selectedMusicPath;
    [self stopEvaPlayer];
    __weak typeof(self)weakSelf = self;
    [vc setSelectedMusic:^(NSString * _Nonnull musicPath) {
        if (musicPath == nil || [musicPath isEqualToString:weakSelf.selectedMusicPath]) return;
        weakSelf.selectedMusicPath = musicPath;
        [weakSelf resetEvaTemplate];
    }];
    [self presentViewController:vc animated:YES completion:nil];
}


/**
 一键重置，将资源重置回源资源
 */
- (IBAction)reset:(UIButton *)sender {
    if (_saving)return;
    [self stopEvaPlayer];
    
    [_evaTemplate resetTemplate];
    
    _replaceText = [NSMutableDictionary dictionary];
    [self resetOrgResoures];
    _selectedMusicPath = nil;
    [self.collectionView reloadData];
    
    [_evaPlayer reloadTemplate];
}


// 替换资源后，播放器重载资源
- (void)resetEvaTemplate {
    if (_saving)return;
    [self stopEvaPlayer];
    
    if (self.selectedMusicPath) {
        TuSDKEvaAudioAsset *audio = _evaTemplate.audioAssetManager.placeholderAssets.firstObject;
        audio.assetURL = [NSURL fileURLWithPath:self.selectedMusicPath];
    }
    [_evaPlayer reloadTemplate];
}


// 重置源资源
- (void)resetOrgResoures {
    // 资源排序
    _orgResources = [NSMutableArray array];
    [_orgResources addObjectsFromArray:_evaTemplate.textAssetManager.placeholderAssets];
    [_orgResources addObjectsFromArray:_evaTemplate.imageAssetManager.placeholderAssets];
    [_orgResources sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        NSInteger start1 = 0.0, start2 = 0.0;
        if ([obj1 isKindOfClass:[TuSDKEvaImageAsset class]]) {
            TuSDKEvaImageAsset *image = (TuSDKEvaImageAsset *)obj1;
            start1 = image.inputEvaImageAssetPtr->startFrame;
        } else if ([obj1 isKindOfClass:[TuSDKEvaTextAsset class]]) {
            TuSDKEvaTextAsset *text = (TuSDKEvaTextAsset *)obj1;
            start1 = text.document.startFrame;
        }
        if ([obj2 isKindOfClass:[TuSDKEvaImageAsset class]]) {
            TuSDKEvaImageAsset *image = (TuSDKEvaImageAsset *)obj2;
            start2 = image.inputEvaImageAssetPtr->startFrame;
        } else if ([obj2 isKindOfClass:[TuSDKEvaTextAsset class]]) {
            TuSDKEvaTextAsset *text = (TuSDKEvaTextAsset *)obj2;
            start2 = text.document.startFrame;
        }
        return [[NSNumber numberWithInteger:start1] compare:[NSNumber numberWithInteger:start2]];
    }];

}


// 点击视频视图
- (IBAction)tapPreview:(UITapGestureRecognizer *)sender {
    // 先处理键盘
    if ([_textField isFirstResponder]) {
        [_textField resignFirstResponder];
        return;
    }
    
    // 再处理播放器
    if (self.evaPlayer == nil) return;
    
    if (self.evaPlayer.status == TuSDKMediaPlayerStatusPlaying) {
        [self.evaPlayer pause];
    } else {
        if (CMTimeCompare(self.evaPlayer.currentTime, self.evaPlayer.durationTime) >= 0) {
            [self.evaPlayer seekToTime:kCMTimeZero];
        }
        [self.evaPlayer play];
    }
    
    self.playBtn.hidden = self.evaPlayer.status == TuSDKMediaPlayerStatusPlaying;
}


// 保存导出
- (void)save {
    if (_saving) return;
    _saving = YES;
    
    // 必须停止/暂停播放器
    [self.evaPlayer stop];
    
    
    // 导出配置
    TuSDKEvaExportSessionSettings *exportSettings = [[TuSDKEvaExportSessionSettings alloc] init];
    // 输出路径
//    exportSettings.outputURL
    // 是否保存到相册 -- 默认YES
    exportSettings.saveToAlbum = YES;
    // 导出视频的尺寸
//    exportSettings.outputSize = CGSizeMake(720, 1280);
    
    // 导出视频的质量
//    exportSettings.outputFileType = lsqFileTypeQuickTimeMovie;
    
    // 导出文件类型
//    exportSettings.outputVideoQuality =
    
    // 设置水印
    exportSettings.waterMarkImage = [UIImage imageNamed:@"sample_watermark"];
    exportSettings.waterMarkPosition = lsqWaterMarkTopRight;
    
    _session = [[TuSDKEvaExportSession alloc] initWithEvaTemplate:_evaTemplate exportOutputSettings:exportSettings];
    _session.delegate = self;
    [_session startExport];
}


// 暂停导出
- (void)stopEvaPlayer {
    if (_evaPlayer) {
        [_evaPlayer stop];
        _evaSlider.value = 0.0;
    }
}


#pragma mark - textEdit
- (void)keyboardWillHide:(NSNotification *)note {
    _textFiledBottom.constant = -44.0;
    [UIView animateWithDuration:0.25 animations:^{
        [self.view layoutIfNeeded];
    }];
}

- (void)keyboardWillShow:(NSNotification *)note {
    NSDictionary *userInfo = [note userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    _textFiledBottom.constant = keyboardRect.size.height;
    [UIView animateWithDuration:0.25 animations:^{
        [self.view layoutIfNeeded];
    }];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField.text.length <= 0) {
        [[TuSDK shared].messageHub showToast:@"输入的内容不能为空"];
        return NO;
    }
    TuSDKEvaTextAsset *textAsset = _orgResources[_index];
    textAsset.text = textField.text;
    _replaceText[[NSString stringWithFormat:@"%ld", _index]] = @"YES";
    [self.collectionView reloadData];
    [self resetEvaTemplate];
    [textField resignFirstResponder];
    return YES;
}



#pragma mark - 导出
/**
 进度改变事件
 
 @param exportSession TuSDKEvaExportSession
 @param percent (0 - 1)
 @param outputTime 当前帧所在持续时间
 @since      v1.0.0
 */
- (void)mediaEvaExportSession:(TuSDKEvaExportSession *_Nonnull)exportSession progressChanged:(CGFloat)percent outputTime:(CMTime)outputTime;{
    [[TuSDK shared].messageHub showProgress:percent status:[NSString stringWithFormat:@"正在导出 %.0f%%",percent*100]];
}

/**
 播放器状态改变事件
 
 @param exportSession 当前
 @param status 当前导出状态
 @since      v1.0.0
 */
- (void)mediaEvaExportSession:(TuSDKEvaExportSession *_Nonnull)exportSession statusChanged:(TuSDKMediaExportSessionStatus)status;{
    switch (status) {
        case TuSDKMediaExportSessionStatusCancelled:
            _saving = NO;
            [[TuSDK shared].messageHub showError:@"已取消导出"];
            break;
        case TuSDKMediaExportSessionStatusFailed:
            _saving = NO;
            [[TuSDK shared].messageHub showError:@"导出失败"];
            break;
        case TuSDKMediaExportSessionStatusCompleted:
            _saving = NO;
            [[TuSDK shared].messageHub showSuccess:@"导出完成"];
            break;
       case TuSDKMediaExportSessionStatusUnknown:
            _saving = NO;
            [[TuSDK shared].messageHub dismiss];
        default:
            break;
    }
}

/**
 播放器状态改变事件
 
 @param exportSession 当前
 @param result TuSDKVideoResult
 @param error 错误信息
 @since      v1.0.0
 */
- (void)mediaEvaExportSession:(TuSDKEvaExportSession *_Nonnull)exportSession result:(TuSDKVideoResult *_Nonnull)result error:(NSError *_Nonnull)error;{
    [TuSDKProgressHUD showWithStatus:@"导出完成"];
    if (error)
        [[TuSDK shared].messageHub showError:@"导出失败"];
    else
        [[TuSDK shared].messageHub showSuccess:@"导出成功"];
}




#pragma mark - load media
/**
 请求 PHAsset
 
 @param phAsset PHAsset 文件对象
 @param completion 完成后的操作
 */
- (void)requestAVAsset:(PHAsset *)phAsset completion:(void (^)(PHAsset *inputPhAsset, NSObject *returnValue))completion {
    
    if (phAsset.mediaType == PHAssetMediaTypeImage) {
        
        PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
        options.networkAccessAllowed = YES;
        options.synchronous = YES;
        // 配置请求
        options.progressHandler = ^(double progress, NSError * _Nullable error, BOOL * _Nonnull stop, NSDictionary * _Nullable info) {
            if (progress == 1.0) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[TuSDK shared].messageHub dismiss];
                });
            } else {
                [[TuSDK shared].messageHub showProgress:progress status:@"iCloud 同步中"];
            }
        };
        
        CGSize outputSize = [TuSDKMediaFormatAssistant safeVideoSize:CGSizeMake(phAsset.pixelWidth, phAsset.pixelWidth)];
        
        [[PHImageManager defaultManager] requestImageForAsset:phAsset targetSize:outputSize contentMode:PHImageContentModeDefault options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
            if (completion) completion(phAsset, result);
        }];
        
    } else {
        
        PHVideoRequestOptions *options = [[PHVideoRequestOptions alloc] init];
        options.networkAccessAllowed = YES;
        // 配置请求
        options.progressHandler = ^(double progress, NSError * _Nullable error, BOOL * _Nonnull stop, NSDictionary * _Nullable info) {
            
            if (progress == 1.0) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[TuSDK shared].messageHub dismiss];
                });
            } else {
                [[TuSDK shared].messageHub showProgress:progress status:@"iCloud 同步中"];
            }
            
        };
        
        [[PHImageManager defaultManager] requestAVAssetForVideo:phAsset options:options resultHandler:^(AVAsset * _Nullable asset, AVAudioMix * _Nullable audioMix, NSDictionary * _Nullable info) {
            
            if (completion) completion(phAsset, asset);
        }];
    }
}

// 获取视频第一帧
- (UIImage*)getVideoPreViewImage:(NSURL *)path {
    
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:path options:nil];
    AVAssetImageGenerator *assetGen = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    
    assetGen.appliesPreferredTrackTransform = YES;
    CMTime time = CMTimeMakeWithSeconds(0.0, 600);
    NSError *error = nil;
    CMTime actualTime;
    CGImageRef image = [assetGen copyCGImageAtTime:time actualTime:&actualTime error:&error];
    UIImage *videoImage = [[UIImage alloc] initWithCGImage:image];
    CGImageRelease(image);
    return videoImage;
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    return YES;
}


@end
