//
//  RealmStorageManager.h
//  RssReader
//
//  Created by dima on 09.04.18.
//  Copyright © 2018 dima. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RssFeed.h"
#import "RSSItem.h"

@interface RealmStorageManager : NSObject
+ (id)sharedManager;

- (void)addRssFeed:(RssFeed *)rssFeed;
- (BOOL)testFeeds;
- (NSMutableArray *)getRssFeeds;

- (void)addRssNews:(RSSItem *)rssItem;
- (NSMutableArray *)getNewsForFeed:(NSString *)feedID;
- (NSUInteger)countForFeed:(NSString *)feedID;
@end
