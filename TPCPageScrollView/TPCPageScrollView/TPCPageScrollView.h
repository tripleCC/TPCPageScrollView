//
//  TPCPageScrollView.h
//  TPCPageScrollView
//
//  Created by 宋瑞旺 on 15/6/1.
//  Copyright (c) 2015年 宋瑞旺. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TPCPageScrollView;
@protocol TPCPageScrollViewDelegate <NSObject>
@optional
- (void)pageScrollView:(TPCPageScrollView *)pageScrollView didClickImageAtIndex:(NSInteger)index;
@end

/**
 * 页索引位置
 */
typedef NS_ENUM(NSInteger, TPCPageControlPosition)
{
    TPCPageControlPositionBottomCenter = 0,
    TPCPageControlPositionBottomRight
};

@interface TPCPageScrollView : UIView
@property (weak, nonatomic) id<TPCPageScrollViewDelegate> delegate;

/** 
 * 图片url（网络的也可以）
 */
@property (strong, nonatomic) NSArray *imageURLStrings;

/**
 * 图片
 */
@property (strong, nonatomic) NSArray *images;

/**
 * 当前页索引颜色
 */
@property (strong, nonatomic) UIColor *currentPageColor;

/**
 * 非当前页索引颜色
 */
@property (strong, nonatomic) UIColor *otherPageColor;

/**
 * 页索引位置
 */
@property (assign, nonatomic) TPCPageControlPosition pageControlPostion;

/**
 * 切换图片间隔
 * 在开启自动切图的情况下，修改时间间隔会实时生效
 */
@property (assign, nonatomic) NSTimeInterval pagingInterval;

/**
 * 开启自动切换图片
 * 会先停止上一次自动切图
 */
- (void)startAutoPaging;

/**
 * 停止自动切换图片
 */
- (void)stopAutoPaging;

/**
 * 以duration时间间隔，开启定时切换图片
 * 会先停止上一次自动切图
 */
- (void)startAutoPagingWithDuration:(NSTimeInterval)pagingInterval;
@end
