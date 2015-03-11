//
//  Forecast+Forecast.m
//  Weather-forecast
//
//  Created by Miguel Rodriguez Rubio on 5/3/15.
//  Copyright (c) 2015 miguelrrc. All rights reserved.
//

#import "Forecast+Utilities.h"

@implementation Forecast (Utilities)

-(NSString*)getTemperatureBasedOnScale
{
    NSNumber *temperatureSelected=[[NSUserDefaults standardUserDefaults] objectForKey:@"TemperatureSettings"];
    NSString *temperature;
    if(temperatureSelected.intValue==1)
        temperature=[NSString stringWithFormat:@"%@°",self.tempC];
    else
        temperature=[NSString stringWithFormat:@"%@°",self.tempF];
    
    return  temperature;
}


@end
