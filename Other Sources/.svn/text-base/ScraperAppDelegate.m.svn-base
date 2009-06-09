//
//  ScraperAppDelegate.m
//  Scraper
//
//  Created by David Perry on 20/01/2009.
//  Copyright Didev Studios 2009. All rights reserved.
//

#import "ScraperAppDelegate.h"
#import "RootViewController.h"
#import "CountryManager.h"

@interface ScraperAppDelegate (Private)
- (void)resetAppStoreSearchCountry;
- (NSString *)currentLocaleName;
@end

@implementation ScraperAppDelegate

@synthesize window;
@synthesize navigationController;

- (void)applicationDidFinishLaunching:(UIApplication *)application
{	
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	
	NSString *testValue = [userDefaults stringForKey:@"LocaleName"];
		
	if(testValue == nil)
	{
		[userDefaults setInteger:0 forKey:@"AllowedOrientation"];
		[userDefaults setInteger:0 forKey:@"iTunesSearchCountry"];
		
		[self resetAppStoreSearchCountry];
		
		[userDefaults synchronize];
	}
	else
	{		
		if(![[userDefaults objectForKey:@"LocaleName"] isEqualToString:[self currentLocaleName]])
		{			
			[self resetAppStoreSearchCountry];
			
			[userDefaults synchronize];
		}
	}
	
	int orientation = [userDefaults integerForKey:@"AllowedOrientation"];
	
	if(orientation > 0)
	{
		[UIApplication sharedApplication].statusBarOrientation = orientation;
	}
	
	window.backgroundColor = [UIColor blackColor];
	
	[window addSubview:[navigationController view]];
	[window makeKeyAndVisible];
}


- (void)applicationWillTerminate:(UIApplication *)application
{
}


- (void)dealloc
{
	[navigationController release];
	[window release];
	
	[super dealloc];
}

#pragma mark - Private Methods

- (void)resetAppStoreSearchCountry
{
	NSString *localeName = [self currentLocaleName];
	
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	[userDefaults setObject:localeName forKey:@"LocaleName"];
	
	for(int i = 0;i < [[[CountryManager sharedManager] sortedCountryCodesByName] count]; i++)
	{
		NSString *countryName = [[[CountryManager sharedManager] sortedCountryCodesByName] objectAtIndex:i];
		
		if([localeName isEqualToString:countryName])
		{
			[userDefaults setInteger:i forKey:@"iTunesSearchCountry"];
		}
	}
}

			
- (NSString *)currentLocaleName
{
	NSLocale *locale = [NSLocale currentLocale];
	return [[locale objectForKey:NSLocaleCountryCode] lowercaseString];
}

@end
