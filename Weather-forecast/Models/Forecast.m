//
//  Forecast.m
//  Weather-forecast
//
//  Created by Miguel Rodriguez Rubio on 4/3/15.
//  Copyright (c) 2015 miguelrrc. All rights reserved.
//

#import "Forecast.h"
#import "WeatherImage.h"
@implementation Forecast


- (NSString *)imageNameForMediumIcon {
    return [NSString stringWithFormat:@"%@%@",[WeatherImage getImageNameForIcon:self.weatherCode],@"_Medium"];
    
}
@end
