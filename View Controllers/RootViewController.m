//
//  RootViewController.m
//  Scraper
//
//  Created by David Perry on 20/01/2009.
//  Copyright Didev Studios 2009. All rights reserved.
//

#import "RootViewController.h"
#import "ScraperAppDelegate.h"
#import "AppsViewController.h"
#import "SettingsViewController.h"
#import "AboutViewController.h"
#import "App.h"
#import "ShouldRotateView.h"

NSInteger intSort(id obj1, id obj2, void *context)
{
    App *app1 = (App *)obj1;
	App *app2 = (App *)obj2;
	
	int v1 = app1.sortIndex;
    int v2 = app2.sortIndex;
	
    if(v1 < v2)
	{
        return NSOrderedAscending;
	}
    else if (v1 > v2)
	{
        return NSOrderedDescending;
	}
	
	return NSOrderedSame;
}

@implementation RootViewController

@synthesize apps;

- (id)initWithCoder:(NSCoder *)coder
{
	[super initWithCoder:coder];
	
	NSMutableArray *tempArray = [NSMutableArray array];
	
	NSArray *filenames = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:[self docPath] error:NULL];
	
	for(NSString *filename in filenames)
	{
		if(![[filename pathExtension] isEqual:@"dat"])
			continue;
		
		NSString *fullPath = [[self docPath] stringByAppendingPathComponent:filename];
		
		App *loadedApp = [NSKeyedUnarchiver unarchiveObjectWithFile:fullPath];
		
		if(loadedApp != nil)
		{
			[tempArray addObject:loadedApp];
		}
	}
	
	self.apps = [NSMutableArray arrayWithArray:[tempArray sortedArrayUsingFunction:intSort context:nil]];
		
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(saveApps) name:UIApplicationWillTerminateNotification object:nil];
	
	return self;
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
    [apps release];
	apps = nil;
	
	[super dealloc];
}

#pragma mark - TableView Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)aTableView
{
    return 2;
}


- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0)
	{
		return 1;
	}
	else if(section == 1)
	{
		return 2;
	}
	
	return 0;
}


- (NSString *)tableView:(UITableView *)aTableView titleForHeaderInSection:(NSInteger)section
{
	if(section == 0)
	{
		return NSLocalizedString(@"Reviews", nil);
	}
	
	return NSLocalizedString(@"Configuration", nil);
}


- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{    
    static NSString *CellIdentifier = @"RootCell";
    
    UITableViewCell *cell = [aTableView dequeueReusableCellWithIdentifier:CellIdentifier];
	
    if(cell == nil)
	{
        cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];
    }
	
	int row = [indexPath row];
	int section = [indexPath section];
	
	if(section == 0)
	{
		if(row == 0)
		{
			[cell setText:NSLocalizedString(@"Apps", nil)];
			[cell setImage:[UIImage imageNamed:@"View.png"]];
		}
	}
	else if(section == 1)
	{
		if(row == 0)
		{
			[cell setText:NSLocalizedString(@"Settings", nil)];
			[cell setImage:[UIImage imageNamed:@"Settings.png"]];
		}
		else if(row == 1)
		{
			[cell setText:NSLocalizedString(@"About", nil)];
			[cell setImage:[UIImage imageNamed:@"About.png"]];
		}
	}
	
	[cell setAccessoryType: UITableViewCellAccessoryDisclosureIndicator];
	
    return cell;
}


- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{	
	[aTableView deselectRowAtIndexPath:indexPath animated:YES];
	
	int row = [indexPath row];
	int section = [indexPath section];
	
	if(section == 0)
	{
		if(row == 0)
		{
			[self.navigationController pushViewController:appsViewController animated:YES];
		}
	}
	else if(section == 1)
	{
		if(row == 0)
		{
			SettingsViewController *settingsViewController = [[SettingsViewController alloc] initWithNibName:@"Settings" bundle:nil];
			[self.navigationController pushViewController:settingsViewController animated:YES];
			[settingsViewController release];
		}
		else if(row == 1)
		{
			AboutViewController *aboutViewController = [[AboutViewController alloc] initWithNibName:@"About" bundle:nil];
			[self.navigationController pushViewController:aboutViewController animated:YES];
			[aboutViewController release];
		}
	}
}

#pragma mark - Class Methods

- (NSString *)docPath
{
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	
	return documentsDirectory;
}


- (void)saveApps
{	
	int iteration = 0;
	
	for(App *app in self.apps)
	{
		app.sortIndex = iteration;
		NSString *fullPath = [[self docPath] stringByAppendingPathComponent:[app filename]];
		[NSKeyedArchiver archiveRootObject:app toFile:fullPath];
		iteration++;
	}
}


- (void)deleteApp:(App *)appToDelete
{
	NSString *fullPath = [[self docPath] stringByAppendingPathComponent:[appToDelete filename]];
	[[NSFileManager defaultManager] removeItemAtPath:fullPath error:NULL];
	
	[self.apps removeObject:appToDelete];
}

- (void)addApp:(App *)appToAdd
{
	[self.apps addObject:appToAdd];
}


@end

