//
//  SearchViewController.m
//  Scraper
//
//  Created by David Perry on 28/01/2009.
//  Copyright 2009 Didev Studios. All rights reserved.
//

#import "SearchViewController.h"
#import "AppCell.h"
#import "AppsViewController.h"
#import "RootViewController.h"
#import "App.h"
#import "SearchDownloader.h"
#import "RemoteAppCell.h"
#import "RemoteAppMoreCell.h"
#import "ImageCache.h"
#import "ProgressActivityView.h"
#import "RemoteAppDidYouMeanCell.h"
#import "ShouldRotateView.h"
#import "UIImage+Mask.h"

@interface SearchViewController (Private)
- (void)loadContentForCells:(NSArray *)cells;
@end


@implementation SearchViewController

@synthesize appsViewController;
@synthesize searchBar;
@synthesize tableView;
@synthesize searchHints;
@synthesize resultsView;
@synthesize searchResults;
@synthesize cellToDelete;


- (id)initWithCoder:(NSCoder *)coder
{
	[super initWithCoder:coder];
	
	cancelButton.title = NSLocalizedString(@"Cancel", nil);
	
	self.searchHints = [NSMutableArray array];
	self.searchResults = [NSMutableArray array];
	searchDownloader = [[SearchDownloader alloc] init];
	
	return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	
	self.searchBar.placeholder = NSLocalizedString(@"Search", nil);
}


- (void)viewWillAppear:(BOOL)animated
{
    [self.searchBar becomeFirstResponder];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:self.view.window];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}


- (void)viewDidDisappear:(BOOL)animated
{	
	[super viewDidDisappear:animated];
	
	[[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
	
	[self.searchResults removeAllObjects];
	[self.searchHints removeAllObjects];
	self.searchBar.text = @"";
	[self.tableView reloadData];
	
	[self.resultsView removeFromSuperview];
	
	[[ImageCache sharedCache] flushCache];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return shouldRotateViewToOrientation(interfaceOrientation);
}


- (void)didReceiveMemoryWarning
{
    NSLog(@"Got memory warning!");
	[[ImageCache sharedCache] flushCache];
	
	[super didReceiveMemoryWarning];
}


- (void)dealloc
{
    [searchHints release];
	searchHints = nil;
	
	[searchResults release];
	searchResults = nil;
	
	[searchDownloader release];
	searchDownloader = nil;
	
	[appsViewController release];
	[searchBar release];
	[tableView release];
	[resultsView release];
	[cellToDelete release];
		
	[super dealloc];
}

#pragma mark - TableView Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)aTableView
{
	return 1;
}


- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)section
{
    int count = 0;
	
	if(aTableView == self.tableView)
	{
		count = [self.searchHints count];
	}
	else
	{
		count = [self.searchResults count];
	}
	
	if(count == 0)
	{
		if(self.searchBar.text.length > 0)
		{
			count = 1;
		}
	}
	
	return count;
}


- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{	
	if(aTableView == self.tableView)
	{		
		UITableViewCell *cell = [aTableView dequeueReusableCellWithIdentifier:@"HintCell"];
		
		if(cell == nil)
		{
			cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:@"HintCell"] autorelease];
		}
	
		if([self.searchHints count] > 0)
		{
			NSDictionary *aHint = [self.searchHints objectAtIndex:indexPath.row];
	
			cell.text = [aHint objectForKey:@"term"];
			cell.userInteractionEnabled = YES;
		}
		else
		{
			cell.text = @"No results found";
			cell.userInteractionEnabled = NO;
		}

		return cell;
	}
	
	if([self.searchResults count] == 0)
	{
		UITableViewCell *cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero] autorelease];
		
		cell.textAlignment = UITextAlignmentCenter;
		cell.text = @"No results found";
		cell.font = [UIFont italicSystemFontOfSize:18];
		cell.userInteractionEnabled = NO;
		
		return cell;
	}
	
	NSDictionary *aResult = [self.searchResults objectAtIndex:indexPath.row];
	
	NSString *type = [aResult objectForKey:@"type"];
	
	if([type isEqualToString:@"link"])
	{	
		NSString *linkType = [aResult objectForKey:@"link-type"];
		
		if([linkType isEqualToString:@"software"])
		{
			RemoteAppCell *cell = [[[RemoteAppCell alloc] initWithFrame:CGRectZero] autorelease];
		
			NSArray *artworkURLS = [aResult objectForKey:@"artwork-urls"];
			NSDictionary *dict = [artworkURLS objectAtIndex:0];
			
			NSNumber *needsShine = [dict objectForKey:@"needs-shine"];
			cell.needsShine = [needsShine boolValue];
		
			[cell setURL:[dict objectForKey:@"url"]];
		
			cell.artistView.text = [aResult objectForKey:@"artist-name"];
			cell.titleView.text = [aResult objectForKey:@"title"];
		
			NSNumber *ratingCount = [aResult objectForKey:@"user-rating-count"];
			cell.reviewView.text = [NSString stringWithFormat:@"%d reviews", [ratingCount intValue]];
		
			NSNumber *rating = [aResult objectForKey:@"average-user-rating"];
		
			NSInteger trueRating = (NSInteger)(5 * [rating floatValue]);
		
			switch(trueRating)
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
		
			return cell;
		}
		else
		{
			RemoteAppDidYouMeanCell *cell = [[[RemoteAppDidYouMeanCell alloc] initWithFrame:CGRectZero] autorelease];
			
			cell.textLabel.text = [aResult objectForKey:@"title"];
			
			return cell;
		}
	}
	else if([type isEqualToString:@"more"])
	{		
		RemoteAppMoreCell *cell = [[[RemoteAppMoreCell alloc] initWithFrame:CGRectZero] autorelease];
		
		cell.textLabel.text = [aResult objectForKey:@"title"];
		
		return cell;
	}
	else if([type isEqualToString:@"separator"])
	{
		UITableViewCell *cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero] autorelease];
		
		cell.textAlignment = UITextAlignmentCenter;
		cell.text = [aResult objectForKey:@"title"];
		cell.font = [UIFont italicSystemFontOfSize:18];
		
		return cell;
	}
	else
	{
		NSLog([aResult description]);
	}
	
	return nil;
}


