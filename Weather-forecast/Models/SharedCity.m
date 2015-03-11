//
//  sharedCity.m
//  Weather-forecast
//
//  Created by Miguel Rodriguez Rubio on 10/3/15.
//  Copyright (c) 2015 miguelrrc. All rights reserved.
//

#import "SharedCity.h"

@implementation SharedCity

+ (SharedCity *)sharedCity
{
    static SharedCity *sharedCity = nil;
    if (sharedCity == nil) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            sharedCity = [[SharedCity alloc] init];
            sharedCity.cityID=nil;
           
        });
    }
    
    return sharedCity;
}
@end
