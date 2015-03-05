//
//  Weather+Utilities.m
//  Weather-forecast
//
//  Created by Miguel Rodriguez Rubio on 5/3/15.
//  Copyright (c) 2015 miguelrrc. All rights reserved.
//

#import "Weather+Utilities.h"

@implementation Weather (Utilities)

-(NSString*)getTemperatureBasedOnScale
{
     NSNumber *temperatureSelected=[[NSUserDefaults standardUserDefaults] objectForKey:@"TemperatureSettings"];
     NSString *temperature;
    if(temperatureSelected.intValue==1)
        temperature=[NSString stringWithFormat:@"%@ °C",self.temp_C];
    else
        temperature=[NSString stringWithFormat:@"%@ °F",self.temp_F];

    return  temperature;
}

-(NSString*)getLengthBasedOnScale
{
    NSNumber *lengthSelected=[[NSUserDefaults standardUserDefaults] objectForKey:@"LengthSettings"];
    NSString *length;
    if(lengthSelected.intValue==1)
        length=[NSString stringWithFormat:@"%@ Km/h",self.windspeedKmph];
    else
        length=[NSString stringWithFormat:@"%@ mil/h",self.windspeedMiles];

    
    return  length;
}

@end
