//
//  PSAppDelegate.m
//  BroBoard
//
//  Created by Peter Shih on 5/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PSAppDelegate.h"

#import "PSViewController.h"
#import <Parse/Parse.h>
#import "CRSlideView.h"

@implementation PSAppDelegate

@synthesize window = _window;
@synthesize viewController = _viewController;
@synthesize revealSideViewController = _revealSideViewController;

- (void)dealloc
{
    [_revealSideViewController release];
    [_window release];
    [_viewController release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //set up parse
    [Parse setApplicationId:@"1a6rtpL0SghGPlT8XS01vjVID1dH1SSaTWdew4Xg"
                  clientKey:@"5yZuFbhEAkezSeo2gzW6ca4dY6RSJFOufjBHTEht"];
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    // Override point for customization after application launch.
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        self.viewController = [[[PSViewController alloc] initWithNibName:@"PSViewController_iPhone" bundle:nil] autorelease];
    } else {
        self.viewController = [[[PSViewController alloc] initWithNibName:@"PSViewController_iPad" bundle:nil] autorelease];
    }
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:self.viewController];
    _revealSideViewController = [[PPRevealSideViewController alloc] initWithRootViewController:nav];
    _revealSideViewController.delegate = self;
    PPRevealSideInteractions inter = PPRevealSideInteractionNone;
    inter |= PPRevealSideInteractionNavigationBar;
    inter |= PPRevealSideInteractionContentView;
    self.revealSideViewController.panInteractionsWhenClosed = inter;
    [self.revealSideViewController setDirectionsToShowBounce:PPRevealSideDirectionLeft];
    CRSlideView *popViewController = [[CRSlideView alloc] init];
    [self.revealSideViewController preloadViewController:popViewController
                                                 forSide:PPRevealSideDirectionLeft
                                              withOffset:250.0f];
    
    
    self.window.rootViewController = _revealSideViewController;
    [self.window makeKeyAndVisible];
    return YES;
}
#pragma mark - PPRevealSideViewController delegate

- (void) pprevealSideViewController:(PPRevealSideViewController *)controller willPushController:(UIViewController *)pushedController {
    
}

- (void) pprevealSideViewController:(PPRevealSideViewController *)controller didPushController:(UIViewController *)pushedController {
    
}

- (void) pprevealSideViewController:(PPRevealSideViewController *)controller willPopToController:(UIViewController *)centerController {
    
}

- (void) pprevealSideViewController:(PPRevealSideViewController *)controller didPopToController:(UIViewController *)centerController {
    
}

- (void) pprevealSideViewController:(PPRevealSideViewController *)controller didChangeCenterController:(UIViewController *)newCenterController {
    
}

- (BOOL) pprevealSideViewController:(PPRevealSideViewController *)controller shouldDeactivateDirectionGesture:(UIGestureRecognizer*)gesture forView:(UIView*)view {
    return NO;
}

- (PPRevealSideDirection)pprevealSideViewController:(PPRevealSideViewController*)controller directionsAllowedForPanningOnView:(UIView*)view {
    
    if ([view isKindOfClass:NSClassFromString(@"UIWebBrowserView")]) return PPRevealSideDirectionLeft | PPRevealSideDirectionRight;
    
    return PPRevealSideDirectionLeft | PPRevealSideDirectionRight | PPRevealSideDirectionTop | PPRevealSideDirectionBottom;
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

@end
