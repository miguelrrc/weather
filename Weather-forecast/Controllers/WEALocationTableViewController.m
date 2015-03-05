//
//  WEALocationTableViewController.m
//  Weather-forecast
//
//  Created by Miguel Rodriguez Rubio on 3/3/15.
//  Copyright (c) 2015 miguelrrc. All rights reserved.
//

#import "WEALocationTableViewController.h"
#import "LocationTableViewCell.h"
#import "UIImage+Utilities.h"
#import "DBWeather.h"

@interface WEALocationTableViewController ()

@property (nonatomic, strong) UISearchDisplayController *searchController;

@end

@implementation WEALocationTableViewController
{
    UIButton *btnAdd;
    NSArray *arrCities;//Array of cities from the search
    NSMutableArray *arrLocations;//Array of weathers
    WeatherClient *client;//Manager for the WS
    BOOL isSearching;
    CGRect originalTableViewSize;
    UIImage* deleteImage;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    arrCities=[NSArray new];
    [self setupViews];
    
    client=[WeatherClient weatherClientManager];
    arrLocations=[NSMutableArray new];
    
    [self getLocations];
    
}

-(void)viewWillLayoutSubviews{
    [self.view bringSubviewToFront:btnAdd];
}

-(void)viewWillAppear:(BOOL)animated{
    
    originalTableViewSize=self.tableView.frame;//We get the size for the tableView to use in keyboardShow or keyboardHide
    
    [self btnAddToView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    
}


-(void)viewWillDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Notifications

- (void)keyboardDidShow:(NSNotification *)nsNotification {
    NSDictionary *userInfo = [nsNotification userInfo];
    CGSize keyboardSize = [[userInfo
                            objectForKey:UIKeyboardFrameBeginUserInfoKey]
                           CGRectValue].size;
    
    CGRect rect=CGRectMake(0, self.tableView.frame.origin.y ,
                           self.tableView.frame.size.width,
                           self.tableView.frame.size.height - keyboardSize.height);
    [self updateTableViewSize:rect];
}


#pragma mark Add Button

-(void)scrollAddButton:(CGFloat)y{
    CGRect frame = btnAdd.frame;
    
//TODO:    20 should be static or constant.
    frame.origin.y = y + self.tableView.frame.size.height - btnAdd.frame.size.height-20;
    btnAdd.frame = frame;
    
    [self.view bringSubviewToFront:btnAdd];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if([btnAdd isHidden])//If the button is hidden we don't need to
        return ;
    
    [self scrollAddButton:scrollView.contentOffset.y];
    [self updateAlphaCell];
    
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    if(isSearching){//Cities
        return arrCities.count;
    }
    else//Weather
    {
        
        return arrLocations.count;
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if(isSearching)//Cities
        return 44;
    else//Weather
        return 90.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    if(isSearching)//Cities
    {
        UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"cityCell" forIndexPath:indexPath];
        City *city=[arrCities objectAtIndex:indexPath.row];
        cell.textLabel.text=[NSString stringWithFormat:@"%@, %@",city.areaName,city.country];
        return cell;
    }else{//Weather
        
         City* cityFromArray=[arrLocations objectAtIndex:indexPath.row];
        
        LocationTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"locationTableViewCell" forIndexPath:indexPath];
       
        
      
        
        
        
        cell.lblCity.text=cityFromArray.areaName;
        cell.lblTemperature.text=@"-";
        if(cityFromArray.ID.intValue==-1)
        {
            [cell.imgCurrentLocation setHidden:NO];
        }else
        {
            [cell.imgCurrentLocation setHidden:YES];
            
            cell.rightUtilityButtons = [self getrightButtonsForSwipeCell];
            cell.delegate=self;//Current Location can't be deleted

        }
         NSString *location=[NSString stringWithFormat:@"%@,%@",cityFromArray.latitude,cityFromArray.longitude];
        [client getWeatherFromLocation:location numberOfDays:[NSNumber numberWithInt:1] city:^(City *city) {
            
            if(city!=nil)
            {
                NSLog(@"Ready to populate the WeatherCell after ws got data");
                
                cell.lblWeather.text=city.weather.weatherDesc;
                cell.lblTemperature.text=[NSString stringWithFormat:@"%@",city.weather.temp_C];
                cell.imgWeather.image=[UIImage imageNamed:[city.weather imageNameForMediumIcon]];
            }
        }];
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(!isSearching)
        return;
    //Add city to database
    City *city=[arrCities objectAtIndex:indexPath.row];
#warning esto en su clase correspondiente
    [DBWeather insert:city];
    
    [self removeSearchBarAndShowWeatherTable];
    
    [self updateDataAndView];
   
    
}


#pragma mark Private Methods

-(void)setupViews{
    self.searchBar = [[UISearchBar alloc] init];
    [self.searchBar setFrame:CGRectMake(0, 0, self.view.frame.size.width, 55)];
    [self.searchBar setShowsCancelButton:YES animated:YES];
    self.searchBar.delegate = self;
    
    [self.navigationItem setHidesBackButton:YES animated:YES];
    
    self.navigationItem.rightBarButtonItem =
    [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                  target:self
                                                  action:@selector(done:)];
    self.navigationItem.rightBarButtonItem.style = UIBarButtonItemStyleDone;
    
    deleteImage=[self createImageForDelete];
    
}

-(void)done:(UIBarButtonItem*)sender{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

-(void)btnAddToView{
    
    btnAdd=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    UIImage *image = [[UIImage imageNamed:@"Location-ButtonAdd"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    btnAdd.frame= CGRectMake(0, self.tableView.frame.size.height-image.size.height-20, self.view.frame.size.width, image.size.height);
    
    NSLog(@"Position btn y: %f size:%f",btnAdd.frame.origin.y,btnAdd.frame.size.height);
    
    [btnAdd setImage:image forState:UIControlStateNormal];
    [btnAdd addTarget:self action:@selector(addLocation) forControlEvents:UIControlEventTouchUpInside];
    //    [btnAdd.layer setBackgroundColor:[UIColor colorWithWhite:0.0 alpha:0.1].CGColor];
    
    [self.view addSubview:btnAdd];
}

- (void)updateTableViewSize:(CGRect)rect {
    self.tableView.frame = rect;
}

-(void)getLocations{
    if (arrLocations.count>0) {//Remove old data
        [arrLocations removeAllObjects];
    }
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"MyLocation"])
    {
        
        NSDictionary * dictMyCity=[[NSUserDefaults standardUserDefaults] objectForKey:@"MyCity"];
        City *myCity=[[City alloc]initWithDictionary:dictMyCity error:nil];
        myCity.ID=[NSNumber numberWithInt:-1];
        [arrLocations addObject:myCity];
    }
    
    client=[WeatherClient weatherClientManager];
    
    [arrLocations addObjectsFromArray:[DBWeather getAll]];
    
}
-(void)updateDataAndView{
    [self getLocations];
    [self.tableView reloadData];
}


-(void)updateAlphaCell{
    
    NSArray *visibleCells = [self.tableView visibleCells];
    for (UITableViewCell *cell in visibleCells) {
        cell.contentView.alpha = 1.0;
    }
    UITableViewCell *lastCell=[visibleCells lastObject];
    lastCell.contentView.alpha=0.1;
    
    
}


- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    
    [self removeSearchBarAndShowWeatherTable];
    [self.tableView reloadData];//Reload to show the other tableView
    
}

-(void)removeSearchBarAndShowWeatherTable{
    [self.searchBar resignFirstResponder];//Keyboard dissapear
    
    [self updateTableViewSize:originalTableViewSize];//Update the tableViewSize
    
    [self.searchBar removeFromSuperview];//Remove from the navigation bar
    
    isSearching=NO;
    
    [btnAdd setHidden:NO];
    
    [self.navigationItem.rightBarButtonItem setTintColor:nil];//Default Color for Done
    [self.navigationItem.rightBarButtonItem setEnabled:YES];//Activate the button
    
    
}
    
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    
    
    isSearching=YES;
    NSLog(@"Looking for results");
    
    [client getLocations:searchBar.text cities:^(NSArray *cities) {
        
        if(cities){
            arrCities=[NSArray arrayWithArray:cities];
            [self.tableView reloadData];
            
            NSLog(@"We have cities");
            
        }else{
            arrCities=[NSArray arrayWithObject:nil];
            NSLog(@"No results");
            [self.tableView reloadData];
            
        }
    }];
    
}
-(void)addLocation{
    
    [btnAdd setHidden:YES];
    
    [self.navigationItem.rightBarButtonItem setTintColor:[UIColor clearColor]];
    [self.navigationItem.rightBarButtonItem setEnabled:NO];
    
    [self.navigationController.navigationBar addSubview:self.searchBar];
    
    [self.searchBar becomeFirstResponder];
}

