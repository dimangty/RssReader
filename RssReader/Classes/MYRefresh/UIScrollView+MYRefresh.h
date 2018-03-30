//
//  UIScrollView+MYRefresh.h
//  MYRefresh
//
//  Created by sunjinshuai on 2017/11/11.
//  Copyright © 2017年 sunjinshuai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MYRefreshHeader.h"
#import "MYRefreshFooter.h"

typedef void (^MYReloadDataBlock)(NSInteger totalDataCount);

@interface UIScrollView (MYRefresh)

@property (nonatomic, strong) MYRefreshHeader *my_header;
@property (nonatomic, strong) MYRefreshFooter *my_footer;
@property (nonatomic, copy) MYReloadDataBlock reloadDataBlock;

- (NSInteger)my_totalDataCount;

@end
