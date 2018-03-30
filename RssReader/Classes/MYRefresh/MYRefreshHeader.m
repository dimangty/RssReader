//
//  MYRefreshHeader.m
//  MYRefresh
//
//  Created by sunjinshuai on 2017/11/11.
//  Copyright © 2017年 sunjinshuai. All rights reserved.
//

#import "MYRefreshHeader.h"

@implementation MYRefreshHeader

+ (instancetype)headerWithRefreshingBlock:(MYRefreshingBlock)block{
    MYRefreshHeader *header = [[MYRefreshHeader alloc] init];
    header.refreshingBlock = block;
    header.stateTitle = @{MYStatePullingKey:@"Pull down to refresh",
                          MYStateWillRefreshKey:@"Release the refresh...",
                          MYStateRefreshingKey:@"Refreshing..."};
    return header;
}

+ (instancetype)headerWithRefreshingTarget:(id)target refreshingAction:(SEL)action {
    MYRefreshHeader *header = [[MYRefreshHeader alloc] init];
    [header setRefreshingTarget:target refreshingAction:action];
    header.stateTitle = @{MYStatePullingKey:@"Pull down to refresh",
                          MYStateWillRefreshKey:@"Release the refresh...",
                          MYStateRefreshingKey:@"Refreshing..."};
    return header;
}

- (void)updateRect {
    [super updateRect];
    
    self.frame = CGRectMake(0, -MYRefreshHeight, _scrollView.bounds.size.width, MYRefreshHeight);
}

- (void)scrollViewContentOffsetDidChange:(NSDictionary *)change {
    
    [super scrollViewContentOffsetDidChange:change];
    // 向上滑动不执行以下方法
    if (_scrollView.contentOffset.y > 0) {
        return;
    }
    // 拖拽的距离
    CGFloat distance = fabs(_scrollView.contentOffset.y + _scrollViewOriginalInset.top);
    // 居中显示
    self.center = CGPointMake(self.center.x, -distance/2.0f);
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

- (void)startRefreshing {
    [super startRefreshing];
    [UIView animateWithDuration:MYRefreshAnimationDuration animations:^{
        CGFloat top = _scrollViewOriginalInset.top + self.bounds.size.height;
        _scrollView.contentInset = UIEdgeInsetsMake(top, 0, 0, 0);
        [_scrollView setContentOffset:CGPointMake(0, -top) animated:NO];
    }];
}

- (void)endRefreshing {
    [super endRefreshing];
    [UIView animateWithDuration:MYRefreshAnimationDuration animations:^{
        [_scrollView setContentInset:_scrollViewOriginalInset];
        self.frame = CGRectMake(0, -MYRefreshHeight, self.bounds.size.width, self.bounds.size.height);
    }];
}

@end
