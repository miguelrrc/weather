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
#import "Weather+Utilities.h"
#import "MBProgressHUD.h"
#import "WEATodayViewController.h"
#import "DBWeather.h"
#import "WEAForecastTableViewController.h"
#import "SharedCity.h"

static NSInteger const btnAddBottomSpace = 20;//Space between the bottom of the view and btnAdd

@interface WEALocationTableViewController ()

@property (nonatomic, strong) UISearchDisplayController *searchController;

@end

@implementation WEALocationTableViewController
{
    UIButton *btnAdd;
    NSArray *arrCities;//Array of cities from the search
    NSMutableArray *arrLocations;//Array of locations from the database
    WeatherClient *client;//Manager for the WS
    BOOL isSearching;//Toggle between the two "tables"
    CGRect originalTableViewSize;//The table for search is smaller
    
    UIImage* deleteImage;//Image for the deleteButton
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initializeData];
    
    [self setupViews];
    
    [self getLocations];
    
}


/**
 * Move btnAdd to the the front
 */
-(void)viewWillLayoutSubviews{
    [self.view bringSubviewToFront:btnAdd];
}

/**
 * Initialize data for the first time
 */
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    originalTableViewSize=self.tableView.frame;//We get the size for the tableView to use in keyboardShow or keyboardHide
    
    [self btnAddToView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Notifications

/**
 * Get the size of the keyboard to update the size of the tableView. It's used for the search
 */
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

/**
 * Move the button with the scroll in the tableView
 */
-(void)scrollAddButton:(CGFloat)y{
    CGRect frame = btnAdd.frame;
    
    frame.origin.y = y + self.tableView.frame.size.height - btnAdd.frame.size.height-btnAddBottomSpace;
    btnAdd.frame = frame;
    
    [self.view bringSubviewToFront:btnAdd];
}

/**
 * We control the alpha for the last cell and the position for the btnAdd
 */
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    //If we are showing the results from search. BtnAdd is hidden so we don't care about its position
    if([btnAdd isHidden])
        return ;
    
    [self scrollAddButton:scrollView.contentOffset.y];
    
    [self updateAlphaCell];//Alpha for last cell
    
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
    else//Locations
    {
        
        return arrLocations.count;
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if(isSearching)//Cities
        return 44;
    else//Locations
        return 90.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    if(isSearching)//Cities
    {
        UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"cityCell" forIndexPath:indexPath];
        City *city=[arrCities objectAtIndex:indexPath.row];
        cell.textLabel.text=[NSString stringWithFormat:@"%@, %@",city.areaName,city.country];
        return cell;
    }else{//Locations
        
         City* cityFromArray=[arrLocations objectAtIndex:indexPath.row];
        
        LocationTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"locationTableViewCell" forIndexPath:indexPath];
        
        cell.lblCity.text=cityFromArray.areaName;
        cell.lblTemperature.text=@"-";
        cell.lblWeather.text=@"Retrieving data...";
        
        if(cityFromArray.ID.intValue==-1)//It's the location from current Position
        {
            [cell.imgCurrentLocation setHidden:NO];
        }else
        {
            [cell.imgCurrentLocation setHidden:YES];
            
            cell.rightUtilityButtons = [self getrightButtonsForSwipeCell];//We can delete only cities in DB.
            cell.delegate=self;//Delegate for SwipeDelegate

        }
        
        NSString *location=[NSString stringWithFormat:@"%@,%@",cityFromArray.latitude,cityFromArray.longitude];
        
        [client getWeatherFromLocation:location numberOfDays:[NSNumber numberWithInt:1] city:^(City *city) {
            
            if(city!=nil)//We have a city
            {
                NSLog(@"Ready to populate the WeatherCell after ws got data");
                
                cell.lblWeather.text=city.weather.weatherDesc;
                cell.lblTemperature.text=[NSString stringWithFormat:@"%@",[city.weather getTemperatureBasedOnScale]];
                cell.imgWeather.image=[UIImage imageNamed:[city.weather imageNameForMediumIcon]];
            }
        }];
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(!isSearching)//If we are not searching. Then we get the data from the selected Row.
    {

        City *citySelected=[arrLocations objectAtIndex:self.tableView.indexPathForSelectedRow.row];
        
        //ID=-1 From Location and ID>0 From DB
        SharedCity *sharedCity=[SharedCity sharedCity];
        if(citySelected.ID.intValue>0)//>0 From DB
            sharedCity.cityID=citySelected.ID;
        else//Geolocation
            sharedCity.cityID=nil;
        
       
        
        [self.navigationController popViewControllerAnimated:YES];//Go back to the parent
        
        return;

    }
    //Add city to database
    City *city=[arrCities objectAtIndex:indexPath.row];
    
    //TODO: Implement in a different layer.
    [DBWeather insert:city];
    
    [self removeSearchBarAndShowWeatherTable];//Clean everything from the search
    
    [self updateDataAndView];//Show locations
   
    
}


