//
//  SearchHint.h
//  Scraper
//
//  Created by David Perry on 01/02/2009.
//  Copyright 2009 Didev Studios. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface SearchHint : NSObject
{
	NSMutableString *term;
	NSInteger priority;
	NSMutableString *url;
}

@property (nonatomic, retain) NSMutableString *term;
@property (nonatomic, assign) NSInteger priority;
@property (nonatomic, retain) NSMutableString *url;

@end
