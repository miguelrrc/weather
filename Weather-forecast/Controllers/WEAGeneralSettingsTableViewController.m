//
//  WEAGeneralSettingsTableViewController.m
//  Weather-forecast
//
//  Created by Miguel Rodriguez Rubio on 5/3/15.
//  Copyright (c) 2015 miguelrrc. All rights reserved.
//

#import "WEAGeneralSettingsTableViewController.h"
#import "TypeOfSettings.h"
#import "WEAChooseSettingsTableViewController.h"
@interface WEAGeneralSettingsTableViewController ()

@end

@implementation WEAGeneralSettingsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
     self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
   
    if ( indexPath.section == 0 && indexPath.row == 0 )//Just to show the separator.
        return 1.f;
    else
        return [super tableView:tableView heightForRowAtIndexPath:indexPath];

}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UITableViewHeaderFooterView *headerView=[UITableViewHeaderFooterView new];
    headerView.textLabel.font=[UIFont fontWithName:@"Proxima Nova-Semibold" size:14];
    [headerView.textLabel setTextColor:[UIColor colorWithRed:(47/255.0) green:(145.0/255.0) blue:255 alpha:1.0]];
    headerView.textLabel.text=@"GENERAL";
//    cell.backgroundColor=[UIColor whiteColor];
    headerView.contentView.backgroundColor=[UIColor whiteColor];
    
    return headerView;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 44;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 3;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellSettings" forIndexPath:indexPath];
    
    if(indexPath.row==lengthSettings)
    {
        NSNumber *optionSelected=[[NSUserDefaults standardUserDefaults]objectForKey:@"LengthSettings"];
        cell.textLabel.text=@"Unit of length";
        if(optionSelected.intValue==1)
        {
            cell.detailTextLabel.text=@"Meters";
        }else
        {
            cell.detailTextLabel.text=@"Feet";
        }
    }else if(indexPath.row==tempereatureSettings){
        NSNumber *optionSelected=[[NSUserDefaults standardUserDefaults]objectForKey:@"TemperatureSettings"];
        cell.textLabel.text=@"Units of temperature";
        if(optionSelected.intValue==1)
        {
            cell.detailTextLabel.text=@"Celsius";
        }else
        {
            cell.detailTextLabel.text=@"Fahrenheit";
        }
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(indexPath.row==1)
        [self performSegueWithIdentifier: @"segueToChooseLength" sender: self];
    else
         [self performSegueWithIdentifier: @"segueToChooseTemperature" sender: self];
    

}

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    id controller = [segue destinationViewController];
    if([segue.identifier isEqualToString:@"segueToChooseLength"])//El controlador es EPCTActivityDatePopoverController
    {
        NSLog(@"Settings for Length");
        
        [controller setTypeSettings:[NSNumber numberWithInt:1]];
        [controller setTypeSelected:^BOOL(BOOL success, NSError **error) {
            if(success)
               [self.tableView reloadData];
            return success;
        }];
        
    }else
    {
        NSLog(@"Settings for Temperature");
        
        [controller setTypeSettings:[NSNumber numberWithInt:2]];
        [controller setTypeSelected:^BOOL(BOOL success, NSError **error) {
            if(success)
                [self.tableView reloadData];
            return success;
        }];
        
    }
    
}


@end