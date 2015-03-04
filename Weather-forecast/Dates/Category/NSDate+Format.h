//
//  NSDate+Format.h
//  Weather-forecast
//
//  Created by Miguel Rodriguez Rubio on 3/3/15.
//  Copyright (c) 2015 miguelrrc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Format)

+(NSString*)getNameForDay:(NSDate*)myDate;
@end
