//
//  ReviewRatingCell.m
//  Scraper
//
//  Created by David Perry on 17/01/2009.
//  Copyright 2009 Didev Studios. All rights reserved.
//

#import "ReviewRatingCell.h"


@implementation ReviewRatingCell

@synthesize ratingView;

- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier
{
    if(self = [super initWithFrame:frame reuseIdentifier:reuseIdentifier])
	{
		UIView *myContentView = self.contentView;
		
		self.ratingView = [[[UIImageView alloc] initWithFrame:CGRectMake(10, 0, 85, 16)] autorelease];
		
		[myContentView addSubview:self.ratingView];
    }
	
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
	
}


- (void)dealloc
{
    [ratingView release];
	
	[super dealloc];
}


@end
