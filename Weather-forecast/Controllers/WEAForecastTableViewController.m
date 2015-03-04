//
//  WEAForecastTableViewController.m
//  Weather-forecast
//
//  Created by Miguel Rodriguez Rubio on 2/3/15.
//  Copyright (c) 2015 miguelrrc. All rights reserved.
//

#import "WEAForecastTableViewController.h"
#import "Weather.h"
#import "CellForecastTableViewCell.h"
#import "NSDate+Format.h"
@interface WEAForecastTableViewController ()
{
    NSArray *arrLocations;
    WeatherClient *client;
}

@end

@implementation WEAForecastTableViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    
    arrLocations=[[NSArray alloc]initWithObjects:@"40.7127,-74.005941",@"-34.603723,-58.381593",@"36.5333,-6.2833", nil];
    client=[WeatherClient weatherClientManager];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
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
    return arrLocations.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90.0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CellForecastTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellForecastTableViewCell" forIndexPath:indexPath];
    
    [client getWeatherFromLocation:[arrLocations objectAtIndex:indexPath.row] weather:^(Weather *w) {
        if(w!=nil)
        {
            NSLog(@"Ready to populate the Cell");
//            CellForecastTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellForecastTableViewCell" forIndexPath:indexPath];
            cell.lblDay.text=[NSDate getNameForDay:[NSDate date]];
            cell.lblWeather.text=w.city.areaName;
            cell.lblTemperature.text=[NSString stringWithFormat:@"%@",w.temp_C];
            cell.imgWeather.image=[UIImage imageNamed:[w imageNameForMediumIcon]];
//            [self populateController:weather];
        }
//        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
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