#pragma mark Private Methods

/**
 * Initialize data for the first time
 */
-(void)initializeData{
    //Create Delete Image
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        deleteImage=[self createImageForDelete];
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"Image done");
        });
    });
    
    arrCities=[NSArray new];
    client=[WeatherClient weatherClientManager];
    arrLocations=[NSMutableArray new];
}

/**
 * Configure the searchBar and the deleteImage;
 */
-(void)setupViews{
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    [self.navigationItem setHidesBackButton:YES animated:YES];
    
    self.navigationItem.rightBarButtonItem =
    [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                  target:self
                                                  action:@selector(done:)];
    self.navigationItem.rightBarButtonItem.style = UIBarButtonItemStyleDone;

    
    [self customizeSearchBar];
    

    
}

/**
 * Customize the Search Bar View;
 */
-(void)customizeSearchBar{
    
    
    self.searchBar = [[UISearchBar alloc] init];
    [self.searchBar setFrame:CGRectMake(0, 0, self.view.frame.size.width, 55)];
    [self.searchBar setShowsCancelButton:YES animated:YES];
    self.searchBar.delegate = self;
    

    //Background Image
    [self.searchBar setSearchFieldBackgroundImage:[UIImage imageNamed:@"Input"] forState:UIControlStateNormal];
    
    //Magnifying glass
    [self.searchBar setImage:[UIImage imageNamed:@"Search"] forSearchBarIcon:UISearchBarIconSearch state:UIControlStateNormal];
    
    //Close
    [[UISearchBar appearance] setImage:[UIImage imageNamed:@"Close"] forSearchBarIcon:UISearchBarIconClear state:UIControlStateNormal];
   
    //Text input style
    [[UITextField appearanceWhenContainedIn:[UISearchBar class], nil] setFont:[UIFont fontWithName:@"Proxima Nova-Regular" size:16]];
    
    [[UITextField appearanceWhenContainedIn:[UISearchBar class], nil] setTextColor:[UIColor colorWithRed:(47/255.0) green:(145.0/255.0) blue:255 alpha:1.0]];
    
    
    //Custom Cancel Button. Appearance crash with title :(.
    
    //Necessary for iOS 7
    UIButton *cancelButton;
    UIView *topView = self.searchBar.subviews[0];
    for (UIView *subView in topView.subviews) {
        if ([subView isKindOfClass:NSClassFromString(@"UINavigationButton")]) {
            cancelButton = (UIButton*)subView;
        }
    }
    if (cancelButton) {
        //Set the new title of the cancel button
        [cancelButton setTitle:@"Close" forState:UIControlStateNormal];
        [cancelButton.titleLabel setFont:[UIFont fontWithName:@"Proxima Nova-Regular" size:16]];
        [cancelButton setTitleColor:[UIColor colorWithRed:(47/255.0) green:(145.0/255.0) blue:255 alpha:1.0] forState:UIControlStateNormal];
    }
}
/**
 * Go back
 */
