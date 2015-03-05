//
//  WEATodayViewController.m
//  Weather-forecast
//
//  Created by Miguel Rodriguez Rubio on 2/3/15.
//  Copyright (c) 2015 miguelrrc. All rights reserved.
//

#import "WEATodayViewController.h"
#import "WeatherClient.h"
#import "MBProgressHUD.h"
@interface WEATodayViewController ()
@property (strong, nonatomic) CLLocationManager *locationManager;

@end

@implementation WEATodayViewController

- (void)viewDidLoad {
   
    [super viewDidLoad];
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    // Check for iOS 8. Without this guard the code will crash with "unknown selector" on iOS 7.
    
    if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [self.locationManager requestWhenInUseAuthorization];
    }
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(getMyLocation)
                                                 name:UIApplicationWillEnterForegroundNotification
                                               object:nil];
    [self getMyLocation];
}

-(void)viewWillAppear:(BOOL)animated{
    [self getMyLocation];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)getMyLocation{
  
    
    [self.locationManager startUpdatingLocation];
}
-(void)populateController:(City *)city {
    
    self.lblWeatherDescription.text=[NSString stringWithFormat:@"%@ | %@",city.weather.temp_C.stringValue,city.weather.weatherDesc];
    self.lblWeatherPrecipMM.text=[NSString stringWithFormat:@"%@ mm",city.weather.precipMM.stringValue];
    self.lblWeatherPressure.text=[NSString stringWithFormat:@"%@ hPa",city.weather.windspeedKmph.stringValue];
    self.lblWeatherChancePrecipMM.text=[NSString stringWithFormat:@"%@%%",city.weather.chanceofrain];
    self.lblWeatherWindSpeed.text=[NSString stringWithFormat:@"%@ %@",city.weather.windspeedKmph.stringValue,@"Km/h"];
    self.lblWindDirection.text=city.weather.winddir16Point;
    self.lblCityAndCountry.text=[NSString stringWithFormat:@"%@,%@",city.areaName,city.country];
    self.imgWeatherDesc.image=[UIImage imageNamed:[city.weather imageNameForBigIcon]];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    // Last object contains the most recent location
    CLLocation *newLocation = [locations lastObject];
    
    NSTimeInterval locationAge = -[newLocation.timestamp timeIntervalSinceNow];
    if (locationAge > 5.0) return;
    
    if (newLocation.horizontalAccuracy < 0) return;

    
    [self.locationManager stopUpdatingLocation];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    WeatherClient *client=[WeatherClient weatherClientManager];
    NSString *locationString=[NSString stringWithFormat:@" %f, %f",newLocation.coordinate.latitude,newLocation.coordinate.longitude];
    
    [client getWeatherFromLocation:locationString numberOfDays:[NSNumber numberWithInt:1] city:^(City *city) {
        if(city!=nil)
        {
            NSDictionary *dictCity=@{@"latitude": city.latitude,
                                     @"longitude":city.longitude,
                                     @"areaName":city.areaName,
                                     @"country":city.country};
            [[NSUserDefaults standardUserDefaults] setObject:dictCity forKey:@"MyCity"];
            NSLog(@"Ready to populate the controller");
            [self populateController:city];
        }
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    }];
    
//    WeatherHTTPClient *client = [WeatherHTTPClient sharedWeatherHTTPClient];
//    client.delegate = self;
//    [client updateWeatherAtLocation:newLocation forNumberOfDays:5];
}
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:  (CLAuthorizationStatus)status
{
    /*if (status == kCLAuthorizationStatusAuthorizedAlways || status == kCLAuthorizationStatusAuthorizedWhenInUse) {
        NSLog(@"Authorized");
        [_mainButton setIsLoading:NO];
        [self startGettingLocation];
    } else if (status == kCLAuthorizationStatusDenied || status == kCLAuthorizationStatusRestricted) {
        NSLog(@"Denied");
        _currentState = CurrentStateError;
        [_mainButton setUpButtonForState:_currentState];
    }
     */
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    UITableViewController *controller=segue.destinationViewController;
    controller.hidesBottomBarWhenPushed=YES;
}
- (IBAction)shareWeather:(id)sender {
}
@end
