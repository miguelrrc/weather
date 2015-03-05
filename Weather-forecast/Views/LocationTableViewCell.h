//
//  LocationTableViewCell.h
//  Weather-forecast
//
//  Created by Miguel Rodriguez Rubio on 3/3/15.
//  Copyright (c) 2015 miguelrrc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWTableViewCell.h"
@interface LocationTableViewCell : SWTableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lblTemperature;
@property (weak, nonatomic) IBOutlet UILabel *lblCity;
@property (weak, nonatomic) IBOutlet UILabel *lblWeather;
@property (weak, nonatomic) IBOutlet UIImageView *imgWeather;
@property (weak, nonatomic) IBOutlet UIImageView *imgCurrentLocation;

@end
