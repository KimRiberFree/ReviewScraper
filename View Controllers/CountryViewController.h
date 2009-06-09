//
//  CountryViewController.h
//  Scraper
//
//  Created by David Perry on 24/01/2009.
//  Copyright 2009 Didev Studios. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AppsViewController;
@class ReviewViewController;
@class App;

@interface CountryViewController : UITableViewController
{
	IBOutlet AppsViewController *appsViewController;
	IBOutlet ReviewViewController *reviewViewController;
	
	IBOutlet UIView *downloadView;
	IBOutlet UILabel *promptLine;
	IBOutlet UILabel *countryLine;
	IBOutlet UIActivityIndicatorView *activityIndicator;
	IBOutlet UIProgressView *progressBar;
	
	App *app;
}

@property (nonatomic, retain) IBOutlet AppsViewController *appsViewController;
@property (nonatomic, retain) IBOutlet UIView *downloadView;
@property (nonatomic, retain) IBOutlet UILabel *promptLine;
@property (nonatomic, retain) IBOutlet UILabel *countryLine;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (nonatomic, retain) IBOutlet UIProgressView *progressBar;
@property (nonatomic, retain) App *app;

- (void)updateDownloadMessage:(NSString *)message;
- (void)updateDownloadProgress:(NSNumber *)increment;
- (void)downloadComplete;

@end
