//
//  ReviewViewController.m
//  Scraper
//
//  Created by David Perry on 25/01/2009.
//  Copyright 2009 Didev Studios. All rights reserved.
//

#import "ReviewViewController.h"
#import "Country.h"
#import "Review.h"
#import "ReviewCell.h"
#import "LKGoogleTranslator.h"
#import "CountryManager.h"
#import "Reachability.h"
#import "ShouldRotateView.h"

#define REVIEWS_PER_PAGE (100)

@interface ReviewViewController (Private)
- (void)showTranslatedReviews;
- (void)showOriginalReviews;
- (void)updateProgressBar:(NSArray *)array;
@end


@implementation ReviewViewController

@synthesize country;
@synthesize countryViewController;
@synthesize translatingView;
@synthesize promptLine;
@synthesize activityIndicator;
@synthesize progressBar;
@synthesize tableView;
@synthesize toolbar;
@synthesize prevButton;
@synthesize nextButton;
@synthesize reviewOffset;

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	self.nextButton.title = [NSString stringWithFormat:NSLocalizedString(@"NextReviews", nil), REVIEWS_PER_PAGE];
	self.prevButton.title = [NSString stringWithFormat:NSLocalizedString(@"PrevReviews", nil), REVIEWS_PER_PAGE];
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
		 
	if(self.country.translated)
	{
		if(self.country.showTranslated)
		{
			[self showTranslatedReviews];
		}
		else
		{
			[self showOriginalReviews];
		}
	}
	else if([[CountryManager sharedManager] googleCodeForKey:[self.country name]])
	{
		self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Translate", nil) style:UIBarButtonSystemItemSave target:self action:@selector(presentTranslatingView)] autorelease];
		[self.tableView reloadData];
	}
	else
	{
		self.navigationItem.rightBarButtonItem = nil;
		[self.tableView reloadData];
	}
	
	[self.tableView setContentOffset:CGPointMake(0, 0) animated:NO];
	
	isTranslating = NO;
	
	self.reviewOffset = 0;
	
	[self.toolbar removeFromSuperview];
	
	if([self.country.reviews count] > REVIEWS_PER_PAGE)
	{
		[self.view addSubview:self.toolbar];
		self.tableView.frame = CGRectMake(self.tableView.frame.origin.x, self.tableView.frame.origin.y, self.tableView.frame.size.width, self.tableView.frame.size.height - self.toolbar.frame.size.height);
		
		self.prevButton.enabled = NO;
		self.nextButton.enabled = YES;
	}
}


- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
	
	[self.tableView setContentOffset:CGPointMake(0, 0) animated:NO];
	
	isTranslating = NO;
	
	self.reviewOffset = 0;
	
	if([self.country.reviews count] > REVIEWS_PER_PAGE)
	{
		self.tableView.frame = CGRectMake(self.tableView.frame.origin.x, self.tableView.frame.origin.y, self.tableView.frame.size.width, self.tableView.frame.size.height + self.toolbar.frame.size.height);
	}
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return shouldRotateViewToOrientation(interfaceOrientation);
}


- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
	[self.tableView reloadData];
}


- (void)didReceiveMemoryWarning
{
    NSLog(@"Got memory warning!");
	[super didReceiveMemoryWarning];
}


- (void)dealloc
{
    [translatingView release];
	translatingView = nil;
	self.navigationItem.rightBarButtonItem = nil;
	
	[country release];
	[countryViewController release];
	[promptLine release];
	[activityIndicator release];
	[progressBar release];
	[tableView release];
	[prevButton release];
	[nextButton release];
	[toolbar release];
	
	[super dealloc];
}

- (IBAction)pressedPrevButton:(id)sender
{
	reviewOffset -= REVIEWS_PER_PAGE;
	
	if(reviewOffset == 0)
	{
		self.prevButton.enabled = NO;
	}
	
	self.nextButton.enabled = YES;
	
	[self.tableView setContentOffset:CGPointMake(0, 0) animated:NO];
	
	[self.tableView reloadData];
}


