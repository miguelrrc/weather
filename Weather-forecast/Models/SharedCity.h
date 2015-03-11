//
//  sharedCity.h
//  Weather-forecast
//
//  Created by Miguel Rodriguez Rubio on 10/3/15.
//  Copyright (c) 2015 miguelrrc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SharedCity : NSObject

+ (SharedCity *)sharedCity;


@property (weak, nonatomic)  NSNumber *cityID;//Geolocation = -1 or nil

@end
