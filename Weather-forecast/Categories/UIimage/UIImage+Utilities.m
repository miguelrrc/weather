//
//  UIImage+Utilities.m
//  Weather-forecast
//
//  Created by Miguel Rodriguez Rubio on 4/3/15.
//  Copyright (c) 2015 miguelrrc. All rights reserved.
//

#import "UIImage+Utilities.h"
#import "QuartzCore/QuartzCore.h"

@implementation UIImage (Utilities)

+(UIImage*) drawImage:(UIImage*) fgImage inImage:(UIImage*) bgImage atPoint:(CGPoint)  point
{
    UIGraphicsBeginImageContextWithOptions(bgImage.size, FALSE, 0.0);
    [bgImage drawInRect:CGRectMake( 0, 0, bgImage.size.width, bgImage.size.height)];
    [fgImage drawInRect:CGRectMake( point.x, point.y, fgImage.size.width, fgImage.size.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

+(UIImage *)convertViewIntoImage:(UIView*)viewToImage{
    UIGraphicsBeginImageContext(viewToImage.frame.size);
    [[viewToImage layer] renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *screenshot = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return screenshot;

}
@end
