//
//  LZBVideoPlayCollectionViewCell.m
//  LZBPlayer
//
//  Created by Apple on 2017/2/20.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "LZBVideoPlayCollectionViewCell.h"
#define   closeButton_leftDefaultMargin 20
#define   closeButton_topDefaultMargin 30
#define   closeButton_WidthHeight 35
#define    timeLabel_TopMargin 20
#define    timeLabel_RightMargin 30
#define    timeLabel_WidthHeight 35

@interface LZBVideoPlayCollectionViewCell()
@property (nonatomic, strong) UIButton *closeButton;
@property (nonatomic, strong) UILabel *timeLabel;
@end

@implementation LZBVideoPlayCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame
{
  if(self = [super initWithFrame:frame])
  {
      [self setupUI];
  }
    return self;
}

- (void)setupUI
{
    [self.contentView insertSubview:self.closeButton atIndex:0];
    self.closeButton.frame = CGRectMake(closeButton_topDefaultMargin, closeButton_topDefaultMargin, closeButton_WidthHeight, closeButton_WidthHeight);
    [self.contentView insertSubview:self.timeLabel atIndex:0];
    self.timeLabel.frame = CGRectMake([UIScreen mainScreen].bounds.size.width -timeLabel_RightMargin-timeLabel_WidthHeight,timeLabel_TopMargin, timeLabel_WidthHeight, timeLabel_WidthHeight);
}

#pragma mark - API
- (void)closeButtonClick
{
    if(self.closeClick)
        self.closeClick();
}

- (void)reloadTimeLabelWithTime:(NSInteger)time
{
    self.timeLabel.text = [NSString stringWithFormat:@"%ld",time];
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
