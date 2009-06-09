//
//  OrientationSettingViewController.m
//  Scraper
//
//  Created by David Perry on 22/02/2009.
//  Copyright 2009 Didev Studios. All rights reserved.
//

#import "OrientationSettingViewController.h"


@implementation OrientationSettingViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
	
	textLabel.text = NSLocalizedString(@"OrientationSettingText", nil);
	[setOrientationButton setTitle:NSLocalizedString(@"AllowCurrentOrientationButton", nil) forState:UIControlStateNormal];
	[anyOrientationButton setTitle:NSLocalizedString(@"AllowAnyOrientationButton", nil) forState:UIControlStateNormal];
	
	self.title = NSLocalizedString(@"AllowedOrientation", nil);
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


- (void)dealloc
{
    [super dealloc];
}

- (IBAction)clickedSetOrientation:(id)sender
{
	[[NSUserDefaults standardUserDefaults] setInteger:[[UIDevice currentDevice] orientation] forKey:@"AllowedOrientation"];
	[[NSUserDefaults standardUserDefaults] synchronize];
}

- (IBAction)clickedAnyOrientation:(id)sender
{
	[[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"AllowedOrientation"];
	[[NSUserDefaults standardUserDefaults] synchronize];
}

@end
