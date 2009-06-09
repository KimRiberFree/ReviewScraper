//
//  ShouldRotateView.m
//  Scraper
//
//  Created by David Perry on 21/02/2009.
//  Copyright 2009 Didev Studios. All rights reserved.
//

#import "ShouldRotateView.h"


BOOL shouldRotateViewToOrientation(UIInterfaceOrientation orientation)
{
	int defaultOrientation = [[NSUserDefaults standardUserDefaults] integerForKey:@"AllowedOrientation"];
	
	if(defaultOrientation == 0)
	{
		return YES;
	}
	
	if(orientation == defaultOrientation)
	{
		return YES;
	}
	
	return NO;
}
