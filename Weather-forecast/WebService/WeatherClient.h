//
//  WeatherClient.h
//  Weather-forecast
//
//  Created by Miguel Rodriguez Rubio on 2/3/15.
//  Copyright (c) 2015 miguelrrc. All rights reserved.
//

#import "AFHTTPSessionManager.h"
#import "City.h"
@import CoreLocation;
@interface WeatherClient : AFHTTPSessionManager

+ (WeatherClient *)weatherClientManager;

-(void)getWeatherFromLocation:(NSString*)locationString numberOfDays:(NSNumber *)days city:(void (^)(City * city))success;
-(void)getLocations:(NSString*)cityBeginningWith cities:(void (^)(NSArray * cities))success;

@end
