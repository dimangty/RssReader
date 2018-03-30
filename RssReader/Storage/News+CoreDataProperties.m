//
//  News+CoreDataProperties.m
//  RssReader
//
//  Created by dima on 14.10.17.
//  Copyright © 2017 dima. All rights reserved.
//
//

#import "News+CoreDataProperties.h"

@implementation News (CoreDataProperties)

+ (NSFetchRequest<News *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"News"];
}

@dynamic feedID;
@dynamic newsDescription;
@dynamic newsLink;
@dynamic newsTitle;
@dynamic pubDate;

@end
