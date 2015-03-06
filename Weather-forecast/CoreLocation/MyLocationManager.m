//
//  LocationManager.m
//  Weather-forecast
//
//  Created by Miguel Rodriguez Rubio on 5/3/15.
//  Copyright (c) 2015 miguelrrc. All rights reserved.
//

#import "MyLocationManager.h"


@implementation MyLocationManager

+ (MyLocationManager *)sharedController
{
    static MyLocationManager *sharedController = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedController = [[self alloc]init];
    });
    
    return sharedController;
}

- (id)init
{
    self = [super init];
    if (self) {
        _locationManager = [[CLLocationManager alloc]init];
        _locationManager.delegate = self;
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        _locationManager.distanceFilter = 1000; // Meters.
    }
    return self;
}

#pragma mark - Location Manager

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    [self.delegate locationControllerDidUpdateLocation:locations.lastObject];
    [self setLocation:locations.lastObject];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSError *errorDomain;
    NSLog(@"Error getting location: %@", error);
     CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    if (status == kCLAuthorizationStatusRestricted || status == kCLAuthorizationStatusDenied ) {
        NSLog(@"Not authorized to use Location");
        
        NSMutableDictionary* details = [NSMutableDictionary dictionary];
        [details setValue:@"Not authorized to use Geolocation" forKey:NSLocalizedDescriptionKey];
        errorDomain=[NSError errorWithDomain:@"GeoLocation Service" code:400 userInfo:details];
    }else
    {
        NSMutableDictionary* details = [NSMutableDictionary dictionary];
        [details setValue:@"Unavailable to receive location" forKey:NSLocalizedDescriptionKey];
        errorDomain=[NSError errorWithDomain:@"GeoLocation Service" code:401 userInfo:details];
    }
    [self.delegate locationFailWithError:errorDomain];
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:  (CLAuthorizationStatus)status
{
    
}
@end
