//
//  AppsViewController.m
//  Scraper
//
//  Created by David Perry on 20/01/2009.
//  Copyright 2009 Didev Studios. All rights reserved.
//

#import "AppsViewController.h"
#import "RootViewController.h"
#import "CountryViewController.h"
#import "SearchViewController.h"
#import "App.h"
#import "AppCell.h"
#import "ShouldRotateView.h"
#import "UIImage+Mask.h"
#import "Reachability.h"

@interface AppsViewController (Private)
- (AppCell *)appCellForRow:(UITableView *)tableView row:(NSInteger)row;
@end


@implementation AppsViewController

@synthesize rootViewController;
@synthesize searchViewController;

- (id)initWithCoder:(NSCoder *)coder
{
	[super initWithCoder:coder];
	
	self.navigationItem.rightBarButtonItem = self.editButtonItem;
	self.navigationItem.rightBarButtonItem.title = NSLocalizedString(@"Edit", nil);
			
	return self;
}


- (void)viewWillAppear:(BOOL)animated
{		
	[super viewWillAppear:animated];
	
	if([self.rootViewController.apps count] == 0)
	{
		[super setEditing:YES animated:NO];
		[self.navigationItem setHidesBackButton:YES animated:NO];
	}
	
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
    [rootViewController release];
	[searchViewController release];
	
	[super dealloc];
}

#pragma mark - TableView Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{	
	return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger count = [self.rootViewController.apps count];
	
	if(self.editing)
	{
		count++;
	}
	
	return count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSInteger aRow = indexPath.row;
	
	if(self.editing)
	{
		if(aRow == 0)
		{			
			UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AddNewCell"];
			
			if(cell == nil)
			{
				cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:@"AddNewCell"] autorelease];
			}
			
			cell.text = NSLocalizedString(@"AddNewApp", nil);
			
			return cell;
		}
		else
		{
			AppCell *cell = [self appCellForRow:tableView row:aRow-1];
			
			return cell;
		}
	}
	
	AppCell *cell = [self appCellForRow:tableView row:aRow];
	
	return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
	
	int row = [indexPath row];
	
	if(self.editing)
	{
		if(row == 0)
		{
			if([[Reachability sharedReachability] checkInternetConnectionAndDisplayAlert:NSLocalizedString(@"NoConnection", nil) errorMsg:NSLocalizedString(@"NeedToBeConnectedSearch", nil)])
			{				
				[self.navigationController presentModalViewController:searchViewController animated:YES];
			}
		}
	}
	else
	{
		NSArray *apps = self.rootViewController.apps;
		countryViewController.title = [[apps objectAtIndex:row] name];
		countryViewController.app = [apps objectAtIndex:row];
		[self.navigationController pushViewController:countryViewController animated:YES];
	}
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
	if(![self.tableView isEditing])
	{
		return NO;
	}
	
	return YES;
}


- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{	
	if(indexPath.row == 0)
	{
		return UITableViewCellEditingStyleInsert;
	}
	
    return UITableViewCellEditingStyleDelete;
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(editingStyle == UITableViewCellEditingStyleDelete)
	{
        NSArray *apps = self.rootViewController.apps;
		[self.rootViewController deleteApp:[apps objectAtIndex:indexPath.row-1]];
		[tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationRight];
    }
}


- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
	if(indexPath.row == 0)
	{
		return NO;
	}
	
	return YES;
}


- (NSIndexPath *)tableView:(UITableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath
{	
	int row = proposedDestinationIndexPath.row;
	
	if(row < 1)
	{
		row = 1;
	}
	
	return [NSIndexPath indexPathForRow:row inSection:0];
}		


- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{	
	App *appToMove = [self.rootViewController.apps objectAtIndex:sourceIndexPath.row-1];
	[appToMove retain];
	
	[self.rootViewController.apps removeObjectAtIndex:sourceIndexPath.row-1];
	[self.rootViewController.apps insertObject:appToMove atIndex:destinationIndexPath.row-1];
	
	[appToMove release];
}


- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{	
	[self.tableView setContentOffset:CGPointMake(0, 0) animated:YES];
	
	[self.navigationItem setHidesBackButton:editing animated:animated];
	
	self.navigationItem.rightBarButtonItem.title = NSLocalizedString(@"Done", nil);
	
	NSArray *indexPaths = [NSArray arrayWithObjects:[NSIndexPath indexPathForRow:0 inSection:0], nil];
	
    [self.tableView beginUpdates];
	
    if(editing)
	{
        [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationRight];
    }
	else
	{
        [self.tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationRight];
    }
	
	[super setEditing:editing animated:animated];
	
    [self.tableView endUpdates];
}

#pragma mark - Private Methods

- (AppCell *)appCellForRow:(UITableView *)tableView row:(NSInteger)row
{    
    AppCell *cell = [[[AppCell alloc] initWithFrame:CGRectZero reuseIdentifier:@"AppCell"] autorelease];
		
	NSArray *apps = self.rootViewController.apps;
	
	App *app = [apps objectAtIndex:row];
	
	cell.titleView.text = app.name;
	cell.artistView.text = app.artist;
	cell.image = app.image;
	
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	
	if(app.hasDownloadedReviews)
	{
		cell.reviewView.text = [app reviewText];
	
		switch([app averageRating])
		{
			case 5:
				[cell.ratingView setImage:[UIImage imageNamed:@"5stars_16.png"]];
				break;
				
			case 4:
				[cell.ratingView setImage:[UIImage imageNamed:@"4stars_16.png"]];
				break;
				
			case 3:
				[cell.ratingView setImage:[UIImage imageNamed:@"3stars_16.png"]];
				break;
				
			case 2:
				[cell.ratingView setImage:[UIImage imageNamed:@"2stars_16.png"]];
				break;
				
			case 1:
				[cell.ratingView setImage:[UIImage imageNamed:@"1star_16.png"]];
				break;
				
			case 0:
				[cell.ratingView setImage:[UIImage imageNamed:@"0star_16.png"]];
				break;
				
			default:
				break;
		}
	}
	
	return cell;
}


@end

