//
//  SearchDownloader.h
//  Scraper
//
//  Created by David Perry on 05/02/2009.
//  Copyright 2009 Didev Studios. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface SearchDownloader : NSObject
{
	NSMutableURLRequest *request;
	NSURLConnection *connection;
	NSMutableData *receivedData;
	id delegate;
	int currentType;
	BOOL isDownloading;
}

typedef enum
{
	kSearchHints = 0,
	kSearchResults
} SearchDownloaderSearchType;

@property(nonatomic, retain) NSMutableData *receivedData;

- (void)requestWithUrl:(NSString *)url delegate:(id)theDelegate type:(SearchDownloaderSearchType)type;
- (void)cancel;

@end

@interface NSObject (SearchDownloaderDelegateMethods)

- (void)didFinishDownloadSearchHints:(NSData *)data;
- (void)didFinishDownloadSearchResults:(NSData *)data;

@end
