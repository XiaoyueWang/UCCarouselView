//
//  UCCarouselView.m
//  UCCarouselView
//
//  Created by Uncle.Chen on 3/3/16.
//  Copyright © 2016 UC. All rights reserved.
//

#import "UCCarouselView.h"
#import "UCCarouselCollectionViewCell.h"
#import <WebKit/WebKit.h>

#define __WS  __weak __typeof(&*self)weakSelf = self;

static NSString * const cellIdentifier = @"carouseCellIdentifier";

typedef NS_ENUM(NSUInteger, UCCarouselCollectionViewCellNum) {
    UCCarouselCollectionViewCellNumFirst,
    UCCarouselCollectionViewCellNumSecond,
    UCCarouselCollectionViewCellNumThird,
};

typedef void(^DidSelectItemBlock)(NSInteger didSelectItem);

@interface UCCarouselView () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UIPageControl *pageControl; ///< pageControl
@property (nonatomic, strong) UICollectionView *carouselCollectionView; ///< UCCarouselCollectionView
@property (nonatomic, copy) NSArray *dataArray; ///< dataArray
@property (nonatomic, assign) CGFloat timeInterval; ///< 定时器滚动时间
@property (nonatomic, assign) NSInteger currentItem; ///< 当前cell的item值
@property (nonatomic, strong) NSTimer *timer; ///< 定时器
@property (nonatomic, copy) DidSelectItemBlock didSelectItemBlock; ///< 选择回调

@end

@implementation UCCarouselView

#pragma mark - Life Cycle

- (instancetype)initWithFrame:(CGRect)frame
                    dataArray:(NSArray *)dataArray
           didSelectItemBlock:(void (^)(NSInteger didSelectItem))block {
    
    self = [super initWithFrame:frame];
    if (self) {
        _dataArray = [self reloadDataArrayWithDataArray:(NSArray *)dataArray];
        _currentItem = 1;
        _didSelectItemBlock = block;
        
        [self loadCarouselCollectionView];
        [self loadPageControl];
        
        if (_dataArray.count > 1) {
            [self.carouselCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:_currentItem inSection:0]
                                                atScrollPosition:UICollectionViewScrollPositionNone
                                                        animated:NO];
        }
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
                    dataArray:(NSArray *)dataArray
                 timeInterval:(CGFloat)timeInterval
           didSelectItemBlock:(void (^)(NSInteger didSelectItem))block {
    
    self = [super initWithFrame:frame];
    if (self) {
        _dataArray = [self reloadDataArrayWithDataArray:(NSArray *)dataArray];
        _currentItem = 1;
        _timeInterval = timeInterval;
        _didSelectItemBlock = block;
        
        [self loadCarouselCollectionView];
        [self loadPageControl];
        [self loadTimer];
        
        if (_dataArray.count > 1) {
            [self.carouselCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:_currentItem inSection:0]
                                                atScrollPosition:UICollectionViewScrollPositionNone
                                                        animated:NO];
        }
    }
    return self;
}

#pragma mark - UI

- (void)loadCarouselCollectionView {
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    flowLayout.minimumInteritemSpacing = 0.f;
    flowLayout.minimumLineSpacing = 0.f;
    flowLayout.itemSize = CGSizeMake(CGRectGetWidth(self.frame),
                                     CGRectGetHeight(self.frame));
    flowLayout.sectionInset = UIEdgeInsetsMake(0.f, 0.f, 0.f, 0.f);
    
    self.carouselCollectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:flowLayout];
    self.carouselCollectionView.delegate = self;
    self.carouselCollectionView.dataSource = self;
    self.carouselCollectionView.showsHorizontalScrollIndicator = NO;
    self.carouselCollectionView.pagingEnabled = YES;
    self.carouselCollectionView.bounces = NO;
    self.carouselCollectionView.backgroundColor = [UIColor whiteColor];
    [self.carouselCollectionView registerClass:[UCCarouselCollectionViewCell class]
                    forCellWithReuseIdentifier:cellIdentifier];
    [self addSubview:self.carouselCollectionView];
}

- (void)loadPageControl {
    CGRect rect = CGRectMake(CGRectGetWidth(self.frame)/2,
                             CGRectGetHeight(self.frame)-20.f, 0.f, 20.f);
    self.pageControl = [[UIPageControl alloc] initWithFrame:rect];
    self.pageControl.numberOfPages = self.dataArray.count-2;
    self.pageControl.currentPage = 0;
    self.pageControl.defersCurrentPageDisplay = YES;
    [self addSubview:self.pageControl];
}

#pragma mark - Datasource/Delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.dataArray.count==1?1:self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UCCarouselCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    
    cell.image = self.dataArray[indexPath.item];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.didSelectItemBlock) {
        self.didSelectItemBlock(indexPath.item-1);
    }
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
    if (self.timer) {
        [self.timer invalidate];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self reloadItemAction];
    
    if (self.timer) {
        [self loadTimer];
    }
}

#pragma mark - Action

- (NSArray *)reloadDataArrayWithDataArray:(NSArray *)dataArray {
    NSMutableArray *resultArray = [[NSMutableArray alloc] initWithCapacity:dataArray.count];
    [resultArray addObject:dataArray.lastObject];
    
    for (id object in dataArray) {
        [resultArray addObject:object];
    }
    
    [resultArray addObject:dataArray.firstObject];
    return resultArray;
}

- (void)reloadItemAction {
    NSIndexPath *indexPath = [[self.carouselCollectionView indexPathsForVisibleItems] lastObject];
    self.currentItem = indexPath.item;
    NSInteger toItem = 0;
    
    if (self.currentItem == 0) {
        toItem = self.dataArray.count-2;
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:toItem inSection:0];
        [self.carouselCollectionView scrollToItemAtIndexPath:indexPath
                                            atScrollPosition:UICollectionViewScrollPositionNone
                                                    animated:NO];
        self.currentItem = toItem;
    }
    
    if (self.currentItem == self.dataArray.count-1) {
        toItem = 1;
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:toItem inSection:0];
        [self.carouselCollectionView scrollToItemAtIndexPath:indexPath
                                            atScrollPosition:UICollectionViewScrollPositionNone
                                                    animated:NO];
        self.currentItem = toItem;
    }
    
    self.pageControl.currentPage = self.currentItem-1;
}

- (void)loadTimer {
    self.timer = [NSTimer timerWithTimeInterval:self.timeInterval
                                         target:self
                                       selector:@selector(timerChanged)
                                       userInfo:nil
                                        repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.timer
                                 forMode:NSRunLoopCommonModes];
}

- (void)timerChanged {
    if (self.currentItem == self.dataArray.count-2) {
        NSInteger toItem = 0;
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:toItem inSection:0];
        [self.carouselCollectionView scrollToItemAtIndexPath:indexPath
                                            atScrollPosition:UICollectionViewScrollPositionNone
                                                    animated:NO];
        self.currentItem = toItem;
    }
    
    self.currentItem++;
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:self.currentItem inSection:0];
    [self.carouselCollectionView scrollToItemAtIndexPath:indexPath
                                        atScrollPosition:UICollectionViewScrollPositionLeft
                                                animated:YES];
    self.pageControl.currentPage = self.currentItem-1;
}

@end
