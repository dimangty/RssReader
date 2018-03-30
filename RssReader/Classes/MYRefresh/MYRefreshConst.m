//
//  MYRefreshConst.m
//  MYRefresh
//
//  Created by sunjinshuai on 2017/11/11.
//  Copyright © 2017年 sunjinshuai. All rights reserved.
//

#import <UIKit/UIKit.h>

const CGFloat MYRefreshHeaderArrowHeight = 20.0f;
const CGFloat MYRefreshHeaderCircleRadius = 10.0f;
const CGFloat MYRefreshHeaderArrowWidth = 2.0f;
const CGFloat MYRefreshHeaderArrowAngle = M_PI / 6.0f;

// 刷新控件高度
const CGFloat MYRefreshHeight = 80.0f;
// 刷新动画持续时间
const CGFloat MYRefreshAnimationDuration = 0.25f;

// KVO
NSString * const MYRefreshKeyPathContentOffset = @"contentOffset";
NSString * const MYRefreshKeyPathContentSize = @"contentSize";

//刷新状态提示信息对应的键
NSString * const MYStatePullingKey = @"MYStatePullingKey";
NSString * const MYStateWillRefreshKey = @"MYStateWillRefreshKey";
NSString * const MYStateRefreshingKey = @"MYStateRefreshingKey";
