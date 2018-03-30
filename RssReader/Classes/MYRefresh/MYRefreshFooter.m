//
//  MYRefreshFooter.m
//  MYRefresh
//
//  Created by sunjinshuai on 2017/11/11.
//  Copyright © 2017年 sunjinshuai. All rights reserved.
//

#import "MYRefreshFooter.h"

@implementation MYRefreshFooter

+ (instancetype)footerWithRefreshingBlock:(MYRefreshingBlock)block {
    MYRefreshFooter *footer = [[MYRefreshFooter alloc] init];
    footer.refreshingBlock = block;
    footer.stateTitle = @{
                          MYStatePullingKey:@"Pull up to load",
                          MYStateWillRefreshKey:@"Release the load...",
                          MYStateRefreshingKey:@"loading..."
                          };
    return footer;
}

+ (instancetype)footerWithRefreshingTarget:(id)target refreshingAction:(SEL)action {
    MYRefreshFooter *footer = [[MYRefreshFooter alloc] init];
    [footer setRefreshingTarget:target refreshingAction:action];
    footer.stateTitle = @{
                          MYStatePullingKey:@"Pull up to load",
                          MYStateWillRefreshKey:@"Release the load...",
                          MYStateRefreshingKey:@"loading..."
                          };
    return footer;
}

- (void)updateRect {
    [super updateRect];
    self.frame = CGRectMake(0, _scrollView.bounds.size.height, _scrollView.bounds.size.width, MYRefreshHeight);
}

- (void)scrollViewContentOffsetDidChange:(NSDictionary *)change {
    [super scrollViewContentOffsetDidChange:change];
    CGFloat distance = 0;
    // 比较短 小于屏幕高度
    if (_scrollView.contentSize.height < _scrollView.bounds.size.height) {
        CGFloat actionY = _scrollView.contentOffset.y + _scrollViewOriginalInset.top;
        BOOL action = actionY != MYRefreshHeight && _scrollViewOriginalInset.top > 0 && actionY > 0;
        if (_scrollViewOriginalInset.top == 0) {
            action = actionY > 0;
        }
        if (action) {
            distance = actionY;
            self.center = CGPointMake(self.center.x, _scrollView.bounds.size.height + distance/2.0f - _scrollViewOriginalInset.top);
        }
    } else {
        // 比较大 大于屏幕高度
        // 拖拽距离
        CGFloat targetOffsetY = _scrollView.contentSize.height - _scrollView.bounds.size.height;
        if (_scrollView.contentOffset.y < targetOffsetY) {
            return;
        }
        distance = fabs(targetOffsetY - _scrollView.contentOffset.y);
        //居中显示
        self.center = CGPointMake(self.center.x, _scrollView.contentSize.height + distance/2.0f);
    }
    // 刷新中不执行以下方法
    if (self.state == MYRefreshStateRefreshing) {
        return;
    }
    // 保留缩进
    _scrollViewOriginalInset = _scrollView.contentInset;
    // 动画进度
    self.refreshProgress = distance / MYRefreshHeight;
    // 拖拽时 当拖拽距离大于header的高度时 状态切换成准备拖拽的状态
    if (_scrollView.isDragging) {
        if (distance <= MYRefreshHeight) {
            self.state = MYRefreshStatePulling;
        } else {
            self.state = MYRefreshStateWillRefresh;
        }
    } else {
        // 松手后，如果已经到达可以刷新的状态 则进行刷新
        if (self.state == MYRefreshStateWillRefresh) {
            [self startRefreshing];
        }
    }
}

- (void)scrollViewContentSizeDidChange:(NSDictionary *)change {
    if (![[change objectForKey:@"new"] isEqual:[change objectForKey:@"old"]]) {
        CGFloat Y = _scrollView.bounds.size.height > _scrollView.contentSize.height ? _scrollView.bounds.size.height : _scrollView.contentSize.height;
        self.frame = CGRectMake(0, Y, _scrollView.bounds.size.width, MYRefreshHeight);
    }
}

- (void)startRefreshing {
    [super startRefreshing];
    [UIView animateWithDuration:MYRefreshAnimationDuration animations:^{
        [_scrollView setContentInset:UIEdgeInsetsMake(0, 0, self.bounds.size.height, 0)];
        if (_scrollView.contentSize.height < _scrollView.bounds.size.height) {
            [_scrollView setContentOffset:CGPointMake(0,self.bounds.size.height - _scrollViewOriginalInset.top) animated:NO];
        }else{
            [_scrollView setContentOffset:CGPointMake(0, _scrollView.contentSize.height - _scrollView.bounds.size.height + self.bounds.size.height) animated:NO];
        }
    }];
}
- (void)endRefreshing {
    [super endRefreshing];
    [UIView animateWithDuration:MYRefreshAnimationDuration animations:^{
        [_scrollView setContentInset:_scrollViewOriginalInset];
        if (_scrollView.contentSize.height < _scrollView.bounds.size.height) {
            self.frame = CGRectMake(0, _scrollView.bounds.size.height + MYRefreshHeight, self.bounds.size.width, self.bounds.size.height);
        } else {
            self.frame = CGRectMake(0, _scrollView.contentSize.height + MYRefreshHeight, self.bounds.size.width, self.bounds.size.height);
        }
    }];
}

@end
