//
//  Forecast.h
//  Weather-forecast
//
//  Created by Miguel Rodriguez Rubio on 4/3/15.
//  Copyright (c) 2015 miguelrrc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"

@interface Forecast : JSONModel

@property (strong, nonatomic) NSNumber * tempC;
@property (strong, nonatomic) NSNumber * tempF;
@property (strong, nonatomic) NSString* weatherCode;
@property (strong, nonatomic) NSString* weatherDesc;

- (NSString *)imageNameForMediumIcon;

@end
