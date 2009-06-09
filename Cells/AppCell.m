//
//  AppCell.m
//  Scraper
//
//  Created by David Perry on 02/02/2009.
//  Copyright 2009 Didev Studios. All rights reserved.
//

#import "AppCell.h"


@implementation AppCell

@synthesize titleView;
@synthesize artistView;
@synthesize ratingView;
@synthesize reviewView;

- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier
{
    if(self = [super initWithFrame:frame reuseIdentifier:reuseIdentifier])
	{
		self.autoresizesSubviews = YES;
		self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		
		self.artistView = [[[UILabel alloc] initWithFrame:CGRectMake(80, 5, 230, 15)] autorelease];
		self.artistView.font = [UIFont boldSystemFontOfSize:12.0];
		self.artistView.textAlignment = UITextAlignmentLeft;
		self.artistView.textColor = [UIColor darkGrayColor];
		self.artistView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		
		self.titleView = [[[UILabel alloc] initWithFrame:CGRectMake(80, 18, 230, 30)] autorelease];
		self.titleView.font = [UIFont boldSystemFontOfSize:16.0];
		self.titleView.textAlignment = UITextAlignmentLeft;
		self.titleView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		
		self.ratingView = [[[UIImageView alloc] initWithFrame:CGRectMake(80, 46, 85, 16)] autorelease];
		
		self.reviewView = [[[UILabel alloc] initWithFrame:CGRectMake(175, 47, 140, 15)] autorelease];
		self.reviewView.font = [UIFont boldSystemFontOfSize:11.0];
		self.reviewView.textAlignment = UITextAlignmentLeft;
		self.reviewView.textColor = [UIColor darkGrayColor];
		self.reviewView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    }
	
	self.backgroundColor = [UIColor lightGrayColor];
	
	[self.contentView addSubview:self.titleView];
	[self.contentView addSubview:self.artistView];
	[self.contentView addSubview:self.ratingView];
	[self.contentView addSubview:self.reviewView];
	
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}


- (void)dealloc
{	
	[titleView release];
	[artistView release];
	[ratingView release];
	[reviewView release];
	
	[super dealloc];
}


@end
