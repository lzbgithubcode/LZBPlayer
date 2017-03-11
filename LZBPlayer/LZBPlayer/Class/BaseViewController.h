//
//  BaseViewController.h
//  LZBPlayer
//
//  Created by Apple on 2017/2/19.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController
@property (nonatomic, strong) NSString *videoPath;
- (void)playerButtonClick:(UIButton *)playButton;
@end
