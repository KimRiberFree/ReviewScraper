//
//  OrientationSettings.h
//  Scraper
//
//  Created by David Perry on 15/02/2009.
//  Copyright 2009 Didev Studios. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface OrientationSettings : NSObject
{
	NSArray *allowedOrientations;
}

@property (nonatomic, retain) NSArray *allowedOrientations;

+ (OrientationSettings *)sharedSettings;

@end
