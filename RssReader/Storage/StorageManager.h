//
//  StorageManager.h
//  RssReader
//
//  Created by dima on 13.10.17.
//  Copyright © 2017 dima. All rights reserved.
//

#import "RssFeed.h"
#import "RSSItem.h"
#import <Foundation/Foundation.h>
@interface StorageManager : NSObject
+ (id)sharedManager;

- (BOOL)testFeeds;
- (void)addRssFeed:(RssFeed *)rssFeed;
- (NSMutableArray *)getRssFeeds;

- (void)addRssNews:(RSSItem *)rssItem;
- (NSMutableArray *)getNewsForFeed:(NSString *)feedID;
- (NSUInteger)countForFeed:(NSString *)feedID;
@end
