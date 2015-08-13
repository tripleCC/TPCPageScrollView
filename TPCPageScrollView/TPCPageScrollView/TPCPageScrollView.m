//
//  TPCPageScrollView.m
//  TPCPageScrollView
//
//  Created by 宋瑞旺 on 15/6/1.
//  Copyright (c) 2015年 宋瑞旺. All rights reserved.
//

#import "TPCPageScrollView.h"

#define kPageControlHeight 37
#define kPageControlEachWidth 16

#define kDefaultDuration 2.0

@interface TPCPageScrollView() <UIScrollViewDelegate>

@property (weak, nonatomic) UIScrollView *scrollView;
@property (weak, nonatomic) UIPageControl *pageControl;

@property (weak, nonatomic) UIImageView *leftImageView;
@property (weak, nonatomic) UIImageView *currentImageView;
@property (weak, nonatomic) UIImageView *rightImageView;

@property (strong, nonatomic) NSTimer *timer;

@property (assign, nonatomic, getter=isAutoPaging) BOOL autoPaging;
@end

@implementation TPCPageScrollView

/**
 * 代码创建
 */
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        // 创建控件并初始化
        [self setup];
        
        [self createImageView];
    }
    
    return  self;
}

/**
 * 从storyboard或者xib加载
 */
- (void)awakeFromNib
{
    // 创建控件并初始化
    [self setup];
    
    [self createImageView];
}

/**
 * 创建控件并初始化
 */
- (void)setup
{
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.pagingEnabled = YES;
    scrollView.scrollEnabled = YES;
    scrollView.delegate = self;
    
    // 取消弹簧效果，不然拖动会出现问题
    scrollView.bounces = NO;

    
    UIPageControl *pageControl = [[UIPageControl alloc] init];
    
    // 对于单个图片隐藏
    pageControl.hidesForSinglePage = YES;

    [self addSubview:scrollView];
    [self addSubview:pageControl];
    self.pageControl = pageControl;
    self.scrollView = scrollView;
    
    // 默认不开启自动切换图片
    self.autoPaging = NO;
    
    // 设置默认切图间隔
    self.pagingInterval = kDefaultDuration;
    
    // 设置页索引默认位置为右下角
    self.pageControlPostion = TPCPageControlPositionBottomRight;
}

/**
 * 创建循环UIImageView
 */
- (void)createImageView
{
    UIImageView *leftImageView = [[UIImageView alloc] init];
    UIImageView *currentImageView = [[UIImageView alloc] init];
    UIImageView *rightImageView = [[UIImageView alloc] init];
    
    [self.scrollView addSubview:leftImageView];
    [self.scrollView addSubview:currentImageView];
    [self.scrollView addSubview:rightImageView];
    
    self.leftImageView = leftImageView;
    self.currentImageView = currentImageView;
    self.rightImageView = rightImageView;
}

- (void)setImages:(NSArray *)images
{
    _images = images;
    
    // 设置默认图片
    self.leftImageView.image = images[images.count - 1];
    self.currentImageView.image = images[0];
    self.rightImageView.image = images[1];
    
    self.leftImageView.tag = images.count - 1;
    self.currentImageView.tag = 0;
    self.rightImageView.tag = 1;
    
    //设置页数
    self.pageControl.numberOfPages = images.count;
    
    [self setNeedsLayout];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // 因为外界可以动态改变frame，所以有关frame的设置都在layoutSubviews中设置
    
    // 设置子控件的frame
    self.scrollView.frame = self.bounds;
    
    CGFloat imageViewW = self.scrollView.bounds.size.width;
    CGFloat imageViewH = self.scrollView.bounds.size.height;
    
    self.leftImageView.frame = CGRectMake(0, 0, imageViewW, imageViewH);
    self.currentImageView.frame = CGRectMake(imageViewW, 0, imageViewW, imageViewH);
    self.rightImageView.frame = CGRectMake(imageViewW * 2, 0, imageViewW, imageViewH);
    
    // 设置UIScrollView滚动内容大小
    self.scrollView.contentSize = CGSizeMake(imageViewW * 3, 0);
    
    // 设置UIPageControl位置
    [self setPageControlPostion];
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // 启动程序后第一次执行子控件调整时，改变一次偏移量值，使其显示中间的UIImageView
        [self.scrollView setContentOffset:CGPointMake(imageViewW, 0)];
    });
    
    // 父控件frame变化后立即更新内容
    [self updateContent];
}

/**
 * 设置页索引位置
 */
