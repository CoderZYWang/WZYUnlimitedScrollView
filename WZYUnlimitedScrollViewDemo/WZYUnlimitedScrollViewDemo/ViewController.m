//
//  ViewController.m
//  WZYUnlimitedScrollViewDemo
//
//  Created by 奔跑宝BPB on 2017/2/8.
//  Copyright © 2017年 wzy. All rights reserved.
//

#import "ViewController.h"

#define SCREENWIDTH [UIScreen mainScreen].bounds.size.width
#import "FirExampleViewController.h"
#import "SecExampleViewController.h"

@interface ViewController () <UITableViewDelegate, UITableViewDataSource>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 100, SCREENWIDTH, 100) style:UITableViewStylePlain];
    tableView.bounces = NO;
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"test"];
    if (indexPath.row == 0) {
        cell.textLabel.text = @"普通效果演示";
    } else {
        cell.textLabel.text = @"带有下拉拉伸效果演示";
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        [self.navigationController pushViewController:[FirExampleViewController new] animated:YES];
    } else {
        [self.navigationController pushViewController:[SecExampleViewController new] animated:YES];
    }
}

@end
