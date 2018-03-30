//
//  News+CoreDataProperties.h
//  RssReader
//
//  Created by dima on 14.10.17.
//  Copyright © 2017 dima. All rights reserved.
//
//

#import "News+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface News (CoreDataProperties)

+ (NSFetchRequest<News *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *feedID;
@property (nullable, nonatomic, copy) NSString *newsDescription;
@property (nullable, nonatomic, copy) NSString *newsLink;
@property (nullable, nonatomic, copy) NSString *newsTitle;
@property (nullable, nonatomic, copy) NSDate *pubDate;

@end

NS_ASSUME_NONNULL_END
