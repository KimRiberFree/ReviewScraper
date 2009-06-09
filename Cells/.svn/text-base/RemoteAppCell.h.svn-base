//
//  RemoteAppCell.h
//  Scraper
//
//  Created by David Perry on 02/02/2009.
//  Copyright 2009 Didev Studios. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RemoteAppCell : UITableViewCell
{
	UIImageView *imageView;
	UILabel *titleView;
	UILabel *artistView;
	UIImageView *ratingView;
	UILabel *reviewView;
	NSString *url;
	BOOL needsShine;
}

@property (nonatomic, retain) UIImageView *imageView;
@property (nonatomic, retain) UILabel *titleView;
@property (nonatomic, retain) UILabel *artistView;
@property (nonatomic, retain) UIImageView *ratingView;
@property (nonatomic, retain) UILabel *reviewView;
@property (nonatomic, retain) NSString *url;
@property (nonatomic, assign) BOOL needsShine;

- (void)setURL:(NSString *)aURL;
- (void)fetchImage;

@end
