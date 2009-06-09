//
//  UIImage+Mask.m
//  Scraper
//
//  Created by David Perry on 05/03/2009.
//  Copyright 2009 Didev Studios. All rights reserved.
//

#import "UIImage+Mask.h"


@implementation UIImage (UIImage_Mask)

- (UIImage *)imageWithRoundedCorners:(BOOL)addShine
{	
	UIImage *mask2 = [UIImage imageNamed:@"AppCornersMask.png"];
	
	UIGraphicsBeginImageContext(self.size);
	CGContextClipToMask(UIGraphicsGetCurrentContext(), CGRectMake(0,0,self.size.width,self.size.height), [mask2 CGImage]);
	[self drawInRect:CGRectMake(0,0,self.size.width,self.size.height ) blendMode:kCGBlendModeNormal alpha:1];
	
	if(addShine)
	{
		UIImage *mask = [UIImage imageNamed:@"AppShineMask.png"];
		[mask drawInRect:CGRectMake(0,0,self.size.width,self.size.height ) blendMode:kCGBlendModeNormal alpha:1];
	}
	
	UIImage *glassImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	return glassImage;
}

@end
