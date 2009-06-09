//
//  SearchResultCell.h
//  Scraper
//
//  Created by David Perry on 02/02/2009.
//  Copyright 2009 Didev Studios. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SearchResultCell : UITableViewCell
{
	UILabel *titleView;
	UILabel *artistView;
}

@property (nonatomic, retain) UILabel *titleView;
@property (nonatomic, retain) UILabel *artistView;

@end
