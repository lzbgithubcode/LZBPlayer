//
//  ViewController.m
//  LZBPlayer
//
//  Created by Apple on 2017/2/19.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "ViewController.h"
#import "LZBAVPlayerVC.h"
#import "LZBMPMoviePlayerControllerVC.h"
#import "LZBMPMoviePlayerViewControllerVC.h"

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSArray <NSString *> *playStyleArray;
@property (nonatomic, strong) NSArray <UIViewController *> *playVCarray;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     self.title = @"选择播放器播放视频";
    [self.view addSubview:self.tableView];
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.playStyleArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"cellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if(cell == nil)
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    cell.textLabel.text = self.playStyleArray[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BaseViewController *baseVC = (BaseViewController *)self.playVCarray[indexPath.row];
  //  baseVC.videoPath = @"http://m3u8back.gougouvideo.com/m3u8_yyyy?i=4275259";
    baseVC.videoPath = @"http://v1.mukewang.com/3e35cbb0-c8e5-4827-9614-b5a355259010/L.mp4";
    [self.navigationController pushViewController:baseVC animated:YES];
}


#pragma mark - lazy
- (UITableView *)tableView
{
  if(_tableView == nil)
  {
      _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
      _tableView.delegate = self;
      _tableView.dataSource = self;
  }
    return _tableView;
}

- (NSArray<NSString *> *)playStyleArray
{
    return @[@"MPMoviePlayerController播放视频",@"MPMoviePlayerViewController播放视频",@"AVPlayer播放视频"];
}

- (NSArray<UIViewController *> *)playVCarray
{
    return @[[[LZBMPMoviePlayerControllerVC alloc]init],[[LZBMPMoviePlayerViewControllerVC alloc]init],[[LZBAVPlayerVC alloc]init]];
}






@end
