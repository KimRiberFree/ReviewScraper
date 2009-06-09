//
//  SearchDownloader.m
//  Scraper
//
//  Created by David Perry on 05/02/2009.
//  Copyright 2009 Didev Studios. All rights reserved.
//

#import "SearchDownloader.h"
#import "CountryManager.h"

@implementation SearchDownloader

@synthesize receivedData;

- (id)init
{
	self = [super init];
	
	self.receivedData = [NSMutableData data];
	
	isDownloading = NO;
	
	return self;
}

- (void)dealloc
{
	self.receivedData = nil;
	
	[super dealloc];
}

- (void)cancel
{	
	if(isDownloading)
	{
		[connection cancel];
		[receivedData setLength:0];
	}
	
	isDownloading = NO;
}

- (void)requestWithUrl:(NSString *)url delegate:(id)theDelegate type:(SearchDownloaderSearchType)type
{	
	[self cancel];
	
	currentType = type;
	
	delegate = theDelegate;
	
	NSString *iTunesCode = [NSString stringWithFormat:@"%@,2", [[CountryManager sharedManager] iTunesCodeForKey:[[NSUserDefaults standardUserDefaults] objectForKey:@"LocaleName"]]];
		
	request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
	[request addValue:iTunesCode forHTTPHeaderField:@"X-Apple-Store-Front"];
	[request addValue:@"iTunes-iPhone/2.2 (2)" forHTTPHeaderField:@"User-Agent"];
	
	connection = [NSURLConnection connectionWithRequest:request delegate:self];
	
	isDownloading = YES;
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    [self.receivedData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [receivedData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
	if(currentType == kSearchHints)
	{
		if([delegate respondsToSelector:@selector(didFinishDownloadSearchHints:)])
		{
			[delegate performSelector:@selector(didFinishDownloadSearchHints:) withObject:receivedData];
		}
	}
	else if(currentType == kSearchResults)
	{
		if([delegate respondsToSelector:@selector(didFinishDownloadSearchResults:)])
		{
			[delegate performSelector:@selector(didFinishDownloadSearchResults:) withObject:receivedData];
		}
	}
	
	[self.receivedData setLength:0];
	
	isDownloading = NO;
}


@end
