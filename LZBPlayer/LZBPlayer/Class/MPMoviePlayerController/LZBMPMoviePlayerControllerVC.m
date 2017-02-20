//
//  LZBMPMoviePlayerControllerVC.m
//  LZBPlayer
//
//  Created by Apple on 2017/2/19.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "LZBMPMoviePlayerControllerVC.h"
#import <MediaPlayer/MediaPlayer.h>

@interface LZBMPMoviePlayerControllerVC ()

@property (nonatomic, strong) MPMoviePlayerController *player;



@end

@implementation LZBMPMoviePlayerControllerVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor grayColor];
}

- (void)playerButtonClick:(UIButton *)playButton
{
     //三部曲
    playButton.selected = !playButton.selected;
    
    
    if(playButton.isSelected)
    {
        [self.player prepareToPlay];  //这句代码很重要
        if([self.player isPreparedToPlay])
            [self.player play];
    }
   else
    {
        [self.player stop];
    }
    
}

-(void)loadStateDidChange:(NSNotification*)sender
{
    switch (self.player.loadState) {
        case MPMovieLoadStatePlayable:
        {
            NSLog(@"加载完成,可以播放");
        }
            break;
        case MPMovieLoadStatePlaythroughOK:
        {
            NSLog(@"缓冲完成，可以连续播放");
        }
            break;
        case MPMovieLoadStateStalled:
        {
            NSLog(@"缓冲中");
        }
            break;
        case MPMovieLoadStateUnknown:
        {
            NSLog(@"未知状态");
        }
            break;
        default:
            break;
    }
}



#pragma mark - lazy
- (MPMoviePlayerController *)player
{
  if(_player == nil)
  {
       // 1.创建播放器
      NSURL *url = [NSURL URLWithString:self.videoPath];
      _player = [[MPMoviePlayerController alloc]initWithContentURL:url];
      
      // 2.给播放器内部的View设置frame
      _player.view.frame = CGRectMake(0, 64, self.view.bounds.size.width, self.view.bounds.size.width * 9 / 16);
      
      // 3.添加到控制器View中
      [self.view addSubview:_player.view];
      
      //监听当前视频播放状态
      [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(loadStateDidChange:) name:MPMoviePlayerLoadStateDidChangeNotification object:nil];
      
      // 4.设置控制面板的显示
      //_player.controlStyle = MPMovieControlStyleFullscreen;
  }
    return _player;
}








@end