- (CGFloat)tableView:(UITableView *)aTableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	if(aTableView == self.tableView)
	{
		return 30.0f;
	}
	
	return 70.0f;
}


- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{	
	[aTableView deselectRowAtIndexPath:indexPath animated:YES];
	
	if(aTableView == self.tableView)
	{
		if([self.searchHints count] == 0)
		{
			return;
		}
		
		[self.searchBar resignFirstResponder];
		
		NSDictionary *aHint = [self.searchHints objectAtIndex:indexPath.row];
		
		NSString *urlString = [aHint objectForKey:@"url"];
		
		progressActivityView = [[ProgressActivityView alloc] initWithFrame:self.tableView.frame];
		
		[self.view addSubview:progressActivityView];
		
		[self.searchResults removeAllObjects];
		[searchDownloader requestWithUrl:urlString delegate:self type:kSearchResults];
		
		return;
	}
	
	if([self.searchResults count] == 0)
	{
		return;
	}
	
	NSDictionary *aResult = [self.searchResults objectAtIndex:indexPath.row];
	
	NSString *type = [aResult objectForKey:@"type"];
		
	if([type isEqualToString:@"link"])
	{
		NSString *linkType = [aResult objectForKey:@"link-type"];
		
		if([linkType isEqualToString:@"software"])
		{
			[searchDownloader cancel];
		
			NSInteger appID = [[aResult objectForKey:@"item-id"] integerValue];
		
			NSArray *artworkURLS = [aResult objectForKey:@"artwork-urls"];
			NSDictionary *dict = [artworkURLS objectAtIndex:0];
			
			NSNumber *needsShine = [dict objectForKey:@"needs-shine"];
				
			App *newApp = [[App alloc] initWithName:[aResult objectForKey:@"title"] appCode:[NSString stringWithFormat: @"%d", appID] appArtist:[aResult objectForKey:@"artist-name"]];
			UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[dict objectForKey:@"url"]]]];
			newApp.image = [image imageWithRoundedCorners:[needsShine boolValue]];
			newApp.sortIndex = [self.appsViewController.rootViewController.apps count];
			[self.appsViewController.rootViewController addApp:newApp];
			[newApp release];
				
			[self.appsViewController.tableView reloadData];
	
			[self.navigationController dismissModalViewControllerAnimated:YES];
		}
		else
		{
			[searchDownloader cancel];
			
			[searchDownloader requestWithUrl:[aResult objectForKey:@"url"] delegate:self type:kSearchResults];
			[self.searchResults removeAllObjects];
			
			RemoteAppMoreCell *cell = (RemoteAppMoreCell *)[self.resultsView cellForRowAtIndexPath:indexPath];
			[cell.contentView addSubview:cell.activityIndicator];
		}
	}
	else if([type isEqualToString:@"more"])
	{
		[searchDownloader cancel];
		
		[searchDownloader requestWithUrl:[aResult objectForKey:@"url"] delegate:self type:kSearchResults];
		self.cellToDelete = indexPath;
		
		RemoteAppMoreCell *cell = (RemoteAppMoreCell *)[self.resultsView cellForRowAtIndexPath:indexPath];
		[cell.contentView addSubview:cell.activityIndicator];
	}
}

