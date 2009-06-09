//
//  App.h
//  Scraper
//
//  Created by David Perry on 20/01/2009.
//  Copyright 2009 Didev Studios. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface App : NSObject
{
	NSMutableDictionary *countries;
	NSString *name;
	NSString *code;
	NSString *artist;
	UIImage *image;
	BOOL isDownloading;
	BOOL hasDownloadedReviews;
	id downloadDelegate;
	int sortIndex;
}

@property (retain) NSMutableDictionary *countries;
@property (retain) NSString *name;
@property (retain) NSString *code;
@property (retain) NSString *artist;
@property (retain) UIImage *image;
@property (assign) BOOL isDownloading;
@property (assign) BOOL hasDownloadedReviews;
@property (assign) int sortIndex;

- (id)initWithName:(NSString *)appName appCode:(NSString *)appCode appArtist:(NSString *)appArtist;
- (NSString *)filename;
- (void)downloadReviews:(id)delegate;
- (void)cancelDownload;
- (NSInteger)averageRating;
- (NSString *)reviewText;

@end
