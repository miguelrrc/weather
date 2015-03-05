//
//  WEALocationTableViewController.h
//  Weather-forecast
//
//  Created by Miguel Rodriguez Rubio on 3/3/15.
//  Copyright (c) 2015 miguelrrc. All rights reserved.
//

#import "WEAForecastTableViewController.h"
#import "SWTableViewCell.h"
@interface WEALocationTableViewController : UITableViewController<UISearchBarDelegate,UISearchDisplayDelegate,SWTableViewCellDelegate>
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) IBOutlet UISearchDisplayController *searchBarController;

@end
