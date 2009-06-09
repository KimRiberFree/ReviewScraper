//
//  ImageCache.m
//  Scraper
//
//  Created by David Perry on 05/02/2009.
//  Copyright 2009 Didev Studios. All rights reserved.
//

#import "ImageCache.h"

@implementation ImageCache

static ImageCache *imageCache;

- (id)init
{	
	self = [super init];
	
	cache = [[NSMutableDictionary alloc] init];

	return self;
}

- (void)dealloc
{
	[cache release];
	[imageCache release];
	
	[super dealloc];
}

+ (ImageCache *)sharedCache
{
	if(!imageCache)
	{
		imageCache = [[ImageCache alloc] init];
	}
	
	return imageCache;
}
 
- (NSString *)urlToHashString:(NSURL *)aURL
{
	NSString *result = [NSString stringWithFormat:@"%U", [[aURL absoluteString] hash]];
	
	return result;
}

- (NSData *)imageDataForURL:(NSURL *)aURL
{
	return [cache valueForKey:[self urlToHashString:aURL]];
}

- (void)addImageDataToCache:(NSData *)aDatum forURL:(NSURL *)aURL
{
	[cache setValue:aDatum forKey:[self urlToHashString:aURL]];
}

- (void)flushCache
{	
	[cache removeAllObjects];
}


@end