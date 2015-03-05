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
    
    [self setup];
    
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

/**
 *Create the section. I didn't insert the separetor here. I used a new row for that.
 */
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UITableViewHeaderFooterView *headerView=[UITableViewHeaderFooterView new];
    headerView.textLabel.font=[UIFont fontWithName:@"Proxima Nova-Semibold" size:14];
    [headerView.textLabel setTextColor:[UIColor colorWithRed:(47/255.0) green:(145.0/255.0) blue:255 alpha:1.0]];
    headerView.textLabel.text=@"GENERAL";
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
    return 3;//1 Hidden + 2 Normal
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellSettings" forIndexPath:indexPath];
    
    if(indexPath.row==lengthSettings)//1
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
        
    }else if(indexPath.row==tempereatureSettings){//2
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
    
    if(indexPath.row==lengthSettings)
        [self performSegueWithIdentifier: @"segueToChooseLength" sender: self];
    else
         [self performSegueWithIdentifier: @"segueToChooseTemperature" sender: self];
    

}

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    id controller = [segue destinationViewController];
    if([segue.identifier isEqualToString:@"segueToChooseLength"])
    {
        NSLog(@"Settings for Length");
        
        [controller setTypeSettings:[NSNumber numberWithInt:1]];
        [controller setTypeSelected:^BOOL(BOOL success, NSError **error) {
            if(success)//It's a new value
               [self.tableView reloadData];
            return success;
        }];
        
    }else //User touch Temperature Settings
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

-(void)setup{
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

@end
