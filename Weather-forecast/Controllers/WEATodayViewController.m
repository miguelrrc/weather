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
#import "DBWeather.h"
#import "SharedCity.h"

@interface WEATodayViewController ()

@end

@implementation WEATodayViewController
{
    City *cityToday;//We will use it for Share
}

- (void)viewDidLoad {
   
    [super viewDidLoad];
    
    cityToday=[City new];
    
    //Set the delegate for the location
    [[MyLocationManager sharedController]setDelegate:self];
    
    
   
   
    
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    
    [[MyLocationManager sharedController].locationManager startUpdatingLocation];//We do it here so it can get new data when user touch Item Button Today.
    // Check for iOS 7.
    if ([[MyLocationManager sharedController].locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [[MyLocationManager sharedController].locationManager requestWhenInUseAuthorization];
    }
    
    //Lets get the CityID from the Singleton
    SharedCity *sharedCity=[SharedCity sharedCity];
    self.cityID=sharedCity.cityID;
    
    if(self.cityID!=nil)//We have a city from the db
    {
        City *cityFromDB=[DBWeather getCityByID:self.cityID];
        
        if(cityFromDB!=nil)
        {
            self.lblCityAndCountry.text=[NSString stringWithFormat:@"%@, %@",cityFromDB.areaName,cityFromDB.country];//For this field we don't need data from the WS
            
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];//Loading
            
            NSString *location=[NSString stringWithFormat:@"%@,%@",cityFromDB.latitude,cityFromDB.longitude];
            
            [self getDataFromLocation:location city:^(City *city) {
                [self populateController:city];
                 [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            }];
           
            
        }
    }
    
    [self.imgLocation setHidden:YES];

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
    
    
    
}

/**
 * Delegate from the singleton.
 * If self.cityID there is a city from the db to show up. We get the data from the ws just to save it in the NSUserdefault. It's always good to have it.
 *@param location new location
 * @see MyLocationManagerDelegate
 */
- (void)locationControllerDidUpdateLocation:(CLLocation *)location
{
    NSLog(@"Got a new location");
    
    NSTimeInterval locationAge = -[location.timestamp timeIntervalSinceNow];
    if (locationAge > 5.0) return;

    if (location.horizontalAccuracy < 0) return;

    
    [[MyLocationManager sharedController].locationManager  stopUpdatingLocation];
    
    NSString *locationString=[NSString stringWithFormat:@" %f, %f",location.coordinate.latitude,location.coordinate.longitude];
    
    //We ask to retrieve from location and update the UI
    if(self.cityID==nil)
    {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];//Loading
        [self getDataFromLocation:locationString city:^(City *city) {
             NSLog(@"Ready to populate the controller");
            [self populateController:city];
            
            [self.imgLocation setHidden:NO];
            
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];//Bye loading
            [self saveCityInDefaults:city];
           
            
        }];
        
    }else
    {
        //Get the data silently
        [self getDataFromLocation:locationString city:^(City *city) {
            NSLog(@"City from WS will not populate the controller");
        }];
    }
    
    
    
}

-(void)getDataFromLocation:(NSString*)locationString city: (void (^)(City * city))success{
    WeatherClient *client=[WeatherClient weatherClientManager];
    
    //Format for the parameter used in WeatherClient
  
    
    [client getWeatherFromLocation:locationString numberOfDays:[NSNumber numberWithInt:1] city:^(City *city) {
        if(city!=nil)//We have a city
        {
            cityToday=city;
            
           
            success(cityToday);
            NSLog(@"Ready to populate the controller");
//            if(self.cityID ==nil)//If CityID is not a city from the db;
//                [self populateController:city];
        }else
        {
            NSLog(@"Error retrieving the city");
             success(nil);
            if(self.cityID==nil){
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"No connection" message:@"Error retrieving data from the server" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
            }
            
            
        }
//        if(self.cityID==nil)
//        {
//            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];//Bye loading
//            
//            
//        }
    }];
}

-(void)locationFailWithError:(NSError *)error{
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:error.domain message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    
    [alert show];
}


/**
 * Save the city for defaults. Only used with geolocation
 *
 */
-(void)saveCityInDefaults:(City*)city{
    NSDictionary *dictCity=@{@"latitude": city.latitude,
                             @"longitude":city.longitude,
                             @"areaName":city.areaName,
                             @"country":city.country};
    [[NSUserDefaults standardUserDefaults] setObject:dictCity forKey:@"MyCity"];//Save in defaults for others views in case we need it.
}

/**
 * Segue to Locations. It's the ony one
 *@param segue 
 *@param sender
 * @see WEALocationTableViewController
 */
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    UITableViewController *controller=(UITableViewController*)segue.destinationViewController;

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


- (IBAction)unwindToTodayViewController:(UIStoryboardSegue *)segue {
    
}


@end
