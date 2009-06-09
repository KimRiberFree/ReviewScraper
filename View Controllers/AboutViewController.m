//
//  AboutViewController.m
//  Scraper
//
//  Created by David Perry on 20/01/2009.
//  Copyright 2009 Didev Studios. All rights reserved.
//

#import "AboutViewController.h"
#import "ShouldRotateView.h"

@implementation AboutViewController

@synthesize webView;

- (void)viewDidLoad
{
	self.title = NSLocalizedString(@"About", nil);
		
	NSString *helpPath = [[NSBundle mainBundle] pathForResource:@"index" ofType:@"html"];
	NSURL *helpURL = [NSURL fileURLWithPath:helpPath];
	[self.webView loadRequest:[NSURLRequest requestWithURL:helpURL]];
	self.webView.backgroundColor = [UIColor colorWithRed:0.8f green:0.8f blue:0.8f alpha:1.0f];
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	
	self.webView.scalesPageToFit = NO;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return shouldRotateViewToOrientation(interfaceOrientation);
}

- (void)didReceiveMemoryWarning
{
    NSLog(@"Got memory warning!");
	[super didReceiveMemoryWarning];
}


- (void)dealloc
{
    [webView release];
	
	[super dealloc];
}

#pragma mark - UIWebView Delegate Methods

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{	
	if(navigationType == UIWebViewNavigationTypeLinkClicked)
	{
		self.webView.scalesPageToFit = YES;
		
		if([[[request URL] absoluteString] hasPrefix:@"http://phobos.apple.com"])
		{			
			NSString *search = @"Didev Studios";
			
			NSString *sstring = [NSString stringWithFormat:@"http://phobos.apple.com/WebObjects/MZSearch.woa/wa/search?term=%@&media=software", [search stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];  
			[[UIApplication sharedApplication] openURL: [NSURL URLWithString:sstring]];
						
			return NO;
		}
		else
		{			
			[[UIApplication sharedApplication] openURL:[request URL]];
			
			return NO;
		}
	}

	return YES;
}

@end
