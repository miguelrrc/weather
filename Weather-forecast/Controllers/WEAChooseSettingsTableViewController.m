//
//  WEAChooseSettingsTableViewController.m
//  Weather-forecast
//
//  Created by Miguel Rodriguez Rubio on 5/3/15.
//  Copyright (c) 2015 miguelrrc. All rights reserved.
//

#import "WEAChooseSettingsTableViewController.h"
#import "TypeOfSettings.h"
@interface WEAChooseSettingsTableViewController ()

@end

@implementation WEAChooseSettingsTableViewController
{
    
    NSArray * arrayOfOptions;
    NSNumber *optionSelected;
}
- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
   
    //arrOfOptions will be filled with different data is the user touch length settings or Temperature Settings
    if(lengthSettings==self.typeSettings.intValue){
        
        arrayOfOptions=[NSArray arrayWithObjects:@"Meters",@"Feet", nil];
        optionSelected=[[NSUserDefaults standardUserDefaults] objectForKey:@"LengthSettings"];
    
    }
    else if(tempereatureSettings==self.typeSettings.intValue)
    {
        arrayOfOptions=[NSArray arrayWithObjects:@"Celsius",@"Fahrenheit",nil];
        optionSelected=[[NSUserDefaults standardUserDefaults] objectForKey:@"TemperatureSettings"];
    }

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
    return arrayOfOptions.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellChooseSettingOption" forIndexPath:indexPath];
    
    cell.textLabel.text=[arrayOfOptions objectAtIndex:indexPath.row];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSError *error = nil;
    
    if(optionSelected.intValue!=indexPath.row+1){//Values are 1 and 2. That is why +1
        [
         self changeSettingsOptions:[NSNumber numberWithLong:indexPath.row+1]];
        
        [self typeSelected](YES, &error);//We have a new option selected to return to the GeneralSettings;
   
    }else{
        
        [self typeSelected](NO, &error);
    }
    
    [self.navigationController popViewControllerAnimated:YES];//Go back after touch an option
}


-(void)changeSettingsOptions:(NSNumber *)newOptionSelected{
    
    optionSelected=newOptionSelected;
    
    if(lengthSettings==self.typeSettings.intValue){//1
        [[NSUserDefaults standardUserDefaults] setObject:optionSelected forKey:@"LengthSettings"];

    }else  if(tempereatureSettings==self.typeSettings.intValue){//2
        [[NSUserDefaults standardUserDefaults] setObject:optionSelected forKey:@"TemperatureSettings"];
    }
    
}

@end
