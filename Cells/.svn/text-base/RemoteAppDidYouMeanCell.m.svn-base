//
//  RemoteAppDidYouMeanCell.m
//  Scraper
//
//  Created by David Perry on 20/02/2009.
//  Copyright 2009 Didev Studios. All rights reserved.
//

#import "RemoteAppDidYouMeanCell.h"


@implementation RemoteAppDidYouMeanCell

@synthesize textLabel;
@synthesize activityIndicator;

- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier
{
    if(self = [super initWithFrame:frame reuseIdentifier:reuseIdentifier])
	{
        self.textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, self.frame.size.width, 50)];
		self.textLabel.textAlignment = UITextAlignmentCenter;
		self.textLabel.font = [UIFont boldSystemFontOfSize:20];
		self.textLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		
		self.activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(28, 25, 20, 20)];
		self.activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
		[self.activityIndicator startAnimating];
		
		[self.contentView addSubview:self.textLabel];
    }
	
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}


- (void)dealloc
{
    [textLabel release];	
	[activityIndicator release];
	
	[super dealloc];
}


@end
