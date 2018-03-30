//
//  UIScrollView+MYExtension.m
//  MYRefresh
//
//  Created by sunjinshuai on 2017/11/11.
//  Copyright © 2017年 sunjinshuai. All rights reserved.
//

#import "UIScrollView+MYExtension.h"

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunguarded-availability-new"

@implementation UIScrollView (MYExtension)

- (UIEdgeInsets)my_inset {
#ifdef __IPHONE_11_0
    if (@available(iOS 11.0, *))  {
        return self.adjustedContentInset;
    }
#endif
    return self.contentInset;
}

- (void)setMy_insetTop:(CGFloat)my_insetTop {
    UIEdgeInsets inset = self.contentInset;
    inset.top = my_insetTop;
#ifdef __IPHONE_11_0
    if (@available(iOS 11.0, *))  {
        inset.top -= (self.adjustedContentInset.top - self.contentInset.top);
    }
#endif
    self.contentInset = inset;
}

- (CGFloat)my_insetTop {
    return self.my_inset.top;
}

- (void)setMy_insetBottom:(CGFloat)my_insetBottom {
    UIEdgeInsets inset = self.contentInset;
    inset.bottom = my_insetBottom;
#ifdef __IPHONE_11_0
    if (@available(iOS 11.0, *))  {
        inset.bottom -= (self.adjustedContentInset.bottom - self.contentInset.bottom);
    }
#endif
    self.contentInset = inset;
}

- (CGFloat)my_insetBottom {
    return self.my_inset.bottom;
}

- (void)setMy_insetLeft:(CGFloat)my_insetLeft {
    UIEdgeInsets inset = self.contentInset;
    inset.left = my_insetLeft;
#ifdef __IPHONE_11_0
    if (@available(iOS 11.0, *))  {
        inset.left -= (self.adjustedContentInset.left - self.contentInset.left);
    }
#endif
    self.contentInset = inset;
}

- (CGFloat)my_insetLeft {
    return self.my_inset.left;
}

- (void)setMy_insetRight:(CGFloat)my_insetRight {
    UIEdgeInsets inset = self.contentInset;
    inset.right = my_insetRight;
#ifdef __IPHONE_11_0
    if (@available(iOS 11.0, *)) {
        inset.right -= (self.adjustedContentInset.right - self.contentInset.right);
    }
#endif
    self.contentInset = inset;
}

- (CGFloat)my_insetRight {
    return self.my_inset.right;
}

- (void)setMy_offsetX:(CGFloat)my_offsetX {
    CGPoint offset = self.contentOffset;
    offset.x = my_offsetX;
    self.contentOffset = offset;
}

- (CGFloat)my_offsetX {
    return self.contentOffset.x;
}

- (void)setMy_offsetY:(CGFloat)my_offsetY {
    CGPoint offset = self.contentOffset;
    offset.y = my_offsetY;
    self.contentOffset = offset;
}

- (CGFloat)my_offsetY {
    return self.contentOffset.y;
}

- (void)setMy_contentH:(CGFloat)my_contentH {
    CGSize size = self.contentSize;
    size.height = my_contentH;
    self.contentSize = size;
}

- (CGFloat)my_contentH {
    return self.contentSize.height;
}

- (void)setMy_contentW:(CGFloat)my_contentW {
    CGSize size = self.contentSize;
    size.width = my_contentW;
    self.contentSize = size;
}

- (CGFloat)my_contentW {
    return self.contentSize.width;
}

@end
#pragma clang diagnostic pop
