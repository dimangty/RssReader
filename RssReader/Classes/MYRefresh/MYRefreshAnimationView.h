//
//  MYRefreshAnimationView.h
//  MYRefresh
//
//  Created by sunjinshuai on 2017/11/11.
//  Copyright © 2017年 sunjinshuai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MYRefreshAnimationView : UIView

@property (nonatomic, assign) CGFloat progress;

- (void)startAnimation;

- (void)endAnimation;

@end
