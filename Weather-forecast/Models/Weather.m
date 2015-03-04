//
//  Weather.m
//  Weather-forecast
//
//  Created by Miguel Rodriguez Rubio on 2/3/15.
//  Copyright (c) 2015 miguelrrc. All rights reserved.
//

#import "Weather.h"
#import "WeatherImage.h"

@implementation Weather


//+(JSONKeyMapper*)keyMapper
//{
//    return [[JSONKeyMapper alloc] initWithDictionary:@{
//                                                       @"temp_C": @"temp_C",
//                                                       @"weatherDesc": @"weatherDesc"                                                       }];
//}

- (NSString *)imageNameForBigIcon {
    return [NSString stringWithFormat:@"%@%@",[WeatherImage getImageNameForIcon:self.weatherCode],@"_Big"];

}
- (NSString *)imageNameForMediumIcon {
    return [NSString stringWithFormat:@"%@%@",[WeatherImage getImageNameForIcon:self.weatherCode],@"_Medium"];
    
}
@end
