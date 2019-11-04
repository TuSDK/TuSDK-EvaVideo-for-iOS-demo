//
//  TSDEDMusicViewController.m
//  TuSDKEvaDemo
//
//  Created by tutu on 2019/6/26.
//  Copyright © 2019 TuSdk. All rights reserved.
//

#import "MusicView.h"
#import <AVFoundation/AVFoundation.h>
#import "TuSDKFramework.h"

@interface MusicView ()<UITableViewDelegate, UITableViewDataSource>

{
    NSArray *_musics;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstant;

/**
 audiplay
 */
@property (nonatomic, strong) AVAudioPlayer *audioPlayer;

/* view */
@property (nonatomic, strong) UIView *view;

@end

@implementation MusicView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    if (self = [super initWithCoder:coder]) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
    _view = (UIView *)([[NSBundle mainBundle] loadNibNamed:@"MusicView" owner:self options:nil].firstObject);
    [self addSubview:_view];
    _musics = @[@"City Sunshine",@"Eye of Forgiveness",@"Lovely Piano Song",@"Motions",@"Pickled Pink", @"Rush"];
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"MusicViewController_CellID"];
    _tableView.rowHeight = 54;
    _topConstant.constant = [UIDevice lsqIsDeviceiPhoneX] ? 44 : 20;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _view.frame = self.bounds;
}

- (void)dealloc {
    if (_audioPlayer) {
        [_audioPlayer stop];
        _audioPlayer = nil;
    }
}

- (void)resetAudioPlayer {
    
    if (_audioPlayer) {
        [_audioPlayer stop];
        _audioPlayer = nil;
    }
    
    if (_selectedMusicPath == nil) return;
    
    NSError *error;
    _audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:_selectedMusicPath] error:&error];
    if (error) {
        NSLog(@"------audio create error: %@", error);
        return;
    }
    [_audioPlayer prepareToPlay];
    [_audioPlayer play];
}


#pragma mark - <UITableViewDelegate, UITableViewDataSource>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _musics.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MusicViewController_CellID"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor clearColor];
    cell.contentView.backgroundColor = [UIColor clearColor];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.textLabel.text = _musics[indexPath.row];
    // 已选择的音乐
    if ([self.selectedMusicPath containsString:cell.textLabel.text]) {
        cell.textLabel.textColor = [UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // 取消音乐
//    if (indexPath.row == _musics.count - 1) {
//        self.selectedMusicPath = nil;
//        [self resetAudioPlayer];
//        [self.tableView reloadData];
//        return;
//    }
    
    if ([self.selectedMusicPath containsString:_musics[indexPath.row]]) {
        if (_audioPlayer == nil) {
            [self resetAudioPlayer];
            return;
        }
        [_audioPlayer play];
    } else {
        self.selectedMusicPath = [[NSBundle mainBundle] pathForResource:_musics[indexPath.row] ofType:@"mp3"];
        [self resetAudioPlayer];
        [self.tableView reloadData];
    }
}


// 完成
- (IBAction)confim:(UIButton *)sender {
    if (_audioPlayer) {
        [_audioPlayer stop];
        _audioPlayer = nil;
    }
    if (self.selectedMusic) {
        self.selectedMusic(self.selectedMusicPath);
    }
}

@end
