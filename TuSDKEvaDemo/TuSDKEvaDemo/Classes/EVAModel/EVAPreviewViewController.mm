//
//  EVAPreviewViewController.m
//  TuSDKEvaDemo
//
//  Created by tutu on 2019/6/26.
//  Copyright © 2019 TuSdk. All rights reserved.
//

#import "EVAPreviewViewController.h"
#import "TuSDKFramework.h"
#import "EditViewController.h"
#import "EvaProgressSlider.h"

@interface EVAPreviewViewController ()<TuSDKEvaPlayerDelegate>

@property (weak, nonatomic) IBOutlet UIView *preview;
@property (weak, nonatomic) IBOutlet UIView *previewSuperView;
@property (weak, nonatomic) IBOutlet EvaProgressSlider *slider;
@property (weak, nonatomic) IBOutlet UIButton *makeBtn;
@property (weak, nonatomic) IBOutlet UILabel *text;
@property (weak, nonatomic) IBOutlet UILabel *media;
@property (weak, nonatomic) IBOutlet UILabel *music;
@property (weak, nonatomic) IBOutlet UILabel *evaTitle;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *previewWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *previewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *sliderWidth;

@property (weak, nonatomic) IBOutlet UIButton *playBtn;
/**
 eva 资源加载器
 */
@property (nonatomic, strong) TuSDKEvaTemplate *evaTemplate;

/**
 eva 播放器
 */
@property (nonatomic, strong) TuSDKEvaPlayer *evaPlayer;

/**
 文字资源
 */
@property (nonatomic, strong) NSMutableArray *texts;

/**
 图片资源
 */
@property (nonatomic, strong) NSMutableArray *medias;

/**
 音频
 */
@property (nonatomic, strong) NSMutableArray *audios;

/**
 slider Befor
 */
@property (nonatomic, assign) BOOL sliderBefore;
/**
 是否seek
 */
@property (nonatomic, assign) BOOL isSeek;

@end

@implementation EVAPreviewViewController

#pragma mark - Init

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self commonInit];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self loadTemplate];
    });
}


- (void)dealloc {
    NSLog(@"EVAPreviewViewController------dealloc");
    if (self.evaPlayer) {
        [self.evaPlayer stop];
        [self.evaPlayer destory];
        self.evaPlayer = nil;
    }
    
    if (self.evaTemplate) {
        self.evaTemplate = nil;
    }
}


- (void)commonInit {
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];
    self.navigationItem.title = @"模板详情";
    self.evaTitle.text = _modelTitle;
    
    [self.slider setThumbImage:[UIImage imageNamed:@"slider_thum_icon"] forState:UIControlStateNormal];
    self.slider.value = 0.0;
    
    self.makeBtn.layer.cornerRadius = 24;
    self.makeBtn.layer.masksToBounds = YES;
    
    _texts = [NSMutableArray array];
    _medias = [NSMutableArray array];
    _audios = [NSMutableArray array];
    [self refreshUI];
}


- (void)refreshUI {
    self.text.text = [NSString stringWithFormat:@"文字 %ld段", self.texts.count];
    self.media.text = [NSString stringWithFormat:@"图片/视频 %ld个", self.medias.count];
    self.music.text = [NSString stringWithFormat:@"音乐 %ld段", self.audios.count];
    
    if (self.evaTemplate == nil) return;
    [self.view layoutIfNeeded];
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
}


// 加载模板
- (void)loadTemplate {
    
//    _jsonDataPath = [[NSBundle mainBundle] pathForResource:@"happy" ofType:@"zip"];
    
    __weak typeof(self) weakSelf = self;
    [TuSDKEvaTemplate loadWithZipFileBundlePath:_jsonDataPath jsonFileName:@"data.json" progressHandler:^(CGFloat progress) {
        dispatch_sync(dispatch_get_main_queue(), ^{
            [[[TuSDK shared] messageHub] showProgress:progress status:@"正在解压..."];
        });
    } completionHandler:^(TuSDKEvaTemplate * _Nonnull evaTemplate, NSError * _Nullable error) {
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            [[[TuSDK shared] messageHub] dismiss];
        });
        
        weakSelf.evaTemplate = evaTemplate;
        weakSelf.texts = [NSMutableArray arrayWithArray:evaTemplate.textAssetManager.placeholderAssets];
        weakSelf.medias = [NSMutableArray arrayWithArray:evaTemplate.imageAssetManager.placeholderAssets];
        weakSelf.audios = [NSMutableArray arrayWithArray:evaTemplate.audioAssetManager.placeholderAssets];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [weakSelf refreshUI];
            weakSelf.evaPlayer = [[TuSDKEvaPlayer alloc] initWithEvaTemplate:evaTemplate inHolderView:weakSelf.preview];
            weakSelf.evaPlayer.delegate = weakSelf;
            
            [weakSelf.evaPlayer load];
            [weakSelf.evaPlayer play];
            
        });
    }];
}


#pragma mark - TuSDKEvaPlayerDelegate
- (void)evaPlayer:(TuSDKEvaPlayer *)player statusChanged:(TuSDKMediaPlayerStatus)status {
    self.playBtn.hidden = self.evaPlayer.status == TuSDKMediaPlayerStatusPlaying;
}

- (void)evaPlayer:(TuSDKEvaPlayer *)player progressChanged:(CGFloat)percent outputTime:(CMTime)outputTime {
    self.slider.value = percent;
}



#pragma mark - actions
// 去制作
- (IBAction)clickMake:(UIButton *)sender {
    if (self.evaTemplate == nil) return;
    [self.evaPlayer pause];
    EditViewController *edit = [[EditViewController alloc] initWithNibName:nil bundle:nil];
    edit.evaTemplate = self.evaTemplate;
    [self showViewController:edit sender:nil];
}


// 播放进度拖拽
- (IBAction)sliderValueChanged:(UISlider *)sender {
    if (self.evaPlayer == nil ) return;
    if (!_isSeek) {
        _isSeek = YES;
        _sliderBefore = self.evaPlayer.status == TuSDKMediaPlayerStatusPlaying;
    }
    CMTime duration = self.evaPlayer.durationTime;
    CMTime seek = CMTimeMake(sender.value * duration.value, duration.timescale);
    [self.evaPlayer seekToTime:seek];
}


// 进度拖拽完成
- (IBAction)sliderCompleted:(UISlider *)sender {
    if (self.evaPlayer == nil ) return;
    if (_sliderBefore) {
        [self.evaPlayer play];
    }
    _isSeek = NO;
}


// 预览播放点击
- (IBAction)tapPreView: (UITapGestureRecognizer *)tap {
    
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

@end
