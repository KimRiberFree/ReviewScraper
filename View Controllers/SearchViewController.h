//
//  SearchViewController.h
//  Scraper
//
//  Created by David Perry on 28/01/2009.
//  Copyright 2009 Didev Studios. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AppsViewController;
@class SearchDownloader;
@class ProgressActivityView;

@interface SearchViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
{
	IBOutlet AppsViewController *appsViewController;
	IBOutlet UISearchBar *searchBar;
	IBOutlet UITableView *tableView;
	IBOutlet UIBarButtonItem *cancelButton;
	UITableView *resultsView;
	NSMutableArray *searchHints;
	NSMutableArray *searchResults;
	SearchDownloader *searchDownloader;
	ProgressActivityView *progressActivityView;
	NSIndexPath *cellToDelete;
}

@property (nonatomic, retain) IBOutlet AppsViewController *appsViewController;
@property (nonatomic, retain) IBOutlet UISearchBar *searchBar;
@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic, retain) UITableView *resultsView;
@property (nonatomic, retain) NSMutableArray *searchHints;
@property (nonatomic, retain) NSMutableArray *searchResults;
@property (nonatomic, retain) NSIndexPath *cellToDelete;

- (IBAction)clickedCancel:(id)sender;

@end
