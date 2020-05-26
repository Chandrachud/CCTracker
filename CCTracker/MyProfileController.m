//
//  MyProfileController.m
//  ExpenseTracker
//
//  Created by Chandrachud on 4/20/16.
//  Copyright © 2016 Patil, Chandrachud K. All rights reserved.
//

#import "MyProfileController.h"
#import "Header.h"
#import "ITRAirSideMenu.h"
#import "AppDelegate.h"
#import "AddCardCell.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "ServerCommunicator.h"
#import "CCCapture-Swift.h"
#import "ServerCommunicator.h"
#import "MBProgressHUD.h"

@interface MyProfileController ()<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    MBProgressHUD *HUD;
}

@property (nonatomic, strong) NSArray *cellLabelsArray;
@property (nonatomic, strong) NSDictionary *profileDict;
@property (nonatomic, strong) NSMutableDictionary *updatedProfileInfo;

@end

@implementation MyProfileController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.cellLabelsArray = [NSArray arrayWithObjects:@"First Name",@"Last Name",@"EMAIL",@"PASSWORD",@"MOBILE NO.",@"NOTIFICATION", nil];
    self.profileImage.layer.cornerRadius = self.profileImage.frame.size.width/2.0;
    self.profileImage.layer.masksToBounds = YES;
    
    /*
     
     myprofileDict = [NSMutableDictionary dictionary];
     [myprofileDict setValue:@"John,Pierce" forKey:@"fullName"];
     [myprofileDict setValue:@"Travel to Delhi" forKey:@"transactionName"];
     [myprofileDict setValue:@"2015-12-12" forKey:@"date"];
     [myprofileDict setValue:@"1234567891" forKey:@"cardNumber"];
     [myprofileDict setValue:@"Travel" forKey:@"categoryName"];
     [_addCardDictionary setValue:@"Business" forKey:@"subCategoryName"];
     [_addCardDictionary setValue:@"Hyderabad,Wells" forKey:@"location"];
     [_addCardDictionary setValue:@"1" forKey:@"merchantId"];
     [_addCardDictionary setValue:@"Trident Hotel" forKey:@"merchantName"];
     [_addCardDictionary setValue:@"Temp" forKey:@"receipt"];
     [_addCardDictionary setValue:@"Meeting with a Client" forKey:@"description"];
     */
    
    [self getTheUserProfile];
    
    [self addBarButtonItems];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)addBarButtonItems
{
    self.title = @"My Cards";
    self.navigationController.navigationBar.tintColor = RED_Color;
    
    //    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    //
    //    [btn setFrame:CGRectMake(0.0, 0.0, 40.0, 20.0)];
    //    [btn setTitle:@"Done" forState:UIControlStateNormal];
    //    [btn setTintColor:[UIColor redColor]];
    //    [btn setBackgroundColor:[UIColor clearColor]];
    //    [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    //    [btn addTarget:self action:@selector(update) forControlEvents:UIControlEventTouchUpInside];
    //    UIBarButtonItem *barbutton = [[UIBarButtonItem alloc]initWithCustomView:btn];
    //    self.navigationItem.rightBarButtonItem = barbutton;
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Update"
                                                                   style:UIBarButtonItemStyleDone target:self
                                                                  action:@selector(update)];
    self.navigationItem.rightBarButtonItem = doneButton;
    
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn setFrame:CGRectMake(0.0, 0.0, 20.0, 20.0)];
    [leftBtn setImage:[UIImage imageNamed:@"icon - Menu@1x.png"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(presentLeftController) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *leftBarbutton = [[UIBarButtonItem alloc]initWithCustomView:leftBtn];
    self.navigationItem.leftBarButtonItem = leftBarbutton;
    
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName:RED_Color}];
    
    [self.navigationController.navigationBar  setBackgroundColor:[UIColor whiteColor]];
    self.navigationItem.hidesBackButton = YES;
    
}

