//
//  AppDelegate.m
//  CCTracker
//
//  Created by Patil, Chandrachud K. on 10/12/15.
//  Copyright © 2015 Patil, Chandrachud K. All rights reserved.
//

#import "AppDelegate.h"
#import "ProfileViewController.h"
#import "ITRLeftMenuController.h"
#import "AddNewCardController.h"
#import "ViewController.h"



#define             SIGNUPISDONE                  @"ISSIGNUPISDONE"
#define             FALSESTR                      @"FALSE"
#define             TRUESTR                       @"TRUE"


@interface AppDelegate ()
{
    ProfileViewController *profileCont;
}
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    _didOpenWithURL = NO;
    
    
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    
#if 0
    
    //sidemenu created with content view controller & menu view controller
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:[ProfileViewController controller]];
    
    
    ITRLeftMenuController *leftMenuViewController = [ITRLeftMenuController controller];
    _itrAirSideMenu = [[ITRAirSideMenu alloc] initWithContentViewController:navigationController leftMenuViewController:leftMenuViewController];
    
    _itrAirSideMenu.backgroundImage = [UIImage imageNamed:@"menu_bg"];
    
    //optional delegate to receive menu view status
    _itrAirSideMenu.delegate = leftMenuViewController;
    
    //content view shadow properties
    _itrAirSideMenu.contentViewShadowColor = [UIColor blackColor];
    _itrAirSideMenu.contentViewShadowOffset = CGSizeMake(0, 0);
    _itrAirSideMenu.contentViewShadowOpacity = 0.6;
    _itrAirSideMenu.contentViewShadowRadius = 12;
    _itrAirSideMenu.contentViewShadowEnabled = YES;
    
    //content view animation properties
    _itrAirSideMenu.contentViewScaleValue = 0.7f;
    _itrAirSideMenu.contentViewRotatingAngle = 30.0f;
    _itrAirSideMenu.contentViewTranslateX = 130.0f;
    
    //menu view properties
    _itrAirSideMenu.menuViewRotatingAngle = 30.0f;
    _itrAirSideMenu.menuViewTranslateX = 130.0f;
    
    self.window.rootViewController = _itrAirSideMenu;
     
#else
     
    
    [self showTheLoginScreen];
    

#endif

    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];

    return YES;
}


-(void)showTheHomeScreenWithAnimationFlag:(BOOL)flag{
    
    //sidemenu created with content view controller & menu view controller
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:[ProfileViewController controller]];
    
    ITRLeftMenuController *leftMenuViewController = [ITRLeftMenuController controller];
    _itrAirSideMenu = [[ITRAirSideMenu alloc] initWithContentViewController:navigationController leftMenuViewController:leftMenuViewController];
    
    _itrAirSideMenu.backgroundImage = [UIImage imageNamed:@"menu_bg"];
    
    //optional delegate to receive menu view status
    _itrAirSideMenu.delegate = leftMenuViewController;
    
    //content view shadow properties
    _itrAirSideMenu.contentViewShadowColor = [UIColor blackColor];
    _itrAirSideMenu.contentViewShadowOffset = CGSizeMake(0, 0);
    _itrAirSideMenu.contentViewShadowOpacity = 0.6;
    _itrAirSideMenu.contentViewShadowRadius = 12;
    _itrAirSideMenu.contentViewShadowEnabled = YES;
    
    //content view animation properties
    _itrAirSideMenu.contentViewScaleValue = 0.7f;
    _itrAirSideMenu.contentViewRotatingAngle = 30.0f;
    _itrAirSideMenu.contentViewTranslateX = 130.0f;
    
    //menu view properties
    _itrAirSideMenu.menuViewRotatingAngle = 30.0f;
    _itrAirSideMenu.menuViewTranslateX = 130.0f;
    
    self.window.rootViewController = _itrAirSideMenu;

}

-(void)showTheLoginScreen{

//    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    ViewController *lObjCtrl = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ViewController"];
    
    UINavigationController *navigationController = [[UINavigationController alloc]initWithRootViewController:lObjCtrl];
    self.window.rootViewController = navigationController;
}

-(void)showTheAddCardScreen{
    
    AddNewCardController *lObjVC = [[AddNewCardController alloc] init];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:lObjVC];
    self.window.rootViewController = navigationController;
    
    /*
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    return [storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([ViewController class])];

    
     */
    
}


-(bool)isSignUpDone{
    
    
    bool isSignUpDone = false;
    
    NSUserDefaults *data = [NSUserDefaults standardUserDefaults];
    
    NSString *retVal =  [data objectForKey:SIGNUPISDONE];
    
    
    if (nil == retVal || [retVal isEqualToString:FALSESTR]) {
        
        [self showTheAddCardScreen];
        
    }
    else if ([retVal isEqualToString:TRUESTR]){
        
        isSignUpDone = true;
        
    }
    
    
    /*
    
    bool firstLaunch = NSUserDefaults.standardUserDefaults().boolForKey("FirstLaunch")
    if firstLaunch  {
        
    }
    else {
        
        keychain.clear()
        
        NSUserDefaults.standardUserDefaults().setBool(true, forKey: "FirstLaunch")
    }
    
    */
    
    return isSignUpDone;
    
    
}

-(void)openNewExpense
{
    
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
    
    if (_didOpenWithURL) {
        NSLog(@"yaaaaaay didOpenWithURL");
       // UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"didOpenWithURL" message:@"" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
//        [alert show];
        
//        profileCont = [[ProfileViewController alloc]init];
//        UIViewController *contv = [[UIApplication sharedApplication].keyWindow rootViewController];
//        [contv.navigationController pushViewController:profileCont animated:YES];
        [self showTheHomeScreenWithAnimationFlag:NO];
    }
    
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    _didOpenWithURL = YES;

       return YES;
}
@end
