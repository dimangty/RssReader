//
//  NewsViewController.m
//  RssReader
//
//  Created by dima on 13.10.17.
//  Copyright © 2017 dima. All rights reserved.
//

#import "NewsViewController.h"
#import "DetailViewController.h"
#import "RSSParser.h"
#import "StorageManager.h"
#import "RssCell.h"
#import "RSSItem.h"

#import "MYRefresh.h"
#import "NetworkManager.h"

@interface NewsViewController ()<UITableViewDelegate, UITableViewDataSource>
@property(strong, nonatomic) IBOutlet UIActivityIndicatorView *indicatorView;
@property(strong, nonatomic) IBOutlet UITableView *newsTable;
@end

@implementation NewsViewController {
    NSMutableArray *news;
}

#pragma mark init
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = _currentFeed.feedName;
    news = [[StorageManager sharedManager] getNewsForFeed:_currentFeed.feedID];
    [self sortNews];
    
    _newsTable.my_header = [MYRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadMoreMethod)];
    

}

- (void)viewDidAppear:(BOOL)animated {
    if ([news count] == 0) {
        [_newsTable setHidden:true];
        [_indicatorView setHidden:false];
        [self loadNews];
    } else {
        [_indicatorView setHidden:true];
        [_newsTable setHidden:false];
        [_newsTable reloadData];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Actions
- (IBAction)refreshAction:(id)sender {
     [_indicatorView setHidden:false];
     [self loadNews];
}

#pragma mark Private
- (void)loadNews {
    
    if ([[NetworkManager defaultNetworkManager] networkStatus] == NotReachable) {
        [[NetworkManager defaultNetworkManager] showNoInternetAlertView];
        return;
    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSError *error;
        NSURL *url = [NSURL URLWithString:_currentFeed.feedLink];
        
        NSString *rssString = [NSString stringWithContentsOfURL:url
                                                       encoding:NSUTF8StringEncoding
                                                          error:&error];
        
        if (rssString == nil) {
            NSLog(@"%@", error);
        } else {
            [self parseRss:rssString];
        }
    });
}

- (void)parseRss:(NSString *)rssString {
    [[RSSParser parser] parseRSS:rssString
                     onCompleate:^(NSMutableArray *result) {
                         [self updateNews:result feedID:_currentFeed.feedID];
                     }];
}

/*
 Обновление новостей после загрузки
*/

- (void)updateNews:(NSMutableArray *)lastNews feedID:(NSString *)feedID {
    
    if ([news count] == 0) {
        news = lastNews;
        
        
        for (RSSItem *rssItem in lastNews) {
            rssItem.feedID = feedID;
            [[StorageManager sharedManager] addRssNews:rssItem];
        }
        
    } else {
        NSMutableArray *loadedNews = [NSMutableArray arrayWithArray:lastNews];
        for (RSSItem *rssItem in loadedNews) {
            rssItem.feedID = feedID;
        }
        
        NSMutableArray *allTitles = [[NSMutableArray alloc] init];
        for (RSSItem *rssItem in news) {
            [allTitles addObject:rssItem.title];
        }
        
        NSMutableArray *allIDS = [[NSMutableArray alloc] init];
        for (RSSItem *rssItem in news) {
            [allIDS addObject:rssItem.feedID];
        }
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"title IN %@",  allTitles];
         NSArray *arr = [loadedNews filteredArrayUsingPredicate:predicate];
        [loadedNews removeObjectsInArray:arr];
        
        for (RSSItem *rssItem in loadedNews) {
            [[StorageManager sharedManager] addRssNews:rssItem];
            [news addObject:rssItem];
        }
    }
    
    [self sortNews];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [_newsTable.my_header endRefreshing];
        [_indicatorView setHidden:true];
        
        _newsTable.dataSource = self;
        _newsTable.delegate = self;
        
        [_newsTable setHidden:false];
        [_newsTable reloadData];
    });
   
}


- (void)sortNews {
    [news sortUsingComparator:^NSComparisonResult(RSSItem *obj1,RSSItem *obj2) {
        NSComparisonResult compareResult = [obj1.pubDate compare:obj2.pubDate];
     
        return compareResult;
    }];
}


- (NSString *) stringFromDate:(NSDate*)date{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd MMM yyyy HH:mm:ss"];
    
    return [dateFormatter stringFromDate:date];
}

#pragma mark Pull to Refresh
- (void)loadMoreMethod {
    NSLog(@"Load MORE");
    
    [_newsTable.my_header endRefreshing];
    
    if([[NetworkManager defaultNetworkManager] networkStatus] != NotReachable) {
        [self loadNews];
    } else {
        [[NetworkManager defaultNetworkManager] showNoInternetAlertView];
    }
}


#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [news count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 130;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    RssCell *rssCell = [tableView dequeueReusableCellWithIdentifier:@"RSSCell"];
    RSSItem *rssItem = [news objectAtIndex:indexPath.row];
    rssCell.titleLab.text = rssItem.title;
    rssCell.descriptionLab.text = rssItem.descriptionText;
    rssCell.dateLab.text = [self stringFromDate:rssItem.pubDate];
    rssCell.titleLab.text = rssItem.title;
    
    return rssCell;
}

#pragma mark Segue
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSIndexPath *indexPath = [_newsTable indexPathForCell:sender];
    RSSItem *rssItem = [news objectAtIndex:indexPath.row];
    
    DetailViewController *vc = segue.destinationViewController;
    [vc setDetail:rssItem];
}



/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little
 preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