- (void)setPageControlPostion
{
    CGFloat pageControlCenterX;
    CGFloat pageControlCenterY;
    if (TPCPageControlPositionBottomCenter == self.pageControlPostion) {
        pageControlCenterX = self.bounds.size.width / 2.0;
    } else if (TPCPageControlPositionBottomRight == self.pageControlPostion) {
        pageControlCenterX = self.bounds.size.width - self.images.count * kPageControlEachWidth / 2.0;
    }
    pageControlCenterY = self.bounds.size.height - kPageControlHeight / 2.0;
    self.pageControl.center = CGPointMake(pageControlCenterX, pageControlCenterY);
}

/**
 * 以duration时间间隔，开启定时切换图片
 */
- (void)startAutoPagingWithDuration:(NSTimeInterval)pagingInterval
{
    // 先停止正在执行的定时器
    [self stopTimer];
    
    self.autoPaging = YES;
    self.pagingInterval = pagingInterval;
    [self startTimer];
}

/**
 * 开启自动切换图片
 */
- (void)startAutoPaging
{
    // 先停止正在执行的定时器
    [self stopTimer];
    
    self.autoPaging = YES;
    [self startTimer];
}

/**
 * 停止自动切换图片
 */
- (void)stopAutoPaging
{
    self.autoPaging = NO;
    [self stopTimer];
}

/**
 * 开启定时器
 */
- (void)startTimer
{
    if (!self.timer) {
        // 注册定时器
        self.timer = [NSTimer timerWithTimeInterval:self.pagingInterval target:self selector:@selector(nextPage) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    }
}

/**
 * 关闭定时器
 */
- (void)stopTimer
{
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
}

/**
 * 下一张
 */
- (void)nextPage
{
    // 防止layoutSubviews中，第一次偏移量还没更改时就执行
    if (self.scrollView.contentOffset.x != 0) {
        // 移动到第三个UIImageView
        [self.scrollView setContentOffset:CGPointMake(self.scrollView.bounds.size.width * 2, 0) animated:YES];
    }
}

/**
 * 更新图片和索引数据
 */
- (void)updateContent
{
    CGFloat scrollViewW = self.scrollView.bounds.size.width;
    
    if (self.scrollView.contentOffset.x > scrollViewW) {
        // 向前滚动，设置tag
        // 先设置左边的tag为当前图片tag后，才改变当前图片tag
        self.leftImageView.tag = self.currentImageView.tag;
        self.currentImageView.tag = self.rightImageView.tag;
        self.rightImageView.tag = (self.rightImageView.tag + 1) % self.images.count;
        
    } else if (self.scrollView.contentOffset.x < scrollViewW) {
        // 向后滚动，设置tag
        // 先设置右边的tag为当前图片tag后，才改变当前图片tag
        self.rightImageView.tag = self.currentImageView.tag;
        self.currentImageView.tag = self.leftImageView.tag;
        self.leftImageView.tag = (self.leftImageView.tag - 1 + self.images.count) % self.images.count;
        
    }
    
    // 设置图片
    self.leftImageView.image = self.images[self.leftImageView.tag];
    self.currentImageView.image = self.images[self.currentImageView.tag];
    self.rightImageView.image = self.images[self.rightImageView.tag];
    
    // 移动至中间的UIImageView
    [self.scrollView setContentOffset:CGPointMake(scrollViewW, 0) animated:NO];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // 设置UIPageControl的页码
    if (self.scrollView.contentOffset.x > self.scrollView.bounds.size.width * 1.5) {
        self.pageControl.currentPage = self.rightImageView.tag;
    } else if (self.scrollView.contentOffset.x < self.scrollView.bounds.size.width * 0.5) {
        self.pageControl.currentPage = self.leftImageView.tag;
    } else {
        self.pageControl.currentPage = self.currentImageView.tag;
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    // 手动拖拽切换更改内容
    [self updateContent];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    // 定时器切换更改内容
    [self updateContent];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if (self.isAutoPaging) {
        [self stopTimer];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (self.isAutoPaging) {
        [self startTimer];
    }
}

- (void)setCurrentPageColor:(UIColor *)currentPageColor
{
    _currentPageColor = currentPageColor;
    
    self.pageControl.currentPageIndicatorTintColor = currentPageColor;
}

- (void)setOtherPageColor:(UIColor *)otherPageColor
{
    _otherPageColor = otherPageColor;
    
    self.pageControl.pageIndicatorTintColor = otherPageColor;
}

- (void)setPageControlPostion:(TPCPageControlPosition)pageControlPostion
{
    _pageControlPostion = pageControlPostion;
    
    [self layoutSubviews];
}

- (void)setPagingInterval:(NSTimeInterval)pagingInterval
{
    _pagingInterval = pagingInterval > 0 ? pagingInterval : kDefaultDuration;
    
    // 在开启自动切图的情况下，修改时间间隔会实时生效
    if (self.isAutoPaging) {
        [self startAutoPaging];
    }
}

@end
