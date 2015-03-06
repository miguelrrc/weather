//
//  WEAForecastTableViewController.m
//  Weather-forecast
//
//  Created by Miguel Rodriguez Rubio on 2/3/15.
//  Copyright (c) 2015 miguelrrc. All rights reserved.
//

#import "WEAForecastTableViewController.h"
#import "City.h"
#import "Forecast+Utilities.h"
#import "CellForecastTableViewCell.h"
#import "NSDate+Format.h"
#import "DBWeather.h"
#import "MBProgressHUD.h"
#import "Constants.h"


@interface WEAForecastTableViewController ()
{
    WeatherClient *client; //WS
    City *myCity; //City from defaults
    City *myCityFromWS;//City from the WebService
    NSNumber *numberOfDays;//Number of days to forecast. If there is no city then it will be 0
}

@end

@implementation WEAForecastTableViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
   
    [self setup];
    
    
    
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"MyCity"])//We have a city in defaults from Today
    {
         [MBProgressHUD showHUDAddedTo:self.view animated:YES];//Loading
        
        NSDictionary * dictMyCity=[[NSUserDefaults standardUserDefaults] objectForKey:@"MyCity"];
        
        myCity=[[City alloc]initWithDictionary:dictMyCity error:nil];//Populate city with dict
        
        self.navigationItem.title=myCity.areaName;
        
        NSString *location=[NSString stringWithFormat:@"%@,%@",myCity.latitude,myCity.longitude];
       
        [client getWeatherFromLocation:location numberOfDays:[NSNumber numberWithInteger:FORECAST_DAYS] city:^(City *city) {//By default 5 days
            
            if(city!=nil)//We got a city from WS
            {
                myCityFromWS=city;
                numberOfDays=[NSNumber numberWithInteger:FORECAST_DAYS];
                
                [self.tableView reloadData];
                
            }
            else{
                NSLog(@"Error retrieving data from WS");
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"No connection" message:@"Error retrieving data from the server" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                
                [alert show];
            }
             [MBProgressHUD hideAllHUDsForView:self.view animated:YES];//Bye loading
        }];
    }else
    {
        numberOfDays=[NSNumber numberWithInt:0];//We don't have a city

        [self showAlertWithoutLocation];
    }
    
}

/**
 * Configurate the tableView and initialize some data
 */
-(void)setup{
    
    //UI setup
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    client=[WeatherClient weatherClientManager];

}
/**
 * Show alert because there is no city
 */
-(void)showAlertWithoutLocation{
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"No location" message:@"There is no geolocation activated" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    
    [alert show];
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
    return numberOfDays.intValue;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CellForecastTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellForecastTableViewCell" forIndexPath:indexPath];

    NSDate *day= [NSDate addNumberOfDays:(int)indexPath.row toDate:[NSDate date]];//Add indexPath.row number of days
    
    cell.lblDay.text=[NSDate getNameForDay:day];//Name of the day M,T,W...
    cell.lblTemperature.text=@"-"; //Until the WS returns data
    
    
    //Configurate the cell with data from Forecast
    Forecast *forecast=[myCityFromWS.arrForeCast objectAtIndex:indexPath.row];
            
    cell.lblTemperature.text=[forecast getTemperatureBasedOnScale];
    cell.imgWeather.image=[UIImage imageNamed:[forecast imageNameForMediumIcon]];
    cell.lblWeather.text=forecast.weatherDesc;
    
    //Separator for the cell
    UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Divider"] ];
    imgView.frame = CGRectMake(71, 90, self.view.frame.size.width-71, 1);
    [cell.contentView addSubview:imgView];
    
    return cell;
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
    controller.hidesBottomBarWhenPushed=YES;
}




@end
