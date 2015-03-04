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

-(void)getWeatherFromLocation:(NSString*)locationString weather:(void (^)(Weather * weather))success{
    
    
    NSDictionary *params=@{@"key": WEB_SERVICE_WEATHER_KEY,
                          @"q":locationString,
                           @"format":@"json",
                           @"number_of_days":@"1",
                           @"includeLocation":@"YES"};
    
    [self  GET:WEB_SERVICE_WEATHER_V2_FREE parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {//OK
       
        NSLog(@"We have data from the ws!");
        NSDictionary *dict=(NSDictionary*)responseObject ;
        NSArray *arr=[[dict objectForKey:@"data"]objectForKey:@"current_condition"];
        NSMutableDictionary *dict1=[[arr objectAtIndex:0]mutableCopy];
        NSArray *desc=[dict1 objectForKey:@"weatherDesc"];
        NSString * weatherDesc = [[desc valueForKey:@"value"] componentsJoinedByString:@"/"];
        [dict1 setObject:weatherDesc forKey:@"weatherDesc"];
        NSDictionary *area=[[[dict objectForKey:@"data"]objectForKey:@"nearest_area"]objectAtIndex:0];
//        NSDictionary*city=@{@"areaName": WEB_SERVICE_WEATHER_KEY,
//                            @"country":@"Rota"};
        NSDictionary*city=@{@"areaName": [[[area objectForKey:@"areaName"] objectAtIndex:0]objectForKey:@"value"],
                            @"country":[[[area objectForKey:@"country"] objectAtIndex:0]objectForKey:@"value"],
                            @"latitude":[area objectForKey:@"latitude"],
                            @"longitude":[area objectForKey:@"longitude"]};
        
        [dict1 setObject:city forKey:@"city"];
        NSArray*arrChanceOfRain=[[[[dict objectForKey:@"data"]objectForKey:@"weather"]objectAtIndex:0] objectForKey:@"hourly"] ;
        int percentage=0;
        for(int i=0;i<arrChanceOfRain.count;i++)
        {
            int f=[[[arrChanceOfRain objectAtIndex:i]valueForKey:@"chanceofrain"]intValue];
           percentage+= f;
            
        }
        percentage=percentage/arrChanceOfRain.count;
        [dict1 setObject:[NSString stringWithFormat:@"%d",percentage] forKey:@"chanceofrain"];
        
        Weather *w=[[Weather alloc]initWithDictionary:dict1 error:nil];
        
        success(w);
        
        
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
