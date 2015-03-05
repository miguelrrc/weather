//
//  DBWeather.h
//  Weather-forecast
//
//  Created by Miguel Rodriguez Rubio on 4/3/15.
//  Copyright (c) 2015 miguelrrc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
#import "FMResultSet.h"
#import "City.h"
@interface DBWeather : NSObject
+(NSMutableArray *) getAll;
+(NSNumber *)insert:(City*)city;
+(BOOL)deleteCityByID:(NSNumber *)ID;
@end
