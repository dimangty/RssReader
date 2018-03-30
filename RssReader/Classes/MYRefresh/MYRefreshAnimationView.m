//
//  MYRefreshAnimationView.m
//  MYRefresh
//
//  Created by sunjinshuai on 2017/11/11.
//  Copyright © 2017年 sunjinshuai. All rights reserved.
//

#import "MYRefreshAnimationView.h"
#import "MYRefreshAnimationLayer.h"

@interface MYRefreshAnimationView ()

@property (nonatomic, strong) MYRefreshAnimationLayer *refreshAnimationLayer;
@property (nonatomic, assign, getter=isAnimation) BOOL animation;

@end

@implementation MYRefreshAnimationView

- (instancetype)init {
    if (self = [super init]) {
        _refreshAnimationLayer = [MYRefreshAnimationLayer layer];
        _refreshAnimationLayer.contentsScale = [UIScreen mainScreen].scale;
        [self.layer addSublayer:_refreshAnimationLayer];
        _refreshAnimationLayer.progress = 0;
    }
    return self;
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    _refreshAnimationLayer.frame = self.bounds;
}

- (void)setProgress:(CGFloat)progress{
    if (self.isAnimation) {
        return;
    }
    // 画圆
    progress = progress > 1 ? 1 : progress;
    _refreshAnimationLayer.progress = progress;
}

- (void)startAnimation {
    self.animation = YES;
    CABasicAnimation *rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = @(M_PI * 2.0);
    rotationAnimation.duration = 0.7f;
    rotationAnimation.autoreverses = NO;
    rotationAnimation.repeatCount = HUGE_VALF;
    rotationAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    [_refreshAnimationLayer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
}

- (void)endAnimation{
    self.animation = NO;
    [_refreshAnimationLayer removeAllAnimations];
}

@end
