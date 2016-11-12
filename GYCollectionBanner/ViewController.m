//
//  ViewController.m
//  GYCollectionBanner
//
//  Created by yangguangyu on 16/11/9.
//  Copyright © 2016年 yangguangyu. All rights reserved.
//

#import "ViewController.h"
#import "GYCollectionBanner.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSArray *array = @[[UIImage imageNamed:@"1"],
                       [UIImage imageNamed:@"2"],
                       [UIImage imageNamed:@"3"],
                       [UIImage imageNamed:@"4"],
                       [UIImage imageNamed:@"5"]];
    
    CGRect rect = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 300);
    GYCollectionBanner *banner = [[GYCollectionBanner alloc] initWithFrame:rect imageArray:array];
    
    [self.view addSubview:banner];
}


@end
