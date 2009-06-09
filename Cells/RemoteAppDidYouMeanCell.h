//
//  RemoteAppDidYouMeanCell.h
//  Scraper
//
//  Created by David Perry on 20/02/2009.
//  Copyright 2009 Didev Studios. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface RemoteAppDidYouMeanCell : UITableViewCell
{
	UILabel *textLabel;
	UIActivityIndicatorView *activityIndicator;
}

@property (nonatomic, retain) UILabel *textLabel;
@property (nonatomic, retain) UIActivityIndicatorView *activityIndicator;

@end
