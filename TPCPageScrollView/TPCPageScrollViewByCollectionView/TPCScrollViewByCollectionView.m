//
//  TPCScrollViewByCollectionView.m
//
//  Created by tripleCC on 15/6/30.
//  Copyright (c) 2015年 tripleCC. All rights reserved.
//

#import "TPCScrollViewByCollectionView.h"

@interface TPCScrollViewByCollectionView()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (weak, nonatomic) UICollectionView *collectionView;

@end

@implementation TPCScrollViewByCollectionView

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
    UICollectionViewFlowLayout *collectionViewLayout = [[UICollectionViewFlowLayout alloc] init];
    collectionViewLayout.minimumInteritemSpacing = 0;
    collectionViewLayout.minimumLineSpacing = 0;
    collectionViewLayout.itemSize = self.bounds.size;
    collectionViewLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:collectionViewLayout];
    
    collectionView.delegate = self;
    collectionView.dataSource = self;
    collectionView.pagingEnabled = YES;
    collectionView.bounces = NO;
    
    [collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"tpc"];
    [self addSubview:collectionView];
    self.collectionView = collectionView;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.images.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"tpc" forIndexPath:indexPath];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:self.images[indexPath.row]];
    imageView.frame = self.bounds;
    cell.backgroundView = imageView;
    
    return cell;
}
@end
