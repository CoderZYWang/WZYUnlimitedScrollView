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
    
    // 初始化 banner
    WZYUnlimitedScrollView *banner = [[WZYUnlimitedScrollView alloc] initWithFrame:CGRectMake(0, 100, SCREENWIDTH, SCREENWIDTH * 150 / 375) placeholderImg:[UIImage imageNamed:@"ggsc_default_pic"]];
    banner.isAutoScroll = YES; // 自动轮播
    
    // 添加图片数组（可自行换为网络图片url数组）
    NSMutableArray *imgArrM = [NSMutableArray array];
    [imgArrM addObject:@"ggsc_banner_1"];
    [imgArrM addObject:@"ggsc_banner_2"];
    [imgArrM addObject:@"ggsc_banner_3"];
    banner.imgArray = imgArrM;
    
    // banner 图片点击回调
    [banner touchImageIndexBlock:^(NSInteger index, NSString *imgUrl) {
        NSLog(@"index --- %ld, imgUrl --- %@", index, imgUrl);
        
        UIAlertView *infoView = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"index --- %ld", index] message:[NSString stringWithFormat:@"图片名称&跳转Url --- %@", imgUrl] delegate:self cancelButtonTitle:@"返回" otherButtonTitles:nil , nil];
        [infoView show];
    }];
    [self.view addSubview:banner];
}

@end