- (IBAction)pressedNextButton:(id)sender
{
	reviewOffset += REVIEWS_PER_PAGE;
	
	if((reviewOffset + REVIEWS_PER_PAGE) > [self.country.reviews count])
	{
		self.nextButton.enabled = NO;
	}
	
	self.prevButton.enabled = YES;
	
	[self.tableView setContentOffset:CGPointMake(0, 0) animated:NO];
	
	[self.tableView reloadData];
}

#pragma mark - TableView methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int count = [self.country.reviews count];
	int nextCount = count - self.reviewOffset - REVIEWS_PER_PAGE;
	
	if((count - self.reviewOffset) < REVIEWS_PER_PAGE)
	{
		count -= self.reviewOffset;
	}
	
	if(count > REVIEWS_PER_PAGE)
	{
		count = REVIEWS_PER_PAGE;
	}
	
	if(nextCount > REVIEWS_PER_PAGE)
	{
		nextCount = REVIEWS_PER_PAGE;
	}
	else if(nextCount < 0)
	{
		nextCount = 0;
	}
	
	self.nextButton.title = [NSString stringWithFormat:@"Next %d", nextCount];
	
	return count;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{	
	Review *review = [self.country.reviews objectAtIndex:indexPath.row + self.reviewOffset];
	
	UIFont *font = [UIFont systemFontOfSize:12];
	CGRect contentRect = self.tableView.bounds;
	CGSize constraint = CGSizeMake(contentRect.size.width - 20, 500);
		
	NSString *text;
	
	float height = 16.0f;
	
	if(self.country.translated && self.country.showTranslated)
	{
		text = review.translatedText;
	}
	else
	{
		text = review.text;
	}

	CGSize size = [text sizeWithFont:font constrainedToSize:constraint];
	
	height += size.height;
	
	text = review.author;
	font = [UIFont boldSystemFontOfSize:12];
	size = [text sizeWithFont:font constrainedToSize:constraint];
	
	height += size.height;
	
	text = review.title;
	font = [UIFont boldSystemFontOfSize:14];
	size = [text sizeWithFont:font constrainedToSize:constraint];
	
	height += size.height;
	
	return height + 32.0f;
}


- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{	
	Review *review = [self.country.reviews objectAtIndex:indexPath.row + reviewOffset];
	
	ReviewCell *cell = (ReviewCell *)[aTableView dequeueReusableCellWithIdentifier:@"ReviewCell"];
		
	if(cell == nil)
	{
		cell = [[[ReviewCell alloc] initWithFrame:CGRectZero reuseIdentifier:@"ReviewCell"] autorelease];
	}

	if(self.country.translated && self.country.showTranslated)
	{
		cell.reviewText.text = review.translatedText;
		cell.reviewTitle.text = review.translatedTitle;
	}
	else
	{
		cell.reviewText.text = review.text;
		cell.reviewTitle.text = review.title;
	}
	
	cell.reviewAuthor.text = review.author;
	cell.reviewVersion.text = review.versionnum;
		
	switch([review.rating integerValue])
	{
		case 5:
			[cell.ratingImage setImage: [UIImage imageNamed:@"5stars_16.png"]];
			break;
			
		case 4:
			[cell.ratingImage setImage: [UIImage imageNamed:@"4stars_16.png"]];
			break;
			
		case 3:
			[cell.ratingImage setImage: [UIImage imageNamed:@"3stars_16.png"]];
			break;
			
		case 2:
			[cell.ratingImage setImage: [UIImage imageNamed:@"2stars_16.png"]];
			break;
			
		case 1:
			[cell.ratingImage setImage: [UIImage imageNamed:@"1star_16.png"]];
			break;
			
		default:
			break;
	}
		
	return cell;
}

#pragma mark - Private Methods

- (void)translateReviews
{		
	isTranslating = YES;
	didCancelTranslating = NO;
	
	[NSThread detachNewThreadSelector:@selector(threadedTranslateReviews) toTarget:self withObject:nil];
}


