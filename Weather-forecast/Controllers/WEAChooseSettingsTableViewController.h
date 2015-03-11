//
//  WEAChooseSettingsTableViewController.h
//  Weather-forecast
//
//  Created by Miguel Rodriguez Rubio on 5/3/15.
//  Copyright (c) 2015 miguelrrc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WEAChooseSettingsTableViewController : UITableViewController

@property (copy) BOOL (^typeSelected)(BOOL changed, NSError **error);
@property (weak, nonatomic)  NSNumber *typeSettings;
@end
