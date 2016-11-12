//
//  GYCollectionBanner.h
//  GYCollectionBanner
//
//  Created by yangguangyu on 16/11/9.
//  Copyright © 2016年 yangguangyu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GYCollectionBanner : UIView

/* 本地图片 */
//@property (nonatomic, strong) NSArray *localImage;

/* 自动滚动 */
@property (nonatomic, assign) BOOL autoScroll;
/* 循环滚动 */
@property (nonatomic, assign) BOOL loopScroll;//有一些默认就是循环的，不提供这个属性
/* 滚动时间 */
@property (nonatomic, assign) NSTimeInterval timeInterval;
/* 图片的填充模式 */
@property (nonatomic, assign) UIViewContentMode contentMode;


- (instancetype)initWithFrame:(CGRect)frame localImageArray:(NSArray *)localImages;
@end
