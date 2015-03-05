//
//  WeatherClient.m
//  Weather-forecast
//
//  Created by Miguel Rodriguez Rubio on 2/3/15.
//  Copyright (c) 2015 miguelrrc. All rights reserved.
//

#import "WeatherClient.h"
#import "Constants.h"
#import "City.h"
#import "Forecast.h"

@implementation WeatherClient

+ (WeatherClient *)weatherClientManager
{
    static WeatherClient * _weatherClientManager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _weatherClientManager = [[self alloc] initWithBaseURL:[NSURL URLWithString:WEB_SERVICE_BASE_WEATHER]];
    });
    
    return _weatherClientManager;
}


/**
 * Initialize with the correct setup
 * @param URL contains the url for the Web Service
 */
- (instancetype)initWithBaseURL:(NSURL *)url
{
    self = [super initWithBaseURL:url];
    
    if (self) {
        self.responseSerializer = [AFJSONResponseSerializer serializer];
        self.requestSerializer = [AFJSONRequestSerializer serializer];
    }
    
    return self;
}

-(void)getWeatherFromLocation:(NSString*)locationString numberOfDays:(NSNumber *)days city:(void (^)(City * city))success{
    
    NSDictionary *params=@{@"key": WEB_SERVICE_WEATHER_KEY,
                          @"q":locationString,
                           @"format":@"json",
                           @"num_of_days":days,
                           @"includeLocation":@"YES"};
    
    [self  GET:WEB_SERVICE_WEATHER_V2_FREE parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {//OK
       
        NSLog(@"We have data from the ws!");
        NSDictionary *dict=(NSDictionary*)responseObject ;
        NSArray *arrCurrentConditions=[[dict objectForKey:@"data"]objectForKey:@"current_condition"];
        NSArray *arrConditionsByDays=[[dict objectForKey:@"data"]objectForKey:@"weather"] ;
        NSMutableArray *arrForecast=[NSMutableArray new];
        for(int i=0;i<arrConditionsByDays.count;i++){
            NSDictionary* weatherByDay=[[[arrConditionsByDays objectAtIndex:i]objectForKey:@"hourly"]objectAtIndex:0];
            NSDictionary*forecastDict=@{@"tempC": [weatherByDay objectForKey:@"tempC"],
                                       @"tempF":[weatherByDay objectForKey:@"tempF"],
                                       @"weatherCode":[weatherByDay objectForKey:@"weatherCode"],
                                       @"weatherDesc":[[[weatherByDay objectForKey:@"weatherDesc"] objectAtIndex:0]valueForKey:@"value"]
                                       };

            Forecast *f=[[Forecast alloc]initWithDictionary:forecastDict error:nil];
            [arrForecast addObject:f];
        }
        NSMutableDictionary *dictWithValues=[[arrCurrentConditions objectAtIndex:0]mutableCopy];
        NSArray *desc=[dictWithValues objectForKey:@"weatherDesc"];
        
       
        
        NSString * weatherDesc = [[desc valueForKey:@"value"] componentsJoinedByString:@"/"];
        [dictWithValues setObject:weatherDesc forKey:@"weatherDesc"];
       
        NSDictionary *area=[[[dict objectForKey:@"data"]objectForKey:@"nearest_area"]objectAtIndex:0];
//        NSDictionary*city=@{@"areaName": WEB_SERVICE_WEATHER_KEY,
//                            @"country":@"Rota"};
        
        
//        [dictWithValues setObject:cityDict forKey:@"city"];
        
        NSArray*arrChanceOfRain=[[[[dict objectForKey:@"data"]objectForKey:@"weather"]objectAtIndex:0] objectForKey:@"hourly"] ;
        int percentage=0;
        for(int i=0;i<arrChanceOfRain.count;i++)
        {
            int f=[[[arrChanceOfRain objectAtIndex:i]valueForKey:@"chanceofrain"]intValue];
           percentage+= f;
            
        }
        percentage=percentage/arrChanceOfRain.count;
        [dictWithValues setObject:[NSString stringWithFormat:@"%d",percentage] forKey:@"chanceofrain"];

        
//        NSMutableDictionary *cityWithWeatherDict=[[NSMutableDictionary alloc]initWithDictionary:cityDict];
//        [cityWithWeatherDict setObject:weatherDict forKey:@"weather"];
        
        NSDictionary*weatherDict=@{@"weatherDesc": weatherDesc,
                                   @"chanceofrain":[NSNumber numberWithInt:percentage],
                                   @"temp_C":[dictWithValues objectForKey:@"temp_C"],
                                    @"temp_F":[dictWithValues objectForKey:@"temp_F"],
                                   @"windspeedMiles":[dictWithValues objectForKey:@"windspeedMiles"],
                                   @"windspeedKmph":[dictWithValues objectForKey:@"windspeedKmph"],
                                   @"winddir16Point":[dictWithValues objectForKey:@"winddir16Point"],
                                   @"precipMM":[dictWithValues objectForKey:@"precipMM"],
                                   @"pressure":[dictWithValues objectForKey:@"pressure"],
                                   @"weatherCode":[dictWithValues objectForKey:@"weatherCode"]
                                   };
       
        NSDictionary*cityDict=@{@"areaName": [[[area objectForKey:@"areaName"] objectAtIndex:0]objectForKey:@"value"],
                                @"country":[[[area objectForKey:@"country"] objectAtIndex:0]objectForKey:@"value"],
                                @"latitude":[area objectForKey:@"latitude"],
                                @"longitude":[area objectForKey:@"longitude"],
                                @"weather":weatherDict,
                                @"arrForeCast":arrForecast};

        City *city=[[City alloc]initWithDictionary:cityDict error:nil];
        
        success(city);
        
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {//FAIL
        NSLog(@"Error getting data from WS: %@",error);
        success(nil);
//        if ([self.delegate respondsToSelector:@selector(fetchingJSONFailedWithError:)]) {
//            NSLog(@"Delegate with Error is called from ws");
//            [self.delegate fetchingJSONFailedWithError:error];
//        }
    }];

}


#pragma mark City
-(void)getLocations:(NSString*)cityBeginningWith cities:(void (^)(NSArray * cities))success{
    
    NSDictionary *params=@{@"key": WEB_SERVICE_WEATHER_KEY,
                           @"q":@"New York",
                           @"format":@"json"
                          };
    
    [self  GET:WEB_SERVICE_SEARCH_CITY_V2_FREE parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {//OK
        NSDictionary *citiesJSON=(NSDictionary*)responseObject;
         NSArray *arr=[[citiesJSON objectForKey:@"search_api"]objectForKey:@"result"];
        NSMutableArray *arrCitiesToReturn=[NSMutableArray new];
        for(int i=0;i<arr.count;i++){
            NSDictionary *object=[arr objectAtIndex:i];
            NSDictionary*dictCity=
                                @{@"areaName": [[[object objectForKey:@"areaName"] objectAtIndex:0]objectForKey:@"value"],
                                @"country":[[[object objectForKey:@"country"] objectAtIndex:0]objectForKey:@"value"],
                                  @"latitude":[object objectForKey:@"latitude"],
                                  @"longitude":[object objectForKey:@"longitude"]};
            
            City *city=[[City alloc]initWithDictionary:dictCity error:nil];
            
            [arrCitiesToReturn addObject:city];
        }
        NSLog(@"Server returned cities %@",citiesJSON);
        success(arrCitiesToReturn);
    
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"Error getting data from WS: %@",error);
        
    }];
}

@end