#pragma mark - SearchBar Methods

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{	
	NSString *urlString = [NSString stringWithFormat:@"http://ax.search.itunes.apple.com/WebObjects/MZSearchHints.woa/wa/hints?media=software&q=%@", [searchText stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
	
	[searchDownloader requestWithUrl:urlString delegate:self type:kSearchHints];
}


- (void)keyboardDidShow:(NSNotification *)notification
{
	if(self.resultsView)
	{
		[self.resultsView removeFromSuperview]; 
		self.resultsView = nil;
				
		[self.tableView reloadData];
	}
	
	UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
	
	float viewHeight = 320.0f;
	
	if(UIInterfaceOrientationIsPortrait(orientation))
	{
		viewHeight = 480.0f;
	}
	
	NSDictionary* info = [notification userInfo];
	
    NSValue* value = [info objectForKey:UIKeyboardBoundsUserInfoKey];
    CGSize keyboardSize = [value CGRectValue].size;
	
    CGRect viewFrame = self.tableView.frame;
    viewFrame.size.height = viewHeight - 20.0f - 44.0f - keyboardSize.height;
	self.tableView.frame = viewFrame;
}


- (void)keyboardWillHide:(NSNotification *)notification
{
	UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
	
	float viewHeight = 320.0f;
	
	if(UIInterfaceOrientationIsPortrait(orientation))
	{
		viewHeight = 480.0f;
	}
	
	CGPoint offset = self.tableView.contentOffset;
		
    CGRect viewFrame = self.tableView.frame;
    viewFrame.size.height = viewHeight - 20.0f - 44.0f;
	self.tableView.frame = viewFrame;
	
	[self.tableView setContentOffset:offset animated:NO];
}


- (IBAction)clickedCancel:(id)sender
{	
	if(progressActivityView)
	{
		[progressActivityView removeFromSuperview];
	}
	
	[searchDownloader cancel];
	
	[self.searchBar resignFirstResponder];
	
	[self.navigationController dismissModalViewControllerAnimated:YES];
}


- (void)searchBarSearchButtonClicked:(UISearchBar *)theSearchBar
{
	[self.searchBar resignFirstResponder];
	
	[self.searchResults removeAllObjects];
	
	progressActivityView = [[ProgressActivityView alloc] initWithFrame:self.tableView.frame];
	
	[self.view addSubview:progressActivityView];
		
	[searchDownloader requestWithUrl:[NSString stringWithFormat:@"http://ax.search.itunes.apple.com/WebObjects/MZSearch.woa/wa/search?submit=edit&term=%@&media=software", [theSearchBar.text stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding]] delegate:self type:kSearchResults];
}

#pragma mark - ScrollView Methods

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
	[self loadContentForCells:[self.resultsView visibleCells]];
}


- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if(!decelerate)
	{
		[self loadContentForCells:[self.resultsView visibleCells]];
    }
}

#pragma mark - Private Methods

- (void)addResultsView
{
	if(!self.resultsView)
	{
		CGRect frame = self.tableView.frame;
		CGRect newFrame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, 416);
		self.resultsView = [[[UITableView alloc] initWithFrame:newFrame] autorelease];
		self.resultsView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		self.resultsView.userInteractionEnabled = YES;
		self.resultsView.delegate = self;
		self.resultsView.dataSource = self;
	
		[self.view insertSubview:self.resultsView belowSubview:progressActivityView];
		[self.resultsView reloadData];
	}
	
	[self loadContentForCells:[self.resultsView visibleCells]];
	
	[progressActivityView fadeOut];
}


- (void)didFinishDownloadSearchHints:(NSData *)data
{	
	if([data length] > 0)
	{
		NSString *dataString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
		NSDictionary *dict = [dataString propertyList];
		[dataString release];
		
		[self.searchHints removeAllObjects];
		self.searchHints = [dict objectForKey:@"hints"];
		
		[self.tableView reloadData];
	}
}


- (void)didFinishDownloadSearchResults:(NSData *)data
{	
	if([data length] > 0)
	{
		NSString *dataString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];

		NSDictionary *dict = [dataString propertyList];
		[dataString release];
				
		[self.searchResults addObjectsFromArray:[dict objectForKey:@"items"]];
		
		if(self.cellToDelete)
		{
			[self.searchResults removeObjectAtIndex:self.cellToDelete.row];
			
			NSArray *paths = [NSArray arrayWithObject:self.cellToDelete];
			[self.resultsView deleteRowsAtIndexPaths:paths withRowAnimation:UITableViewRowAnimationRight];
			self.cellToDelete = nil;
		}
		else
		{
			[self.resultsView reloadData];
		}
		
		[self addResultsView];		
	}
}


- (void)loadContentForCells:(NSArray *)cells
{
    [cells retain];
	
    for(int i = 0;i < [cells count];i++)
	{
        RemoteAppCell *cell = [[cells objectAtIndex:i] retain];
		
        if([cell respondsToSelector:@selector(fetchImage)])
		{
            [cell fetchImage];
		}
		
        [cell release];
        cell = nil;
    }
	
    [cells release];
}

#pragma mark - ProgressActivityView Delegate Methods

- (void)fadeOutDidFinish
{
	[progressActivityView removeFromSuperview];
}


@end