- (NSArray *)getrightButtonsForSwipeCell
{
    NSMutableArray *rightUtilityButtons = [NSMutableArray new];
    [rightUtilityButtons sw_addUtilityButtonWithColor:[UIColor clearColor] icon:deleteImage];
    //    [rightUtilityButtons sw_addUtilityButtonWithColor:
    //     [UIColor colorWithRed:1.0f green:0.231f blue:0.188 alpha:1.0f]
    //                                                title:@"Delete"];
    
    return rightUtilityButtons;
}

-(UIImage *)createImageForDelete
{
    UIImage *icon=[UIImage imageNamed:@"Delete"];
    UIImage *deleteIcon=[UIImage imageNamed:@"DeleteIcon"];
    CGPoint centerBigIcon=CGPointMake(icon.size.width/2, icon.size.height/2);
    CGPoint centerBothIcon=CGPointMake(centerBigIcon.x-deleteIcon.size.width/2, centerBigIcon.y-deleteIcon.size.height/2);
    return [UIImage drawImage:deleteIcon inImage:icon atPoint:centerBothIcon];
    
}


#pragma mark SWTableViewCellDelegate
- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index;
{
    NSLog(@"Delete button touched");
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    City *city=[arrLocations objectAtIndex:indexPath.row];
    [DBWeather deleteCityByID:city.ID];
    
    [self updateDataAndView];
    
}


@end
