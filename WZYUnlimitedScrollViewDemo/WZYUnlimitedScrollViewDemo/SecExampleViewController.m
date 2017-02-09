//
//  SecExampleViewController.m
//  WZYUnlimitedScrollViewDemo
//
//  Created by 奔跑宝BPB on 2017/2/8.
//  Copyright © 2017年 wzy. All rights reserved.
//

#import "SecExampleViewController.h"

#import "UIView+Frame.h"
#import "WZYUnlimitedScrollView.h"

@interface SecExampleViewController () <WZYUnlimitedScrollViewDelegate, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) WZYUnlimitedScrollView *banner;
@property (nonatomic, weak) UITableView *tableView;

@end

@implementation SecExampleViewController

static NSString *testCellId = @"testCellId";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;

    // 添加一个与banner连接的tableView
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.showsVerticalScrollIndicator = NO;
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:testCellId];
    self.tableView = tableView;
    tableView.contentInset = UIEdgeInsetsMake(SCREENWIDTH * 150 / 375 + 64, 0, 0, 0);
    [self.view addSubview:tableView];
    
    // 添加banner。用法和前面的基本集成一样
    WZYUnlimitedScrollView *banner = [[WZYUnlimitedScrollView alloc] initWithFrame:CGRectMake(0, 64, SCREENWIDTH, SCREENWIDTH * 150 / 375) placeholderImg:[UIImage imageNamed:@"ggsc_default_pic"]];
    self.banner = banner;
    banner.isAutoScroll = YES; // 自动轮播
    banner.unlimitedScrollDelegate = self;
    banner.backgroundColor = [UIColor blueColor];
    NSMutableArray *imgArrM = [NSMutableArray array];
    [imgArrM addObject:@"ggsc_banner_1"];
    [imgArrM addObject:@"ggsc_banner_2"];
    [imgArrM addObject:@"ggsc_banner_3"];
    banner.imgArray = imgArrM;
    [banner touchImageIndexBlock:^(NSInteger index, NSString *imgUrl) {
//        NSLog(@"index --- %ld, imgUrl --- %@", index, imgUrl);
        UIAlertView *infoView = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"index --- %ld", index] message:[NSString stringWithFormat:@"图片名称&跳转Url --- %@", imgUrl] delegate:self cancelButtonTitle:@"返回" otherButtonTitles:nil , nil];
        [infoView show];
    }];
    [self.view addSubview:banner];
}

#pragma mark - Scroll View delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat bannerHeightChange = - scrollView.contentOffset.y - SCREENWIDTH * 150 / 375 - 64;

    if (bannerHeightChange <= 1) {
        self.banner.y = bannerHeightChange + 64;
        self.banner.height = SCREENWIDTH * 150 / 375;
        self.banner.userInteractionEnabled = YES;
    } else {
        self.banner.frame = CGRectMake(0, 64, SCREENWIDTH, SCREENWIDTH * 150 / 375 + bannerHeightChange);
        self.banner.userInteractionEnabled = NO;
    }
}

#pragma mark - WZYUnlimitedScrollViewDelegate
- (void)scrollDidScrollisOutsideScroll:(BOOL)isOutsideScroll {
    if (isOutsideScroll) {
        self.tableView.scrollEnabled = YES;
    } else {
        self.tableView.scrollEnabled = NO;
    }
}

#pragma mark - Table View Delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

#pragma mark - Table View Data Source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:testCellId];
    cell.textLabel.text = [NSString stringWithFormat:@"%ld --- %ld", indexPath.section, indexPath.row];
    return cell;
}

@end
