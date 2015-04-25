//
//  AppDelegate.m
//  TUTCafeterias
//
//  Created by Aleksander Grzyb on 24/04/15.
//  Copyright (c) 2015 Aleksander Grzyb. All rights reserved.
//

#import "AppDelegate.h"
#import <Parse/Parse.h>
#import "SHFoodViewController.h"
#import "SHCategoriesViewController.h"
#import "MSDynamicsDrawerViewController.h"

@interface AppDelegate () <MSDynamicsDrawerViewControllerDelegate, SHCategoriesViewControllerDelegate>
@property (weak, nonatomic) SHFoodViewController *foodViewController;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [Parse enableLocalDatastore];

    // Initialize Parse.
    [Parse setApplicationId:@"4yCQ8RgcE7FSJjgB4z7ijaTcMhRiG7aJjx4MofE6"
                  clientKey:@"CxkBvDwaoBciKoPyt525nzpam8Q29bJlbYnc1uD0"];

    // [Optional] Track statistics around application opens.
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

    self.dynamicsDrawerViewController = [MSDynamicsDrawerViewController new];
    self.dynamicsDrawerViewController.delegate = self;

    // Front view controller
    SHFoodViewController *foodViewController = [SHFoodViewController new];
    foodViewController.dynamicsDrawerViewController = self.dynamicsDrawerViewController;

    // Navigation controller for main food and map controller on the right
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:foodViewController];

    // Keeping reference to pass filters from categories vc
    self.foodViewController = foodViewController;

    // Left view controller
    SHCategoriesViewController *categoriesViewController = [SHCategoriesViewController new];
    categoriesViewController.dynamicsDrawerViewController = self.dynamicsDrawerViewController;
    categoriesViewController.delegate = self;
    [self.dynamicsDrawerViewController setDrawerViewController:categoriesViewController forDirection:MSDynamicsDrawerDirectionLeft];

    self.dynamicsDrawerViewController.paneViewController = navigationController;

    self.window.rootViewController = self.dynamicsDrawerViewController;
    [self.window makeKeyAndVisible];

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

#pragma mark -
#pragma mark Categories View Controller Delegete

- (void)viewController:(SHCategoriesViewController *)categoriesViewController didUpdateFilters:(NSArray *)filters
{
    self.foodViewController.filters = filters;
}

@end
