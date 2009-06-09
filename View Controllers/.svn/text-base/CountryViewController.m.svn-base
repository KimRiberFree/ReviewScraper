//
//  CountryViewController.m
//  Scraper
//
//  Created by David Perry on 24/01/2009.
//  Copyright 2009 Didev Studios. All rights reserved.
//

#import "CountryViewController.h"
#import "AppsViewController.h"
#import "ReviewViewController.h"
#import "CountryCell.h"
#import "Country.h"
#import "App.h"
#import "Reachability.h"
#import "ShouldRotateView.h"
#import "CountryManager.h"

@interface CountryViewController (Private)
- (Country *)countryAtSortedIndex:(NSInteger)index;
@end

@implementation CountryViewController

@synthesize appsViewController;
@synthesize downloadView;
@synthesize promptLine;
@synthesize countryLine;
@synthesize activityIndicator;
@synthesize progressBar;
@synthesize app;

- (void)downloadComplete
{
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
	[UIView setAnimationDuration:0.5];
	[self.downloadView setAlpha:0.0f];
	[UIView commitAnimations];
	[self.navigationItem setHidesBackButton:NO animated:YES];
	self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Download", nil) style:UIBarButtonSystemItemSave target:self action:@selector(presentDownloadView)] autorelease];
	[self.tableView reloadData];

}

- (void)animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
{
	[self.downloadView removeFromSuperview];
	self.tableView.userInteractionEnabled = YES;
}
	

- (id)initWithCoder:(NSCoder *)coder
{
	[super initWithCoder:coder];
	
	self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Download", nil) style:UIBarButtonSystemItemSave target:self action:@selector(presentDownloadView)] autorelease];
		
	return self;
}


- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	[self.tableView reloadData];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return shouldRotateViewToOrientation(interfaceOrientation);
}


- (void)didReceiveMemoryWarning
{
    NSLog(@"Got memory warning!");
	[super didReceiveMemoryWarning];
}


- (void)dealloc
{
	[appsViewController release];
	[downloadView release];
	[promptLine release];
	[countryLine release];
	[activityIndicator release];
	[progressBar release];
	[app release];
	
	[super dealloc];
}

#pragma mark - TableView methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{	
	return [self.app.countries count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    CountryCell *cell = (CountryCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	
    if(cell == nil)
	{
        cell = [[[CountryCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];
    }
    
	Country *country = [self countryAtSortedIndex:indexPath.row];
	UIImage *flagImage = [UIImage imageNamed:[[NSString stringWithFormat:@"%@.png", country.name] lowercaseString]];
	
	[cell.flagView setImage: flagImage];
	[cell.countryLabel setText: [country.name uppercaseString]];
	[cell.reviewLabel setText: [NSString stringWithFormat:@"%d", [country.reviews count]]];
	
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	
	switch([country averageRating])
	{
		case 5:
			[cell.ratingView setImage: [UIImage imageNamed:@"5stars.png"]];
			break;
			
		case 4:
			[cell.ratingView setImage: [UIImage imageNamed:@"4stars.png"]];
			break;
			
		case 3:
			[cell.ratingView setImage: [UIImage imageNamed:@"3stars.png"]];
			break;
			
		case 2:
			[cell.ratingView setImage: [UIImage imageNamed:@"2stars.png"]];
			break;
			
		case 1:
			[cell.ratingView setImage: [UIImage imageNamed:@"1star.png"]];
			break;
			
		default:
			break;
	}

    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{	
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	
	Country *country = [self countryAtSortedIndex:indexPath.row];
	reviewViewController.country = country;
	reviewViewController.title = [country.name uppercaseString];
	[self.navigationController pushViewController:reviewViewController animated:YES];
	
}

#pragma mark - Private Methods

- (void)presentDownloadView
{	
	if([[Reachability sharedReachability] checkInternetConnectionAndDisplayAlert:NSLocalizedString(@"NoConnection", nil) errorMsg:NSLocalizedString(@"NeedToBeConnectedDownload", nil)])
	{		
		[self.navigationItem setHidesBackButton:YES animated:YES];
		self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Cancel", nil) style:UIBarButtonSystemItemSave target:self action:@selector(cancelDownload)] autorelease];

		self.tableView.userInteractionEnabled = NO;
		
		[self.tableView setContentOffset:CGPointMake(0, 0) animated:NO];
		self.promptLine.text = NSLocalizedString(@"DownloadingAnyReviewsFrom", nil);
		self.progressBar.progress = 0.0f;
		self.downloadView.frame = self.tableView.frame;
		
		[self.tableView addSubview:self.downloadView];
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.5];
		[self.downloadView setAlpha:0.9f];
		[UIView commitAnimations];
		
		[self.app downloadReviews:self];
	}
}

- (Country *)countryAtSortedIndex:(NSInteger)index
{
	NSArray *countries = [self.app.countries allKeys];
	
	NSArray *sortedCountries = [countries sortedArrayUsingSelector:@selector(compare:)];
		
	return [self.app.countries objectForKey:[sortedCountries objectAtIndex:index]];
}


- (void)updateDownloadMessage:(NSString *)message
{
	self.countryLine.text = message;
}

- (void)updateDownloadProgress:(NSNumber *)increment
{
	self.progressBar.progress += [increment floatValue];
}

- (void)cancelDownload
{
	self.navigationItem.rightBarButtonItem.enabled = NO;
	
	self.promptLine.text = NSLocalizedString(@"Cancelling...", nil);
	self.countryLine.text = @"";
	
	[self.app cancelDownload];
}


@end

