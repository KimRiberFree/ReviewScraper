//
//  ReviewViewController.h
//  Scraper
//
//  Created by David Perry on 25/01/2009.
//  Copyright 2009 Didev Studios. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Country;
@class CountryViewController;

@interface ReviewViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
{
	Country *country;
	IBOutlet CountryViewController *countryViewController;
	IBOutlet UIView *translatingView;
	IBOutlet UILabel *promptLine;
	IBOutlet UIActivityIndicatorView *activityIndicator;
	IBOutlet UIProgressView *progressBar;
	IBOutlet UITableView *tableView;
	IBOutlet UIToolbar *toolbar;
	IBOutlet UIBarButtonItem *prevButton;
	IBOutlet UIBarButtonItem *nextButton;
	BOOL isTranslating;
	BOOL didCancelTranslating;
	unsigned int reviewOffset;
}

@property (nonatomic, retain) Country *country;
@property (nonatomic, retain) IBOutlet CountryViewController *countryViewController;
@property (nonatomic, retain) IBOutlet UIView *translatingView;
@property (nonatomic, retain) IBOutlet UILabel *promptLine;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (nonatomic, retain) IBOutlet UIProgressView *progressBar;
@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic, retain) IBOutlet UIToolbar *toolbar;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *prevButton;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *nextButton;
@property (nonatomic, assign) unsigned int reviewOffset;

- (IBAction)pressedPrevButton:(id)sender;
- (IBAction)pressedNextButton:(id)sender;

@end
