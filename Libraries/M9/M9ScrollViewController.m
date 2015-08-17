//
//  M9ScrollViewController.m
//  M9Dev
//
//  Created by MingLQ on 2012-06-12.
//  Copyright (c) 2012年 MingLQ <minglq.9@gmail.com>. All rights reserved.
//

#import "M9ScrollViewController.h"

@interface M9ScrollViewController ()

@property(nonatomic, readwrite, strong) UIScrollView *scrollView;

@end

#pragma mark -

@implementation M9ScrollViewController

- (id)init {
    self = [super init];
    if (self) {
    }
    return self;
}

- (UIScrollView *)scrollView {
    if (![self isViewLoaded]) {
        [self view];
    }
    if (_scrollView) {
        return _scrollView;
    }
    
    UIScrollView *scrollView = [UIScrollView new];
    scrollView.delegate = self;
    self.scrollView = scrollView;
    [self.view addSubview:scrollView];
    
    weakify(self);
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        strongify(self);
        make.left.top.width.height.equalTo(self.view);
    }];
    
    return _scrollView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self scrollView];
}

- (void)dealloc {
    self.scrollView.delegate = nil;
}

#pragma mark -

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (!decelerate) {
        if ([self respondsToSelector:@selector(scrollViewDidEndScrolling:)]) {
            [self scrollViewDidEndScrolling:scrollView];
        }
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if ([self respondsToSelector:@selector(scrollViewDidEndScrolling:)]) {
        [self scrollViewDidEndScrolling:scrollView];
    }
}

@end

#pragma mark - UIScrollView+M9Category

@implementation UIScrollView (M9Category)

- (void)scrollToTopAnimated:(BOOL)animated {
    [self scrollRectToVisible:CGRectMake(self.contentOffset.x, 0, 1, 1) animated:animated];
}

- (void)scrollToLeftAnimated:(BOOL)animated {
    [self scrollRectToVisible:CGRectMake(0, self.contentOffset.y, 1, 1) animated:animated];
}

- (void)scrollToLeftTopAnimated:(BOOL)animated {
    [self scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:animated];
}

@end
