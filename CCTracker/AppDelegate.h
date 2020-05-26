//
//  AppDelegate.h
//  CCTracker
//
//  Created by Patil, Chandrachud K. on 10/12/15.
//  Copyright © 2015 Patil, Chandrachud K. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ITRAirSideMenu.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property(nonatomic, assign) BOOL didOpenWithURL;
@property ITRAirSideMenu *itrAirSideMenu;

@property NSDictionary *userProfileDict;
@property NSDictionary *cardDict;


-(void)showTheHomeScreenWithAnimationFlag:(BOOL)flag;
-(void)showTheLoginScreen;

@end

