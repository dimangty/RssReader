//
//  Feeds+CoreDataProperties.m
//  RssReader
//
//  Created by dima on 13.10.17.
//  Copyright © 2017 dima. All rights reserved.
//
//

#import "Feeds+CoreDataProperties.h"

@implementation Feeds (CoreDataProperties)

+ (NSFetchRequest<Feeds *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Feeds"];
}

@dynamic feedID;
@dynamic feedLink;
@dynamic feedName;

@end
