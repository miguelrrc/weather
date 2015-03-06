//
//  AppDelegate.m
//  Weather-forecast
//
//  Created by Miguel Rodriguez Rubio on 2/3/15.
//  Copyright (c) 2015 miguelrrc. All rights reserved.
//

#import "AppDelegate.h"
#import "AFNetworkActivityIndicatorManager.h"
@interface AppDelegate ()

@end

@implementation AppDelegate
{
    NSString *databaseName;
    NSString *databasePath;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    UIImage *line=[UIImage imageNamed:@"NLine"];
    [[UINavigationBar appearance] setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault
     ];
    [[UINavigationBar appearance] setShadowImage:line];
    [[UINavigationBar appearance]setBackgroundColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setShadowImage:[UIImage imageNamed:@"Line.png"]];

    
    databaseName = @"weather.sqlite";
    
    NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDir = [documentPaths objectAtIndex:0];
    databasePath = [documentDir stringByAppendingPathComponent:databaseName];
    
    [self createAndCheckDatabase];
    
    
    [self setupUserDefaultsByDefault];

    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];//AFNetworking will deal with ActivityIndicator
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

-(void) createAndCheckDatabase
{
//    NSString * databaseName = @"epctracker.sqlite";
    
    //    NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    //    NSString *documentDir = [documentPaths objectAtIndex:0];
//    NSString *databasePathLocal = [self getDatabasePath];
    BOOL success;
    
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    success = [fileManager fileExistsAtPath:databasePath];
    
    if(success) return;
    
    NSString *databasePathFromApp = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:databaseName];
    
    success=[fileManager copyItemAtPath:databasePathFromApp toPath:databasePath error:nil];
    if(success)
        NSLog(@"Everything ok with the database");
    else
        NSLog(@"There is a problem with the database");
    
}

-(void) setupUserDefaultsByDefault{
    
    //By default 1 is Celsius and meters
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:1] forKey:@"LengthSettings"];
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:1] forKey:@"TemperatureSettings"];
}

@end
