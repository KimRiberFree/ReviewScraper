//
//  Country.h
//  Scraper
//
//  Created by David Perry on 20/01/2009.
//  Copyright 2009 Didev Studios. All rights reserved.
//

#import <Foundation/Foundation.h>

@class App;

@interface Country : NSObject
{
	NSString *name;
	NSMutableArray *reviews;
	BOOL translated;
	BOOL showTranslated;
}

@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSMutableArray *reviews;
@property (nonatomic, assign) BOOL translated;
@property (nonatomic, assign) BOOL showTranslated;

- (id)initWithName:(NSString *)countryName;
- (NSInteger)averageRating;

@end