- (void)threadedTranslateReviews
{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	NSArray *languages = [userDefaults objectForKey:@"AppleLanguages"];
	NSString *currentLanguage = [languages objectAtIndex:0];
	
	LKGoogleTranslator* translator = [[[LKGoogleTranslator alloc] init] autorelease];
	
	NSString *origLanguage = [[CountryManager sharedManager] googleCodeForKey:[self.country name]]; 
		
	NSLog(@"Current language: %@", currentLanguage);
	NSLog(@"Original language: %@", origLanguage);
	
	[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
		
	for(Review *review in self.country.reviews)
	{
		if(!isTranslating)
		{
			break;
		}
		
		NSAutoreleasePool *loopPool = [[NSAutoreleasePool alloc] init];
				
		NSString* translation = [translator translateText:[NSString stringWithFormat:@"%@|%@", review.title, review.text] fromLanguage:origLanguage toLanguage:currentLanguage];
		
		if([translation length] == 0)
		{
			review.translatedText = review.text;
			review.translatedTitle = review.title;
			[self performSelectorOnMainThread:@selector(updateProgressBar:) withObject:self.country.reviews waitUntilDone:YES];
			
			[loopPool release];
			continue;
		}
		
		translation = [translation stringByReplacingOccurrencesOfString:@"&quot;" withString:@"\""];
		
		int index = [translation rangeOfString:@"|"].location;
		
		review.translatedTitle = [translation substringToIndex:index];
		review.translatedText = [translation substringFromIndex:index + 1];
		
		if([review.translatedText hasPrefix:@" "])
		{
			review.translatedText = [review.translatedText substringFromIndex:1];
		}
		
		[self performSelectorOnMainThread:@selector(updateProgressBar:) withObject:self.country.reviews waitUntilDone:YES];
		
		[loopPool release];
	}
	
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	
	if(!didCancelTranslating)
	{
		self.country.translated = YES;
		[self performSelectorOnMainThread:@selector(showTranslatedReviews) withObject:nil waitUntilDone:YES];
	}
	else
	{
		if([[CountryManager sharedManager] googleCodeForKey:[self.country name]])
		{
			self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Translate", nil) style:UIBarButtonSystemItemSave target:self action:@selector(presentTranslatingView)] autorelease];
		}
	}
	
	[self performSelectorOnMainThread:@selector(dismissTranslatingView) withObject:nil waitUntilDone:YES];
	
	isTranslating = NO;
	
	[pool release];
}

- (void)animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
{	
	self.tableView.userInteractionEnabled = YES;
	[translatingView removeFromSuperview];
}

- (void)dismissTranslatingView
{
	[self.navigationItem setHidesBackButton:NO animated:YES];
	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
	[UIView setAnimationDuration:0.5];
	[self.translatingView setAlpha:0.0f];
	[UIView commitAnimations];
}


- (void)presentTranslatingView
{
	if([[Reachability sharedReachability] checkInternetConnectionAndDisplayAlert:NSLocalizedString(@"NoConnection", nil) errorMsg:NSLocalizedString(@"NeedToBeConnectedTranslate", nil)])
	{
		[self.navigationItem setHidesBackButton:YES animated:YES];
		self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Cancel", nil) style:UIBarButtonSystemItemSave target:self action:@selector(cancelTranslatingReviews)] autorelease];
		
		[self.tableView setContentOffset:CGPointMake(0, 0) animated:NO];
		self.translatingView.frame = self.tableView.frame;
		[self.tableView addSubview:self.translatingView];
		self.tableView.userInteractionEnabled = NO;
		self.progressBar.progress = 0.0f;
		
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.5];
		[self.translatingView setAlpha:0.9f];
		[UIView commitAnimations];
		[self translateReviews];
	}
}


- (void)updateProgressBar:(NSArray *)array
{	
	progressBar.progress += 1.0f/[array count];
}


- (void)cancelTranslatingReviews
{
	isTranslating = NO;
	didCancelTranslating = YES;
}


- (void)showOriginalReviews
{
	self.country.showTranslated = NO;
	self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"ShowTranslated", nil) style:UIBarButtonSystemItemSave target:self action:@selector(showTranslatedReviews)] autorelease];
	[self.tableView reloadData];
}


- (void)showTranslatedReviews
{
	self.country.showTranslated = YES;
	self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"ShowOriginal", nil) style:UIBarButtonSystemItemSave target:self action:@selector(showOriginalReviews)] autorelease];
	[self.tableView reloadData];
}

@end

