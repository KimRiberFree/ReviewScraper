//
//  Review.m
//  Scraper
//
//  Created by David Perry on 23/01/2009.
//  Copyright 2009 Didev Studios. All rights reserved.
//

#import "Review.h"

@implementation Review

@synthesize author;
@synthesize title;
@synthesize versionnum;
@synthesize text;
@synthesize rating;
@synthesize translatedTitle;
@synthesize translatedText;


- (id)init
{
	self = [super init];
	self.author = [NSMutableString string];
	self.versionnum = [NSMutableString string];
	self.title = [NSMutableString string];
	self.text = [NSMutableString string];
	self.rating = [NSMutableString string];
	self.translatedTitle = [NSString string];
	self.translatedText = [NSString string];
	
	return self;
}


- (id)initWithCoder:(NSCoder *)coder
{
	[super init];
	
	self.author = [coder decodeObjectForKey:@"author"];
	self.title = [coder decodeObjectForKey:@"title"];
	self.versionnum = [coder decodeObjectForKey:@"versionnum"];
	self.text = [coder decodeObjectForKey:@"text"];
	self.rating = [coder decodeObjectForKey:@"rating"];
	self.translatedTitle = [coder decodeObjectForKey:@"translatedTitle"];
	self.translatedText = [coder decodeObjectForKey:@"translatedText"];
	
	return self;
}

- (void)encodeWithCoder:(NSCoder *)coder
{
	[coder encodeObject:self.author forKey:@"author"];
	[coder encodeObject:self.title forKey:@"title"];
	[coder encodeObject:self.versionnum forKey:@"versionnum"];
	[coder encodeObject:self.text forKey:@"text"];
	[coder encodeObject:self.rating forKey:@"rating"];
	[coder encodeObject:self.translatedTitle forKey:@"translatedTitle"];
	[coder encodeObject:self.translatedText forKey:@"translatedText"];
}

- (void)dealloc
{
	[author release];	
	[title release];	
	[versionnum release];	
	[text release];	
	[rating release];	
	[translatedTitle release];	
	[translatedText release];
	
	[super dealloc];
}


@end
