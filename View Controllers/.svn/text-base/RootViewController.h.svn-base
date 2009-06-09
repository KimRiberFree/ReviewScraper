//
//  RootViewController.h
//  Scraper
//
//  Created by David Perry on 20/01/2009.
//  Copyright Didev Studios 2009. All rights reserved.
//

#import <UIKit/UIKit.h>

@class App;
@class AppsViewController;

@interface RootViewController : UITableViewController
{
	IBOutlet AppsViewController *appsViewController;
	IBOutlet UITableView *tableView;
	
	NSMutableArray *apps;
}

@property (nonatomic, retain) NSMutableArray *apps;

- (NSString *)docPath;
- (void)saveApps;
- (void)deleteApp:(App *)appToDelete;
- (void)addApp:(App *)appToAdd;

@end
