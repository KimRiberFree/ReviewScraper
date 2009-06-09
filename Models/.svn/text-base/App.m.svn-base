//
//  App.m
//  Scraper
//
//  Created by David Perry on 20/01/2009.
//  Copyright 2009 Didev Studios. All rights reserved.
//

#import "App.h"
#import "Country.h"
#import "Review.h"
#import "DownloadReviews.h"
#import "CountryManager.h"
#import "CountryViewController.h"

@interface App (Private)
- (Country *)countryNamed:(NSString *)countryName;
@end

@implementation App

@synthesize countries;
@synthesize name;
@synthesize code;
@synthesize artist;
@synthesize image;
@synthesize isDownloading;
@synthesize hasDownloadedReviews;
@synthesize sortIndex;

- (id)initWithName:(NSString *)appName appCode:(NSString *)appCode appArtist:(NSString *)appArtist
{
	self = [super init];
		
	self.countries = [NSMutableDictionary dictionary];
	self.name = appName;
	self.code = appCode;
	self.artist = appArtist;
	self.image = nil;
	self.isDownloading = NO;
	self.hasDownloadedReviews = NO;
	self.sortIndex = 0;
	
	return self;
}


- (id)initWithCoder:(NSCoder *)coder
{
	self = [super init];
	
	self.countries = [coder decodeObjectForKey:@"countries"];
	self.name = [coder decodeObjectForKey:@"name"];
	self.code = [coder decodeObjectForKey:@"code"];
	self.artist = [coder decodeObjectForKey:@"artist"];
	self.image = [UIImage imageWithData:[coder decodeObjectForKey:@"image"]];
	self.isDownloading = NO;
	self.hasDownloadedReviews = [coder decodeBoolForKey:@"downloadedreviews"];
	self.sortIndex = [coder decodeIntForKey:@"sortindex"];
	
	return self;
}


- (void)encodeWithCoder:(NSCoder *)coder
{
	[coder encodeObject:self.countries forKey:@"countries"];
	[coder encodeObject:self.name forKey:@"name"];
	[coder encodeObject:self.code forKey:@"code"];
	[coder encodeObject:self.artist forKey:@"artist"];
	[coder encodeObject:UIImagePNGRepresentation(self.image) forKey:@"image"];
	[coder encodeBool:self.hasDownloadedReviews forKey:@"downloadedreviews"];
	[coder encodeInt:self.sortIndex forKey:@"sortindex"];
}


- (void)dealloc
{
	[name release];
	[code release];
	[countries release];
	[artist release];
	[image release];
	
	[super dealloc];
}

#pragma mark - Class Methods

- (Country *)countryNamed:(NSString *)countryName
{
	Country *country = [self.countries objectForKey:countryName];
	
	if(!country)
	{
		country = [[[Country alloc] initWithName:countryName] autorelease];
		[self.countries setObject:country forKey:countryName];
	}
	
	return country;
}


- (NSString *)filename
{	
	return [NSString stringWithFormat:@"%@.dat", self.name];
}


- (void)updateCountryText:(NSString *)message
{
	NSLocale *locale = [NSLocale currentLocale];
	[downloadDelegate updateDownloadMessage:[locale displayNameForKey:NSLocaleCountryCode value:message]];
}


- (void)updateProgressBar:(NSArray *)array
{	
	NSNumber *increment = [NSNumber numberWithFloat:1.0f/[array count]];
	
	[downloadDelegate updateDownloadProgress:increment];
}

- (void)cancelDownload
{
	self.isDownloading = NO;
	[self.countries removeAllObjects];
}

-(void)threadedDownloadReviews
{	
	[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
	
	self.isDownloading = YES;
	
	NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
		
	NSArray *countryArray = [[CountryManager sharedManager] sortedCountryCodesByName];
	
	for(int i = 0;i < [countryArray count]; i++)
	{				
		if(!self.isDownloading)
			break;
		
		[self performSelectorOnMainThread:@selector(updateCountryText:) withObject:[[countryArray objectAtIndex:i] uppercaseString] waitUntilDone:YES];
		
		[self performSelectorOnMainThread:@selector(updateProgressBar:) withObject:countryArray waitUntilDone:YES];
		
		NSInteger currentPage = 0;
		
		NSMutableArray *tempReviewArray = [NSMutableArray array];
		
		while(self.isDownloading)
		{			
			NSAutoreleasePool *loopPool = [[NSAutoreleasePool alloc] init];
			
			NSArray *reviewArray = [DownloadReviews downloadWithCountry:[[CountryManager sharedManager] iTunesCodeForKey:[countryArray objectAtIndex:i]] countryName:[countryArray objectAtIndex:i] appCode:self.code pageNumber:currentPage];
			
			if([reviewArray count] == 0 && [tempReviewArray count] == 0)
			{
				[loopPool release];
				break;
			}
			
			if([reviewArray count] > 0)
			{								
				[tempReviewArray addObjectsFromArray:reviewArray];
			}
			
			if([reviewArray count] < 25 && self.isDownloading && [tempReviewArray count] > 0)
			{
				Country *country = [self countryNamed:[countryArray objectAtIndex:i]];
				country.translated = NO;
				country.showTranslated = NO;
				[country.reviews removeAllObjects];
				[country.reviews addObjectsFromArray:tempReviewArray];
				[tempReviewArray removeAllObjects];
				[loopPool release];
				break;
			}
			
			currentPage++;
			
			[loopPool release];
		}
	}
	
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	
	[downloadDelegate downloadComplete];
	self.isDownloading = NO;
		
	[pool release];
}


- (void)downloadReviews:(id)delegate
{
	self.hasDownloadedReviews = YES;
	downloadDelegate = delegate;
	[NSThread detachNewThreadSelector: @selector(threadedDownloadReviews) toTarget:self withObject:nil];
}


- (NSInteger)averageRating
{	
	float rating = 0.0f;
	
	if([self.countries count] > 0)
	{		
		for(NSString *key in self.countries)
		{		
			Country *country = [self.countries objectForKey:key];
			rating += [country averageRating];
		}
		
		return (NSInteger)(rating / (float)[self.countries count]);
	}
	
	return 0;
}


- (NSString *)reviewText
{
	int count = 0;
		
	if([self.countries count] > 0)
	{		
		for(NSString *key in self.countries)
		{		
			Country *country = [self.countries objectForKey:key];
			count += [country.reviews count];
		}
	}
	
	NSString *result = [NSString stringWithFormat:NSLocalizedString(@"ReviewCount", nil), count];
	
	return result;
}


@end
