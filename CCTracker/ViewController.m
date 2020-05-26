//
//  ViewController.m
//  CCTracker
//
//  Created by Patil, Chandrachud K. on 10/12/15.
//  Copyright © 2015 Patil, Chandrachud K. All rights reserved.
//

#import "ViewController.h"
#import "Header.h"
#import "ProfileViewController.h"
#import "IQKeyboardManager.h"
#import "AppDelegate.h"
#import "AddNewCardController.h"
#import "ServerCommunicator.h"
#import "MBProgressHUD.h"

#define IS_IPHONE_5 ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )

@interface ViewController ()<UITextFieldDelegate,MBProgressHUDDelegate>
{
    MBProgressHUD *HUD;
}

@property(nonatomic, strong) ProfileViewController *profileController;
@property(nonatomic, strong) NSString  *userId;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configureLoginButton];
    [[IQKeyboardManager sharedManager] setToolbarManageBehaviour:IQAutoToolbarByPosition];
    [IQKeyboardManager sharedManager].shouldToolbarUsesTextFieldTintColor = YES;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.userNameField.text = @"salman";
    self.passwordField.text = @"khan";

    self.navigationController.navigationBarHidden = YES;
}

-(void)viewDidAppear:(BOOL)animated
{
    //    AppDelegate *del = [UIApplication sharedApplication].delegate;
    //    if (del.didOpenWithURL) {
    //        NSLog(@"yaaaaaay didOpenWithURL");
    //        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"didOpenWithURL" message:@"" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    //        [alert show];
    //    }
}

-(void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    if (IS_IPHONE_5) {
        self.verticalConstraint.constant = 30;
    }
    else
    {
        self.verticalConstraint.constant = 90;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Other Methods

-(void)configureLoginButton
{
    self.loginButton.layer.borderWidth = 1.0;
    self.loginButton.layer.cornerRadius = 25.0;
    self.loginButton.layer.borderColor = RED_Color.CGColor;
    self.loginButton.titleLabel.textColor = RED_Color;
}

- (IBAction)onActivateCardButtonClicked:(id)sender {
    
    
    AddNewCardController *lObjCtrl = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"AddNewCardController"];
    UINavigationController *navCont = [[UINavigationController alloc]initWithRootViewController:lObjCtrl];
    
    
    //  [self.navigationController pushViewController:lObjCtrl animated:YES];
    [self.navigationController presentViewController:navCont animated:YES completion:nil];
    
    
}

#pragma mark - IBAction Methods

- (IBAction)loginClicked:(id)sender
{
    
    if  ([self.userNameField.text  isEqual: @""] && [self.userNameField.text isEqualToString:@""])
    {
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Invalid Logon" message:@"Please enter a valid login credentials" delegate:self cancelButtonTitle:nil otherButtonTitles:@"ok", nil];
        [alert show];
    }
    else
    {
        //        [self performSelectorOnMainThread:@selector(onResponseCall:) withObject:MESSAGE_CALL_SUCCESS waitUntilDone:NO];
        [self showLoadingIndicator];
        
        ServerCommunicator *serverComm = [[ServerCommunicator alloc] init];
        [serverComm processLogin:self.userNameField.text pwd:self.passwordField.text  downloadHandlerBlock: ^(id returnObj,NSError *error){
            
            
            if (nil != error) {
                [self performSelectorOnMainThread:@selector(onResponseCall:) withObject:ERROR_TIMEDOUT waitUntilDone:NO];
            }
            else
            {
                NSDictionary *retData = returnObj;
                
                //Saving Dict to App Delegate for now
                //TODO Create a model class or a database to store user profile
                AppDelegate *del = [UIApplication sharedApplication].delegate;
                del.userProfileDict = retData;
                
                if ([[retData objectForKey:@"code"] integerValue] == 100) {
                    
                    NSNumber *userid = [returnObj valueForKey:@"userId"];
                    self.userId = [userid stringValue];
                    [self performSelectorOnMainThread:@selector(onResponseCall:) withObject:MESSAGE_CALL_SUCCESS waitUntilDone:NO];
                }
                else if ([[retData objectForKey:@"code"] integerValue] == 0) {
                    
                    
                    [self performSelectorOnMainThread:@selector(onResponseCall:) withObject:ERROR_INVALID_PARAMS waitUntilDone:NO];
                    
                }
                else if ([[retData objectForKey:@"code"] integerValue] == 101) {
                    
                    [self performSelectorOnMainThread:@selector(onResponseCall:) withObject:ERROR_INVALID_PARAMS waitUntilDone:NO];
                }
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self stopProgressIndicator];
            });
        }];
    }
}

-(void)onResponseCall:(NSString *)responseMessage{
    
    if ([responseMessage isEqualToString:MESSAGE_CALL_SUCCESS]) {
        
        NSUserDefaults *data = [NSUserDefaults standardUserDefaults];
        
        [data setObject:self.userNameField.text forKey:USERNAME];
        [data setObject:self.userId forKey:USERID];
        
        [data synchronize];
        /*
         self.profileController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ProfileViewController"];
         [self.navigationController pushViewController:self.profileController animated:YES];
         
         */
        
        [((AppDelegate *)[UIApplication sharedApplication].delegate) showTheHomeScreenWithAnimationFlag:YES];
        
    }
    else if ([responseMessage isEqualToString:ERROR_INVALID_PARAMS]) {
        
        NSString *keyName = [NSString stringWithFormat:@"Sorry! Unable to login.Please check your credentials"];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:keyName
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        
    }
    else if ([responseMessage isEqualToString:ERROR_TIMEDOUT]) {
        
        NSString *keyName = [NSString stringWithFormat:@"Sorry!,Unable to login!"];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:keyName
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
}


#pragma mark - Loading Indicator Methods
-(void)showLoadingIndicator
{
    HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:HUD];
    
    HUD.delegate = self;
    HUD.labelText = @"Signing In";
    HUD.minSize = CGSizeMake(135.f, 135.f);
    HUD.removeFromSuperViewOnHide = YES;
    [HUD show:YES];
}

-(void)stopProgressIndicator{
    
    [HUD hide:YES];
}


@end
