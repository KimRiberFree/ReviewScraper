//
//  ReviewsCountryCell.h
//  Scraper
//
//  Created by David Perry on 10/01/2009.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CountryCell : UITableViewCell
{
	UIImageView *flagView;
	UILabel *countryLabel;
	UILabel *reviewLabel;
	UILabel *reviewCountLabel;
	UIImageView *ratingView;
}

@property (nonatomic, retain) UIImageView *flagView;
@property (nonatomic, retain) UILabel *countryLabel;
@property (nonatomic, retain) UILabel *reviewLabel;
@property (nonatomic, retain) UILabel *reviewCountLabel;
@property (nonatomic, retain) UIImageView *ratingView;

@end
