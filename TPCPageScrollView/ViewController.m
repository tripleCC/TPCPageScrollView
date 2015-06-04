//
//  ViewController.m
//  TPCPageScrollView
//
//  Created by 宋瑞旺 on 15/6/1.
//  Copyright (c) 2015年 宋瑞旺. All rights reserved.
//

#import "ViewController.h"
#import "TPCPageScrollView.h"

#define kImageNumber 4

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
    
    [self addTestWidget];
}

- (void)addTestWidget
{
    CGFloat height = 40;
    CGFloat btnWidth = 60;
    
    UILabel *pagingIntervalLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height - height, self.view.bounds.size.width, height)];
    pagingIntervalLabel.text = [NSString stringWithFormat:@"轮切间隔%.1f", self.pageView.pagingInterval];
    pagingIntervalLabel.textAlignment = NSTextAlignmentCenter;
    pagingIntervalLabel.textColor = [UIColor orangeColor];
    pagingIntervalLabel.font = [UIFont systemFontOfSize:25.0];
    [self.view addSubview:pagingIntervalLabel];
    
    self.pagingIntervalLabel = pagingIntervalLabel;
    
    UIButton *btnLeft = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnLeft setTitle:@"上一处" forState: UIControlStateNormal];
    [btnLeft setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    btnLeft.frame = CGRectMake(0, pagingIntervalLabel.frame.origin.y, btnWidth, height);
    [btnLeft addTarget:self action:@selector(btnLeftOnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnLeft];
    
    UIButton *btnRight = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnRight setTitle:@"下一处" forState: UIControlStateNormal];
    [btnRight setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    btnRight.frame = CGRectMake(self.view.bounds.size.width - btnWidth, pagingIntervalLabel.frame.origin.y, btnWidth, height);
    [btnRight addTarget:self action:@selector(btnRightOnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnRight];
}

- (void)btnLeftOnClick:(UIButton *)btn
{
    self.pageView.pageControlPostion = TPCPageControlPositionBottomCenter;
}

- (void)btnRightOnClick:(UIButton *)btn
{
    self.pageView.pageControlPostion = TPCPageControlPositionBottomRight;
}

- (NSArray *)images
{
    if (nil == _images) {
        NSMutableArray *images = [NSMutableArray arrayWithCapacity:kImageNumber];
        
        for (int i = 0; i < kImageNumber; i++) {
            NSString *imageName = [NSString stringWithFormat:@"%d.png", i + 1];
            [images addObject:[UIImage imageNamed:imageName]];
        }
        self.images = images;
    }
    
    return _images;
}

- (UIColor *)randomColor {
    CGFloat hue = ( arc4random() % 256 / 256.0 );
    CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5;
    CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5;
    return [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.pageView.pagingInterval = arc4random_uniform(8);
    
    self.pageView.currentPageColor = [self randomColor];
    self.pageView.otherPageColor = [self randomColor];
    
    self.pageView.frame = CGRectMake(arc4random_uniform(100), arc4random_uniform(300), arc4random_uniform(200) + 100, arc4random_uniform(200) + 200);
    
    self.pagingIntervalLabel.text = [NSString stringWithFormat:@"轮切间隔%.1f", self.pageView.pagingInterval];
}


- (BOOL)prefersStatusBarHidden
{
   return YES;
}
@end
