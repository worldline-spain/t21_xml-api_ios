//
//  AppDelegate.m
//  BaseProject
//
//  Created by Eloi Guzmán on 24/02/14.
//  Copyright (c) 2014 Tempos21. All rights reserved.
//

#import "AppDelegate.h"

#import "T21APIDefinitionParser.h"
#import "T21APIRequestFactory.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //Create the window
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

    //Add here your app start view controller
    UIViewController * vc = [[UIViewController alloc] initWithNibName:nil bundle:nil];
    vc.view.backgroundColor = [UIColor grayColor];
    vc.title = @"Base Pod Lib";
    
    //Create navigation view controller
    self.navController = [[UINavigationController alloc] initWithRootViewController:vc];
    
    //Add the view controller to the window
    self.window.rootViewController = self.navController;
    [self.window makeKeyAndVisible];
    
    
    
    
    //test code
    T21APIDefinition * api = [self loadApi];
    NSLog(@"%@", [api description]);
    
    //creating is optional, but it can be very useful to change common runtime parameters
    T21APIMap * commonContext = [T21APIMap map];
    [commonContext setObject:@"api" forKey:@"apiVersion"];
    
    //first, get the services definition
    T21APIHTTPService * serviceA = [api getService:@"ServiceGetPlanet" usingContext:commonContext];
    NSLog(@"%@", [serviceA description]);
    T21APIHTTPService * serviceB = [api getService:@"ServiceGetPlanetsList" usingContext:commonContext];
    NSLog(@"%@", [serviceB description]);
    
    //create an HTTP Map from the service definition
    T21APIHTTPMap * mapA = [serviceA createHTTPMap];
    
    //fill the HTTP Map with the required parameters
    [mapA setUrlParams:[T21APIMap mapWithDict:@{@"resourceID" : @"1"}]];
    
    //configure a new request using the HTTP Map
    NSMutableURLRequest * requestA = [T21APIRequestFactory configureURLRequest:nil withMap:mapA errors:nil loggingEnabled:YES];
    NSMutableURLRequest * requestB = [T21APIRequestFactory configureURLRequest:nil withMap:[serviceB createHTTPMap] errors:nil loggingEnabled:YES];
    NSLog(@"%@", [requestA description]);
    NSLog(@"%@", [requestB description]);
    
    return YES;
}


-(T21APIDefinition*)loadApi
{
    NSLog(@"Loading api...");
    T21APIDefinitionParser * parser = [[T21APIDefinitionParser alloc] init];
    T21APIDefinition * api = [parser getApiDefinitionForFile:@"app_api.xml"];
    NSAssert(api,@"Unable to load API");
    return api;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

BOOL isRunningTests(void)
{
    NSDictionary* environment = [[NSProcessInfo processInfo] environment];
    NSString* injectBundle = environment[@"XCInjectBundle"];
    NSString* pathExtension = [injectBundle pathExtension];
    
    return ([pathExtension isEqualToString:@"octest"] ||
            [pathExtension isEqualToString:@"xctest"]);
}


@end
