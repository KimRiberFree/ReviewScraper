
//
//  CountryManager.h
//  Scraper
//
//  Created by David Perry on 26/01/2009.
//  Copyright 2009 Didev Studios. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface CountryManager : NSObject
{
	NSDictionary *countries;
	NSDictionary *dictionary;
	NSArray *sortedCountryCodesByName;
}

@property (nonatomic, retain) NSArray *sortedCountryCodesByName;

+ (CountryManager *)sharedManager;
- (NSDictionary *)dictionaryForKey:(NSString *)key;
- (NSString *)googleCodeForKey:(NSString *)key;
- (NSInteger)iTunesCodeForKey:(NSString *)key;
- (NSArray *)allKeys;

@end
