//
//  WEALocationTableViewController.m
//  Weather-forecast
//
//  Created by Miguel Rodriguez Rubio on 3/3/15.
//  Copyright (c) 2015 miguelrrc. All rights reserved.
//

#import "WEALocationTableViewController.h"
#import "LocationTableViewCell.h"
@interface WEALocationTableViewController ()
@property (nonatomic, strong) UISearchDisplayController *searchController;
@end

@implementation WEALocationTableViewController
{
    UIButton *btnAdd;
    NSArray *arrCities;
    NSArray *arrLocations;
    WeatherClient *client;
    BOOL isSearching;
    CGRect originalSize;
    UITableViewCell *cellAtBottom;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    cellAtBottom=[UITableViewCell new];
    arrCities=[NSArray new];
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
    
    arrLocations=[[NSArray alloc]initWithObjects:@"40.7127,-74.005941",@"40.7127,-74.005941",@"40.7127,-74.005941",@"40.7127,-74.005941",@"40.7127,-74.005941",@"40.7127,-74.005941",@"40.7127,-74.005941",@"40.7127,-74.005941",@"-34.603723,-58.381593",@"36.5333,-6.2833", nil];
    client=[WeatherClient weatherClientManager];
    
//    self.searchController = [[UISearchDisplayController alloc] initWithSearchBar:self.mpSearchBar contentsController:self];
//    self.searchController.delegate = self;
//    self.searchController.searchResultsDataSource = self;
//    self.searchController.searchResultsDelegate = self;
////    self.searchDisplayController.displaysSearchBarInNavigationBar=YES;
//    [self.searchDisplayController setActive:NO animated:NO];
    
   // self.searchDisplayController.active = false;

    
  
}

-(void)viewWillLayoutSubviews{
     [self.view bringSubviewToFront:btnAdd];
}

-(void)viewWillAppear:(BOOL)animated{

    originalSize=self.tableView.frame;
    
    btnAdd=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    UIImage *image = [[UIImage imageNamed:@"Location-ButtonAdd"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    btnAdd.frame= CGRectMake(0, self.tableView.frame.size.height-image.size.height-20, self.view.frame.size.width, image.size.height);
    NSLog(@"Position btn y: %f size:%f",btnAdd.frame.origin.y,btnAdd.frame.size.height);
    [btnAdd setImage:image forState:UIControlStateNormal];
    [btnAdd addTarget:self action:@selector(addLocation) forControlEvents:UIControlEventTouchUpInside];
//    [btnAdd.layer setBackgroundColor:[UIColor colorWithWhite:0.0 alpha:0.1].CGColor];
    [self.view addSubview:btnAdd];
    
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
   
    
}

-(void)viewWillDisappear:(BOOL)animated{
     [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)keyboardDidShow:(NSNotification *)nsNotification {
    NSDictionary *userInfo = [nsNotification userInfo];
    CGSize keyboardSize = [[userInfo
                      objectForKey:UIKeyboardFrameBeginUserInfoKey]
                     CGRectValue].size;
    
    CGRect rect=CGRectMake(0, self.tableView.frame.origin.y ,
                           self.tableView.frame.size.width,
                           self.tableView.frame.size.height - keyboardSize.height);
    NSLog(@" rect w %f rect h %f",rect.size.width,rect.size.height);
    [self updateTextViewSize:rect];
}


- (void)updateTextViewSize:(CGRect)rect {
    
    
    
    self.tableView.frame = rect;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    if(isSearching){
        return arrCities.count;
    }
    else
    {
        
        return arrLocations.count;
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if(isSearching)
        return 44;
    else
        return 90.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    if(isSearching)
    {
        UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"cityCell" forIndexPath:indexPath];
        City *city=[arrCities objectAtIndex:indexPath.row];
        cell.textLabel.text=[NSString stringWithFormat:@"%@, %@",city.areaName,city.country];
        return cell;
    }else{
        LocationTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"locationTableViewCell" forIndexPath:indexPath];
        
        [client getWeatherFromLocation:[arrLocations objectAtIndex:indexPath.row] weather:^(Weather *w) {
            if(w!=nil)
            {
                NSLog(@"Ready to populate the Cell");
                //            CellForecastTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellForecastTableViewCell" forIndexPath:indexPath];
                cell.lblCity.text=w.city.areaName;
                cell.lblWeather.text=w.weatherDesc;
                cell.lblTemperature.text=[NSString stringWithFormat:@"%@",w.temp_C];
                cell.imgWeather.image=[UIImage imageNamed:[w imageNameForMediumIcon]];
                //            [self populateController:weather];
            }
            //        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        }];
//        if(cell==cellAtBottom)
//            cell.contentView.alpha = 0.6;
        return cell;
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    UITableViewController *controller=segue.destinationViewController;
    controller.hidesBottomBarWhenPushed=YES;
}



- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if([btnAdd isHidden])
        return ;
    
    CGRect frame = btnAdd.frame;
    
#warning    20 should be static or constant.
    frame.origin.y = scrollView.contentOffset.y + self.tableView.frame.size.height - btnAdd.frame.size.height-20;
    btnAdd.frame = frame;
    
    [self.view bringSubviewToFront:btnAdd];
    
    NSArray *visibleCells = [self.tableView visibleCells];
    NSArray *paths = [self.tableView indexPathsForVisibleRows];
    for (UITableViewCell *cell in visibleCells) {
        cell.contentView.alpha = 1.0;
    }
    UITableViewCell *lastCell=[visibleCells lastObject];
    lastCell.contentView.alpha=0.1;

}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    
    [searchBar resignFirstResponder];
    [self updateTextViewSize:originalSize];
    [self.searchBar removeFromSuperview];
    isSearching=NO;
//    btnAdd.frame= CGRectMake(0, super.tableView.frame.size.height-btnAdd.imageView.image.size.height-20, self.view.frame.size.width, btnAdd.imageView.image.size.height);
    [btnAdd setHidden:NO];
    [self.navigationItem.rightBarButtonItem setTintColor:nil];
    [self.navigationItem.rightBarButtonItem setEnabled:YES];
    [self.tableView reloadData];
}
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    
    
    isSearching=YES;
    NSLog(@"Looking for results");
    
    [client getLocations:searchBar.text cities:^(NSArray *cities) {

        if(cities){
            arrCities=[NSArray arrayWithArray:cities];
            [self.tableView reloadData];
//            self.tableView.frame=CGRectMake(0, 0, 150, 400);
            
            NSLog(@"We have cities");
            
        }else{
            arrCities=[NSArray arrayWithObject:nil];
            NSLog(@"No results");
            [self.tableView reloadData];
            
        }
    }];
   
//    [self.searchDisplayController.searchResultsTableView reloadData];
}
-(void)addLocation{

    [btnAdd setHidden:YES];
    [self.navigationItem.rightBarButtonItem setTintColor:[UIColor clearColor]];
    [self.navigationItem.rightBarButtonItem setEnabled:NO];
    [self.navigationController.navigationBar addSubview:self.searchBar];
    [self.searchBar becomeFirstResponder];
    }
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
