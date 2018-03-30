//
//  MYRefreshComponent.h
//  MYRefresh
//
//  Created by sunjinshuai on 2017/11/11.
//  Copyright © 2017年 sunjinshuai. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, MYRefreshState) {
    MYRefreshStatePulling = 0,   // 初始状态
    MYRefreshStateWillRefresh,   // 即将刷新
    MYRefreshStateRefreshing,    // 正在刷新
};

typedef void (^MYRefreshingBlock)();

@interface MYRefreshComponent : UIView {
    
    __weak UIScrollView *_scrollView;
    
    /** 记录scrollView刚开始的inset */
    UIEdgeInsets _scrollViewOriginalInset;
}

@property (nonatomic, assign) MYRefreshState state;
@property (nonatomic, copy) MYRefreshingBlock refreshingBlock;
@property (nonatomic, weak) id refreshingTarget;
@property (nonatomic, assign) SEL refreshingAction;
// 刷新进度 用于动画显示
@property (nonatomic, assign) CGFloat refreshProgress;
// 是否正在刷新
@property (nonatomic, assign) BOOL isRefreshing;
// 状态提示文字
@property (nonatomic, strong) NSDictionary *stateTitle;
// 更新frame
- (void)updateRect;
// 开始刷新
- (void)startRefreshing;
// 结束刷新
- (void)endRefreshing;
- (void)scrollViewContentOffsetDidChange:(NSDictionary *)change;
- (void)scrollViewContentSizeDidChange:(NSDictionary *)change;
- (void)setRefreshingTarget:(id)target refreshingAction:(SEL)action;

@end
