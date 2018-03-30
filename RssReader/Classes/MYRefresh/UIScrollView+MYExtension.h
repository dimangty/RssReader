//
//  UIScrollView+MYExtension.h
//  MYRefresh
//
//  Created by sunjinshuai on 2017/11/11.
//  Copyright © 2017年 sunjinshuai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIScrollView (MYExtension)

@property (nonatomic, assign, readonly) UIEdgeInsets my_inset;
@property (nonatomic, assign) CGFloat my_insetTop;
@property (nonatomic, assign) CGFloat my_insetBottom;
@property (nonatomic, assign) CGFloat my_insetLeft;
@property (nonatomic, assign) CGFloat my_insetRight;
@property (nonatomic, assign) CGFloat my_offsetX;
@property (nonatomic, assign) CGFloat my_offsetY;
@property (nonatomic, assign) CGFloat my_contentW;
@property (nonatomic, assign) CGFloat my_contentH;

@end
