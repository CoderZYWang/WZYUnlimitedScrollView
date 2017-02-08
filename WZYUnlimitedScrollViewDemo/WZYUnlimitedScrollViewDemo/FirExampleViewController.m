//
//  FirExampleViewController.m
//  WZYUnlimitedScrollViewDemo
//
//  Created by 奔跑宝BPB on 2017/2/8.
//  Copyright © 2017年 wzy. All rights reserved.
//

#import "FirExampleViewController.h"

#import "WZYUnlimitedScrollView.h"

@interface FirExampleViewController ()

@end

@implementation FirExampleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    WZYUnlimitedScrollView *banner = [[WZYUnlimitedScrollView alloc] initWithFrame:CGRectMake(0, 100, SCREENWIDTH, SCREENWIDTH * 150 / 375) placeholderImg:[UIImage imageNamed:@"ggsc_default_pic"]];
    NSMutableArray *imgArrM = [NSMutableArray array];
    [imgArrM addObject:@"ggsc_banner_1"];
    [imgArrM addObject:@"ggsc_banner_2"];
    [imgArrM addObject:@"ggsc_banner_3"];
    banner.imgArray = imgArrM;
    [banner touchImageIndexBlock:^(NSInteger index, NSString *imgUrl) {
        NSLog(@"index --- %ld, imgUrl --- %@", index, imgUrl);
    }];
    [self.view addSubview:banner];
}

@end