-(void)update
{
    //[((AppDelegate *)[UIApplication sharedApplication].delegate) showTheLoginScreen];
    ServerCommunicator *serverComm = [[ServerCommunicator alloc]init];
    [self showLoadingIndicator];
    [serverComm updateUserInfo:self.updatedProfileInfo downloadHandlerBlock:^(id data, NSError *error) {
       
        if (nil != error)
        {
            
        }
        else
        {
            
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self stopProgressIndicator];
        });
    }];
}

- (IBAction)changeProfilePic:(id)sender {
    UIActionSheet *sheet = [[UIActionSheet alloc]initWithTitle:@"Select Photo" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil     otherButtonTitles:@"Camera",@"Choose from Gallery", nil];
    [sheet showInView:self.view];
}

- (void) presentLeftController
{
    //show left menu with animation
    ITRAirSideMenu *itrSideMenu = ((AppDelegate *)[UIApplication sharedApplication].delegate).itrAirSideMenu;
    [itrSideMenu presentLeftMenuViewController];
}

- (void)selectPhoto {
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:picker animated:YES completion:NULL];
}

- (void)takePhoto
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    [self presentViewController:picker animated:YES completion:NULL];
}


-(NSDictionary *)getTheRequestDictionary
{
    return nil;
}



-(void)onResponseCall:(NSString *)responseMessage{
    
    //    [self stopProgressIndicator];
    
    if ([responseMessage isEqualToString:MESSAGE_CALL_SUCCESS]) {
        
        NSString *keyName = [NSString stringWithFormat:@"Transaction is saved successfully!"];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success"
                                                        message:keyName
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        
        
        //    [self.navigationController popViewControllerAnimated:YES];
        
        
    }
    else if ([responseMessage isEqualToString:ERROR_INVALID_PARAMS]) {
        
        NSString *keyName = [NSString stringWithFormat:@"Sorry!,Unable to Connect to server.Please contact your Admin"];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:keyName
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        
    }
    else if ([responseMessage isEqualToString:ERROR_TIMEDOUT]) {
        
        NSString *keyName = [NSString stringWithFormat:@"Sorry!,Unable to Connect to server.Please contact  your Admin"];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:keyName
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        
    }
}



-(void)getTheUserProfile{
    
    AppDelegate *del = [UIApplication sharedApplication].delegate;
    self.profileDict = del.userProfileDict;
    
    //Keeping a seperate instance to store updated values in case
    self.updatedProfileInfo = [NSMutableDictionary dictionary];
    [self.updatedProfileInfo setValue:[_profileDict valueForKey:@"userId"] forKey:@"id"];
    [self.updatedProfileInfo setValue:[_profileDict valueForKey:@"firstName"] forKey:@"firstName"];
    [self.updatedProfileInfo setValue:[_profileDict valueForKey:@"lastName"] forKey:@"lastName"];
    [self.updatedProfileInfo setValue:[_profileDict valueForKey:@"phone"] forKey:@"phone"];

    [self.tableView reloadData];
    
    /*
     ServerCommunicator *serverComm = [[ServerCommunicator alloc] init];
     
     
     NSString *userId = [DataManager getTheUserId];
     
     
     [serverComm getTheUserInfo:userId downloadHandlerBlock:^(id returnObj,NSError *error){
     
     
     if (nil != error) {
     
     [self performSelectorOnMainThread:@selector(onResponseCall:) withObject:ERROR_TIMEDOUT waitUntilDone:NO];
     
     }
     else{
     
     NSDictionary *retData = returnObj;
     
     if ([[retData objectForKey:@"code"] integerValue] == 100) {
     
     
     //  int x = 0;
     
     //                [self saveTheWholeTransaction];
     
     [self performSelectorOnMainThread:@selector(onResponseCall:) withObject:MESSAGE_CALL_SUCCESS waitUntilDone:NO];
     
     
     }
     else if ([[retData objectForKey:@"code"] integerValue] == 0) {
     
     
     //   [self performSelectorOnMainThread:@selector(onResponseCall:) withObject:ERROR_INVALID_PARAMS waitUntilDone:NO];
     
     // int x = 0;
     
     }
     }
     
     }];
     */
}


