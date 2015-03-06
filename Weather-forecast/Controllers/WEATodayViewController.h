//
//  WEATodayViewController.h
//  Weather-forecast
//
//  Created by Miguel Rodriguez Rubio on 2/3/15.
//  Copyright (c) 2015 miguelrrc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyLocationManager.h"

@interface WEATodayViewController : UIViewController<MyLocationManagerDelegate>

@property (weak, nonatomic) IBOutlet UIView *viewCentered;
@property (weak, nonatomic) IBOutlet UIImageView *imgWeatherDesc;
@property (weak, nonatomic) IBOutlet UILabel *lblCityAndCountry;
@property (weak, nonatomic) IBOutlet UILabel *lblWeatherDescription;
@property (weak, nonatomic) IBOutlet UILabel *lblWeatherChancePrecipMM;
@property (weak, nonatomic) IBOutlet UILabel *lblWeatherPrecipMM;
@property (weak, nonatomic) IBOutlet UILabel *lblWeatherPressure;
@property (weak, nonatomic) IBOutlet UILabel *lblWeatherWindSpeed;
@property (weak, nonatomic) IBOutlet UILabel *lblWindDirection;
@property (weak, nonatomic) IBOutlet UIImageView *imgLocation;

- (IBAction)shareWeather:(id)sender;

@end
