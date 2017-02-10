//
//  WZYUnlimitedScrollView.m
//  WZYUnlimitedScrollViewDemo
//
//  Created by CoderZYWang on 2017/2/8.
//  Copyright © 2017年 wzy. All rights reserved.
//

#import "WZYUnlimitedScrollView.h"
// 没有下面两个分类的自行添加
#import "UIView+Frame.h"
//#import "UIImageView+WebCache.h"

@interface WZYUnlimitedScrollView () <UIScrollViewDelegate>

/** 外面加层UIView */
@property (nonatomic, strong) UIView *divView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIPageControl *pageControl;
/** 当前图片索引 */
@property (nonatomic, assign) NSInteger imgIndexOf;
/** 定时器 */
@property (nonatomic, strong) NSTimer *timer;
/** 回调block */
@property (nonatomic, copy) void (^block)();
@property (nonatomic, strong) UIImage *placeholderImg;
@property (nonatomic, assign) float oldContentOffsetX;
@property (nonatomic, assign) NSInteger imgCount;

@end

@implementation WZYUnlimitedScrollView

- (instancetype)initWithFrame:(CGRect)frame placeholderImg:(UIImage *)img {
    if (self = [super init]) {
        self.frame = frame;
        if (img) {
            self.placeholderImg = img;
        }
        [self addSubview:self.scrollView];
        [self addSubview:self.pageControl];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.scrollView.frame = self.bounds;
    self.pageControl.frame = CGRectMake(0, self.height - 13, self.width, 4);
    
    for (UIImageView *imgView in self.scrollView.subviews) {
        if (imgView.tag == self.pageControl.currentPage) {
            imgView.height = self.scrollView.height;
        }
    }
}

#pragma mark -- Scroll View Delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGPoint point = scrollView.contentOffset;
    BOOL isRight = self.oldContentOffsetX < point.x;
    self.oldContentOffsetX = point.x;
    
    // 开始显示最后一张图片的时候切换到第二个图
    if (point.x > self.width * (self.imgCount - 2) + self.width * 0.5 && !self.timer) {
        self.pageControl.currentPage = 0;
    } else if (point.x > self.width * (self.imgCount - 2) && self.timer && isRight) {
        self.pageControl.currentPage = 0;
    } else {
        self.pageControl.currentPage = (point.x + self.width * 0.5) / self.width;
    }
    
    // 开始显示第一张图片的时候切换到倒数第二个图
    if (point.x >= self.width*(self.imgCount - 1)) {
        [_scrollView setContentOffset:CGPointMake(self.width + point.x - self.width * self.imgCount, 0) animated:NO];
    } else if (point.x < 0) {
        [scrollView setContentOffset:CGPointMake(point.x + self.width * (self.imgCount - 1), 0) animated:NO];
    }
    
    // 代理方法(目的在做外层下拉时，使我们的控件同步拉伸)
    if([self judgeDivisibleWithFirstNumber:scrollView.contentOffset.x andSecondNumber:SCREENWIDTH]) { // 外层scroll可以拖动
        //        NSLog(@"yes");
        [self.unlimitedScrollDelegate scrollDidScrollisOutsideScroll:YES];
    } else { // 外层scroll不可以拖动
        //        NSLog(@"no");
        [self.unlimitedScrollDelegate scrollDidScrollisOutsideScroll:NO];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self stopTimer];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (self.isAutoScroll) {
        [self startTimer];
    }
}

#pragma mark - 定时器
- (void)startTimer {
    self.timer = [NSTimer timerWithTimeInterval:3 target:self selector:@selector(nextPage) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSDefaultRunLoopMode];
}

- (void)nextPage {
    [self.scrollView setContentOffset:CGPointMake((self.pageControl.currentPage+1)*self.width, 0) animated:YES];
}

- (void)stopTimer {
    [self.timer invalidate];
    self.timer = nil;
}

#pragma mark - 模型初始化
- (void)setImgArray:(NSArray *)imgArray {
    [(NSMutableArray *)imgArray addObject:imgArray[0]];
    _imgArray = imgArray;
    self.imgCount = imgArray.count;
    for (int i = 0; i < imgArray.count; i ++) {
        UIImageView *imgView = [[UIImageView alloc] init];
        imgView.contentMode = UIViewContentModeScaleAspectFill;
        imgView.clipsToBounds = YES;
        imgView.image = [UIImage imageNamed:imgArray[i]];
        imgView.tag = i;
        imgView.frame = CGRectMake(i * self.width, 0, self.width, self.height);
        [self.scrollView addSubview:imgView];
    }
    self.scrollView.contentSize = CGSizeMake(self.width * imgArray.count, 0);
    self.pageControl.numberOfPages = imgArray.count - 1;
    [self addImgClick];
    if (self.isAutoScroll) {
        [self startTimer];
    }
}

