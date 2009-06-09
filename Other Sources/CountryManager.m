//
//  CountryManager.m
//  Scraper
//
//  Created by David Perry on 26/01/2009.
//  Copyright 2009 Didev Studios. All rights reserved.
//

#import "CountryManager.h"


@implementation CountryManager

@synthesize sortedCountryCodesByName;

NSInteger alphabeticSort(id string1, id string2, void *reverse)
{
    NSLocale *locale = [NSLocale currentLocale];
	
	if((NSInteger *)reverse == NO)
	{
        return [[locale displayNameForKey:NSLocaleCountryCode value:string2] localizedCaseInsensitiveCompare:[locale displayNameForKey:NSLocaleCountryCode value:string1]];
    }
	
    return [[locale displayNameForKey:NSLocaleCountryCode value:string1] localizedCaseInsensitiveCompare:[locale displayNameForKey:NSLocaleCountryCode value:string2]];
}

- (id)init
{
	self = [super init];
	
	dictionary = [[NSDictionary alloc] initWithContentsOfFile:[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"Countries.plist"]];
	
	countries = [dictionary objectForKey:@"Countries"];
	
	NSArray *tempArray = [countries allKeys];
		
	int reverseSort = NO;
	self.sortedCountryCodesByName = [tempArray sortedArrayUsingFunction:alphabeticSort context:&reverseSort];
		
	return self;
}


+ (CountryManager *)sharedManager
{
	static CountryManager *sharedManager = nil;
	
	if(sharedManager == nil)
	{
		sharedManager = [CountryManager new];
	}
	
	return sharedManager;
}


- (NSString *)googleCodeForKey:(NSString *)key;
{
	NSDictionary *tempDictionary = [countries objectForKey:key];
	
	if(!tempDictionary)
	{
		return nil;
	}
	
	NSString *resultString =  [tempDictionary objectForKey:@"GoogleCode"];
	
	if(!resultString)
	{
		return nil;
	}
	
	return resultString;
}


- (NSInteger)iTunesCodeForKey:(NSString *)key
{
	NSDictionary *tempDictionary = [countries objectForKey:key];
	
	if(!tempDictionary)
	{
		return -1;
	}
	
	NSInteger result = (NSInteger)[tempDictionary objectForKey:@"iTunesCode"];
	
	if(!result)
	{
		return -1;
	}
	
	return result;
}


- (NSDictionary *)dictionaryForKey:(NSString *)key
{
	NSDictionary *dict = [countries objectForKey:key];
	
	if(!dict)
	{
		return nil;
	}
	
	return dict;
}

- (NSArray *)allKeys
{	
	NSArray *array = [countries allKeys];
	
	return array;
}

- (void)dealloc
{
	countries = nil;
	
	[dictionary release];	
	[sortedCountryCodesByName release];
	
	[super dealloc];
}

@end
