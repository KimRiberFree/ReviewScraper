//
//  DownloadReviews.h
//  Scraper
//
//  Created by David Perry on 16/01/2009.
//  Copyright 2009 Didev Studios. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ParseXML.h"


@interface DownloadReviews : NSObject
{
	
}

+ (NSArray *)downloadWithCountry:(int)itunesCode countryName:(NSString *)countryName appCode:(NSString *)appCode pageNumber:(NSInteger)pageNumber;

@end