-(void)done:(UIBarButtonItem*)sender{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

/**
 * Add the btnAdd button to the view
 */
-(void)btnAddToView{
    
    btnAdd=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    UIImage *image = [[UIImage imageNamed:@"Location-ButtonAdd"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    btnAdd.frame= CGRectMake(0, self.tableView.frame.size.height-image.size.height-btnAddBottomSpace, self.view.frame.size.width, image.size.height);
    
    NSLog(@"Position btn y: %f size:%f",btnAdd.frame.origin.y,btnAdd.frame.size.height);
    
    [btnAdd setImage:image forState:UIControlStateNormal];
    [btnAdd addTarget:self action:@selector(addLocation) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:btnAdd];
}

/**
 * Update the size of the tableView between search and locations
 */
- (void)updateTableViewSize:(CGRect)rect {
    self.tableView.frame = rect;
}

/**
 *Get locations from current location and DB
 */
-(void)getLocations{
    if (arrLocations.count>0) {//Remove old data
        [arrLocations removeAllObjects];
    }
    
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"MyCity"])//First row will be user location
    {
        
        NSDictionary * dictMyCity=[[NSUserDefaults standardUserDefaults] objectForKey:@"MyCity"];
        City *myCity=[[City alloc]initWithDictionary:dictMyCity error:nil];
        myCity.ID=[NSNumber numberWithInt:-1];
        [arrLocations addObject:myCity];
    }
    
    
    [arrLocations addObjectsFromArray:[DBWeather getAll]];
    
}

/**
 *Get locations and reload TableView
 */
-(void)updateDataAndView{
    [self getLocations];
    [self.tableView reloadData];
}

/**
 *Alpha for the last cell
 */
-(void)updateAlphaCell{
    
    NSArray *visibleCells = [self.tableView visibleCells];
    for (UITableViewCell *cell in visibleCells) {
        cell.contentView.alpha = 1.0;
    }
    UITableViewCell *lastCell=[visibleCells lastObject];
    lastCell.contentView.alpha=0.1;
    
    
}

/**
 *Hide search and show locations
 */
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    
    [self removeSearchBarAndShowWeatherTable];
    
    [self.tableView reloadData];
    
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

/**
 *Get cities from the WS
 */
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    
    
    isSearching=YES;
    NSLog(@"Looking for results");
    
    [client getLocations:searchBar.text cities:^(NSArray *cities) {
        
        if(cities){
            arrCities=[NSArray arrayWithArray:cities];
            NSLog(@"We have cities");
            
        }else{
            arrCities=[NSArray new  ];
            NSLog(@"No results");
        }
        
        [self.tableView reloadData];
    }];
    
}

/**
 *Show the searchBar
 */
-(void)addLocation{
    
    [btnAdd setHidden:YES];
    
    [self.navigationItem.rightBarButtonItem setTintColor:[UIColor clearColor]];
    [self.navigationItem.rightBarButtonItem setEnabled:NO];
    
    [self.navigationController.navigationBar addSubview:self.searchBar];
    
    
    
    
   
    
    [self.searchBar becomeFirstResponder];
}

/**
 *Get the utilities buttons for the SwipeCell
 */
- (NSArray *)getrightButtonsForSwipeCell
{
    NSMutableArray *rightUtilityButtons = [NSMutableArray new];
    [rightUtilityButtons sw_addUtilityButtonWithColor:[UIColor clearColor] icon:deleteImage];
    return rightUtilityButtons;
}

/**
 *Delete button is one image over another.
 @return Image for the DeleteButton
 */
-(UIImage *)createImageForDelete
{
    UIImage *icon=[UIImage imageNamed:@"Delete"];//Big Image
    UIImage *deleteIcon=[UIImage imageNamed:@"DeleteIcon"];//Small Image X
    
    CGPoint centerBigIcon=CGPointMake(icon.size.width/2, icon.size.height/2);//Get center of the big image
    
    CGPoint originPositionForSmallImage=CGPointMake(centerBigIcon.x-deleteIcon.size.width/2, centerBigIcon.y-deleteIcon.size.height/2);//Position for the second one
    
    return [UIImage drawImage:deleteIcon inImage:icon atPoint:originPositionForSmallImage];//Utility to create image
    
}


#pragma mark SWTableViewCellDelegate

/**
 *Delete button action.
 */
- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index;
{
    NSLog(@"Delete button touched");
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    City *city=[arrLocations objectAtIndex:indexPath.row];
    [DBWeather deleteCityByID:city.ID];
    
    [self updateDataAndView];
    
    SharedCity *sharedCity=[SharedCity sharedCity];
    if(sharedCity.cityID.intValue==city.ID.intValue)
    {
        NSLog(@"The selected City For Today and Forecast is deleted");
        sharedCity.cityID=nil;
    }
    
}


#pragma mark Segue
//
//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
//{
//    WEATodayViewController *controller=segue.destinationViewController;
//    City *citySelected=[arrLocations objectAtIndex:self.tableView.indexPathForSelectedRow.row];
//    if(citySelected.ID.intValue>0)//It's from DB
//        controller.cityID=citySelected.ID;
//    else
//        controller.cityID=nil;
//}


@end
