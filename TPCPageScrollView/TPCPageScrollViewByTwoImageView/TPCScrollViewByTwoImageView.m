//
//  TPCScrollViewByTwoImageView.m
//
//  Created by tripleCC on 15/6/30.
//  Copyright (c) 2015年 tripleCC. All rights reserved.
//

#import "TPCScrollViewByTwoImageView.h"

@interface TPCScrollViewByTwoImageView() <UIScrollViewDelegate>

@property (weak, nonatomic) UIScrollView *scrollView;
/**
 *  当前显示的view
 */
@property (weak, nonatomic) UIImageView *currentView;

/**
 *  备份的view（左右滑动时，显示的view）
 */
@property (weak, nonatomic) UIImageView *backupView;
@end

@implementation TPCScrollViewByTwoImageView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setUp];
    }
    
    return self;
}

- (void)awakeFromNib
{
    [self setUp];
}

- (void)setUp
{
    // 创建需要的三个控件
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.pagingEnabled = YES;
    scrollView.bounces = NO;
    scrollView.delegate = self;
    scrollView.backgroundColor = [UIColor redColor];
    [self addSubview:scrollView];
    self.scrollView = scrollView;
    
    UIImageView *currentView = [[UIImageView alloc] init];
    [self.scrollView addSubview:currentView];
    self.currentView = currentView;
    
    UIImageView *backupView = [[UIImageView alloc] init];
    [self.scrollView addSubview:backupView];
    self.backupView = backupView;
    
    self.backgroundColor = [UIColor greenColor];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.scrollView.frame = self.bounds;
    
    CGFloat imageViewW = self.bounds.size.width;
    CGFloat imageViewH = self.bounds.size.height;
    // 设置scrollView的内容大小
    self.scrollView.contentSize = CGSizeMake(imageViewW * 3, 0);
    
    // 设置imageView的frame
    self.currentView.frame = CGRectMake(imageViewW, 0, imageViewW, imageViewH);
    self.backupView.frame = CGRectMake(imageViewW * 2, 0, imageViewW, imageViewH);
    
    // 开始后执行一次初始偏移
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        self.scrollView.contentOffset = CGPointMake(imageViewW, 0);
    });
}

- (void)setImages:(NSArray *)images
{
    _images = images;
    
    // 设置默认图片
    self.currentView.image = images[0];
    self.backupView.image = images[1];
    
    // 设置tag为图片下标
    self.currentView.tag = 0;
    self.backupView.tag = 1;
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat offsetX = scrollView.contentOffset.x;
    
    // 根据偏移量，设置backView的图片，并修改其图片下标
    if (offsetX < self.bounds.size.width) {
        self.backupView.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
        self.backupView.tag = (self.currentView.tag - 1 + self.images.count) % self.images.count;
        self.backupView.image = self.images[self.backupView.tag];
    } else if (offsetX > self.bounds.size.width) {
        self.backupView.frame = CGRectMake(self.bounds.size.width * 2, 0, self.bounds.size.width, self.bounds.size.height);
        self.backupView.tag = (self.currentView.tag + 1) % self.images.count;
        self.backupView.image = self.images[self.backupView.tag];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat offsetX = scrollView.contentOffset.x;
    
    // 停止时，设置偏移量为currentView所在位置
    scrollView.contentOffset = CGPointMake(self.bounds.size.width, 0);
    
    // 实际上没有换页，就返回
    if (offsetX < self.bounds.size.width * 1.5 && offsetX > self.bounds.size.width * 0.5) {
        return;
    }
    
    // 根据backView的image，来进行图片更换
    self.currentView.image = self.backupView.image;
    
    // 设置当前图片下标
    self.currentView.tag = self.backupView.tag;
}

@end
