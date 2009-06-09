//
//  AppCell.h
//  Scraper
//
//  Created by David Perry on 02/02/2009.
//  Copyright 2009 Didev Studios. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface AppCell : UITableViewCell
{
	UILabel *titleView;
	UILabel *artistView;
	UIImageView *ratingView;
	UILabel *reviewView;
}

@property (nonatomic, retain) UILabel *titleView;
@property (nonatomic, retain) UILabel *artistView;
@property (nonatomic, retain) UIImageView *ratingView;
@property (nonatomic, retain) UILabel *reviewView;

@end
