//
//  City.h
//  Weather-forecast
//
//  Created by Miguel Rodriguez Rubio on 2/3/15.
//  Copyright (c) 2015 miguelrrc. All rights reserved.
//

#import "JSONModel.h"

@interface City : JSONModel

@property (strong, nonatomic) NSString* areaName;
@property (strong, nonatomic) NSString* country;
@property (strong, nonatomic) NSString* latitude;
@property (strong, nonatomic) NSString* longitude;
@end
