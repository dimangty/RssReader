//
//  UIScrollView+MYRefresh.m
//  MYRefresh
//
//  Created by sunjinshuai on 2017/11/11.
//  Copyright © 2017年 sunjinshuai. All rights reserved.
//

#import "UIScrollView+MYRefresh.h"

@implementation UIScrollView (MYRefresh)

static const char MYRefreshHeaderKey = '\0';
static const char MYRefreshFooterKey = '\0';
static const char MYRefreshReloadDataBlockKey = '\0';

- (void)setMy_header:(MYRefreshHeader *)my_header {
    if (my_header != self.my_header) {
        // 删除旧的，添加新的
        [self.my_header removeFromSuperview];
        [self insertSubview:my_header atIndex:0];
        
        // 存储新的
        [self willChangeValueForKey:@"my_header"]; // KVO
        objc_setAssociatedObject(self, &MYRefreshHeaderKey, my_header, OBJC_ASSOCIATION_ASSIGN);
        [self didChangeValueForKey:@"my_header"]; // KVO
    }
}

- (MYRefreshHeader *)my_header {
    return objc_getAssociatedObject(self, &MYRefreshHeaderKey);
}

- (void)setMy_footer:(MYRefreshFooter *)my_footer {
    if (my_footer != self.my_footer) {
        // 删除旧的，添加新的
        [self.my_footer removeFromSuperview];
        [self insertSubview:my_footer atIndex:0];
        
        // 存储新的
        [self willChangeValueForKey:@"my_footer"]; // KVO
        objc_setAssociatedObject(self, &MYRefreshFooterKey, my_footer, OBJC_ASSOCIATION_ASSIGN);
        [self didChangeValueForKey:@"my_footer"]; // KVO
    }
}

- (MYRefreshFooter *)my_footer {
    return objc_getAssociatedObject(self, &MYRefreshFooterKey);
}

- (void)setReloadDataBlock:(MYReloadDataBlock)reloadDataBlock {
    [self willChangeValueForKey:@"my_reloadDataBlock"]; // KVO
    objc_setAssociatedObject(self, &MYRefreshReloadDataBlockKey, reloadDataBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self didChangeValueForKey:@"my_reloadDataBlock"]; // KVO
}

- (MYReloadDataBlock)reloadDataBlock {
    return objc_getAssociatedObject(self, &MYRefreshReloadDataBlockKey);
}

- (NSInteger)my_totalDataCount {
    NSInteger totalCount = 0;
    if ([self isKindOfClass:[UITableView class]]) {
        UITableView *tableView = (UITableView *)self;
        
        for (NSInteger section = 0; section<tableView.numberOfSections; section++) {
            totalCount += [tableView numberOfRowsInSection:section];
        }
    } else if ([self isKindOfClass:[UICollectionView class]]) {
        UICollectionView *collectionView = (UICollectionView *)self;
        
        for (NSInteger section = 0; section<collectionView.numberOfSections; section++) {
            totalCount += [collectionView numberOfItemsInSection:section];
        }
    }
    return totalCount;
}

- (void)executeReloadDataBlock
{
    !self.reloadDataBlock ? : self.reloadDataBlock(self.my_totalDataCount);
}

@end

@implementation UITableView (MYRefresh)

+ (void)load
{
    method_exchangeImplementations(class_getInstanceMethod(self, @selector(reloadData)), class_getInstanceMethod(self, @selector(my_reloadData)));
}

+ (void)exchangeInstanceMethod1:(SEL)method1 method2:(SEL)method2
{
    
}

+ (void)exchangeClassMethod1:(SEL)method1 method2:(SEL)method2
{
    method_exchangeImplementations(class_getClassMethod(self, method1), class_getClassMethod(self, method2));
}


- (void)my_reloadData
{
    [self my_reloadData];
    
    [self executeReloadDataBlock];
}
@end

@implementation UICollectionView (MJRefresh)

+ (void)load
{
    method_exchangeImplementations(class_getInstanceMethod(self, @selector(reloadData)), class_getInstanceMethod(self, @selector(my_reloadData)));
}

- (void)mj_reloadData
{
    [self mj_reloadData];
    
    [self executeReloadDataBlock];
}

@end
