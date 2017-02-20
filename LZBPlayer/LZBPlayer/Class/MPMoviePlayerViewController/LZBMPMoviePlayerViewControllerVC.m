//
//  LZBMPMoviePlayerViewControllerVC.m
//  LZBPlayer
//
//  Created by Apple on 2017/2/19.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "LZBMPMoviePlayerViewControllerVC.h"
#import <MediaPlayer/MediaPlayer.h>

@interface LZBMPMoviePlayerViewControllerVC ()
@property (nonatomic, strong) MPMoviePlayerViewController *player;
@end

@implementation LZBMPMoviePlayerViewControllerVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blueColor];;
}

- (void)playerButtonClick:(UIButton *)playButton
{
    [self presentMoviePlayerViewControllerAnimated:self.player];
}



#pragma mark - lazy
- (MPMoviePlayerViewController *)player
{
   if(_player == nil)
   {
       // 1.创建播放器
       NSURL *url = [NSURL URLWithString:self.videoPath];
       _player = [[MPMoviePlayerViewController alloc]initWithContentURL:url];

   }
    return _player;
}

@end
