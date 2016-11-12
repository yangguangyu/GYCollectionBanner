//
//  GYCollectionBanner.h
//  GYCollectionBanner
//
//  Created by yangguangyu on 16/11/9.
//  Copyright © 2016年 yangguangyu. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GYCollectionBanner;
@protocol GYCollectionBannerDelegate <NSObject>

- (void)banner:(GYCollectionBanner *)banner didSelectedItemAtIndex:(NSInteger)index;

@end


typedef void(^collectionViewItemDidSelectedBlock)(GYCollectionBanner *banner,NSInteger index);

@interface GYCollectionBanner : UIView

/* 占位图片 */
@property (nonatomic, strong) UIImage *placeHolder;
/* UIPageControl */
@property (nonatomic, strong) UIPageControl *pageControl;
                    //TODO：自定义pageControl，可以传入图片，也可以直接控件设置圆角变成一个小圆环
/* 自动滚动 */
@property (nonatomic, assign) BOOL autoScroll;
/* 循环滚动 */
@property (nonatomic, assign) BOOL loopScroll;
/* 滚动时间 */
@property (nonatomic, assign) NSTimeInterval timeInterval;
/* 图片的填充模式 */
@property (nonatomic, assign) UIViewContentMode contentMode;

/* 代理 */
@property (nonatomic, weak) id <GYCollectionBannerDelegate> delegate;
/* block */
@property (nonatomic, copy) collectionViewItemDidSelectedBlock block;

/**
 *  初始化方法
 *
 *  @param frame  frame
 *  @param Images 图片数组（如果传入string认为是远程资源，如果是image认为本地资源）
 */
- (instancetype)initWithFrame:(CGRect)frame imageArray:(NSArray *)Images;
@end
