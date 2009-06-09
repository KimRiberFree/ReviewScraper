//
//  ParseSearchHintsXML.h
//  Scraper
//
//  Created by David Perry on 01/02/2009.
//  Copyright 2009 Didev Studios. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SearchHint;

@interface ParseSearchHintsXML : NSObject
{
	NSInteger currentString;
	SearchHint *hint;
	NSMutableArray *resultArray;
}

@end
