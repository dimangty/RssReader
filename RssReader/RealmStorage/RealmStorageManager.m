//
//  RealmStorageManager.m
//  RssReader
//
//  Created by dima on 09.04.18.
//  Copyright © 2018 dima. All rights reserved.
//

#import "RealmStorageManager.h"
#import "FeedRealm.h"
#import "NewsRealm.h"
#import <Realm/Realm.h>

@implementation RealmStorageManager
+ (id)sharedManager {
    static RealmStorageManager *instance = nil;
    @synchronized(self) {
        if (instance == nil)
            instance = [[self alloc] init];
    }
    return instance;
}

- (BOOL)testFeeds {
    RLMResults *feeds = [FeedRealm objectsWithPredicate:nil];
    if(feeds.count == 0) {
        return false;
    }
    return true;
}

- (void)addRssFeed:(RssFeed *)rssFeed {
    FeedRealm *feed = [FeedRealm new];
    feed.feedID = [[NSUUID UUID] UUIDString];
    feed.feedLink = rssFeed.feedLink;
    feed.feedName = rssFeed.feedName;
    
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm transactionWithBlock:^{
        [realm addObject:feed];
    }];
}

- (NSMutableArray *)getRssFeeds {
    NSMutableArray *result = [[NSMutableArray alloc] init];
    RLMResults *feeds = [FeedRealm objectsWithPredicate:nil];
    
    for (FeedRealm *feed in feeds) {
        RssFeed *rssFeed = [RssFeed new];
        rssFeed.feedID = feed.feedID;
        rssFeed.feedName = feed.feedName;
        rssFeed.feedLink = feed.feedLink;
        [result addObject:rssFeed];
    }
    
    return result;
}

-(void)addRssNews:(RSSItem *)rssItem {
    NewsRealm *newRealm = [NewsRealm new];
    newRealm.feedID = rssItem.feedID;
    newRealm.title = rssItem.title;
    newRealm.descriptionText = rssItem.descriptionText;
    newRealm.pubDate = rssItem.pubDate;
    newRealm.link = rssItem.link;
    
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm transactionWithBlock:^{
        [realm addObject:newRealm];
    }];
}

- (NSUInteger)countForFeed:(NSString *)feedID {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"feedID = %@", feedID];
    RLMResults *news = [NewsRealm objectsWithPredicate:predicate];
    return news.count;
}

-(NSMutableArray *)getNewsForFeed:(NSString *)feedID {
    NSMutableArray *result = [[NSMutableArray alloc] init];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"feedID = %@", feedID];
    RLMResults *news = [NewsRealm objectsWithPredicate:predicate];
    RLMResults *sortedNews = [news sortedResultsUsingKeyPath:@"pubDate" ascending:YES];
    
    for (NewsRealm *newRealm in sortedNews) {
        RSSItem *rssItem = [[RSSItem alloc] init];
        
        rssItem.feedID = newRealm.feedID;
        rssItem.title = newRealm.title;
        rssItem.descriptionText = newRealm.descriptionText;
        rssItem.pubDate = newRealm.pubDate;
        rssItem.link = newRealm.link;
        [result addObject:rssItem];
    }
    
    return result;
}
@end
