//
//  SearchResultCell.m
//  Scraper
//
//  Created by David Perry on 02/02/2009.
//  Copyright 2009 Didev Studios. All rights reserved.
//

#import "SearchResultCell.h"


@implementation SearchResultCell

@synthesize titleView;
@synthesize artistView;

- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier
{
    if(self = [super initWithFrame:frame reuseIdentifier:reuseIdentifier])
	{
		self.autoresizesSubviews = YES;
		self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		
		self.artistView = [[[UILabel alloc] initWithFrame:CGRectMake(80, 10, 200, 20)] autorelease];
		self.artistView.font = [UIFont boldSystemFontOfSize:12.0];
		self.artistView.textAlignment = UITextAlignmentLeft;
		self.artistView.textColor = [UIColor darkGrayColor];
		self.artistView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		
		self.titleView = [[[UILabel alloc] initWithFrame:CGRectMake(80, 30, 200, 30)] autorelease];
		self.titleView.font = [UIFont boldSystemFontOfSize:16.0];
		self.titleView.textAlignment = UITextAlignmentLeft;
		self.titleView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    }
	
	self.backgroundColor = [UIColor lightGrayColor];
	
	[self.contentView addSubview:self.titleView];
	[self.contentView addSubview:self.artistView];
	
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
	
	[super dealloc];
}


@end
