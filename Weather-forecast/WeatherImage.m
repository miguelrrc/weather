//
//  WeatherImage.m
//  Weather-forecast
//
//  Created by Miguel Rodriguez Rubio on 2/3/15.
//  Copyright (c) 2015 miguelrrc. All rights reserved.
//

#import "WeatherImage.h"

@implementation WeatherImage

+ (NSDictionary *)imageMap {
    static NSDictionary *_imageMap = nil;
    if (! _imageMap) {
        _imageMap=@{
                    @"395":	@"Cloudy",
                    @"392":	@"Cloudy",
                    @"389":	@"Lightning",
                    @"386":	@"Lightning",
                    @"377":	@"Cloudy",
                    @"374":	@"Cloudy",
                    @"371":	@"Cloudy",
                    @"368":	@"Cloudy",
                    @"365":	@"Cloudy",
                    @"362":	@"Cloudy",
                    @"359":	@"Cloudy",
                    @"356":	@"Cloudy",
                    @"353":	@"Cloudy",
                    @"350":	@"Cloudy",
                    @"338":	@"Cloudy",
                    @"335":	@"Cloudy",
                    @"332":	@"Cloudy",
                    @"329":	@"Cloudy",
                    @"326":	@"Cloudy",
                    @"323":	@"Cloudy",
                    @"320":	@"Cloudy",
                    @"317":	@"Cloudy",
                    @"314":	@"Cloudy",
                    @"311":	@"Cloudy",
                    @"308":	@"Cloudy",
                    @"305":	@"Cloudy",
                    @"302":	@"Cloudy",
                    @"299":	@"Cloudy",
                    @"296":	@"Cloudy",
                    @"293":	@"Cloudy",
                    @"284":	@"Cloudy",
                    @"281":	@"Cloudy",
                    @"266":	@"Cloudy",
                    @"263":	@"Cloudy",
                    @"260":	@"Cloudy",
                    @"248":	@"Cloudy",
                    @"230":	@"Cloudy",
                    @"227":	@"Cloudy",
                    @"200":	@"Lightning",
                    @"185":	@"Cloudy",
                    @"182":	@"Cloudy",
                    @"179":	@"Cloudy",
                    @"176":	@"Cloudy",
                    @"143":	@"Cloudy",
                    @"122":	@"Cloudy",
                    @"119":	@"Cloudy",
                    @"116":	@"Cloudy",
                    @"113":	@"Sun",
                    };    }
    return _imageMap;
}




+(NSString*)getImageNameForIcon:(NSString *)icon{
    return [WeatherImage imageMap][icon];
}
@end
