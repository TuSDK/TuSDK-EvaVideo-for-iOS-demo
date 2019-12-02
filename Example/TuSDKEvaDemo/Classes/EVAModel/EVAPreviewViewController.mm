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

@interface EVAPreviewViewController ()<TuSDKEvaPlayerDelegate, TuSDKEvaPlayerLoadDelegate, UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet UIView *preview;
@property (weak, nonatomic) IBOutlet UIView *previewSuperView;
@property (weak, nonatomic) IBOutlet EvaProgressSlider *slider;
@property (weak, nonatomic) IBOutlet UIButton *makeBtn;
@property (weak, nonatomic) IBOutlet UILabel *text;
@property (weak, nonatomic) IBOutlet UILabel *media;
@property (weak, nonatomic) IBOutlet UILabel *music;
@property (weak, nonatomic) IBOutlet UILabel *duration;
@property (weak, nonatomic) IBOutlet UILabel *evaTitle;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *previewWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *makeButtonBottom;
@property (weak, nonatomic) IBOutlet UIStackView *textSuperView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *previewSuperHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *previewHeight;
@property (weak, nonatomic) IBOutlet UIView *durationView;

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

/** 上次拖拽的进度 */
@property (nonatomic, assign) CGFloat lastProgress;

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
    
    [self.slider setThumbImage:[UIImage imageNamed:@"circle_s_ic"] forState:UIControlStateNormal];
    self.slider.value = 0.0;
    
    self.makeBtn.layer.cornerRadius = 26;
    self.makeBtn.layer.masksToBounds = YES;
    self.makeBtn.backgroundColor = [UIColor colorWithRed:0 green:122.0/255.0 blue:1.0 alpha:1.0];
    
    _texts = [NSMutableArray array];
    _medias = [NSMutableArray array];
    _audios = [NSMutableArray array];
    [self refreshUI];
    self.previewSuperView.hidden = YES;
    self.slider.hidden = YES;
    self.textSuperView.hidden = YES;
    self.evaTitle.hidden = YES;
    self.makeBtn.hidden = YES;
    self.durationView.hidden = YES;
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
    CGFloat nHeight = [UIDevice lsqIsDeviceiPhoneX] ? 88 : 64;
    CGFloat sHeight = [UIScreen mainScreen].bounds.size.height * 0.6 - nHeight;
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
    self.previewSuperHeight.constant = sHeight;
    [UIView animateWithDuration:0.25 animations:^{
       [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        self.previewSuperView.hidden = NO;
        self.slider.hidden = NO;
        self.textSuperView.hidden = NO;
        self.evaTitle.hidden = NO;
        self.makeBtn.hidden = NO;
        self.durationView.hidden = NO;
    }];
}


