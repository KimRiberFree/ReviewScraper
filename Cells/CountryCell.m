//
//  CountryCell.m
//  Scraper
//
//  Created by David Perry on 10/01/2009.
//  Copyright 2009 Didev Studios. All rights reserved.
//

#import "CountryCell.h"


@implementation CountryCell

@synthesize flagView, countryLabel, reviewLabel, reviewCountLabel, ratingView;

- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier
{
    if(self = [super initWithFrame:frame reuseIdentifier:reuseIdentifier])
	{
		self.flagView = [[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 44, 32)] autorelease];
		self.flagView.contentMode = UIViewContentModeCenter;
		self.flagView.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1.0];
		
		self.countryLabel = [[[UILabel alloc] initWithFrame:CGRectMake(0, 30, 44, 13)] autorelease];
		self.countryLabel.font = [UIFont systemFontOfSize:9.0];
		self.countryLabel.textAlignment = UITextAlignmentCenter;
		self.countryLabel.text = @"N/A";
		self.countryLabel.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1.0];
		
		self.reviewLabel = [[[UILabel alloc] initWithFrame:CGRectMake(55, 0, 100, 30)] autorelease];
		self.reviewLabel.font = [UIFont boldSystemFontOfSize:26.0];
		self.reviewLabel.textAlignment = UITextAlignmentLeft;
		self.reviewLabel.text = @"88888";
		
		self.reviewCountLabel = [[[UILabel alloc] initWithFrame:CGRectMake(55, 30, 100, 13)] autorelease];
		self.reviewCountLabel.font = [UIFont systemFontOfSize:9.0];
		self.reviewCountLabel.textAlignment = UITextAlignmentLeft;
		self.reviewCountLabel.text = NSLocalizedString(@"REVIEWS", nil);
		
		self.ratingView = [[[UIImageView alloc] initWithFrame:CGRectMake(130, 8, 134, 25)] autorelease];
    }
	
	[self.contentView addSubview:reviewCountLabel];
	[self.contentView addSubview:reviewLabel];
	[self.contentView addSubview:flagView];
	[self.contentView addSubview:countryLabel];
	[self.contentView addSubview:ratingView];
	
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}


- (void)dealloc
{	
	[reviewCountLabel release];
	[reviewLabel release];
	[flagView release];
	[countryLabel release];
	[ratingView release];
	
	[super dealloc];
}


@end
