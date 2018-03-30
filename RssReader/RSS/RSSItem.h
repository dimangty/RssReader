//
//  RSSItem.h
//  RssReader
//
//  Created by dima on 13.10.17.
//  Copyright © 2017 dima. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RSSItem : NSObject
@property(nonatomic, strong) NSString *feedID;
@property(nonatomic, strong) NSString *title;
@property(nonatomic, strong) NSString *descriptionText;
@property(nonatomic, strong) NSDate *pubDate;
@property(nonatomic, strong) NSString *link;
@end
