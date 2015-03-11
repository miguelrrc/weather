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
+(City*)getCityByID:(NSNumber *)ID{
    
    DatabaseManager *databaseManager = [DatabaseManager sharedManager];
    City *city=[City new];
    
    [databaseManager.databaseQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *results = [db executeQuery:@"SELECT * FROM City WHERE ID=?",ID];
        
        while([results next])
        {
            
            city.areaName=[results stringForColumn:@"area_name"];
            city.latitude=[results stringForColumn:@"latitude"];
            city.longitude=[results stringForColumn:@"longitude"];
            city.country=[results stringForColumn:@"country"];
            city.ID=[NSNumber numberWithInt:[results intForColumn:@"id"]];
            
//            [dbArray addObject:city];
            
        }
        [results close];
    }];
    
    return city;
    

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

+(BOOL)deleteCityByID:(NSNumber *)ID{
    DatabaseManager *databaseManager = [DatabaseManager sharedManager];
    
    __block BOOL success;
    [databaseManager.databaseQueue inDatabase:^(FMDatabase *db) {
        
        success =  [db executeUpdate:
                    @"DELETE FROM City "
                    " WHERE id=? ",ID];
        
        if (success) {
            NSLog(@"Deleted row from DB");
            //            [db commit];
            
        }else {
            NSLog(@"Error deleting row from DB");
        }
    }];
    
    return success;
}
@end
