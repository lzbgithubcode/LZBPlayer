//
//  LZBAVPlayerVC.m
//  LZBPlayer
//
//  Created by Apple on 2017/2/19.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "LZBAVPlayerVC.h"
#import "LZBVideoPlayer.h"

#define   closeButton_leftDefaultMargin 20
#define   closeButton_topDefaultMargin 30
#define   closeButton_WidthHeight 35
#define    timeLabel_TopMargin 20
#define    timeLabel_RightMargin 30
#define    timeLabel_WidthHeight 35
@interface LZBAVPlayerVC ()
@property (nonatomic, strong) UIButton *closeButton;
@property (nonatomic, strong) UILabel *timeLabel;
@end

@implementation LZBAVPlayerVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupPlayer];
    [self setupUI];
}


- (void)setupPlayer
{
  //播放单个视频
     __weak __typeof(self) weakSelf = self;
    
    NSString *videoPath = self.videoPath;
    [[LZBVideoPlayer sharedInstance] playVideoUrl:[NSURL URLWithString:videoPath] coverImageurl:@"背景图片路径" showInSuperView:self.view];
    [LZBVideoPlayer sharedInstance].openSoundWhenPlaying = YES;
    [[LZBVideoPlayer sharedInstance] setPlayerTimeProgressBlock:^(long residueTime) {
        [weakSelf reloadTimeProgress:residueTime];
    }];
}
- (void)setupUI
{
    [self.view insertSubview:self.closeButton atIndex:0];
    self.closeButton.frame = CGRectMake(closeButton_topDefaultMargin, closeButton_topDefaultMargin, closeButton_WidthHeight, closeButton_WidthHeight);
    [self.view insertSubview:self.timeLabel atIndex:0];
    self.timeLabel.frame = CGRectMake([UIScreen mainScreen].bounds.size.width -timeLabel_RightMargin-timeLabel_WidthHeight,timeLabel_TopMargin, timeLabel_WidthHeight, timeLabel_WidthHeight);
}

- (void)stopPlayer
{
    [[LZBVideoPlayer sharedInstance] stop];
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)closeButtonClick
{
    [self stopPlayer];
}
- (void)reloadTimeProgress:(NSInteger)time
{
    NSLog(@"======%ld",time);
    self.timeLabel.text =[NSString stringWithFormat:@"%ld",time];
    if(time == 0)
        [self stopPlayer];
}

#pragma mark - lazy
- (UIButton *)closeButton
{
    if(_closeButton == nil)
    {
        _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeButton setImage:[UIImage imageNamed:@"shortvideo_button_close"] forState:UIControlStateNormal];
        [_closeButton addTarget:self action:@selector(closeButtonClick) forControlEvents:UIControlEventTouchUpInside];
         _closeButton.backgroundColor = [UIColor greenColor];
    }
    return _closeButton;
}
-(UILabel *)timeLabel
{
  if(_timeLabel ==nil)
  {
      _timeLabel = [UILabel new];
      _timeLabel.font = [UIFont systemFontOfSize:16.0];
      _timeLabel.textColor = [UIColor redColor];
      _timeLabel.text = @"0";
      _timeLabel.textAlignment = NSTextAlignmentCenter;
      _timeLabel.backgroundColor = [UIColor greenColor];
  }
    return _timeLabel;
}





@end
