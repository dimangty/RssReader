//
//  MYRefreshConst.h
//  MYRefresh
//
//  Created by sunjinshuai on 2017/11/11.
//  Copyright © 2017年 sunjinshuai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <objc/message.h>

// 弱引用
#define MJWeakSelf __weak typeof(self) weakSelf = self;

#define MYScreenWidth [UIScreen mainScreen].bounds.size.width
#define MYScreenHeight [UIScreen mainScreen].bounds.size.height
#define MYSCREEN_RATIO ([UIScreen mainScreen].bounds.size.height)/667
#define MYSCREEN_SCALESIZE ([UIScreen mainScreen].bounds.size.width)/375

// RGB颜色
#define MYRefreshColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]

// 文字颜色
#define MYRefreshLabelTextColor MYRefreshColor(90, 90, 90)

// 字体大小
#define MYRefreshLabelFont [UIFont boldSystemFontOfSize:14]

//运行时objc_msgSend
#define MYRefreshMsgSend(...) ((void (*)(void *, SEL, UIView *))objc_msgSend)(__VA_ARGS__)
#define MYRefreshMsgTarget(target) (__bridge void *)(target)

// 常量
/// header箭头高度
UIKIT_EXTERN const CGFloat MYRefreshHeaderArrowHeight;
/// header圆弧半径
UIKIT_EXTERN const CGFloat MYRefreshHeaderCircleRadius;
/// header箭头的长度
UIKIT_EXTERN const CGFloat MYRefreshHeaderArrowWidth;
/// header箭头的角度
UIKIT_EXTERN const CGFloat MYRefreshHeaderArrowAngle;

// 刷新控件高度
UIKIT_EXTERN const CGFloat MYRefreshHeight;
// 刷新动画持续时间
UIKIT_EXTERN const CGFloat MYRefreshAnimationDuration;

// KVO
UIKIT_EXTERN NSString * const MYRefreshKeyPathContentOffset;
UIKIT_EXTERN NSString * const MYRefreshKeyPathContentSize;

//刷新状态提示信息对应的键
UIKIT_EXTERN NSString * const MYStatePullingKey;
UIKIT_EXTERN NSString * const MYStateWillRefreshKey;
UIKIT_EXTERN NSString * const MYStateRefreshingKey;
