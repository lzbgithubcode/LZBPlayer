//
//  LZBPlayerMoreVideoVC.m
//  LZBPlayer
//
//  Created by Apple on 2017/3/12.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "LZBPlayerMoreVideoVC.h"
#import "LZBVideoPlayCollectionViewCell.h"
#import "LZBVideoPlayer.h"
typedef NS_ENUM(NSInteger,LZBVideoScreenDirection)
{
    LZBVideoScreenDirection_None,
    LZBVideoScreenDirection_Left,
    LZBVideoScreenDirection_Right,
    
};
static NSString *LZBVideoPlayCollectionViewCellID = @"LZBVideoPlayCollectionViewCellID";

@interface LZBPlayerMoreVideoVC ()<UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;
@property (nonatomic, strong) UICollectionView *collectionView;
//数据记录
@property (nonatomic, assign) CGFloat lastContentOffsetX;
@property (nonatomic, assign)  LZBVideoScreenDirection moveDirection;
@property (nonatomic, strong)  LZBVideoPlayCollectionViewCell *playingCell;
@property (nonatomic, strong)  NSString *currentVideoPath;
@property (nonatomic, assign)  BOOL isFirst;
@property (nonatomic, assign)  NSInteger lastIndex;
@property (nonatomic, strong) NSArray *videoPaths;
@end

@implementation LZBPlayerMoreVideoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.collectionView];
    self.automaticallyAdjustsScrollViewInsets = NO;
  
}
- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self stopPlay];
}


#pragma mark - dataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return  self.videoPaths.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
     __weak __typeof(self) weakSelf = self;
    LZBVideoPlayCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:LZBVideoPlayCollectionViewCellID forIndexPath:indexPath];
    if(indexPath.row < self.videoPaths.count)
    {
        cell.videoPath = self.videoPaths[indexPath.row];
        cell.indexPath = indexPath;
        [cell setCloseClick:^{
            [weakSelf dismissViewControllerAnimated:YES completion:nil];
        }];
    }
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self handleQuickScroll];
    if(indexPath.row == 0 && !self.isFirst)
    {
        self.isFirst = YES;
        LZBVideoPlayCollectionViewCell *firstCell = (LZBVideoPlayCollectionViewCell *)cell;
        [self playFirstCellWithFirst:firstCell];
    }
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSInteger index = scrollView.contentOffset.x/[UIScreen mainScreen].bounds.size.width + 0.5;
    if(index > self.lastIndex)
    {
        self.lastIndex = index;
        // scrollView已经完全静止
        [self processNextVideoPlayEventWithDirection:LZBVideoScreenDirection_Right index:index];
    }
    else if(index < self.lastIndex)
    {
        self.lastIndex = index;
        // scrollView已经完全静止
        [self processNextVideoPlayEventWithDirection:LZBVideoScreenDirection_Left index:index];
    }
    
   
}

#pragma mark - handel

- (void)playFirstCellWithFirst:(LZBVideoPlayCollectionViewCell *)firstCell
{
    __weak __typeof(self) weakSelf = self;
    if(firstCell && firstCell.videoPath.length > 0)
    {
        self.playingCell = firstCell;
        self.currentVideoPath =firstCell.videoPath;
        NSURL *url = [NSURL URLWithString:firstCell.videoPath];
        [[LZBVideoPlayer sharedInstance] playVideoUrl:url coverImageurl:@"背景图片" showInSuperView:firstCell.contentView];
        [LZBVideoPlayer sharedInstance].openSoundWhenPlaying = YES;
        //剩余时间
        [[LZBVideoPlayer sharedInstance] setPlayerTimeProgressBlock:^(long residueTime) {
            [weakSelf.playingCell reloadTimeLabelWithTime:residueTime];
            if(residueTime == 0)
            {
                NSIndexPath *indexPath = weakSelf.playingCell.indexPath;
                NSInteger nextIndex = indexPath.row + 1;
                if(nextIndex < weakSelf.videoPaths.count)
                {
                    NSIndexPath *nextIndexPath = [NSIndexPath indexPathForRow:nextIndex inSection:0];
                    [weakSelf.collectionView scrollToItemAtIndexPath:nextIndexPath atScrollPosition:UICollectionViewScrollPositionLeft animated:YES];
                }
                
                return;
            }
            
        }];
    }
}
//停止播放
-(void)stopPlay
{
    [[LZBVideoPlayer sharedInstance] stop];
    self.playingCell = nil;
    self.currentVideoPath = nil;
}

