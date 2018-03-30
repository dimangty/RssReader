//
//  MYRefreshAnimationLayer.m
//  MYRefresh
//
//  Created by sunjinshuai on 2017/11/11.
//  Copyright © 2017年 sunjinshuai. All rights reserved.
//

#import "MYRefreshAnimationLayer.h"
#import "MYRefreshConst.h"

@implementation MYRefreshAnimationLayer

- (void)drawInContext:(CGContextRef)ctx {
    [super drawInContext:ctx];
    
    UIGraphicsPushContext(ctx);
    CGContextRef contex = UIGraphicsGetCurrentContext();

    CGFloat refreshAnimationLayerHeight = self.bounds.size.height;
    CGFloat refreshAnimationLayerWidth = self.bounds.size.width;

    // 线段最长移动距离
    CGFloat maxDistance = refreshAnimationLayerHeight / 2 - MYRefreshHeaderArrowHeight;
    // 线段当前移动距离
    CGFloat moveDisatnce = maxDistance * self.progress * 2;

    //--------第一条：从下向上的线
    UIBezierPath *curvePath1 = [UIBezierPath bezierPath];
    curvePath1.lineCapStyle = kCGLineCapRound;
    curvePath1.lineJoinStyle = kCGLineJoinRound;
    curvePath1.lineWidth = 2.0f;
    // 线的x位置
    CGFloat path1_X = refreshAnimationLayerWidth/2 - MYRefreshHeaderCircleRadius;
    CGPoint pointA = CGPointMake(path1_X, refreshAnimationLayerHeight - moveDisatnce);
    CGPoint pointB = CGPointMake(path1_X, refreshAnimationLayerHeight - moveDisatnce - MYRefreshHeaderArrowHeight);
    // 当小于0.5座直线向上的动画
    if (self.progress <= 0.5) {
        [curvePath1 moveToPoint:pointA];
        [curvePath1 addLineToPoint:pointB];
        //添加箭头
        CGPoint point = curvePath1.currentPoint;
        CGPoint arrowPoint = CGPointMake(point.x - MYRefreshHeaderArrowWidth * cos(MYRefreshHeaderArrowAngle),
                                         point.y + MYRefreshHeaderArrowWidth * sin(MYRefreshHeaderArrowAngle));
        UIBezierPath *arrowPath = [UIBezierPath bezierPath];
        [arrowPath moveToPoint:point];
        [arrowPath addLineToPoint:arrowPoint];
        [curvePath1 appendPath:arrowPath];
    } else {
        // 当大于0.5时 添加顺时针曲线动画，且下半部逐渐缩短（保持B点不动A点逐渐上移）
        pointB = CGPointMake(path1_X, refreshAnimationLayerHeight / 2.0f);
        [curvePath1 moveToPoint:pointA];
        [curvePath1 addLineToPoint:pointB];
        
        // 由progress获取旋转的角度
        CGFloat moveAngle = M_PI * (_progress - 0.5) * 2 * 0.8;
        // 设置弧线
        [curvePath1 addArcWithCenter:CGPointMake(refreshAnimationLayerWidth/2, refreshAnimationLayerHeight/2)
                              radius:MYRefreshHeaderCircleRadius
                          startAngle:M_PI
                            endAngle:M_PI + moveAngle
                           clockwise:YES];
        // 添加箭头
        CGPoint point = curvePath1.currentPoint;
        CGPoint arrowPoint = CGPointMake(point.x - MYRefreshHeaderArrowWidth * cos(MYRefreshHeaderArrowAngle - moveAngle),
                                         point.y + MYRefreshHeaderArrowWidth * sin(MYRefreshHeaderArrowAngle - moveAngle));
        UIBezierPath *arrowPath = [UIBezierPath bezierPath];
        [arrowPath moveToPoint:point];
        [arrowPath addLineToPoint:arrowPoint];
        [curvePath1 appendPath:arrowPath];
    }
    
    //--------第二条：从上向下的线
    UIBezierPath *curvePath2 = [UIBezierPath bezierPath];
    curvePath2.lineCapStyle = kCGLineCapRound;
    curvePath2.lineJoinStyle = kCGLineJoinRound;
    curvePath2.lineWidth = 2.0f;
    
    CGFloat path2_X = refreshAnimationLayerWidth/2 + MYRefreshHeaderCircleRadius;
    CGPoint pointC = CGPointMake(path2_X,moveDisatnce);
    CGPoint pointD = CGPointMake(path2_X,moveDisatnce + MYRefreshHeaderArrowHeight);
    
    if (self.progress <= 0.5) {
        [curvePath2 moveToPoint:pointC];
        [curvePath2 addLineToPoint:pointD];
        
        CGPoint point = curvePath2.currentPoint;
        CGPoint arrowPoint = CGPointMake(point.x + MYRefreshHeaderArrowWidth * cos(MYRefreshHeaderArrowAngle),
                                         point.y - MYRefreshHeaderArrowWidth * sin(MYRefreshHeaderArrowAngle));
        UIBezierPath *arrowPath = [UIBezierPath bezierPath];
        [arrowPath moveToPoint:point];
        [arrowPath addLineToPoint:arrowPoint];
        [curvePath2 appendPath:arrowPath];
    } else {
        pointD = CGPointMake(path2_X, refreshAnimationLayerHeight/2.0f);
        [curvePath2 moveToPoint:pointC];
        [curvePath2 addLineToPoint:pointD];
        
        CGFloat moveAngle = M_PI * (self.progress - 0.5) * 2 * 0.8;
        
        [curvePath2 addArcWithCenter:CGPointMake(refreshAnimationLayerWidth/2, refreshAnimationLayerHeight/2)
                              radius:MYRefreshHeaderCircleRadius
                          startAngle:0
                            endAngle:moveAngle
                           clockwise:YES];
        
        CGPoint point = curvePath2.currentPoint;
        CGPoint arrowPoint = CGPointMake(point.x + MYRefreshHeaderArrowWidth * cos(MYRefreshHeaderArrowAngle - moveAngle),
                                         point.y - MYRefreshHeaderArrowWidth * sin(MYRefreshHeaderArrowAngle - moveAngle));
        UIBezierPath *arrowPath = [UIBezierPath bezierPath];
        [arrowPath moveToPoint:point];
        [arrowPath addLineToPoint:arrowPoint];
        [curvePath2 appendPath:arrowPath];
    }
    
    CGContextSaveGState(contex);
    CGContextRestoreGState(contex);
    
    [[UIColor blackColor] setStroke];
    [curvePath1 stroke];
    [curvePath2 stroke];
    
    UIGraphicsPopContext();
}

- (void)setProgress:(CGFloat)progress {
    _progress = progress;
    [self setNeedsDisplay];
}

@end
