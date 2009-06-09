//
//  Country.m
//  Scraper
//
//  Created by David Perry on 20/01/2009.
//  Copyright 2009 Didev Studios. All rights reserved.
//

#import "Country.h"
#import "Review.h"


@implementation Country

@synthesize name;
@synthesize reviews;
@synthesize translated;
@synthesize showTranslated;

- (id)initWithName:(NSString *)countryName
{	
	self = [super init];
	
	self.name = countryName;
	self.reviews = [NSMutableArray array];
	self.translated = NO;
	self.showTranslated = NO;
	
	return self;
}


- (id)initWithCoder:(NSCoder *)coder
{
	self = [super init];
	
	self.name = [coder decodeObjectForKey:@"name"];
	self.reviews = [coder decodeObjectForKey:@"reviews"];
	self.translated = [coder decodeBoolForKey:@"translated"];
	self.showTranslated = [coder decodeBoolForKey:@"showTranslated"];
	
	return self;
}


- (void)encodeWithCoder:(NSCoder *)coder
{
	[coder encodeObject:self.name forKey:@"name"];
	[coder encodeObject:self.reviews forKey:@"reviews"];
	[coder encodeBool:self.translated forKey:@"translated"];
	[coder encodeBool:self.showTranslated forKey:@"showTranslated"];
}


- (void)dealloc
{
	[name release];
	[reviews release];
	
	[super dealloc];
}

#pragma mark - Instance Methods

- (NSInteger)averageRating
{	
	float rating = 0.0f;
	
	for(Review *review in self.reviews)
	{		
		rating += [review.rating integerValue];
	}
		
	return (NSInteger)(rating / (float)[self.reviews count]);
}


@end
