//
//  DownloadReviews.m
//  Scraper
//
//  Created by David Perry on 16/01/2009.
//  Copyright 2009 Didev Studios. All rights reserved.
//

#import "DownloadReviews.h"

@interface DownloadReviews (Private)
+ (NSArray *)parseData:(NSData *)data countryString:(NSString *)countryString;
@end


@implementation DownloadReviews


+ (NSArray *)downloadWithCountry:(int)itunesCode countryName:(NSString *)countryName appCode:(NSString *)appCode pageNumber:(NSInteger)pageNumber
{	
	NSString *urlString = [NSString stringWithFormat:@"http://phobos.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?sortOrdering=4&onlyLatestVersion=false&sortAscending=true&pageNumber=%d&type=Purple+Software&id=%@", pageNumber, appCode];
	
	NSURL *url = [NSURL URLWithString:urlString];
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
	[request addValue:[NSString stringWithFormat:@"%@-1", itunesCode] forHTTPHeaderField:@"X-Apple-Store-Front"];
	[request addValue:@"iTunes-iPhone/2.2 (2)" forHTTPHeaderField:@"User-Agent"];
	
	NSURLResponse* response; NSError* error;
	NSData* data = [NSURLConnection sendSynchronousRequest: request returningResponse:&response error:&error];
			
	return [self parseData:data countryString:countryName];	
}

+ (NSArray *)parseData:(NSData *)data countryString:(NSString *)countryString
{	
	NSString *dataString = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease];
	NSScanner *scanner = [NSScanner scannerWithString:dataString];
	
	BOOL scanning = YES;
	BOOL foundReview = NO;
	
	NSString *tempString = nil;
	NSMutableString *xml = [[NSMutableString alloc] init];
	[xml appendString:@"<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"no\"?>"];
	
	while(scanning)
	{
		[scanner scanUpToString:@"<TextView topInset=\"0\" truncation=\"right\" leftInset=\"0\" squishiness=\"1\" styleSet=\"basic13\" textJust=\"left\" maxLines=\"1\"><SetFontStyle normalStyle=\"textColor\"><b>" intoString:NULL];
		foundReview = [scanner scanString:@"<TextView topInset=\"0\" truncation=\"right\" leftInset=\"0\" squishiness=\"1\" styleSet=\"basic13\" textJust=\"left\" maxLines=\"1\"><SetFontStyle normalStyle=\"textColor\"><b>" intoString:NULL];
		[scanner scanUpToString:@"</b>" intoString:&tempString];
		
		if(foundReview == NO)
		{
			break;
		}
		
		if([tempString length] > 0)
		{
			[xml appendString:@"<title>"];
			[xml appendString:tempString];
			[xml appendString:@"</title>"];
		}
		
		[scanner scanUpToString:@"<HBoxView topInset=\"1\" alt=\"" intoString:NULL];
		[scanner scanString:@"<HBoxView topInset=\"1\" alt=\"" intoString:NULL];
		[scanner scanUpToString:@" " intoString:&tempString];
		
		if([tempString length] > 0)
		{
			[xml appendString:@"<rating>"];
			[xml appendString:tempString];
			[xml appendString:@"</rating>"];
		}
		
		[scanner scanUpToString:@"<TextView topInset=\"0\" truncation=\"right\" leftInset=\"0\" squishiness=\"1\" styleSet=\"basic13\" textJust=\"left\" maxLines=\"1\"><SetFontStyle normalStyle=\"textColor\">" intoString:NULL];
		[scanner scanString:@"<TextView topInset=\"0\" truncation=\"right\" leftInset=\"0\" squishiness=\"1\" styleSet=\"basic13\" textJust=\"left\" maxLines=\"1\"><SetFontStyle normalStyle=\"textColor\">" intoString:NULL];
		[scanner scanUpToString:@"\">" intoString:NULL];
		[scanner scanString:@"\">" intoString:NULL];
		[scanner scanUpToString:@"</GotoURL>" intoString:&tempString];
		tempString = [tempString stringByReplacingOccurrencesOfString:@"<b>" withString:@""];
		tempString = [tempString stringByReplacingOccurrencesOfString:@"</b>" withString:@""];
				
		if([tempString length] > 0)
		{
			[xml appendString:@"<author>"];
			[xml appendString:[tempString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
			[xml appendString:@"</author>"];
		}
		
		[scanner scanString:@"</GotoURL>" intoString:NULL];
		[scanner scanUpToString:@"</SetFontStyle>" intoString:&tempString];
				
		if([tempString length] > 0)
		{
			[xml appendString:@"<versionnum>"];
			tempString = [tempString stringByReplacingOccurrencesOfString:@"- " withString:@""];
			tempString = [tempString stringByReplacingOccurrencesOfString:@"  " withString:@""];
			tempString = [tempString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
			[xml appendString:[tempString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
			[xml appendString:@"</versionnum>"];
		}
		
		[scanner scanUpToString:@"<TextView topInset=\"2\" leftInset=\"0\" rightInset=\"0\" styleSet=\"normal11\" textJust=\"left\"><SetFontStyle normalStyle=\"textColor\">" intoString:NULL];
		[scanner scanString:@"<TextView topInset=\"2\" leftInset=\"0\" rightInset=\"0\" styleSet=\"normal11\" textJust=\"left\"><SetFontStyle normalStyle=\"textColor\">" intoString:NULL];
		[scanner scanUpToString:@"</SetFontStyle>" intoString:&tempString];
		
		if([tempString length] > 0)
		{
			[xml appendString:@"<review>"];
			[xml appendString:tempString];
			[xml appendString:@"</review>"];
		}
	}
		
	NSArray *reviews = [NSArray array];
	
	if([xml length] > 54)
	{		
		ParseXML *tidied = [[[ParseXML alloc] init] autorelease];
		
		reviews = [tidied getReviewsFromXMLString:xml country:countryString];
	}
	
	[xml release];
	
	return reviews;
}


- (void)dealloc
{	
	[super dealloc];
}


@end
