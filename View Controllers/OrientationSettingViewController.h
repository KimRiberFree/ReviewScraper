//
//  OrientationSettingViewController.h
//  Scraper
//
//  Created by David Perry on 22/02/2009.
//  Copyright 2009 Didev Studios. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface OrientationSettingViewController : UIViewController
{
	IBOutlet UILabel *textLabel;
	IBOutlet UIButton *setOrientationButton;
	IBOutlet UIButton *anyOrientationButton;
}

- (IBAction)clickedSetOrientation:(id)sender;
- (IBAction)clickedAnyOrientation:(id)sender;

@end
