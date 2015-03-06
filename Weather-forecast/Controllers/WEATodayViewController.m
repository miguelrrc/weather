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
#import "Weather+Utilities.h"
#import "UIImage+Utilities.h"

@interface WEATodayViewController ()

@end

@implementation WEATodayViewController
{
    City *cityToday;//We will use it for Share
}
- (void)viewDidLoad {
   
    [super viewDidLoad];
    
    cityToday=[City new];
    
    //Get the singleton for Location
    [[MyLocationManager sharedController]setDelegate:self];

    // Check for iOS 7.
    if ([[MyLocationManager sharedController].locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [[MyLocationManager sharedController].locationManager requestWhenInUseAuthorization];
    }
   
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.imgLocation setHidden:YES];
    [[MyLocationManager sharedController].locationManager startUpdatingLocation];//We do it here so it can get new data when user touch Item Button Today.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 * Populate the UI with data from the City
 *@param city City From the WS
 * @see WeatherClient
 */
-(void)populateController:(City *)city {
    
    //We use a category to get the temperature based on the Settings from the user
    self.lblWeatherDescription.text=[NSString stringWithFormat:@"%@ | %@",[city.weather getTemperatureBasedOnScale],city.weather.weatherDesc];
    
    self.lblWeatherPrecipMM.text=[NSString stringWithFormat:@"%@ mm",city.weather.precipMM];
    self.lblWeatherPressure.text=[NSString stringWithFormat:@"%@ hPa",city.weather.pressure];
    self.lblWeatherChancePrecipMM.text=[NSString stringWithFormat:@"%@%%",city.weather.chanceofrain];
    self.lblWeatherWindSpeed.text=[city.weather getLengthBasedOnScale];
    self.lblWindDirection.text=city.weather.winddir16Point;
    self.lblCityAndCountry.text=[NSString stringWithFormat:@"%@, %@",city.areaName,city.country];
    self.imgWeatherDesc.image=[UIImage imageNamed:[city.weather imageNameForBigIcon]];
    [self.imgLocation setHidden:NO];
}

/**
 * Delegate from the singleton
 *@param location new location
 * @see MyLocationManagerDelegate
 */
- (void)locationControllerDidUpdateLocation:(CLLocation *)location
{
    
    NSTimeInterval locationAge = -[location.timestamp timeIntervalSinceNow];
    if (locationAge > 5.0) return;

    if (location.horizontalAccuracy < 0) return;

    
    [[MyLocationManager sharedController].locationManager  stopUpdatingLocation];
   
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];//Loading
    
    WeatherClient *client=[WeatherClient weatherClientManager];
    
    //Format for the parameter used in WeatherClient
    NSString *locationString=[NSString stringWithFormat:@" %f, %f",location.coordinate.latitude,location.coordinate.longitude];
    
    [client getWeatherFromLocation:locationString numberOfDays:[NSNumber numberWithInt:1] city:^(City *city) {
        if(city!=nil)//We have a city
        {
            cityToday=city;
            
            NSDictionary *dictCity=@{@"latitude": city.latitude,
                                     @"longitude":city.longitude,
                                     @"areaName":city.areaName,
                                     @"country":city.country};
            [[NSUserDefaults standardUserDefaults] setObject:dictCity forKey:@"MyCity"];//Save in defaults for others views in case we need it.
           
            NSLog(@"Ready to populate the controller");
            
            [self populateController:city];
        }else
        {
            NSLog(@"Error retrieving the city");
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"No connection" message:@"Error retrieving data from the server" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            
            [alert show];
        }
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];//Bye loading
    }];
    
}

-(void)locationFailWithError:(NSError *)error{
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:error.domain message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    
    [alert show];
}

/**
 * Segue to Locations. It's the ony one
 *@param segue 
 *@param sender
 * @see WEALocationTableViewController
 */
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    UITableViewController *controller=segue.destinationViewController;
    controller.hidesBottomBarWhenPushed=YES;//Hide the bottom bar
}


/**
 * Share the view by email, facebook, twitter and message
 * Create a image with the central view and add a small message
 *@param sender not used
 */

- (IBAction)shareWeather:(id)sender {
    //Create the image
    
    UIImage *screenshot = [UIImage convertViewIntoImage:self.viewCentered];

    //Message to send
    NSString *myMessage=[NSString stringWithFormat:@"The weather today at: %@",cityToday.areaName];
    
    NSArray *activityItems = @[myMessage,screenshot];
    
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];

    activityViewController.excludedActivityTypes = @[UIActivityTypePostToWeibo, UIActivityTypeAssignToContact,UIActivityTypeCopyToPasteboard,UIActivityTypePrint,UIActivityTypeSaveToCameraRoll ];//We exclude some stuff
    
    [self presentViewController:activityViewController animated:YES completion:NULL];//Show
    
}
@end