#pragma mark - UITableView Delegate Methods

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.cellLabelsArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = @"cell";
    NSString *notificationCellIdentifier = @"notificationCell";
    
    AddCardCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    AddCardCell *notificationCell = [tableView dequeueReusableCellWithIdentifier:notificationCellIdentifier];
    
    cell.textField.font = [UIFont systemFontOfSize:15];
    cell.textField.tag = indexPath.row + 1;
    cell.lbl.text = [NSString stringWithFormat:@"%@",[self.cellLabelsArray objectAtIndex:indexPath.row]];
    cell.textField.enabled = YES;
    
    switch (indexPath.row) {
        case 0:
        {
            if ([_profileDict objectForKey:@"firstName"] != [NSNull null])
            {
            cell.textField.text = [_profileDict valueForKey:@"firstName"];
            }
        }
            break;
        case 1:
        {
            if ([_profileDict objectForKey:@"lastName"] != [NSNull null])
            {

            cell.textField.text =  [_profileDict valueForKey:@"lastName"];
            }
        }
            break;
        case 2:
        {
            if ([_profileDict objectForKey:@"firstName"] != [NSNull null] &&[_profileDict objectForKey:@"lastName"])
            {

            NSString *str = [NSString stringWithFormat:@"%@.%@@wellsfargo.com",[_profileDict valueForKey:@"lastName"],[_profileDict valueForKey:@"firstName"]];
            cell.textField.text =  str;
            }
        }
            break;
        case 3:

            cell.textField.text = @"*******";
            cell.textField.enabled = NO;
            
            break;
        case 4:
            if ([_profileDict objectForKey:@"phone"] != [NSNull null])
            {

            cell.textField.text = [_profileDict valueForKey:@"phone"];
            }
            break;
            
        default:
            break;
    }
    
    if (indexPath.row == 5) {
        return notificationCell;
    }
    return cell;
}


#pragma mark - UIImagePickerControllerDelegate

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    // get the ref url
    NSURL *refURL = [info valueForKey:UIImagePickerControllerReferenceURL];
    // define the block to call when we get the asset based on the url (below)
    ALAssetsLibraryAssetForURLResultBlock resultblock = ^(ALAsset *imageAsset)
    {
        ALAssetRepresentation *imageRep = [imageAsset defaultRepresentation];
        NSLog(@"[imageRep filename] : %@", [imageRep filename]);
    };
    
    // get the asset library and fetch the asset based on the ref url (pass in block above)
    ALAssetsLibrary* assetslibrary = [[ALAssetsLibrary alloc] init];
    [assetslibrary assetForURL:refURL resultBlock:resultblock failureBlock:nil];
    
    self.profileImage.image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - UIActionSheet Delegates

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
            [self takePhoto];
            break;
        case 1:
            [self selectPhoto];
            break;
        default:
            break;
    }
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

+ (instancetype) controller{
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    return [storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([MyProfileController class])];
}

#pragma mark - TextField Delegates
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    [self UpdateDictionary:textField];
    return  true;
}

-(void)UpdateDictionary:(UITextField *)textField
{
    switch (textField.tag) {
        case 1:
            [self.updatedProfileInfo setValue:textField.text forKey:@"firstName"];
            break;
        case 2:
            [self.updatedProfileInfo setValue:textField.text forKey:@"lastName"];
            
            break;
        case 3:
            [self.updatedProfileInfo setValue:textField.text forKey:@"email"];
            break;
            
        case 4:
            [self.updatedProfileInfo setValue:textField.text forKey:@"phone"];
            break;
            
        case 5:
            break;
            
        default:
            break;
    }
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    [self UpdateDictionary:textField];
}


#pragma mark - Loading Indicator Methods
-(void)showLoadingIndicator
{
    HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:HUD];
    
//    HUD.delegate = self;
    HUD.labelText = @"Updating";
    HUD.minSize = CGSizeMake(135.f, 135.f);
    HUD.removeFromSuperViewOnHide = YES;
    [HUD show:YES];
}

-(void)stopProgressIndicator{
    
    [HUD hide:YES];
}

@end
