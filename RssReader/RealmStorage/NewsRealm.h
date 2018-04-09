//
//  NewsRealm.h
//  RssReader
//
//  Created by dima on 08.04.18.
//  Copyright © 2018 dima. All rights reserved.
//

#import "RLMObject.h"

@interface NewsRealm : RLMObject
@property NSString *feedID;
@property NSString *title;
@property NSString *descriptionText;
@property NSDate *pubDate;
@property NSString *link;
@end
