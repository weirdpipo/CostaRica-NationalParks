//
//  PSAppDelegate.h
//  BroBoard
//
//  Created by Peter Shih on 5/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PPRevealSideViewController.h"

@class PSViewController;

@interface PSAppDelegate : UIResponder <UIApplicationDelegate,PPRevealSideViewControllerDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) PSViewController *viewController;
@property (strong, nonatomic) PPRevealSideViewController *revealSideViewController;

@end
