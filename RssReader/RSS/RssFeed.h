//
//  RssFeed.h
//  RssReader
//
//  Created by dima on 13.10.17.
//  Copyright © 2017 dima. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RssFeed : NSObject
@property(nonatomic, strong) NSString *feedName;
@property(nonatomic, strong) NSString *feedLink;
@property(nonatomic, strong) NSString *feedID;
@property(nonatomic, assign) NSUInteger newsCount;
@end
