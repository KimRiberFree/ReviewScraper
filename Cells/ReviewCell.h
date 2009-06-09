//
//  ReviewCell.h
//  Scraper
//
//  Created by David Perry on 17/01/2009.
//  Copyright 2009 Didev Studios. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ReviewCell : UITableViewCell
{
	UILabel *reviewTitle;
	UILabel *reviewTitleBackground;
	UILabel *reviewText;
	UILabel *reviewAuthor;
	UILabel *reviewVersion;
	UIImageView *ratingImage;
}

@property (nonatomic, retain) UILabel *reviewTitle;
@property (nonatomic, retain) UILabel *reviewText;
@property (nonatomic, retain) UILabel *reviewAuthor;
@property (nonatomic, retain) UILabel *reviewVersion;
@property (nonatomic, retain) UIImageView *ratingImage;

@end
