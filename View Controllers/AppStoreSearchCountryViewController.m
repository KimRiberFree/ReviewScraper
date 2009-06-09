//
//  AppStoreSearchCountryViewController.m
//  Scraper
//
//  Created by David Perry on 20/02/2009.
//  Copyright 2009 Didev Studios. All rights reserved.
//

#import "AppStoreSearchCountryViewController.h"
#import "CountryManager.h"
#import "ShouldRotateView.h"


@implementation AppStoreSearchCountryViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	self.title = NSLocalizedString(@"SearchCountry", nil);
}


- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
	
	[[NSUserDefaults standardUserDefaults] setInteger:selectedRow forKey:@"iTunesSearchCountry"];
	[[NSUserDefaults standardUserDefaults] synchronize];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
	
	selectedRow = [[NSUserDefaults standardUserDefaults] integerForKey:@"iTunesSearchCountry"];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return shouldRotateViewToOrientation(interfaceOrientation);
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


- (void)dealloc
{	
	[super dealloc];
}

#pragma mark Table View methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[CountryManager sharedManager] sortedCountryCodesByName] count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AppStoreSearchCountryCell"];
	
    if(cell == nil)
	{
        cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:@"AppStoreSearchCountryCell"] autorelease];
    }
    
	NSString *countryCode = [[[CountryManager sharedManager] sortedCountryCodesByName] objectAtIndex:indexPath.row];
	cell.text = [[NSLocale currentLocale] displayNameForKey:NSLocaleCountryCode value:countryCode];
		
	if(indexPath.row == selectedRow)
	{
		cell.accessoryType = UITableViewCellAccessoryCheckmark;
		cell.textColor = [UIColor colorWithRed:0.196f green:0.309f blue:0.521f alpha:1.0f];
	}
	else
	{
		cell.accessoryType = UITableViewCellAccessoryNone;
		cell.textColor = [UIColor blackColor];
	}
	
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{	
	[[tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:selectedRow inSection:0]] setAccessoryType:UITableViewCellAccessoryNone];
	[[tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:selectedRow inSection:0]] setTextColor:[UIColor blackColor]];
	[[tableView cellForRowAtIndexPath:indexPath] setAccessoryType:UITableViewCellAccessoryCheckmark];
	[[tableView cellForRowAtIndexPath:indexPath] setTextColor:[UIColor colorWithRed:0.196f green:0.309f blue:0.521f alpha:1.0f]];
	
	selectedRow = indexPath.row;
	
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}


@end

