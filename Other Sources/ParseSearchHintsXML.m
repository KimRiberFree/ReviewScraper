//
//  ParseSearchHintsXML.m
//  Scraper
//
//  Created by David Perry on 01/02/2009.
//  Copyright 2009 Didev Studios. All rights reserved.
//

#import "ParseSearchHintsXML.h"
#import "SearchHint.h"

@implementation ParseSearchHintsXML

- (id)init
{
	if([super init])
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
		hint = [[[SearchHint alloc] init] autorelease];
		
		currentString = 0;
	}
	else if([elementName isEqualToString:@"author"])
	{
		currentString = 1;
	}
	else if([elementName isEqualToString:@"review"])
	{
		currentString = 2;
	}
	else if([elementName isEqualToString:@"rating"])
	{
		currentString = 3;
	}
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{	
	if([elementName isEqualToString:@"review"])
	{
		[resultArray addObject:hint];
		
		hint = nil;
		
		currentString = 0;
	}
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError
{
}


- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)s
{		
	switch(currentString)
	{
		case 0:
			[hint.term appendString:s];
			break;
			
		case 1:
			hint.priority = [s integerValue];
			break;
			
		case 2:
			[hint.url appendString:s];
			break;
			
		default:
			break;
	}
}


- (void)dealloc
{
	[hint release];
	[resultArray release];
	
	[super dealloc];
}


@end