// 加载模板
- (void)loadTemplate {
//    _jsonDataPath = [NSString stringWithFormat:@"%@/jsonModel/lsq_eva_2.eva", [[NSBundle mainBundle] bundlePath]];
    
    TuSDKEvaTemplateOptions *options = [[TuSDKEvaTemplateOptions alloc] init];
    options.replaceMaxVideoCount = [UIDevice lsqDevicePlatform] <= TuSDKDevicePlatform_iPhone6p ? 5 : 9;
    options.scale = [UIDevice lsqDevicePlatform] <= TuSDKDevicePlatform_iPhone6p ? 0.3 : 1.0;
    
    // 7P及以下的机型保持最高分辨率是中等，即720p，其它的保证原分辨率
    options.renderSizeLever = [UIDevice lsqDevicePlatform] <= TuSDKDevicePlatform_iPhone7p ? ( [UIDevice lsqDevicePlatform] < TuSDKDevicePlatform_iPhone6s ? TuSDKEvaRenderSizeLevelLow : TuSDKEvaRenderSizeLevelMiddle) : TuSDKEvaRenderSizeLevelNormal;
//    options.renderSizeLever = TuSDKEvaRenderSizeLevelMiddle;
    // 画布分辨率设置，需要再初始化的时候传递进去
    TuSDKEvaTemplate *evaTemplate = [TuSDKEvaTemplate initWithEvaBundlePath:_evaPath options:options];
    if (evaTemplate == nil) {
        [[TuSDK shared].messageHub showError:@"  模板有误   "];
        if (self.loadTempleError) {
            self.loadTempleError();
        }
        return;
    }
    
    _texts = [NSMutableArray arrayWithArray:evaTemplate.textAssetManager.placeholderAssets];
    _medias = [NSMutableArray arrayWithArray:evaTemplate.imageAssetManager.placeholderAssets];
    _audios = [NSMutableArray arrayWithArray:evaTemplate.audioAssetManager.placeholderAssets];

    _evaTemplate = evaTemplate;
    
    // 添加mask视频，视频文件名称和模板名称对应
    TuSDKEvaImageAsset *asset;
    for (TuSDKEvaImageAsset *item in _medias) {
        if ([item isPlaceholderMaskVideoAsset]) {
            asset = item;
            break;
        }
    }
    
    // 这里预览目前只替换第一个
    if (asset) {
        NSString *file = [[NSBundle mainBundle] pathForResource:[_fileName componentsSeparatedByString:@"."].firstObject ofType:@"mp4"];
        if ([[NSFileManager defaultManager] fileExistsAtPath:file]) {
            NSURL *url = [NSURL fileURLWithPath:file];
            asset.assetURL = url;
        } else {
            NSLog(@"没找到mask视频文件");
        }
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self refreshUI];
        self.evaPlayer = [[TuSDKEvaPlayer alloc] initWithEvaTemplate:evaTemplate inHolderView:self.preview];
        self.evaPlayer.delegate = self;
        self.evaPlayer.loadDelegate = self;
        __weak typeof(self) weakSelf = self;
        dispatch_async(dispatch_get_global_queue(DISPATCH_TARGET_QUEUE_DEFAULT, 0), ^{
            [weakSelf.evaPlayer load];
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.evaPlayer play];
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
    [self refreshCurrentTime:outputTime];
}

#pragma mark - TuSDKEvaPlayerLoadDelegate
- (void)evaPlayer:(TuSDKEvaPlayer *)player loadProgressChanged:(CGFloat)percent {

//    lsqLInfo(@"++++%f", percent);
    [TuSDKProgressHUD showProgress:percent status:@"资源加载中..." maskType:TuSDKProgressHUDMaskTypeBlack];
}

- (void)evaPlayer:(TuSDKEvaPlayer *)player loadStatusChanged:(TuSDKMediaPlayerLoadStatus)status {
    switch (status) {
        case TuSDKMediaPlayerLoadStatusFailed:
            [TuSDKProgressHUD showErrorWithStatus:@"加载失败"];
            break;
        case TuSDKMediaPlayerLoadStatusCompleted:
            [TuSDKProgressHUD dismiss];
//                [self refreshCurrentTime:kCMTimeZero];
            break;
        default:
            break;
    }
}

- (void)refreshCurrentTime:(CMTime)currentTime {
    CMTime dur = self.evaPlayer.durationTime;
    int duration = round(CMTimeGetSeconds(dur));
    int current = MIN(round(CMTimeGetSeconds(currentTime)), duration);
    self.duration.text = [NSString stringWithFormat:@"%02d:%02d/%02d:%02d",(current/60),(current%60),(duration/60),(duration%60)];
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
        _lastProgress = 0;
    }
    // seek
    CMTime duration = self.evaPlayer.durationTime;
    CMTime seek = CMTimeMake(sender.value * duration.value, duration.timescale);
    
    if (abs(sender.value - _lastProgress) > 0.03) {
        // 拖拽了百分之一才开始seek
        [self.evaPlayer seekToTime:seek];
        _lastProgress = sender.value;
    } else {
        // 拖拽变化值太低
//        NSLog(@"拖拽变化值太低");
    }
    
    // time
    int total = CMTimeGetSeconds(duration);
    int current = CMTimeGetSeconds(seek);
    self.duration.text = [NSString stringWithFormat:@"%02d:%02d/%02d:%02d",(current/60),(current%60),(total/60),(total%60)];
}

// 进度拖拽完成
- (IBAction)sliderCompleted:(UISlider *)sender {
    if (self.evaPlayer == nil ) return;
    if (_sliderBefore) {
        [self.evaPlayer play];
    }
    _isSeek = NO;
}

- (IBAction)lastFrame:(UIButton *)sender {
    if (self.evaPlayer == nil ) return;
    [self.evaPlayer pause];
    [self.evaPlayer seekToTime:self.evaPlayer.durationTime];
    self.slider.value = 1.0;
    [self refreshCurrentTime:self.evaPlayer.durationTime];
}

- (IBAction)firstFrame:(UIButton *)sender {
    if (self.evaPlayer == nil ) return;
    [self.evaPlayer pause];
    [self.evaPlayer seekToTime:kCMTimeZero];
    self.slider.value = 0.0;
    [self refreshCurrentTime:kCMTimeZero];
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
