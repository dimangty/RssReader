//
//  Feeds+CoreDataProperties.h
//  RssReader
//
//  Created by dima on 13.10.17.
//  Copyright © 2017 dima. All rights reserved.
//
//

#import "Feeds+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Feeds (CoreDataProperties)

+ (NSFetchRequest<Feeds *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *feedID;
@property (nullable, nonatomic, copy) NSString *feedLink;
@property (nullable, nonatomic, copy) NSString *feedName;

@end

NS_ASSUME_NONNULL_END
