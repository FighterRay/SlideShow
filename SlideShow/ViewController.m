//
//  ViewController.m
//  SlideShow
//
//  Created by 张润峰 on 15/12/16.
//  Copyright © 2015年 张润峰. All rights reserved.
//

#import "ViewController.h"

#define MAIN_SCREEN_W [UIScreen mainScreen].bounds.size.width
#define MAIN_SCREEN_H [UIScreen mainScreen].bounds.size.height
#define kCount 3 //图片页数


@interface ViewController ()<UIScrollViewDelegate>

@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) UIPageControl *pageControl;
@property (strong, nonatomic) NSTimer *timer;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    
    //设置图片
    for (int i = 0; i < kCount; i++) {
        NSString *imageName = [NSString stringWithFormat:@"%d", i+1];
        UIImage *image = [UIImage imageNamed:imageName];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.scrollView.bounds];
        imageView.image = image;
        [self.scrollView addSubview:imageView];
    }
    
    //设置每个imageView的位置
    [self.scrollView.subviews enumerateObjectsUsingBlock:^(UIImageView *imageView, NSUInteger idx, BOOL * _Nonnull stop) {
        CGRect frame = imageView.frame;
        frame.origin.x = idx * frame.size.width;
        imageView.frame = frame;
    }];
    
    self.pageControl.currentPage = 0;
    [self startTime];
}

-(UIScrollView *)scrollView{
    if (!_scrollView) {
        //通过点语法初始化scrollView
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 20, MAIN_SCREEN_W, MAIN_SCREEN_W * 0.56)];
        _scrollView.backgroundColor = [UIColor clearColor];
        [self.view addSubview:_scrollView];
        
        _scrollView.contentSize = CGSizeMake(kCount * _scrollView.bounds.size.width, 0);
        _scrollView.pagingEnabled = YES;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        
        _scrollView.delegate = self;
    }
    return _scrollView;
}

-(UIPageControl *)pageControl{
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(300, 200, 10, 30)];
        _pageControl.numberOfPages = kCount;
        
        CGSize size = [_pageControl sizeForNumberOfPages:kCount];
        _pageControl.bounds = CGRectMake(0, 0, size.width, size.height);
        _pageControl.pageIndicatorTintColor = [UIColor yellowColor];
        _pageControl.currentPageIndicatorTintColor = [UIColor redColor];
        
        [self.view addSubview:_pageControl];
        [_pageControl addTarget:self action:@selector(valueChange:) forControlEvents:UIControlEventEditingChanged];
    }
    return _pageControl;
}

- (void)valueChange:(UIPageControl *)page{
    CGFloat x = page.currentPage * self.scrollView.bounds.size.width;
    [_scrollView setContentOffset:CGPointMake(x, 0) animated:YES];
}

- (void)startTime{
    self.timer = [NSTimer timerWithTimeInterval:2 target:self selector:@selector(updateTime) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
}

//时钟所需要做的事
- (void)updateTime{
    int page = (self.pageControl.currentPage + 1) % kCount;
    self.pageControl.currentPage = page;
    [self valueChange:self.pageControl];
}

#pragma mark UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.timer invalidate];//拖拽时时钟停止(移从循环池中移除timer)
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    [self startTime];
    int distance = _scrollView.frame.size.width;
    int num = floor( (_scrollView.contentOffset.x + 0.5*distance) / distance);
    _pageControl.currentPage = num;
}
 
@end