-(void)handleQuickScroll{
    
    if (self.playingCell == nil) return;
    NSArray *visiableCells = [self.collectionView visibleCells];
    NSMutableArray *indexPaths = [NSMutableArray array];
    for (LZBVideoPlayCollectionViewCell *cell in visiableCells) {
        [indexPaths addObject:cell.indexPath];
    }
    
    BOOL isPlayingCellVisiable = YES;
    if (![indexPaths containsObject:self.playingCell.indexPath]) {
        isPlayingCellVisiable = NO;
    }
    // 当前播放视频的cell移出视线， 或者cell被快速的循环利用了， 都要移除播放器
    if (!isPlayingCellVisiable || ![self.playingCell.videoPath isEqualToString:self.currentVideoPath]) {
        [self stopPlay];
    }
}
- (void)processNextVideoPlayEventWithDirection:(LZBVideoScreenDirection)direction  index:(NSInteger)index
{

     __weak __typeof(self) weakSelf = self;
    NSArray *visiableCells = [self.collectionView visibleCells];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    LZBVideoPlayCollectionViewCell  *nextCell = (LZBVideoPlayCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
    if([self.playingCell isEqual:nextCell]) return;
    if(self.playingCell != nextCell && nextCell != nil)
    {
        NSURL *url = [NSURL URLWithString:nextCell.videoPath];
        [[LZBVideoPlayer sharedInstance] playVideoUrl:url coverImageurl:@"背景图片" showInSuperView:nextCell.contentView];
        self.playingCell = nextCell;
        self.currentVideoPath = nextCell.videoPath;
        [LZBVideoPlayer sharedInstance].openSoundWhenPlaying = YES;
         //剩余时间
         [[LZBVideoPlayer sharedInstance] setPlayerTimeProgressBlock:^(long residueTime) {
             [weakSelf.playingCell reloadTimeLabelWithTime:residueTime];
             if(residueTime == 0)
             {
                 NSIndexPath *indexPath = weakSelf.playingCell.indexPath;
                 NSInteger nextIndex = indexPath.row + 1;
                 if(nextIndex < weakSelf.videoPaths.count)
                 {
                     NSIndexPath *nextIndexPath = [NSIndexPath indexPathForRow:nextIndex inSection:0];
                     [weakSelf.collectionView scrollToItemAtIndexPath:nextIndexPath atScrollPosition:UICollectionViewScrollPositionLeft animated:YES];
                 }
                 
                 return;
             }
 
         }];
        return;
    }
    
    
    // 正在播放视频的那个cell移出视野, 则停止播放
    BOOL isPlayingCellVisiable = YES;
    if (![visiableCells containsObject:self.playingCell.indexPath]) {
        isPlayingCellVisiable = NO;
    }
    if (!isPlayingCellVisiable && self.playingCell) {
        [self stopPlay];
    }
}

#pragma mark- lazy
-(UICollectionView *)collectionView
{
    if(_collectionView == nil)
    {
        _collectionView = [[UICollectionView alloc]initWithFrame:self.view.bounds collectionViewLayout:self.flowLayout];
        _collectionView.delegate =self;
        _collectionView.dataSource =self;
        _collectionView.showsHorizontalScrollIndicator =NO;
        _collectionView.showsVerticalScrollIndicator =NO;
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.bounces = NO;
        _collectionView.pagingEnabled = YES;
        [_collectionView registerClass:[LZBVideoPlayCollectionViewCell class] forCellWithReuseIdentifier:LZBVideoPlayCollectionViewCellID];
    }
    return _collectionView;
}
- (UICollectionViewFlowLayout *)flowLayout
{
    if(_flowLayout == nil)
    {
        _flowLayout = [[UICollectionViewFlowLayout alloc]init];
        _flowLayout.minimumInteritemSpacing =0;
        _flowLayout.minimumLineSpacing =0;
        _flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _flowLayout.scrollDirection =UICollectionViewScrollDirectionHorizontal;
        _flowLayout.itemSize =[UIScreen mainScreen].bounds.size;
    }
    return _flowLayout;
}
- (NSArray *)videoPaths
{
  if(_videoPaths == nil)
  {
      _videoPaths = @[@"http://120.25.226.186:32812/resources/videos/minion_01.mp4",
                      @"http://120.25.226.186:32812/resources/videos/minion_02.mp4",
                      @"http://120.25.226.186:32812/resources/videos/minion_03.mp4",
                      @"http://120.25.226.186:32812/resources/videos/minion_04.mp4",
                      @"http://120.25.226.186:32812/resources/videos/minion_05.mp4",
                      @"http://120.25.226.186:32812/resources/videos/minion_06.mp4",
                      @"http://120.25.226.186:32812/resources/videos/minion_07.mp4"];
  }
    return _videoPaths;
}


@end
