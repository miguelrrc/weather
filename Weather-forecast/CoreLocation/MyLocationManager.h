//
//  LocationManager.h
//  Weather-forecast
//
//  Created by Miguel Rodriguez Rubio on 5/3/15.
//  Copyright (c) 2015 miguelrrc. All rights reserved.
//

#import <Foundation/Foundation.h>

@import CoreLocation;

@protocol MyLocationManagerDelegate

- (void)locationControllerDidUpdateLocation:(CLLocation *)location;
-(void)locationFailWithError:(NSError *)error;
@end

@interface MyLocationManager : NSObject<CLLocationManagerDelegate>

@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CLLocation *location;

@property (weak, nonatomic) id delegate;

+ (MyLocationManager *)sharedController;

@end
