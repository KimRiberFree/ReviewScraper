//
//  RemoteAppMoreCell.m
//  Scraper
//
//  Created by David Perry on 08/02/2009.
//  Copyright 2009 Didev Studios. All rights reserved.
//

#import "RemoteAppMoreCell.h"


@implementation RemoteAppMoreCell

@synthesize textLabel;
@synthesize activityIndicator;

- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier
{
    if(self = [super initWithFrame:frame reuseIdentifier:reuseIdentifier])
	{
        self.textLabel = [[[UILabel alloc] initWithFrame:CGRectMake(80, 10, 200, 50)] autorelease];
		self.textLabel.font = [UIFont boldSystemFontOfSize:14.0];
		self.textLabel.textAlignment = UITextAlignmentCenter;
		self.activityIndicator = [[[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(28, 25, 20, 20)] autorelease];
		self.activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
		[self.activityIndicator startAnimating];
    }

	[self.contentView addSubview:self.textLabel];
	
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
	[super setSelected:selected animated:animated];
}

- (void)setHidden:(BOOL)hidden
{
	[super setHidden:hidden];
}

- (void)dealloc
{
	[textLabel release];
	[activityIndicator release];
	
	[super dealloc];
}


@end
