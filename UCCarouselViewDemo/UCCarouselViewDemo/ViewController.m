//
//  ViewController.m
//  UCCarouselViewDemo
//
//  Created by Uncle.Chen on 3/8/16.
//  Copyright © 2016 UC. All rights reserved.
//

#import "ViewController.h"
#import "UCCarouselView.h"

#define __LOADIMAGE(file, type) [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:file ofType:type]]

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self loadCarouselViewWithoutTimer];
//    [self loadCarouselViewWithTimer];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// 不使用定时器初始化
- (void)loadCarouselViewWithoutTimer {
    UCCarouselView *carouselView = [[UCCarouselView alloc] initWithFrame:({
        CGRectMake(0.f, 20.f,
                   CGRectGetWidth([UIScreen mainScreen].bounds),
                   200.f);
    }) dataArray:[self loadData] didSelectItemBlock:^(NSInteger didSelectItem) {
        
        NSLog(@"didSelectItem is :%ld", (long)didSelectItem);
        
    }];
    [self.view addSubview:carouselView];
}

// 使用定时器初始化
- (void)loadCarouselViewWithTimer {
    UCCarouselView *carouselView = [[UCCarouselView alloc] initWithFrame:({
        CGRectMake(0.f, 20.f,
                   CGRectGetWidth([UIScreen mainScreen].bounds),
                   200.f);
    }) dataArray:[self loadData] timeInterval:2.f didSelectItemBlock:^(NSInteger didSelectItem) {
        
        NSLog(@"didSelectItem is :%ld", (long)didSelectItem);
        
    }];
    [self.view addSubview:carouselView];
}

// Demo 数据
- (NSArray *)loadData {
    NSArray *array = @[__LOADIMAGE(@"dota2_0", @"jpg"),
                       __LOADIMAGE(@"dota2_1", @"jpg"),
                       __LOADIMAGE(@"dota2_2", @"jpg"),
                       __LOADIMAGE(@"dota2_3", @"jpg")];
    return array;
}

@end
