//
//  GYCollectionBanner.m
//  GYCollectionBanner
//
//  Created by yangguangyu on 16/11/9.
//  Copyright © 2016年 yangguangyu. All rights reserved.
//

#import "GYCollectionBanner.h"
#import "UIImageView+WebCache.h"

static  NSString * const kCellID = @"collectionViewCell";

@interface GYCollectionBanner () <UICollectionViewDelegate,UICollectionViewDataSource> {
    UIPageControl * _pageControl;
    UICollectionView *_collectionView;
    UICollectionViewFlowLayout *_flowLayout;
    NSArray *_images;
    //    CADisplayLink *_timer;
    NSTimer *_timer;
}

//@property (nonatomic, strong) UICollectionView *collectionView;
//@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;
//@property (nonatomic, strong) UIPageControl *pageControl;
@end

@implementation GYCollectionBanner

#pragma mark - life cycle
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self configUI];
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame imageArray:(NSArray *)images {
    self = [super initWithFrame:frame];
    if (self) {
        [self configUI];
        
        if (self.loopScroll) {//循环滚动的话，首位添加2个
            NSMutableArray *tempArray = [images mutableCopy];
            [tempArray insertObject:images.lastObject atIndex:0];
            [tempArray addObject:images.firstObject];
            _images = tempArray;
        }else {
            _images = images;
        }
        _pageControl.numberOfPages = images.count;
        CGSize size = [_pageControl sizeForNumberOfPages:images.count];
        _pageControl.frame = CGRectMake((self.frame.size.width - size.width)*0.5, 0.9 * self.frame.size.height, size.width, size.height);
    }
    return self;
}


- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - method
- (void)configUI {
    self.autoScroll = YES;
    self.loopScroll = YES;
    self.timeInterval = 2.5;
    self.contentMode = UIViewContentModeScaleAspectFill;
    
    _flowLayout = [[UICollectionViewFlowLayout alloc] init];
    _flowLayout.minimumLineSpacing = 0;
    _flowLayout.minimumInteritemSpacing = 0;
    _flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    _flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    _flowLayout.itemSize = CGSizeMake(self.frame.size.width, self.frame.size.height);
    
    _collectionView = [[UICollectionView alloc] initWithFrame:self.frame collectionViewLayout:_flowLayout];
    _collectionView.showsVerticalScrollIndicator = NO;
    _collectionView.showsHorizontalScrollIndicator = NO;
    _collectionView.bounces = NO;
    _collectionView.pagingEnabled = YES;
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:kCellID];
    _collectionView.backgroundColor = [UIColor redColor];
    
    
    _pageControl = [[UIPageControl alloc] init];
    _pageControl.pageIndicatorTintColor = [UIColor whiteColor];
    _pageControl.currentPageIndicatorTintColor = [UIColor orangeColor];
    _pageControl.hidesForSinglePage = YES;
    
    [self addSubview:_collectionView];
    [self addSubview:_pageControl];
}

- (void)didMoveToSuperview {
    [self resetCollectionView];
    [self startTimer];
}


- (void)registerNotifcation {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stopTimer) name:UIApplicationWillResignActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(startTimer) name:UIApplicationDidBecomeActiveNotification object:nil];
}

- (void)resetCollectionView {
    _pageControl.currentPage = 0;
    [_collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:1 inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
}

- (void)jumpToLast {
    _pageControl.currentPage = _pageControl.numberOfPages;
    [_collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:_pageControl.numberOfPages inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
}

- (void)nextItem {
    NSIndexPath *indexPath = [_collectionView indexPathsForVisibleItems].firstObject;

    indexPath = [NSIndexPath indexPathForItem:(indexPath.item + 1) inSection:0];
    [_collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionRight animated:YES];
}

- (void)startTimer {
    if (_timer) {
        return;
    }
    
    if (_images.count == 1 ) {//一张图，不需要轮播
        return;
    }
    
    if (!_autoScroll) {
        return;
    }
//    _timer = [CADisplayLink displayLinkWithTarget:self selector:@selector(nextItem)];
//    [_timer addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
//    _timer.frameInterval = 60 * 3;
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:self.timeInterval target:self selector:@selector(nextItem) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
}

- (void)stopTimer {
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
}

- (void)checkLastImage {
    NSInteger index = (NSInteger)_collectionView.contentOffset.x / self.frame.size.width;
    if (index == _images.count - 1) {//数组前面多一个
        if (!_loopScroll) {//不循环
            [self stopTimer];
        }else {//循环
            [self resetCollectionView];
        }
    }
}

- (void)checkFirstImage {
    NSInteger index = (NSInteger)_collectionView.contentOffset.x / self.frame.size.width;
    if (index == 0) {
        [self jumpToLast];
    }
}

#pragma mark - UITableViewDataSources
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _loopScroll ? _pageControl.numberOfPages + 2 : _pageControl.numberOfPages;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellID forIndexPath:indexPath];
    
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.frame = CGRectMake(0, 0, _flowLayout.itemSize.width,
                                       _flowLayout.itemSize.height);
    if ([_images[indexPath.row] isKindOfClass:[UIImage class]]) {//传图片认为是本地资源
        imageView.image = _images[indexPath.row];
    }else {
        [imageView sd_setImageWithURL:[NSURL URLWithString:_images[indexPath.row]] placeholderImage:self.placeHolder];
    }
    imageView.contentMode = self.contentMode;
    imageView.clipsToBounds = YES;
    [cell setBackgroundView:imageView];
    
    if (_loopScroll) {
        _pageControl.currentPage = indexPath.row - 1;
    }else {
        _pageControl.currentPage = indexPath.row;
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    //点击浏览大图，或者跳转
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(banner:didSelectedItemAtIndex:)]) {
        [self.delegate banner:self didSelectedItemAtIndex:indexPath.row];
    }
    
    if (self.block) {
        self.block(self,indexPath.row);
    }
}


#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self stopTimer];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [self startTimer];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self checkLastImage];
    [self checkFirstImage];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    [self checkLastImage];
}


@end
