//
//  AppsViewController.h
//  Scraper
//
//  Created by David Perry on 20/01/2009.
//  Copyright 2009 Didev Studios. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RootViewController;
@class CountryViewController;
@class SearchViewController;

@interface AppsViewController : UITableViewController
{
	IBOutlet SearchViewController *searchViewController;
	IBOutlet RootViewController *rootViewController;
	IBOutlet CountryViewController *countryViewController;
}

@property (nonatomic, retain) IBOutlet RootViewController *rootViewController;
@property (nonatomic, retain) IBOutlet SearchViewController *searchViewController;

@end
