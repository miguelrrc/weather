//
//  WEAForecastTableViewController.m
//  Weather-forecast
//
//  Created by Miguel Rodriguez Rubio on 2/3/15.
//  Copyright (c) 2015 miguelrrc. All rights reserved.
//

#import "WEAForecastTableViewController.h"
#import "Weather.h"
#import "Forecast.h"
#import "CellForecastTableViewCell.h"
#import "NSDate+Format.h"
#import "DBWeather.h"

@interface WEAForecastTableViewController ()
{
    NSMutableArray *arrLocations;
    WeatherClient *client;
    City *myCity;
}

@end

@implementation WEAForecastTableViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    arrLocations=[NSMutableArray new];
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"MyLocation"])
    {

        NSDictionary * dictMyCity=[[NSUserDefaults standardUserDefaults] objectForKey:@"MyCity"];
        myCity=[[City alloc]initWithDictionary:dictMyCity error:nil];
        self.navigationItem.title=myCity.areaName;
    }
    
    client=[WeatherClient weatherClientManager];
   
    }

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90.0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CellForecastTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellForecastTableViewCell" forIndexPath:indexPath];
    
//    City* cityFromDB=[arrLocations objectAtIndex:indexPath.row];
//    
//    cell.lblWeather.text=cityFromDB.areaName;
    NSDate *day= [NSDate addNumberOfDays:indexPath.row toDate:[NSDate date]];
    
    cell.lblDay.text=[NSDate getNameForDay:day];
    cell.lblTemperature.text=@"-";
    
    NSString *location=[NSString stringWithFormat:@"%@,%@",myCity.latitude,myCity.longitude];
    
    [client getWeatherFromLocation:location numberOfDays:[NSNumber numberWithInt:5] city:^(City *city) {
        
        if(city!=nil)
        {
            NSLog(@"Ready to populate the Cell");
            Forecast *forecast=[city.arrForeCast objectAtIndex:indexPath.row];
            
            cell.lblTemperature.text=[NSString stringWithFormat:@"%@",forecast.tempC];
            cell.imgWeather.image=[UIImage imageNamed:[forecast imageNameForMediumIcon]];
            cell.lblWeather.text=forecast.weatherDesc;
        }
    }];
    
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    UITableViewController *controller=segue.destinationViewController;
    controller.hidesBottomBarWhenPushed=YES;
}
- (IBAction)shareWeather:(id)sender {
}



@end
