//
//  VideoEditViewController.m
//  TuSDKEvaDemo
//
//  Created by tutu on 2019/6/26.
//  Copyright © 2019 TuSdk. All rights reserved.
//

#import "VideoEditViewController.h"
#import "TuSDKFramework.h"
#import "SegmentButton.h"
#import "VideoTrimmerView.h"
#import "TrimmerMaskView.h"
#import "VideoCuteView.h"

// 最小剪裁时长
static const NSTimeInterval kMinCutDuration = 1.0;

@interface VideoEditViewController ()<VideoTrimmerViewDelegate, UIGestureRecognizerDelegate, TuSDKMediaTimelineAssetMoviePlayerDelegate, TuSDKMediaMovieAssetTranscoderDelegate>

/**
 时间修整视图
 */
@property (weak, nonatomic) IBOutlet VideoTrimmerView *videoTrimmerView;

@property (weak, nonatomic) IBOutlet UISlider *slider;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UILabel *timeMark;

/**
 视频预览视图
 */
@property (weak, nonatomic) IBOutlet VideoCuteView *playerView;

/**
 播放按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *playButton;



/**
 多文件播放器
 */
@property (nonatomic, strong) TuSDKMediaMutableAssetMoviePlayer *moviePlayer;

/**
 视频导出管理器
 */
@property (nonatomic, strong) TuSDKMediaMovieAssetTranscoder *saver;

/**
 选取的时间范围
 */
@property (nonatomic, assign) CMTimeRange selectedTimeRange;

/**
 标识是否删除生成的临时文件
 */
@property (nonatomic, assign) BOOL removeTempFileFlag;

@end


@implementation VideoEditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    
    // 添加后台、前台切换的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enterBackFromFront) name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enterFrontFromBack) name:UIApplicationWillEnterForegroundNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [_moviePlayer stop];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [_moviePlayer updatePreViewFrame:_playerView.displayView.frame];
    NSLog(@"%@", NSStringFromCGRect(_playerView.displayView.frame));
    [_moviePlayer load];
    self.playerView.regionRatio = _cutSize.width/_cutSize.height;
}

- (void)dealloc;
{
    [_moviePlayer destory];
}

- (void)setupUI {
    
    NSArray *tracks = [self.inputAssets.firstObject tracksWithMediaType:AVMediaTypeVideo];
    if([tracks count] > 0) {
        AVAssetTrack *videoTrack = [tracks objectAtIndex:0];
        CGAffineTransform t = videoTrack.preferredTransform;
        CGSize size = videoTrack.naturalSize;
        if(t.a == 0 && t.b == 1.0 && t.c == -1.0 && t.d == 0){
            // Portrait
            size = CGSizeMake(videoTrack.naturalSize.height, videoTrack.naturalSize.width);
            
        }else if(t.a == 0 && t.b == -1.0 && t.c == 1.0 && t.d == 0){
            // PortraitUpsideDown
            size = CGSizeMake(videoTrack.naturalSize.height, videoTrack.naturalSize.width);
        }else if(t.a == 1.0 && t.b == 0 && t.c == 0 && t.d == 1.0){
            size = videoTrack.naturalSize;
            // LandscapeRight
        }else if(t.a == -1.0 && t.b == 0 && t.c == 0 && t.d == -1.0){
            // LandscapeLeft
            size = videoTrack.naturalSize;
        }
        NSLog(@"=====hello  width:%f===height:%f",size.width,size.height);//宽高
        self.playerView.videoSize = size;
    }
    [self setupPlayer];
    [self setupUIAfterAssetsPrepared];
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];
    self.navigationItem.title = @"编辑";
    
    UIButton *save = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    [save setTitle:@"确定" forState:UIControlStateNormal];
    save.titleLabel.font = [UIFont systemFontOfSize:18 weight:UIFontWeightMedium];
    [save setTitleColor:[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0] forState:UIControlStateNormal];
    [save addTarget:self action:@selector(confirm) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:save];
}


/**
 创建并配置播放器
 */
- (void)setupPlayer {
    
    NSMutableArray<TuSDKMediaAsset *> *inputMediaAssets = [NSMutableArray arrayWithCapacity:_inputAssets.count];
    [_inputAssets enumerateObjectsUsingBlock:^(AVURLAsset * _Nonnull inputAsset, NSUInteger idx, BOOL * _Nonnull stop) {
        TuSDKMediaAsset *mediaAsset = [[TuSDKMediaAsset alloc] initWithAsset:inputAsset timeRange:kCMTimeRangeInvalid];
        [inputMediaAssets addObject:mediaAsset];
    }];
    
    _moviePlayer = [[TuSDKMediaMutableAssetMoviePlayer alloc] initWithMediaAssets:inputMediaAssets preview:_playerView.displayView];
    _moviePlayer.delegate = self;
//    _moviePlayer.previewSize = self.playerView.videoSize;
//    _selectedTimeRange = CMTimeRangeMake(kCMTimeZero, _moviePlayer.asset.duration);
    _selectedTimeRange = CMTimeRangeMake(kCMTimeZero, self.duration);
    _slider.value = 1.0;
}

