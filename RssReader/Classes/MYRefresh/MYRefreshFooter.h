//
//  MYRefreshFooter.h
//  MYRefresh
//
//  Created by sunjinshuai on 2017/11/11.
//  Copyright © 2017年 sunjinshuai. All rights reserved.
//

#import "MYRefreshComponent.h"
#import "MYRefreshConst.h"

@interface MYRefreshFooter : MYRefreshComponent

+ (instancetype)footerWithRefreshingBlock:(MYRefreshingBlock)block;

+ (instancetype)footerWithRefreshingTarget:(id)target refreshingAction:(SEL)action;

@end
