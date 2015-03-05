//
//  NSDate+Format.m
//  Weather-forecast
//
//  Created by Miguel Rodriguez Rubio on 3/3/15.
//  Copyright (c) 2015 miguelrrc. All rights reserved.
//

#import "NSDate+Format.h"

@implementation NSDate (Format)

+(NSString*)getNameForDay:(NSDate*)myDate{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"EEEE"];
    dateFormatter.locale=[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    NSString *dayName = [dateFormatter stringFromDate:myDate];
    return dayName;
}


+(NSDate*)addNumberOfDays:(int)days toDate:(NSDate*)date
{
    NSDateComponents *dayComponent = [[NSDateComponents alloc] init];
    dayComponent.day = days;
    
    NSCalendar *theCalendar = [NSCalendar currentCalendar];
    date = [theCalendar dateByAddingComponents:dayComponent toDate:[NSDate date] options:0];
    return date;
}
@end
