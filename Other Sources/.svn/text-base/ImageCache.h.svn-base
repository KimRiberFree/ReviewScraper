//
//  ImageCache.h
//  Scraper
//
//  Created by David Perry on 05/02/2009.
//  Copyright 2009 Didev Studios. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ImageCache: NSObject
{
	NSMutableDictionary *cache;
}

+ (ImageCache *)sharedCache;
- (void)addImageDataToCache:(NSData *)aData forURL:(NSURL *)anImageURL;
- (NSData *)imageDataForURL:(NSURL *)aURL;
- (void)flushCache;

@end