/**
 配置其他 UI
 */
- (void)setupUIAfterAssetsPrepared {
    NSTimeInterval duration = CMTimeGetSeconds(_moviePlayer.asset.duration);
    
    // 获取缩略图
    TuSDKVideoImageExtractor *imageExtractor = [TuSDKVideoImageExtractor createExtractor];
    //imageExtractor.isAccurate = YES; // 精确截帧
    imageExtractor.videoAssets = _inputAssets;
    const NSInteger frameCount = 10;
    imageExtractor.extractFrameCount = frameCount;
    _videoTrimmerView.thumbnailsView.thumbnailCount = frameCount;
    // 异步渐进式配置缩略图
    [imageExtractor asyncExtractImageWithHandler:^(UIImage * _Nonnull frameImage, NSUInteger index) {
        [self.videoTrimmerView.thumbnailsView setThumbnail:frameImage atIndex:index];
    }];
    
    // 配置最短截取时长
    _videoTrimmerView.minIntervalProgress = [self currentCutMinDuration]/duration;
    
    // 设置目前的范围
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.videoTrimmerView.endProgress = CMTimeGetSeconds(self.duration)/duration;
    });
    _timeMark.text = [NSString stringWithFormat:@"需截取视频的时长范围为：%0.1f~%0.1f", [self currentCutMinDuration], CMTimeGetSeconds(self.duration)];
}

- (void)confirm {
    if (_saver && _saver.status == TuSDKMediaExportSessionStatusExporting) {
        return;
    }
    [_moviePlayer pause];
    
    // 若截取时间与视频时长一致，则直接返回视频 URL
    if (CMTimeRangeEqual(_selectedTimeRange, CMTimeRangeMake(kCMTimeZero, _moviePlayer.inputDuration)) && CGSizeEqualToSize(self.playerView.videoSize, self.playerView.cutFrame.size))
    {
        /** 原始视频卫生处临时文件时不需要删除 */
        self.removeTempFileFlag = NO;
        
        if (self.editCompleted) {
            self.editCompleted( _inputAssets.firstObject.URL);
        }
        return;
    }
    
    TuSDKMediaTimeRange *timeRange = [[TuSDKMediaTimeRange alloc] initWithStart:_selectedTimeRange.start duration:_selectedTimeRange.duration];
    NSLog(@"cutDuration: %f,,, start: %f", CMTimeGetSeconds(_selectedTimeRange.duration),CMTimeGetSeconds(_selectedTimeRange.start));
    TuSDKMediaTimelineSlice *cutTimeRangeSlice = [[TuSDKMediaTimelineSlice alloc] initWithTimeRange:timeRange];
    
    // 否则进行导出
    TuSDKMediaMovieAssetTranscoderSettings *exportSettings = [[TuSDKMediaMovieAssetTranscoderSettings alloc] init];
    exportSettings.saveToAlbum = NO;
    exportSettings.enableExportAssetSound = YES;
    exportSettings.videoSoundVolume = self.slider.value;
    
    exportSettings.outputRegion = self.playerView.cutFrame;
    exportSettings.outputSize = self.playerView.cutSize;
    NSLog(@"cutSize: width-%f,  height-%f", exportSettings.outputSize.width, exportSettings.outputSize.height);
    NSLog(@"cutRegion: x-%f,  y-%f, width-%f, height-%f", exportSettings.outputRegion.origin.x, exportSettings.outputRegion.origin.y, exportSettings.outputRegion.size.width, exportSettings.outputRegion.size.height);
    // 多文件时裁剪时可以通过 _moviePlayer.videoComposition 获取 videoComposition, 开发者也可以自定义。
    [_moviePlayer appendMediaTimeSlice:cutTimeRangeSlice];
    exportSettings.videoComposition = _moviePlayer.videoComposition;
    // 通过 appendMediaTimeSlice 为播放器添加切片，只是为了生成 videoComposition。
    [_moviePlayer removeAllMediaTimeSlices];
    
    _saver = [[TuSDKMediaMovieAssetTranscoder alloc] initWithInputAsset:_moviePlayer.asset exportOutputSettings:exportSettings];
    _saver.delegate = self;
    [_saver appendSlice:cutTimeRangeSlice];
    [_saver startExport];
}


