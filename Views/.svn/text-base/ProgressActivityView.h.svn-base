//
//  ProgressActivityView.h
//  Scraper
//
//  Created by David Perry on 09/02/2009.
//  Copyright 2009 Didev Studios. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ProgressActivityView : UIView
{
	UIActivityIndicatorView *activityIndicator;
	UIProgressView *progressBar;
	id delegate;
}

@property (nonatomic, retain) UIActivityIndicatorView *activityIndicator;
@property (nonatomic, retain) UIProgressView *progressBar;
@property (nonatomic, assign) id delegate;

- (void)fadeOut;

@end

@interface ProgressActivityView (ProgressActivityViewDelegateMethods)

- (void)fadeOutDidFinish;

@end
