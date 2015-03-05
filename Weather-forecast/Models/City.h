//
//  City.h
//  Weather-forecast
//
//  Created by Miguel Rodriguez Rubio on 2/3/15.
//  Copyright (c) 2015 miguelrrc. All rights reserved.
//

#import "JSONModel.h"
#import "Weather.h"
#import "Forecast.h"
@interface City : JSONModel

@property (strong, nonatomic) NSString* areaName;
@property (strong, nonatomic) NSString* country;
@property (strong, nonatomic) NSString* latitude;
@property (strong, nonatomic) NSString* longitude;
@property (strong, nonatomic) NSNumber<Optional>* ID;
@property (strong, nonatomic) Weather<Optional>* weather;
@property (strong, nonatomic) NSArray<Optional>* arrForeCast;
@end
