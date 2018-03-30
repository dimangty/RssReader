//
//  StorageManager.m
//  RssReader
//
//  Created by dima on 13.10.17.
//  Copyright © 2017 dima. All rights reserved.
//

#import "Feeds+CoreDataProperties.h"
#import "News+CoreDataProperties.h"
#import "StorageManager.h"
#import <CoreData/CoreData.h>

@interface StorageManager ()
@property(nonatomic, retain) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property(nonatomic, retain) NSManagedObjectModel *managedObjectModel;
@property(nonatomic, retain) NSManagedObjectContext *managedContext;
@end

@implementation StorageManager

+ (id)sharedManager {
    static StorageManager *instance = nil;
    @synchronized(self) {
        if (instance == nil)
            instance = [[self alloc] init];
    }
    return instance;
}

- (NSString *)applicationsDocumentsDirectory {
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    if (_managedObjectModel != nil)
        return _managedObjectModel;
    
    NSString *path = [[NSBundle bundleForClass:self.class] pathForResource:@"Model" ofType:@"momd"];
    NSURL *url = [NSURL fileURLWithPath:path];
    _managedObjectModel =
    [[NSManagedObjectModel alloc] initWithContentsOfURL:url];
    
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSString *storePath = [[self applicationsDocumentsDirectory]
                           stringByAppendingPathComponent:@"DB.sqlite"];
    NSURL *stroreURL = [NSURL fileURLWithPath:storePath];
    NSError *error;
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    
    NSPersistentStore *store;
    store = [_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType
                                                      configuration:nil
                                                                URL:stroreURL
                                                            options:nil
                                                              error:&error];
    if (!store) {
        NSLog(@"%@ %@", error, error.userInfo);
    }
    
    return _persistentStoreCoordinator;
}

- (NSManagedObjectContext *)managedObjectContext {
    if (_managedContext != nil) {
        return _managedContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        [_managedContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedContext;
}

- (BOOL)testFeeds {
    NSManagedObjectContext *context = [self managedObjectContext];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *description = [NSEntityDescription entityForName:@"Feeds" inManagedObjectContext:context];
    [request setEntity:description];
    
    NSError *error;
    NSArray *arr = [context executeFetchRequest:request error:&error];
    
    if ([arr count] == 0)
        return false;
    else
        return true;
}

- (void)addRssFeed:(RssFeed *)rssFeed {
    NSManagedObjectContext *context = [self managedObjectContext];
    
    Feeds *feed = [NSEntityDescription
                   insertNewObjectForEntityForName:@"Feeds"
                   inManagedObjectContext:self.managedContext];
    feed.feedID = [[NSUUID UUID] UUIDString];
    feed.feedName = rssFeed.feedName;
    feed.feedLink = rssFeed.feedLink;
    
    NSError *error;
    @try {
        [context save:&error];
    } @catch (NSException *exception) {
        
        NSLog(@"%@", exception.reason);
    }
}

- (NSMutableArray *) getRssFeeds {
    NSMutableArray *result = [[NSMutableArray alloc] init];
    
    NSManagedObjectContext *context = [self managedObjectContext];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *description = [NSEntityDescription entityForName:@"Feeds" inManagedObjectContext:context];
    [request setEntity:description];
    
    NSError *error;
    NSArray *arr = [context executeFetchRequest:request error:&error];
    
    for (Feeds *feed in arr) {
        RssFeed *rssFeed = [[RssFeed alloc] init];
        rssFeed.feedID = feed.feedID;
        rssFeed.feedName = feed.feedName;
        rssFeed.feedLink = feed.feedLink;
        [result addObject:rssFeed];
    }
    
    return result;
}

- (void)addRssNews:(RSSItem *)rssItem {
    NSManagedObjectContext *context = [self managedObjectContext];
    
    News *news = [NSEntityDescription insertNewObjectForEntityForName:@"News"
                                               inManagedObjectContext:self.managedContext];
    
    news.feedID = rssItem.feedID;
    news.newsTitle = rssItem.title;
    news.newsDescription = rssItem.descriptionText;
    news.newsLink = rssItem.link;
    news.pubDate = rssItem.pubDate;
    
    NSError *error;
    @try {
        [context save:&error];
    } @catch (NSException *exception) {
        
        NSLog(@"%@", exception.reason);
    }
}

- (NSMutableArray *)getNewsForFeed:(NSString *)feedID {
    
    NSMutableArray *result = [[NSMutableArray alloc] init];
    
    NSManagedObjectContext *context = [self managedObjectContext];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *description = [NSEntityDescription entityForName:@"News" inManagedObjectContext:context];
    [request setEntity:description];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"feedID = %@", feedID];
    [request setPredicate:predicate];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"pubDate" ascending:YES];
    [request setSortDescriptors:[NSArray arrayWithObjects:sortDescriptor, nil]];
    
    NSError *error;
    NSArray *arr = [context executeFetchRequest:request error:&error];
    
    for (News *news in arr) {
        RSSItem *rssItem = [[RSSItem alloc] init];
        
        rssItem.feedID = news.feedID;
        rssItem.title = news.newsTitle;
        rssItem.descriptionText = news.newsDescription;
        rssItem.pubDate = news.pubDate;
        rssItem.link = news.newsLink;
        [result addObject:rssItem];
    }
    
    return result;
}

- (NSUInteger)countForFeed:(NSString *)feedID {
    NSManagedObjectContext *context = [self managedObjectContext];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *description = [NSEntityDescription entityForName:@"News" inManagedObjectContext:context];
    [request setEntity:description];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"feedID = %@", feedID];
    [request setPredicate:predicate];
    NSError *error;
    
    NSUInteger entityCount = 0;
    NSUInteger count = [context countForFetchRequest:request error:&error];
    if (error == nil) {
        entityCount = count;
    }
    
    return entityCount;
}

@end