- (void)setImgUrlArray:(NSArray *)imgUrlArray {
    [(NSMutableArray *)imgUrlArray addObject:imgUrlArray[0]];
    _imgUrlArray = imgUrlArray;
    self.imgCount = imgUrlArray.count;
    for (int i = 0; i < imgUrlArray.count; i ++) {
        UIImageView *imgView = [[UIImageView alloc] init];
        imgView.contentMode = UIViewContentModeScaleAspectFill;
        imgView.clipsToBounds = YES;
        imgView.tag = i;
        NSURL *imgUrl = [NSURL URLWithString:imgUrlArray[i]];
        
        // 使用时请打开
//        [imgView sd_setImageWithURL:imgUrl placeholderImage:self.placeholderImg completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//            //NSLog(@"====================\n%@\n%@\n=====================",imgUrl,error);
//        }];
        imgView.frame = CGRectMake(i * self.width, 0, self.width, self.height);
        [self.scrollView addSubview:imgView];
    }
    self.scrollView.contentSize = CGSizeMake(self.width * imgUrlArray.count, 0);
    self.pageControl.numberOfPages = imgUrlArray.count - 1;
    [self addImgClick];
    if (self.isAutoScroll) {
        [self startTimer];
    }
}

#pragma mark - 图片点击
- (void)touchImageIndexBlock:(void (^)(NSInteger, NSString *))block {
    __block WZYUnlimitedScrollView *banner = self;
    self.block = ^(){
        if (block) {
            //            NSLog(@"imageArr --- %@ imageUrlArr --- %@", banner.imgArray, banner.imgUrlArray);
            if (banner.imgArray.count != 0) {
                NSString *imageName = banner.imgArray[banner.pageControl.currentPage];
                block(banner.pageControl.currentPage, imageName);
            } else {
                NSString *imageUrl = banner.imgUrlArray[banner.pageControl.currentPage];
                block(banner.pageControl.currentPage, imageUrl);
            }
        }
    };
}

- (void)addImgClick {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imgClick)];
    [self.scrollView addGestureRecognizer:tap];
}

- (void)imgClick {
    if (self.block) {
        self.block();
    }
}

#pragma mark - 懒加载
- (UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        _scrollView.contentOffset = CGPointMake(0, 0);
        _scrollView.backgroundColor = [UIColor orangeColor];
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.pagingEnabled = YES;
        //        _scrollView.bounces = NO;
        self.imgIndexOf = 1;
        _scrollView.delegate = self;
    }
    return _scrollView;
}

- (UIPageControl *)pageControl{
    if (!_pageControl) {
        
        _pageControl = [[UIPageControl alloc] init];
        self.pageControl.currentPage = 0;
        self.pageControl.currentPageIndicatorTintColor = HEXCOLOR(0xFF5A39);
        self.pageControl.pageIndicatorTintColor = [UIColor whiteColor];
    }
    return _pageControl;
}

/**
 *  判断两个浮点数是否整除
 *
 *  @param firstNumber  第一个浮点数(被除数)
 *  @param secondNumber 第二个浮点数(除数,不能为0)
 *
 *  @return 返回值可判定是否整除
 */
- (BOOL)judgeDivisibleWithFirstNumber:(CGFloat)firstNumber andSecondNumber:(CGFloat)secondNumber {
    // 默认记录为整除
    BOOL isDivisible = YES;
    
    if (secondNumber == 0) {
        return NO;
    }
    
    CGFloat result = firstNumber / secondNumber;
    NSString * resultStr = [NSString stringWithFormat:@"%f", result];
    NSRange range = [resultStr rangeOfString:@"."];
    NSString * subStr = [resultStr substringFromIndex:range.location + 1];
    
    for (NSInteger index = 0; index < subStr.length; index ++) {
        unichar ch = [subStr characterAtIndex:index];
        
        // 后面的字符中只要有一个不为0，就可判定不能整除，跳出循环
        if ('0' != ch) {
            //            NSLog(@"不能整除");
            isDivisible = NO;
            break;
        }
    }
    
    // NSLog(@"可以整除");
    return isDivisible;
}

@end
