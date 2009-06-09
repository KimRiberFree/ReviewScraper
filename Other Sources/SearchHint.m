//
//  SearchHint.m
//  Scraper
//
//  Created by David Perry on 01/02/2009.
//  Copyright 2009 Didev Studios. All rights reserved.
//

#import "SearchHint.h"


@implementation SearchHint

@synthesize term;
@synthesize priority;
@synthesize url;

- (id)initWithTerm:(NSMutableString *)hintTerm priority:(NSInteger)hintPriority url:(NSMutableString *)hintUrl
{
	self = [super init];
	
	self.term = hintTerm;
	self.priority = hintPriority;
	self.url = hintUrl;
	
	return self;
}

- (void)dealloc
{
	[term release];
	[url release];
	
	[super dealloc];
}

@end
