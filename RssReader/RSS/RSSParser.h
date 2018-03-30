//
//  RSSParser.h
//  RssReader
//
//  Created by dima on 13.10.17.
//  Copyright © 2017 dima. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RSSParser : NSObject
+ (id)parser;
- (void)parseRSS:(NSString *)parseString
     onCompleate:(void (^)(NSMutableArray *result))block;
@end
