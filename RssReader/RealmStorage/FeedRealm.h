//
//  FeedRealm.h
//  RssReader
//
//  Created by dima on 08.04.18.
//  Copyright © 2018 dima. All rights reserved.
//

#import "RLMObject.h"

@interface FeedRealm : RLMObject
@property NSString *feedName;
@property NSString *feedLink;
@property NSString *feedID;
@end
