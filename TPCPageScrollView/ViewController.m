//
//  ViewController.m
//  TPCPageScrollView
//
//  Created by 宋瑞旺 on 15/6/1.
//  Copyright (c) 2015年 宋瑞旺. All rights reserved.
//

#import "ViewController.h"
#import "TPCPageScrollView.h"

#define kImageNumber 10

@interface ViewController ()

@property (strong, nonatomic) NSArray *images;
//@property (weak, nonatomic) IBOutlet TPCPageScrollView *pageScrollView;
@property (weak, nonatomic) TPCPageScrollView *pageView;

@property (weak, nonatomic) UILabel *pagingIntervalLabel;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    TPCPageScrollView *pageScrollView = [[TPCPageScrollView alloc] initWithFrame:CGRectMake(20, 0, 200, 300)];
    pageScrollView.images = self.images;
    pageScrollView.pagingInterval = 1.0;
    [pageScrollView startAutoPaging];
    [self.view addSubview:pageScrollView];
    
    self.pageView = pageScrollView;
    
    UILabel *pagingIntervalLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height - 40, self.view.bounds.size.width, 40)];
    pagingIntervalLabel.text = [NSString stringWithFormat:@"轮切间隔%.1f", pageScrollView.pagingInterval];
    pagingIntervalLabel.textAlignment = NSTextAlignmentCenter;
    pagingIntervalLabel.textColor = [UIColor orangeColor];
    pagingIntervalLabel.font = [UIFont systemFontOfSize:25.0];
    [self.view addSubview:pagingIntervalLabel];
    
    self.pagingIntervalLabel = pagingIntervalLabel;
}

- (NSArray *)images
{
    if (nil == _images) {
        NSMutableArray *images = [NSMutableArray arrayWithCapacity:10];
        
        for (int i = 0; i < kImageNumber; i++) {
            NSString *imageName = [NSString stringWithFormat:@"%d.png", i + 1];
            [images addObject:[UIImage imageNamed:imageName]];
        }
        self.images = images;
    }
    
    return _images;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.pageView.pagingInterval = arc4random_uniform(8);
    self.pageView.currentPageColor = [UIColor redColor];
    self.pageView.otherPageColor = [UIColor blackColor];
    self.pageView.frame = CGRectMake(arc4random_uniform(100), arc4random_uniform(100), 200, 300);
    
    self.pagingIntervalLabel.text = [NSString stringWithFormat:@"轮切间隔%.1f", self.pageView.pagingInterval];
}


- (BOOL)prefersStatusBarHidden
{
   return YES;
}
@end
