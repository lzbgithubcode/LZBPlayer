//
//  LZBVideoPlayCollectionViewCell.h
//  LZBPlayer
//
//  Created by Apple on 2017/2/20.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^LZBVideoPlayCollectionViewCellCloseClickBlock)();
@interface LZBVideoPlayCollectionViewCell : UICollectionViewCell
/** videoPath */
@property(nonatomic, strong)NSString *videoPath;
@property(nonatomic, strong)NSIndexPath *indexPath;

//点击关闭按钮
@property (nonatomic, copy) LZBVideoPlayCollectionViewCellCloseClickBlock closeClick;
-(void)setCloseClick:(LZBVideoPlayCollectionViewCellCloseClickBlock)closeClick;

//刷新时间的数据
- (void)reloadTimeLabelWithTime:(NSInteger)time;
@end
