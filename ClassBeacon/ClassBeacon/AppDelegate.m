//
//  AppDelegate.m
//  ClassBeacon
//
//  Created by lah37@kent.ac.uk on 3/3/2015.
//  Copyright (c) 2015 lah37@kent.ac.uk. All rights reserved.
//

#import "AppDelegate.h"
#import <Parse/Parse.h>


@interface AppDelegate ()

@end

@implementation AppDelegate
NSArray *dataStore1;
NSArray *dataStore2;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:0.1922 green:0.3804 blue:0.7922 alpha:1.0]];
    
    
    /* [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"navBar.png"] forBarMetrics:UIBarMetricsDefault ];*/
    
    [[UINavigationBar appearance] setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
                                                           [UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0], NSForegroundColorAttributeName,
                                                           [UIFont fontWithName:@"System" size:21.0], NSFontAttributeName, nil]];
    //Initialise Parse connection
    
    // Enable Parse localdatastore
    [Parse enableLocalDatastore];
    
    // Initialise Parse.
    [Parse setApplicationId:@"" //input your Parse Id
     
                  clientKey:@""]; //input your parse clientKey
    
    // Track statistics around application opens.
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    
    //Initiate the Download of Class data to save in local data store
    [self pinDataStore];
    
    return YES;
}

- (void) pinDataStore{
    //Query server and save to local datastore
    //ClassList class to save Classes
    PFQuery *query = [PFQuery queryWithClassName:@"ClassList"];
    dataStore1 = [query findObjects]; // Online PFQuery results
    
    // Pin PFQuery results
    [PFObject pinAllInBackground:dataStore1];
    
    
    //lectures class to save room beacon data
    PFQuery *query1 = [PFQuery queryWithClassName:@"iBeacons"];
    // Pin PFQuery results
    dataStore2 = [query1 findObjects]; // Online PFQuery results
    
    [PFObject pinAllInBackground:dataStore2];
    
    
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
        
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    //Unpin all the objects store in the local datastore when the app is exited.
    //Unpin all the objects store in the local datastore when the app is exited.
    [PFObject unpinAllInBackground:dataStore1];
    [PFObject unpinAllInBackground:dataStore2];
    

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

@end
