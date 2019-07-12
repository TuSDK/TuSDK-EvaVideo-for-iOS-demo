//
//  TSDEDMusicViewController.m
//  TuSDKEvaDemo
//
//  Created by tutu on 2019/6/26.
//  Copyright © 2019 TuSdk. All rights reserved.
//

#import "MusicViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface MusicViewController ()<UITableViewDelegate, UITableViewDataSource>

{
    NSArray *_musics;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;

/**
 audiplay
 */
@property (nonatomic, strong) AVAudioPlayer *audioPlayer;

@end

@implementation MusicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _musics = @[@"City Sunshine",@"Eye of Forgiveness",@"Lovely Piano Song",@"Motions",@"Pickled Pink",@"Rush"];
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"MusicViewController_CellID"];
}

- (void)dealloc {
    if (_audioPlayer) {
        [_audioPlayer stop];
        _audioPlayer = nil;
    }
}

- (void)resetAudioPlayer {
    
    if (_selectedMusicPath == nil) return;
    
    if (_audioPlayer) {
        [_audioPlayer stop];
        _audioPlayer = nil;
    }
    
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
    if ([self.selectedMusicPath containsString:cell.textLabel.text]) {
        cell.textLabel.textColor = [UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
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

// 取消
- (IBAction)cancel:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


// 完成
- (IBAction)confim:(UIButton *)sender {
    if (self.selectedMusic) {
        self.selectedMusic(self.selectedMusicPath);
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