#pragma mark - 后台切换操作

/**
 进入后台
 */
- (void)enterBackFromFront {
    if (_moviePlayer) {
        if (_saver) {
            [_saver cancelExport];
        }
        [_moviePlayer stop];
    }
}

/**
 后台到前台
 */
- (void)enterFrontFromBack {
    [[TuSDK shared].messageHub dismiss];
}

#pragma mark - action

/**
 点击手势事件
 
 @param sender 点击手势
 */
- (IBAction)tapAction:(UITapGestureRecognizer *)sender {
    if (_moviePlayer.status == TuSDKMediaPlayerStatusPlaying) {
        [_moviePlayer pause];
    } else {
        if (_videoTrimmerView.currentProgress >= 1.0) {
            [_moviePlayer seekToTime:kCMTimeZero];
        }
        [_moviePlayer play];
    }
}

/**
 播放按钮事件
 
 @param sender 点击的按钮
 */
- (IBAction)palyButtonAction:(UIButton *)sender {
    if (_videoTrimmerView.currentProgress >= 1.0) {
        [_moviePlayer seekToTime:kCMTimeZero];
    }
    [_moviePlayer play];
}

- (IBAction)volumChanged:(UISlider *)sender {
    if (_moviePlayer == nil) return;
    _moviePlayer.volume = sender.value;
}

#pragma mark - VideoTrimmerViewDelegate

/**
 时间轴进度更新回调
 
 @param trimmer 时间轴
 @param progress 播放进度
 @param location 进度位置
 */
- (void)trimmer:(id<VideoTrimmerViewProtocol>)trimmer updateProgress:(double)progress atLocation:(TrimmerTimeLocation)location {
    NSTimeInterval duration = CMTimeGetSeconds(_moviePlayer.timelineOutputDuraiton);
    NSTimeInterval targetTime = duration * progress;
    
    [_moviePlayer seekToTime:CMTimeMakeWithSeconds(targetTime, _moviePlayer.timelineOutputDuraiton.timescale)];
    
    CMTimeRange timeRange = [_videoTrimmerView selectedTimeRangeAtDuration:_moviePlayer.timelineOutputDuraiton];
    _selectedTimeRange = CMTimeRangeMake(CMTimeMake(timeRange.start.value, timeRange.start.timescale), CMTimeMake(timeRange.duration.value, timeRange.duration.timescale));
}

/**
 时间轴开始滑动回调
 
 @param trimmer 时间轴
 @param location 进度位置
 */
- (void)trimmer:(id<VideoTrimmerViewProtocol>)trimmer didStartAtLocation:(TrimmerTimeLocation)location {
    [_moviePlayer pause];
    _playButton.hidden = YES;
}

/**
 时间轴结束滑动回调
 
 @param trimmer 时间轴
 @param location 进度位置
 */
- (void)trimmer:(id<VideoTrimmerViewProtocol>)trimmer didEndAtLocation:(TrimmerTimeLocation)location {
    _playButton.hidden = _moviePlayer.status == TuSDKMediaPlayerStatusPlaying;
    
    NSTimeInterval duration = CMTimeGetSeconds(_moviePlayer.asset.duration);
    if (duration == 0) {
        return;
    }
    if ((trimmer.endProgress - trimmer.startProgress) * duration <= CMTimeGetSeconds(self.duration)) {
        NSLog(@"------------------- 范围小于要选择的视频长度");
        return;
    }
    if (location == TrimmerTimeLocationLeft) {
        // 修整了左边时间，右边时间自适应
        trimmer.endProgress = MIN(trimmer.startProgress + CMTimeGetSeconds(self.duration)/duration, 1.0);
    } else if (location == TrimmerTimeLocationRight) {
        // 修整了右边的时间，左边时间自适应
        trimmer.startProgress = MAX(trimmer.endProgress - CMTimeGetSeconds(self.duration)/duration, 0.0);
    }
    [self trimmer:trimmer updateProgress:location == TrimmerTimeLocationLeft ? trimmer.startProgress : trimmer.endProgress atLocation:location];
    NSLog(@"目前截取的视频时长：%f", (trimmer.endProgress - trimmer.startProgress) * duration);
}

/**
 时间轴到达临界值回调
 
 @param trimmer 时间轴
 @param reachMaxIntervalProgress 进度最大值
 @param reachMinIntervalProgress 进度最小值
 */
