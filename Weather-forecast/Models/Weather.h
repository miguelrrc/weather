//
//  Weather.h
//  Weather-forecast
//
//  Created by Miguel Rodriguez Rubio on 2/3/15.
//  Copyright (c) 2015 miguelrrc. All rights reserved.
//

#import "JSONModel.h"
//#import "City.h"
#import "WeatherImage.h"
@interface Weather : JSONModel

@property (strong, nonatomic) NSNumber * temp_C;
@property (strong, nonatomic) NSNumber * temp_F;
@property (strong, nonatomic) NSNumber * windspeedMiles;
@property (strong, nonatomic) NSNumber* windspeedKmph;
@property (strong, nonatomic) NSString* winddir16Point;
@property (strong, nonatomic) NSNumber* precipMM;
@property (strong, nonatomic) NSNumber* pressure;
@property (strong, nonatomic) NSString* weatherDesc;
@property (strong, nonatomic) NSString* weatherCode;
@property (strong, nonatomic) NSString* chanceofrain;
//@property (strong, nonatomic) City* city;
@property (strong, nonatomic) NSString <Optional> * icon;

- (NSString *)imageNameForBigIcon;
- (NSString *)imageNameForMediumIcon;

//@property (strong, nonatomic) NSString* weatherDesc;


@end
