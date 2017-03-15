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
    [self stopPlayer];
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
    if(firstCell == nil) return;
    if(firstCell.videoPath.length == 0) return;
    
    self.playingCell = firstCell;
    self.currentVideoPath =firstCell.videoPath;
    NSURL *url = [NSURL URLWithString:firstCell.videoPath];
    [self startPlayerWithUrl:url coverImageUrl:@"设置背景图片" playerSuperView:firstCell.contentView];
    
}
//停止播放
-(void)stopPlayer
{
    [[LZBVideoPlayer sharedInstance] stop];
    self.playingCell = nil;
    self.currentVideoPath = nil;
}

//开始播放
- (void)startPlayerWithUrl:(NSURL *)url coverImageUrl:(NSString *)coverUrl playerSuperView:(UIView *)superView
{
    
     __weak __typeof(self) weakSelf = self;
    [[LZBVideoPlayer sharedInstance] playVideoUrl:url coverImageurl:coverUrl showInSuperView:superView];
    [LZBVideoPlayer sharedInstance].openSoundWhenPlaying = YES;
    //剩余时间
    [[LZBVideoPlayer sharedInstance] setPlayerTimeProgressBlock:^(long residueTime) {
        [weakSelf.playingCell reloadTimeLabelWithTime:residueTime];
        if(residueTime == 0)
        {
            //播放完成，自动滚动到下一页
            [weakSelf scrollToNextCell];
        }
        
    }];
}
//滚动到下一个cell
- (void)scrollToNextCell
{
    NSIndexPath *indexPath = self.playingCell.indexPath;
    NSInteger nextIndex = indexPath.row + 1;
    if(nextIndex < self.videoPaths.count)
    {
        NSIndexPath *nextIndexPath = [NSIndexPath indexPathForRow:nextIndex inSection:0];
        [self.collectionView scrollToItemAtIndexPath:nextIndexPath atScrollPosition:UICollectionViewScrollPositionLeft animated:YES];
    }
    else
        return;
}

- (void)processNextVideoPlayEventWithDirection:(LZBVideoScreenDirection)direction  index:(NSInteger)index
{
   //获取当前屏幕的cell
    NSArray *visiableCells = [self.collectionView visibleCells];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    LZBVideoPlayCollectionViewCell  *nextCell = (LZBVideoPlayCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
    if([self.playingCell isEqual:nextCell]) return;
    if(nextCell == nil) return;
    
    //屏幕到中间时候，停止上一个cell视频播放
    if ([visiableCells containsObject:self.playingCell]) {
        [self stopPlayer];
    }

    //开始播放下一个视频
    self.playingCell = nextCell;
    self.currentVideoPath = nextCell.videoPath;
    NSURL *url = [NSURL URLWithString:nextCell.videoPath];
   [self startPlayerWithUrl:url coverImageUrl:@"设置背景图片" playerSuperView:nextCell.contentView];
    
    
   
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
