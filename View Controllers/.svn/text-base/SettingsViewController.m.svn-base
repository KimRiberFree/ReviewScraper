//
//  SettingsViewController.m
//  Scraper
//
//  Created by David Perry on 20/01/2009.
//  Copyright 2009 Didev Studios. All rights reserved.
//

#import "SettingsViewController.h"
#import "OrientationSettings.h"
#import "CountryManager.h"
#import "OrientationSettingViewController.h"
#import "AppStoreSearchCountryViewController.h"
#import "ShouldRotateView.h"

@implementation SettingsViewController

@synthesize tableView;

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.title = NSLocalizedString(@"Settings", nil);
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
	[tableView release];
	
	[super dealloc];
}

#pragma mark - Table View Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)aTableView
{
    return 2;
}


- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}


- (NSString *)tableView:(UITableView *)aTableView titleForHeaderInSection:(NSInteger)section
{
	if(section == 0)
	{
		return NSLocalizedString(@"AllowedOrientation", nil);
	}
	
	return NSLocalizedString(@"AppStoreSearchCountry", nil);
}


- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{        
    UITableViewCell *cell = [aTableView dequeueReusableCellWithIdentifier:@"SettingsCell"];
	
    if(cell == nil)
	{
        cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:@"SettingsCell"] autorelease];
    }
    
	if(indexPath.section == 0)
	{
		NSInteger allowedOrientation = [[NSUserDefaults standardUserDefaults] integerForKey:@"AllowedOrientation"];
		cell.text = [[[OrientationSettings sharedSettings] allowedOrientations] objectAtIndex:allowedOrientation];
	}
	else if(indexPath.section == 1)
	{
		NSInteger country = [[NSUserDefaults standardUserDefaults] integerForKey:@"iTunesSearchCountry"];
		NSString *countryCode = [[[CountryManager sharedManager] sortedCountryCodesByName] objectAtIndex:country];
		cell.text = [[NSLocale currentLocale] displayNameForKey:NSLocaleCountryCode value:countryCode];
	}
	
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

    return cell;
}


- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[aTableView deselectRowAtIndexPath:indexPath animated:YES];
	
	if(indexPath.section == 0)
	{
		[self.navigationController pushViewController:orientationSettingViewController animated:YES];
	}
	else if(indexPath.section == 1)
	{
		[self.navigationController pushViewController:appStoreSearchCountryViewController animated:YES];
	}
}


@end

