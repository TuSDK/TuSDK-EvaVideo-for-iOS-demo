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

@interface EVAPreviewViewController ()<TuSDKEvaPlayerDelegate, TuSDKEvaPlayerLoadDelegate>

@property (weak, nonatomic) IBOutlet UIView *preview;
@property (weak, nonatomic) IBOutlet UIView *previewSuperView;
@property (weak, nonatomic) IBOutlet EvaProgressSlider *slider;
@property (weak, nonatomic) IBOutlet UIButton *makeBtn;
@property (weak, nonatomic) IBOutlet UILabel *text;
@property (weak, nonatomic) IBOutlet UILabel *media;
@property (weak, nonatomic) IBOutlet UILabel *music;
@property (weak, nonatomic) IBOutlet UILabel *evaTitle;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *previewWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *makeButtonBottom;
@property (weak, nonatomic) IBOutlet UIStackView *textSuperView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *makeButtonTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *previewSuperHeight;
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
    
    [self loadTemplate];
    
    // 添加后台、前台切换的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enterBackFromFront) name:UIApplicationWillResignActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enterFrontFromBack) name:UIApplicationDidBecomeActiveNotification object:nil];
}


- (void)dealloc {
    NSLog(@"EVAPreviewViewController------dealloc");
    if (_evaPlayer) {
        [_evaPlayer stop];
        [_evaPlayer destory];
        _evaPlayer = nil;
    }
    
    if (_evaTemplate) {
        _evaTemplate = nil;
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
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
    self.previewSuperView.hidden = YES;
    self.slider.hidden = YES;
    self.textSuperView.hidden = YES;
    self.evaTitle.hidden = YES;
    self.makeBtn.hidden = YES;
    
    if ([UIScreen mainScreen].bounds.size.height < 667.0) {
        self.makeButtonTop.constant = 20;
        self.makeButtonBottom.constant = 20;
    }
}


- (void)refreshUI {
    self.text.text = [NSString stringWithFormat:@"文字 %ld段", self.texts.count];
    self.media.text = [NSString stringWithFormat:@"图片/视频 %ld个", self.medias.count];
    self.music.text = [NSString stringWithFormat:@"音乐 %ld段", self.audios.count];
    
    if (self.evaTemplate == nil) return;
    [self.view layoutIfNeeded];
    // 视频预览视图宽高
//    CGFloat sWidth  = self.previewSuperView.bounds.size.width;
//    CGFloat sHeight = self.previewSuperView.bounds.size.height;
    // 视频预览视图宽高
    CGFloat sWidth  = [UIScreen mainScreen].bounds.size.width;
    CGFloat sHeight = sWidth < 375.0 ? 250 : sWidth;
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
    self.previewSuperHeight.constant = self.previewHeight.constant;
    [UIView animateWithDuration:0.25 animations:^{
       [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        self.previewSuperView.hidden = NO;
        self.slider.hidden = NO;
        self.textSuperView.hidden = NO;
        self.evaTitle.hidden = NO;
        self.makeBtn.hidden = NO;
    }];
}


// 加载模板
- (void)loadTemplate {
//    _jsonDataPath = [NSString stringWithFormat:@"%@/jsonModel/lsq_eva_2.eva", [[NSBundle mainBundle] bundlePath]];
    
    TuSDKEvaTemplateOptions *options = [[TuSDKEvaTemplateOptions alloc] init];
    options.replaceMaxVideoCount = [UIDevice lsqDevicePlatform] <= TuSDKDevicePlatform_iPhone6p ? 5 : 9;
    options.scale = [UIDevice lsqDevicePlatform] <= TuSDKDevicePlatform_iPhone6p ? 0.3 : 1.0;
    TuSDKEvaTemplate *evaTemplate = [TuSDKEvaTemplate initWithEvaBundlePath:_evaPath];
    evaTemplate.options = options;
    _texts = [NSMutableArray arrayWithArray:evaTemplate.textAssetManager.placeholderAssets];
    _medias = [NSMutableArray arrayWithArray:evaTemplate.imageAssetManager.placeholderAssets];
    _audios = [NSMutableArray arrayWithArray:evaTemplate.audioAssetManager.placeholderAssets];

    _evaTemplate = evaTemplate;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self refreshUI];
        
        self.evaPlayer = [[TuSDKEvaPlayer alloc] initWithEvaTemplate:evaTemplate inHolderView:self.preview];
        self.evaPlayer.delegate = self;
        self.evaPlayer.loadDelegate = self;
        dispatch_async(dispatch_get_global_queue(DISPATCH_TARGET_QUEUE_DEFAULT, 0), ^{
            [self.evaPlayer load];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.evaPlayer play];
            });
        });
    });
}

#pragma mark - back & front
- (void)enterBackFromFront {
    if (self.evaPlayer && self.evaPlayer.status == TuSDKMediaPlayerStatusPlaying) {
        [self tapPreView:nil];
    }
}

- (void)enterFrontFromBack {
    
}


#pragma mark - TuSDKEvaPlayerDelegate
- (void)evaPlayer:(TuSDKEvaPlayer *)player statusChanged:(TuSDKMediaPlayerStatus)status {
    self.playBtn.hidden = self.evaPlayer.status == TuSDKMediaPlayerStatusPlaying;
    
    if (status == TuSDKMediaPlayerStatusPlaying) {
        // 避免进度未达到1，一直显示的问题
        [[TuSDK shared].messageHub dismiss];
    }
}

- (void)evaPlayer:(TuSDKEvaPlayer *)player progressChanged:(CGFloat)percent outputTime:(CMTime)outputTime {
    self.slider.value = percent;
}

#pragma mark - TuSDKEvaPlayerLoadDelegate
- (void)evaPlayer:(TuSDKEvaPlayer *)player loadProgressChanged:(CGFloat)percent {
    dispatch_sync(dispatch_get_main_queue(), ^{
//        lsqLInfo(@"++++%f", percent);
        [TuSDKProgressHUD showProgress:percent status:@"资源加载中..." maskType:TuSDKProgressHUDMaskTypeBlack];
    });
}

- (void)evaPlayer:(TuSDKEvaPlayer *)player loadStatusChanged:(TuSDKMediaPlayerLoadStatus)status {
    dispatch_async(dispatch_get_main_queue(), ^{
        switch (status) {
            case TuSDKMediaPlayerLoadStatusFailed:
                [TuSDKProgressHUD showErrorWithStatus:@"加载失败"];
                break;
            case TuSDKMediaPlayerLoadStatusCompleted:
                [TuSDKProgressHUD dismiss];
                break;
            default:
                break;
        }
    });
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
