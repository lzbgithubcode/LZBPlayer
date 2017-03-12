//
//  LZBVideoPlayer.h
//  LZBPlayer
//
//  Created by Apple on 2017/2/20.
//  Copyright © 2017年 Apple. All rights reserved.
//
//封装的视频工具类，如果可以播放本地视频也可以播放网络视频
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@protocol LZBVideoPlayerLoadingDelegate <NSObject>

@required
- (void)startAnimating;
- (void)stopAnimating;

@end

@interface LZBVideoPlayer : NSObject

//单例初始化播放器
+ (instancetype)sharedInstance;

/**
   传入url自动播放， superView 是表示在哪里播放，传入视频播放层的父控件
 */
- (void)playVideoUrl:(NSURL *)url showInSuperView:(UIView *)superView;

/**
   传入url自动播放，coverUrl默认的加载背景图 superView是表示在哪里播放，传入视频播放层的父控件
 */
- (void)playVideoUrl:(NSURL *)url coverImageurl:(NSString *)coverUrl showInSuperView:(UIView *)superView;
/**
    返回剩余时间
 */
@property (nonatomic, copy) void(^playerTimeProgressBlock)(long residueTime);
- (void)setPlayerTimeProgressBlock:(void (^)(long residueTime))playerTimeProgressBlock;

/**
  播放与重播
 */
- (void)playWithResume;

/**
  暂停
 */
- (void)pause;
/**
  停止
 */
- (void)stop;



#pragma mark - config 属性

/**
 * 视频加载视图, 默认为系统UIActivityIndicatorView
 */
@property (nonatomic,strong) UIView<LZBVideoPlayerLoadingDelegate> *loadingView;

/**
 * 默认YES. 当app加载视频是否显示加载动画
 */
@property (nonatomic, assign) BOOL showActivityWhenLoading;
/**
 * 默认YES.  当app进入后台是否停止播放
 */
@property (nonatomic, assign) BOOL stopWhenAppDidEnterBackground;

/**
 * 默认NO.  当播放的时候是否打开声音
 */
@property(nonatomic, assign)  BOOL openSoundWhenPlaying;
@end
