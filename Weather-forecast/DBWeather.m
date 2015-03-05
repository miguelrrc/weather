//
//  DBWeather.m
//  Weather-forecast
//
//  Created by Miguel Rodriguez Rubio on 4/3/15.
//  Copyright (c) 2015 miguelrrc. All rights reserved.
//

#import "DBWeather.h"
#import  "DatabaseManager.h"
@implementation DBWeather

+(NSMutableArray *) getAll{
    
    DatabaseManager *databaseManager = [DatabaseManager sharedManager];
    NSMutableArray *dbArray = [[NSMutableArray alloc] init];
    
    [databaseManager.databaseQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *results = [db executeQuery:@"SELECT * FROM City"];
        
        while([results next])
        {
            City *city=[City new];
            city.areaName=[results stringForColumn:@"area_name"];
            city.latitude=[results stringForColumn:@"latitude"];
            city.longitude=[results stringForColumn:@"longitude"];
            city.country=[results stringForColumn:@"country"];
            city.ID=[NSNumber numberWithInt:[results intForColumn:@"id"]];
            
            [dbArray addObject:city];
            
        }
        [results close];
    }];
    
    return dbArray;
    
}

+(NSNumber *)insert:(City*)city{
    
        // insert customer into database
        DatabaseManager *databaseManager = [DatabaseManager sharedManager];
        __block NSNumber *  lastId;
        [databaseManager.databaseQueue inDatabase:^(FMDatabase *db) {
            
            BOOL success =  [db executeUpdate:
                             @"INSERT INTO City "
                             "(area_name"
                             ",country"
                             ",latitude"
                             ",longitude)"
                             "VALUES (?,?,?,?);",
                             city.areaName
                             ,city.country
                             ,city.latitude
                             ,city.longitude
                             ,nil];
            if(success)
                lastId=[NSNumber numberWithLongLong:[db lastInsertRowId]];
            
            
        }];
        return lastId;

}
@end
