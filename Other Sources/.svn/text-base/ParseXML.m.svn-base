//
//  ParseXML.m
//  Scraper
//
//  Created by David Perry on 12/01/2009.
//  Copyright 2009 Didev Studios. All rights reserved.
//

#import "ParseXML.h"


@implementation ParseXML

- (id)init
{
	if(self = [super init])
	{
		resultArray = [NSMutableArray array];
		currentString = -1;
	}
	
	return self;
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{	
	currentString = -1;
	
	if([elementName isEqualToString:@"title"])
	{
		review = [[Review alloc] init];
		
		currentString = 0;
	}
	else if([elementName isEqualToString:@"author"])
	{
		currentString = 1;
	}
	else if([elementName isEqualToString:@"versionnum"])
	{
		currentString = 2;
	}
	else if([elementName isEqualToString:@"review"])
	{
		currentString = 3;
	}
	else if([elementName isEqualToString:@"rating"])
	{
		currentString = 4;
	}
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{	
	if([elementName isEqualToString:@"review"])
	{
		if(review)
		{
			[resultArray addObject:review];
		}
		
		[review release];
		
		currentString = 0;
	}
}


- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)s
{		
	switch(currentString)
	{
		case 0:
			if([s length] > 0)
			{
				[review.title appendString:s];
			}
			break;
			
		case 1:
			if([s length] > 0)
			{
				[review.author appendString:s];
			}
			break;
			
		case 2:
			if([s length] > 0)
			{
				[review.versionnum appendString:s];
			}
			break;
		
		case 3:
			if([s length] > 0)
			{
				[review.text appendString:s];
			}
			break;
		
		case 4:
			if([s length] > 0)
			{
				[review.rating appendString:s];
			}
			break;
			
		default:
			break;
	}
}


- (NSArray *)getReviewsFromXMLString:(NSString *)string country:(NSString *)country
{
	currentCountry = country;
	
	NSString *xml = [NSString stringWithFormat:@"<d>%@</d>", string];
	NSData *data = [xml dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
	NSXMLParser *xmlParse = [[NSXMLParser alloc] initWithData:data];
	[xmlParse setDelegate:self];
	[xmlParse parse];
	[xmlParse release];
			
	return resultArray;
}

- (void)dealloc
{
	currentCountry = nil;
	resultArray = nil;
	
	[super dealloc];
}


@end