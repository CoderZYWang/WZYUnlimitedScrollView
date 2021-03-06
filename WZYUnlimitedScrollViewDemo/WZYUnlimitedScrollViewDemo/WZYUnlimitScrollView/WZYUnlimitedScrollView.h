//
//  WZYUnlimitedScrollView.h
//  WZYUnlimitedScrollViewDemo
//
//  Created by CoderZYWang on 2017/2/8.
//  Copyright © 2017年 wzy. All rights reserved.
//

#import <UIKit/UIKit.h>

#define SCREENWIDTH [UIScreen mainScreen].bounds.size.width
#define SCREENHEIGHT [UIScreen mainScreen].bounds.size.height
#define HEXCOLOR(hex) [UIColor colorWithRed:((float)((hex & 0xFF0000) >> 16)) / 255.0 green:((float)((hex & 0xFF00) >> 8)) / 255.0 blue:((float)(hex & 0xFF)) / 255.0 alpha:1]

@protocol WZYUnlimitedScrollViewDelegate <NSObject>

/** 内层scroll滚动的过程中 影响外层scroll是否滚动 */
- (void)scrollDidScrollisOutsideScroll:(BOOL)isOutsideScroll;

@end

@interface WZYUnlimitedScrollView : UIView

@property (nonatomic, weak) id <WZYUnlimitedScrollViewDelegate> unlimitedScrollDelegate;

/** 本地图片数组*/
@property (nonatomic, strong) NSArray *imgArray;
/** 网络图片数组*/
@property (nonatomic, strong) NSArray *imgUrlArray;
/** 是否自动轮播滚动（默认为不自动轮播） */
@property (nonatomic, assign) BOOL isAutoScroll;
/** 图片点击调用*/
- (void)touchImageIndexBlock:(void (^)(NSInteger index, NSString *imgUrl))block;

- (instancetype)initWithFrame:(CGRect)frame placeholderImg:(UIImage *)img;

@end

/**
 使用说明：
 01 按照 FirExampleViewController.m 和 SecExampleViewController.m 的集成方法进行集成。集成步骤很简单，不做描述。
 02 集成依赖 UIView+Frame 和 SDWebImage
 03 传入isAutoScroll YES == 自动滚动, NO == 不自动滚动
 */