- (void)trimmer:(id<VideoTrimmerViewProtocol>)trimmer reachMaxIntervalProgress:(BOOL)reachMaxIntervalProgress reachMinIntervalProgress:(BOOL)reachMinIntervalProgress {
    
    if (reachMinIntervalProgress) {
        NSString *message = [NSString stringWithFormat:NSLocalizedStringFromTable(@"tu_视频时长最少%@秒", @"VideoDemo", @"视频时长最少%@秒"), @([self currentCutMinDuration])];
        [[TuSDK shared].messageHub showToast:message];
    }
}


#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    BOOL skip = NO;
    skip = [_bottomView.layer containsPoint:[touch locationInView:_bottomView]];
    
    if (skip) return NO;
    return YES;
}

#pragma mark - TuSDKMediaTimelineAssetMoviePlayerDelegate

/**
 进度改变事件
 
 @param player 当前播放器
 @param percent (0 - 1)
 @param outputTime 当前帧所在持续时间
 @param outputSlice 当前正在输出的切片信息
 @since      v3.0
 */
- (void)mediaTimelineAssetMoviePlayer:(TuSDKMediaTimelineAssetMoviePlayer *_Nonnull)player progressChanged:(CGFloat)percent outputTime:(CMTime)outputTime outputSlice:(TuSDKMediaTimelineSlice * _Nonnull)outputSlice {
    _videoTrimmerView.currentProgress = percent;
}

/**
 播放器状态改变事件
 
 @param player 当前播放器
 @param status 当前播放器状态
 @since      v3.0
 */
- (void)mediaTimelineAssetMoviePlayer:(TuSDKMediaTimelineAssetMoviePlayer *_Nonnull)player statusChanged:(TuSDKMediaPlayerStatus)status {
    
    if (!_videoTrimmerView.dragging)
        _playButton.hidden = status == TuSDKMediaPlayerStatusPlaying;
}

#pragma mark - TuSDKMediaMovieFilmEditSaverDelegate

/**
 进度改变事件
 
 @param exportSession TuSDKMediaMovieAssetTranscoder
 @param percent (0 - 1)
 @param outputTime 当前帧所在持续时间
 @since      v3.0
 */
- (void)mediaAssetExportSession:(TuSDKMediaMovieAssetTranscoder *_Nonnull)exportSession progressChanged:(CGFloat)percent outputTime:(CMTime)outputTime {
    [TuSDKProgressHUD showProgress:percent status:@"正在处理视频" maskType:TuSDKProgressHUDMaskTypeBlack];
}

/**
 导出状态改变事件
 
 @param exportSession TuSDKMediaMovieAssetTranscoder
 @param status 当前播放器状态
 @since      v3.0
 */
- (void)mediaAssetExportSession:(TuSDKMediaMovieAssetTranscoder *_Nonnull)exportSession statusChanged:(TuSDKMediaExportSessionStatus)status {
    switch (status) {
            // 导出时被中途取消
        case TuSDKMediaExportSessionStatusCancelled:{
            
        } break;
            // 正在导出
        case TuSDKMediaExportSessionStatusExporting:{} break;
            // 导出失败
        case TuSDKMediaExportSessionStatusFailed:{} break;
            // 导出完成
        case TuSDKMediaExportSessionStatusCompleted:{} break;
            // 导出状态未知
        case TuSDKMediaExportSessionStatusUnknown:{} break;
        default:{} break;
    }
}

/**
 导出结果回调
 
 @param exportSession TuSDKMediaMovieAssetTranscoder
 @param result TuSDKVideoResult
 @param error 错误信息
 @since      v3.0
 */
- (void)mediaAssetExportSession:(TuSDKMediaMovieAssetTranscoder *_Nonnull)exportSession result:(TuSDKVideoResult *_Nonnull)result error:(NSError *_Nonnull)error {
    [TuSDKProgressHUD dismiss];
    if (result) {
        
        /** 转码后生成的时临时需要自行清楚，MovieEditor 不负责清除。*/
        self.removeTempFileFlag = YES;
        _saver = nil;
        if (self.editCompleted) {
            self.editCompleted([NSURL fileURLWithPath:result.videoPath]);
        }
    }
}


#pragma mark - getter setter
- (CGFloat)currentCutMinDuration {
    if (CMTIME_IS_INVALID(self.duration)) {
        return 0;
    }
    if (kMinCutDuration < CMTimeGetSeconds(self.duration)) {
        return kMinCutDuration;
    } else {
        return MAX(CMTimeGetSeconds(self.duration) * 0.5, 0);
    }
}


@end
