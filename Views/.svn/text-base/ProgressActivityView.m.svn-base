//
//  ProgressActivityView.m
//  Scraper
//
//  Created by David Perry on 09/02/2009.
//  Copyright 2009 Didev Studios. All rights reserved.
//

#import "ProgressActivityView.h"


@implementation ProgressActivityView

@synthesize activityIndicator;
@synthesize progressBar;
@synthesize delegate;

- (id)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
	{
        self.backgroundColor = [UIColor blackColor];
		self.alpha = 0.0f;
    }
	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:1.0];
	[self setAlpha:0.75f];
	[UIView commitAnimations];
	
    return self;
}


- (void)drawRect:(CGRect)rect
{
    if(!self.activityIndicator)
	{
		self.activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake((self.frame.size.width/2) - 10, (self.frame.size.height/2) - 10, 20, 20)];
		[self.activityIndicator startAnimating];
		self.progressBar = [[UIProgressView alloc] initWithFrame:CGRectMake(100, 280, 100, 5)];
		self.progressBar.progress = 0.0f;
		
		[self addSubview:self.activityIndicator];
	}
}


- (void)fadeOut
{
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
	[UIView setAnimationDuration:1.0];
	[self setAlpha:0.0f];
	[UIView commitAnimations];
}

- (void)animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
{
	if([delegate respondsToSelector:@selector(fadeOutDidFinish)])
	{
		[delegate performSelector:@selector(fadeOutDidFinish)];
	}
}


- (void)dealloc
{
    [activityIndicator release];
	[progressBar release];
	[delegate release];
	
	[super dealloc];
}


@end
