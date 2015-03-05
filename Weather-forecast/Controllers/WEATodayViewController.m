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
//TODO: Put it in category the next import
#import "QuartzCore/QuartzCore.h"
@interface WEATodayViewController ()
@property (strong, nonatomic) CLLocationManager *locationManager;

@end

@implementation WEATodayViewController
{
    City *cityToday;//We will use it for Share
}
- (void)viewDidLoad {
   
    [super viewDidLoad];
    
    cityToday=[City new];
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    // Check for iOS 7.
    
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
    self.lblCityAndCountry.text=[NSString stringWithFormat:@"%@, %@",city.areaName,city.country];
    self.imgWeatherDesc.image=[UIImage imageNamed:[city.weather imageNameForBigIcon]];
}

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
            cityToday=city;
            
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
    
}
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:  (CLAuthorizationStatus)status
{

}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    UITableViewController *controller=segue.destinationViewController;
    controller.hidesBottomBarWhenPushed=YES;
}
- (IBAction)shareWeather:(id)sender {
    //Create the image
    UIGraphicsBeginImageContext(self.viewCentered.frame.size);
    [[self.viewCentered layer] renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *screenshot = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    //Message to send
    NSString *myMessage=[NSString stringWithFormat:@"The weather today at: %@",cityToday.areaName];
    
    NSArray *activityItems = @[myMessage,screenshot];
    
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
    activityViewController.excludedActivityTypes = @[UIActivityTypePostToWeibo, UIActivityTypeAssignToContact,UIActivityTypeCopyToPasteboard,UIActivityTypePrint,UIActivityTypeSaveToCameraRoll ];//We exclude some stuff
    
    [self presentViewController:activityViewController animated:YES completion:NULL];//Show
    
}
@end
