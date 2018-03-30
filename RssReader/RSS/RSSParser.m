//
//  RSSParser.m
//  RssReader
//
//  Created by dima on 13.10.17.
//  Copyright © 2017 dima. All rights reserved.
//

#import "RSSParser.h"
#import "RSSItem.h"

@interface RSSParser () <NSXMLParserDelegate>
@property(nonatomic, copy) void (^compleationBlock)(NSMutableArray *);
@end

@implementation RSSParser {
    NSMutableArray *result;
    RSSItem *rssItem;
    
    NSString *lastElement;
    BOOL parseCompleated;
    
    NSMutableString *dateString;
}

+ (id)parser {
    static RSSParser *instance = nil;
    @synchronized(self) {
        if (instance == nil) {
            instance = [[self alloc] init];
        }
    }
    return instance;
}

- (void)parseRSS:(NSString *)parseString
     onCompleate:(void (^)(NSMutableArray *))block {
    _compleationBlock = block;
    if (result == nil) {
        result = [[NSMutableArray alloc] init];
    } else {
        [result removeAllObjects];
    }
    
    NSXMLParser *parser = [[NSXMLParser alloc]
                           initWithData:[parseString dataUsingEncoding:NSUTF8StringEncoding]];
    
    parser.delegate = self;
    [parser parse];
}

- (void)parser:(NSXMLParser *)parser
didStartElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qName
    attributes:(NSDictionary<NSString *, NSString *> *)attributeDict {
    
    lastElement = [elementName lowercaseString];
    
    if ([elementName isEqualToString:@"item"]) {
        rssItem = [[RSSItem alloc] init];
        rssItem.title = @"";
        rssItem.descriptionText = @"";
        rssItem.link = @"";
        dateString = [[NSMutableString alloc] init];
    }
}

- (void)parser:(NSXMLParser *)parser
 didEndElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qName {
    
    
    if ([elementName isEqualToString:@"item"] && rssItem != nil) {
        rssItem.title = [rssItem.title stringByTrimmingCharactersInSet:
                         [NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
        rssItem.descriptionText = [rssItem.descriptionText stringByTrimmingCharactersInSet:
                                   [NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
        NSString *pubDate = [dateString stringByTrimmingCharactersInSet:
                           [NSCharacterSet whitespaceAndNewlineCharacterSet]];
        pubDate = [pubDate stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        
        rssItem.pubDate = [self dateFromString:pubDate];
        
        rssItem.link = [rssItem.link stringByTrimmingCharactersInSet:
                        [NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
        [result addObject:rssItem];
    }
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    if ([lastElement isEqualToString:@"title"]) {
        rssItem.title = [rssItem.title stringByAppendingString:string];
    } else if ([lastElement isEqualToString:@"description"]) {
        rssItem.descriptionText = [rssItem.descriptionText stringByAppendingString:string];
    } else if ([lastElement isEqualToString:@"pubdate"]) {
        [dateString appendString:string];
    } else if ([lastElement isEqualToString:@"link"]) {
        rssItem.link = [rssItem.link stringByAppendingString:string];
    }
}

- (void)parserDidEndDocument:(NSXMLParser *)parser {
    
    if (_compleationBlock != nil) {
        _compleationBlock(result);
    }
}

- (NSDate *)dateFromString:(NSString *)dateString {
    
    /*
     Разный форматы дат.
     Для разных сайтов
     */
    NSMutableArray *formats = [[NSMutableArray alloc] init];
    [formats addObject:@"EEE, d MMM yyyy HH:mm:ss zzzz"];
    [formats addObject:@"EEE, d MMM yyyy HH:mm zzz"];
    [formats addObject:@"EEE, d MMM yyyy HH:mm:ss zzz"];
    [formats addObject:@"EEE, d MMM yyyy HH:mm:ss Z"];
    
    [formats addObject:@"EEE, dd MMM yyyy HH:mm:ss zzzz"];
    [formats addObject:@"EEE, dd MMM yyyy HH:mm zzz"];
    [formats addObject:@"EEE, dd MMM yyyy HH:mm:ss zzz"];
    [formats addObject:@"EEE, dd MMM yyyy HH:mm:ss Z"];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSLocale *loc = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    [dateFormatter setLocale: loc];
    NSDate *date;
    
    for (NSString *format in formats) {
       [dateFormatter setDateFormat:format];
        date = [dateFormatter dateFromString:dateString];
        if (date != nil) {
            break;
        }
    }
    
    return date;
}

@end

