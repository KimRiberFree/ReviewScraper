//
//  OrientationSettings.m
//  Scraper
//
//  Created by David Perry on 15/02/2009.
//  Copyright 2009 Didev Studios. All rights reserved.
//

#import "OrientationSettings.h"


@implementation OrientationSettings

@synthesize allowedOrientations;

static OrientationSettings *_settings;

- (id)init
{	
	if((self == [super init]))
	{
		self.allowedOrientations = [[NSArray alloc] initWithObjects:NSLocalizedString(@"Any", nil), NSLocalizedString(@"Portrait", nil), NSLocalizedString(@"PortraitUpsideDown", nil), NSLocalizedString(@"LandscapeLeft", nil), NSLocalizedString(@"LandscapeRight", nil), nil];
	}
	
	return self;
}

- (void)dealloc
{
	[allowedOrientations release];
	[_settings release];
	
	[super dealloc];
}


+ (OrientationSettings *) sharedSettings
{
	if(!_settings)
	{
		_settings = [[OrientationSettings alloc] init];
	}
	
	return _settings;
}


@end
