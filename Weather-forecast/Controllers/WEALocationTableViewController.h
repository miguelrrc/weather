//
//  WEALocationTableViewController.h
//  Weather-forecast
//
//  Created by Miguel Rodriguez Rubio on 3/3/15.
//  Copyright (c) 2015 miguelrrc. All rights reserved.
//

#import "WEAForecastTableViewController.h"

@interface WEALocationTableViewController : UITableViewController<UISearchBarDelegate,UISearchDisplayDelegate>
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) IBOutlet UISearchDisplayController *searchBarController;

@end
