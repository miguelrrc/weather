//
//  UIImage+Utilities.h
//  Weather-forecast
//
//  Created by Miguel Rodriguez Rubio on 4/3/15.
//  Copyright (c) 2015 miguelrrc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Utilities)

+(UIImage*) drawImage:(UIImage*) fgImage inImage:(UIImage*) bgImage atPoint:(CGPoint)  point;
+(UIImage *)convertViewIntoImage:(UIView*)viewToImage;
@end
