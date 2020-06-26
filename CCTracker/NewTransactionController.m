//
//  NewTransactionController.m
//  CCTracker
//
//  Created by Patil, Chandrachud K. on 11/12/15.
//  Copyright © 2015 Patil, Chandrachud K. All rights reserved.
//


#import "NewTransactionController.h"
#import "AddCardCell.h"
#import "Header.h"
#import "CamViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "CCCapture-Swift.h"
#import "MBProgressHUD.h"
#import "ServerCommunicator.h"
#import "MediaViewCtrl.h"
#import "DownPicker.h"
#import "AppDelegate.h"

#define         PICKER_VIEW_HEIGHT                      150

@interface NewTransactionController ()<MBProgressHUDDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate,UIAlertViewDelegate,DownPickerDelegate,EPPickerDelegate>

{
    MBProgressHUD *HUD;
}
@property (weak, nonatomic) IBOutlet UITableView *dataTable;

@property (nonatomic, strong) NSArray *cellLabelsArray;
@property(nonatomic, strong) CamViewController *cameraCont;
@property(nonatomic, strong) UITextField *subCategoryTextField;
@property(nonatomic, strong) UITextField *contactsFieldInstance;

@property (nonatomic, retain) UIPickerView *purposePickerView;
@property (nonatomic, retain) UIImage *selectedImg;

@property (nonatomic, assign) BOOL isMainCategory;
@property (nonatomic) DownPicker *picker;
@property (nonatomic) DownPicker *subPicker;

@property (nonatomic) NSMutableArray *categoryArray;
@property (nonatomic) NSMutableArray *subCategoryArray;

@property(nonnull, strong)NSArray *dummyMerchantsArray;

@end

@implementation NewTransactionController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //  self.cellLabelsArray = [NSArray arrayWithObjects:@" GIVE YOUR TRANSACTION A NAME",@"PURPOSE",@"DESCRIPTION",@"PEOPLE",@"LOCATION",@"INVOICE", nil];
    
    self.cellLabelsArray = [NSArray arrayWithObjects:@"INVOICE",@"GIVE YOUR TRANSACTION A NAME",@"PURPOSE",@"PURPOSE2",@"DESCRIPTION",@"LOCATION", nil];
    
    [self addBarButtonItems];
    [self getDataSourceForPickerWithCategory:@"TRAVEL"];;
    _addCardDictionary = [NSMutableDictionary dictionary];
    
    if (self.isReadOnlyMode) {
        [self preparetheData];
    }
   self.dummyMerchantsArray =  [NSArray arrayWithObjects:@"Ola Cabs Pvt Ltd",@"Uber Cabs Pvt Ltd",@"Ola Cabs Pvt Ltd",@"The Trident Hotel Pune",@"Radisson, Hyderabad", nil];
}

-(void)preparetheData{
    
    ServerCommunicator *serComm = [[ServerCommunicator alloc]init];
    
    __block UIImage *image = self.selectedImg;
    
    [serComm getTransactionreceipt:[_transactionDict valueForKey:@"id"] downloadHandlerBlock:^(id data, NSError *error) {
        
        if (nil != error)
        {
            image = [UIImage imageNamed:@"new-warning.png"];
        }
        else
        {
//            NSData * encodedData = [NSKeyedArchiver archivedDataWithRootObject:data];
            
           NSString *str = [data base64EncodedStringWithOptions:0];
            NSURL *URL = [NSURL URLWithString:
                          [NSString stringWithFormat:@"data:application/octet-stream;base64,%@",
                           str]];
            NSData *imageData = [NSData dataWithContentsOfURL:URL];
            self.selectedImg = [UIImage imageWithData:(NSData*)imageData];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.dataTable reloadData];
        });
    }];
    
    self.navigationItem.rightBarButtonItem = nil;
}

-(NSMutableArray *)getDataSourceForPickerWithCategory:(NSString *)str{
    
    NSMutableArray *retVal = nil;
    
    self.categoryArray = [[NSMutableArray alloc] initWithArray:@[@"TRAVEL", @"FOOD", @"ACCOMMODATION"]];
    self.subCategoryArray = [[NSMutableArray alloc] initWithArray:@[@"BUSINESS", @"PERSONAL", @"DOMESTIC",@"INTERNATIONAL"]];
    
    NSString *categoryStr = str;
    
    if ([categoryStr isEqualToString:@"TRAVEL"]) {
        
        self.subCategoryArray = [[NSMutableArray alloc] initWithArray:@[@"BUSINESS", @"PERSONAL", @"DOMESTIC",@"INTERNATIONAL"]];
    }
    else if ([categoryStr isEqualToString:@"FOOD"]) {
        
        self.subCategoryArray = [[NSMutableArray alloc] initWithArray:@[@"TEAM OUTING", @"CLIENT ENTERTAINMENT", @"SHIFT"]];
        
    }
    else if ([categoryStr isEqualToString:@"ACCOMMODATION"]) {
        
        self.subCategoryArray = [[NSMutableArray alloc] initWithArray:@[@"BUSINESS", @"CLIENT", @"PERSONAL"]];
    }
    return retVal;
}

-(void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
}

-(void)categoryCancelButtonPressed{
    
    [self.purposePickerView removeFromSuperview];
    
    CGRect tableViewFrame = self.dataTable.frame;
    tableViewFrame.size.height += (PICKER_VIEW_HEIGHT + 50);
    self.dataTable.frame = tableViewFrame;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)addBarButtonItems
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setFrame:CGRectMake(0.0, 0.0, 25.0, 20.0)];
    [btn setImage:[UIImage imageNamed:@"icon - Check@1x.png"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(done) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barbutton = [[UIBarButtonItem alloc]initWithCustomView:btn];
    self.navigationItem.rightBarButtonItem = barbutton;
}

#pragma mark - UITextfieldDelegate Methods

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    [self UpdateDictionary:textField];
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    [self UpdateDictionary:textField];
    return  true;
}

-(void)UpdateDictionary:(UITextField *)textField
{
    NSString *textFieldStr = [NSString stringWithFormat:@"%@",textField.text];
    switch (textField.tag) {
        case 1:
            break;
        case 2:
            [self.addCardDictionary setValue:textFieldStr forKey:@"transactionName"];
            [self.addCardDictionary setValue:@"TRAVEL" forKey:@"categoryName"];
            [self.addCardDictionary setValue:@"BUSINESS" forKey:@"subCategoryName"];
            
            break;
        case 3:
            
            //            textField.text = @"FOOD";
            //
            //            if ([textField.text isEqualToString:@"TRAVEL"]) {
            //
            //                [self.addCardDictionary setValue:@"1" forKey:@"categoryName"];
            //
            //            }
            //            else if ([textField.text isEqualToString:@"FOOD"]) {
            //                h
            //                [self.addCardDictionary setValue:@"2" forKey:@"categoryName"];
            //
            //            }
            //            else if ([textField.text isEqualToString:@"LODGIND"]) {
            //
            //                [self.addCardDictionary setValue:@"3" forKey:@"categoryName"];
            //
            //            }
            //            else if ([textField.text isEqualToString:@"OTHER EXPENSES"]) {
            //
            //                [self.addCardDictionary setValue:@"4" forKey:@"categoryName"];
            //
            //            }
            
            break;
        case 4:
            
            textField.text = @"BUSINESS TRAVEL";
            
            if ([textField.text isEqualToString:@"BUSINESS TRAVEL"]) {
                
                [self.addCardDictionary setValue:@"1" forKey:@"categoryName"];
                
            }
            else if ([textField.text isEqualToString:@"BUSINESS TRAVEL"]) {
                
                [self.addCardDictionary setValue:@"2" forKey:@"categoryName"];
                
            }
            else if ([textField.text isEqualToString:@"BUSINESS TRAVEL"]) {
                
                [self.addCardDictionary setValue:@"3" forKey:@"BUSINESS TRAVEL"];
                
            }
            else if ([textField.text isEqualToString:@"BUSINESS TRAVEL"]) {
                
                [self.addCardDictionary setValue:@"4" forKey:@"categoryName"];
            }
            
            [self.addCardDictionary setValue:@"2" forKey:@"subCategoryName"];
            break;
            
        case 5:
            [self.addCardDictionary setValue:textFieldStr forKey:@"description"];
            break;
            
        case 6:
            [self.addCardDictionary setValue:textFieldStr forKey:@"location"];
            break;
        default:
            break;
    }
}

-(bool)validateAllTheFields{
    
    bool retVal = true;
    
    for (NSString *key in _addCardDictionary) {
        
        NSString *eachObj = [_addCardDictionary objectForKey:key];
        
        if (eachObj.length == 0) {
            
            retVal = false;
            break;
        }
    }
    
    if (nil == self.selectedImg) {
        
        retVal = false;
    }
    
    if (false == retVal) {
        NSString *keyName = [NSString stringWithFormat:@"Please enter all the fields"];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:keyName
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
    return retVal;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)onResponseCall:(NSString *)responseMessage{
    
    [self stopProgressIndicator];
    
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
        
        NSString *keyName = [NSString stringWithFormat:@"Sorry!,Unable to Connect to server.Please contact  your Admin"];
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

-(NSMutableDictionary *)getTheRequestDictionary{
    
    AppDelegate *del = [[UIApplication sharedApplication] delegate];
    NSString *cardId = [del.cardDict valueForKey:@"cardId"];
    
    NSUInteger randomIndex = arc4random() % [self.dummyMerchantsArray count];
    NSString *dummyMerchent = [self.dummyMerchantsArray objectAtIndex:randomIndex];
    
    [_addCardDictionary setValue:@"12345" forKey:@"transactionNumber"];
    [_addCardDictionary setValue:cardId forKey:@"cardId"];
    [_addCardDictionary setValue:@"2015-12-12" forKey:@"transactionDate"];
    
    [_addCardDictionary setValue:dummyMerchent forKey:@"merchantName"];
    [_addCardDictionary setValue:@"100.10" forKey:@"amount"];
    
    NSLog(@"%@",_addCardDictionary);
    return _addCardDictionary;
}

-(void)saveTheWholeTransaction{
    
    ServerCommunicator *serverComm = [[ServerCommunicator alloc] init];
    
    NSMutableDictionary *dictToSend = [self getTheRequestDictionary];
    
    [serverComm saveTheNewTransaction:dictToSend downloadHandlerBlock:^(id returnObj,NSError *error){
        
        if (nil != error) {
            
            [self performSelectorOnMainThread:@selector(onResponseCall:) withObject:ERROR_TIMEDOUT waitUntilDone:NO];
        }
        else
        {
            NSDictionary *retData = returnObj;
            
            if ([[retData objectForKey:@"code"] integerValue] == 100) {
                
                //                int x = 0;
                //                [self saveTheWholeTransaction];
                
                [self performSelectorOnMainThread:@selector(onResponseCall:) withObject:MESSAGE_CALL_SUCCESS waitUntilDone:NO];
            }
            
            else if ([[retData objectForKey:@"code"] integerValue] == 0) {
                
                //   [self performSelectorOnMainThread:@selector(onResponseCall:) withObject:ERROR_INVALID_PARAMS waitUntilDone:NO];
                //                int x = 0;
            }
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self stopProgressIndicator];
        });
    }];
}

-(void)saveTransaction{
    
    [self showLoadingIndicator];
    // [self performSelector:@selector(dismissAfterDelay) withObject:self afterDelay:9];
    
    if (nil != self.selectedImg) {
        
        NSData *imgData = UIImageJPEGRepresentation(self.selectedImg,1.0);
        
        NSString *docPath = [NSHomeDirectory() stringByAppendingString:@"/Documents"];
        NSString *imgPath = [docPath stringByAppendingPathComponent:@"temp.jpg"];
        BOOL success =  [imgData writeToFile:imgPath atomically:YES];
        
        NSURL *imgUrl = nil;
        
        if (success) {
            imgUrl = [[NSURL alloc] initFileURLWithPath:imgPath];
            NSLog(@"url from data : %@",imgUrl);
        }
        
        
        if (nil != imgUrl) {
            
            ServerCommunicator *serverComm = [[ServerCommunicator alloc] init];
            
            
            //            [serverComm]
            
            [serverComm uploadImage:imgUrl image:self.selectedImg downloadHandlerBlock:^(id returnObj,NSError *error){
                
                if (nil != error) {
                    
                    [self performSelectorOnMainThread:@selector(onResponseCall:) withObject:ERROR_TIMEDOUT waitUntilDone:NO];
                }
                else{
                    //                    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:returnObj options:0 error:nil];
                    
                    NSDictionary *retData = returnObj;
                    
                    if ([[retData objectForKey:@"code"] integerValue] == 100) {
                        
                        [_addCardDictionary setValue:[retData objectForKey:@"recieptId"] forKey:@"receipt"];
                        
                        [self saveTheWholeTransaction];
                        
                    }
                    else if ([[retData objectForKey:@"code"] integerValue] == 0) {
                        
                        [self performSelectorOnMainThread:@selector(onResponseCall:) withObject:ERROR_INVALID_PARAMS waitUntilDone:NO];
                    }
                }
            }];
        }
    }
}

-(void)done
{
    if (true == [self validateAllTheFields]) {
        [self saveTransaction];
    }
}

-(void)dismissAfterDelay
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)cancel
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)handleAction:(id)sender
{
    NSInteger i = [sender tag];
    
    
    [self categoryCancelButtonPressed];
    
    switch (i) {
        case 2:
            
            self.isMainCategory = YES;
            
            //            [self showPickerView];
            break;
            
        case 3:
            
            self.isMainCategory = NO;
            
            
            //       NSMutableArray *retArray = [self getDataSourceForPicker];
            
            //            [self showPickerView];
            
            
            
            //        [self addPeople];
            
            break;
        case 0:
            [self openCamera];
            
            break;
        default:
            
            break;
    }
}

-(void)showPicker
{
    UIToolbar *toolbar = [[UIToolbar alloc] init];
    [toolbar setBarStyle:UIBarStyleBlackTranslucent];
    [toolbar sizeToFit];
    UIBarButtonItem *buttonflexible = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *buttonDone = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneClicked:)];
    [toolbar setItems:[NSArray arrayWithObjects:buttonflexible,buttonDone, nil]];
    
}

-(void)doneClicked:(UIBarButtonItem*)button
{
    [self.view endEditing:YES];
}

-(void)openCamera
{
    UIActionSheet *sheet = [[UIActionSheet alloc]initWithTitle:@"Select Photo" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil     otherButtonTitles:@"Camera",@"Choose from Gallery", nil];
    [sheet showInView:self.view];
}

-(void)addPeople
{
    EPContactsPicker *picker = [[EPContactsPicker alloc]initWithDelegate:self multiSelection:YES];
    UINavigationController *navCont = [[UINavigationController alloc]initWithRootViewController:picker];
    
    [self presentViewController:navCont animated:YES completion:nil];
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

-(void)showLoadingIndicator
{
    HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:HUD];
    
    HUD.delegate = self;
    HUD.labelText = @"Please wait ...";
    HUD.minSize = CGSizeMake(135.f, 135.f);
    HUD.removeFromSuperViewOnHide = YES;
    
    [HUD show:YES];
}

-(void)stopProgressIndicator{
    
    [HUD hide:YES];
}


-(void)handleImageClickAction:(id)sender{
    
    MediaViewCtrl *lObjCtrl = [[MediaViewCtrl alloc] initWithNibName:@"MediaViewCtrl" bundle:nil];
    lObjCtrl.imageToDisplay = self.selectedImg;
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:lObjCtrl];
    
    [self presentViewController:navigationController animated:YES completion:nil];
}

#pragma mark - UITableView Delegate Methods

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.cellLabelsArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = @"Cell";
    AddCardCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    cell.textField.font = [UIFont systemFontOfSize:15];
    cell.lbl.text = [NSString stringWithFormat:@"%@",[self.cellLabelsArray objectAtIndex:indexPath.row]];
    [cell.btn addTarget:self action:@selector(handleAction:) forControlEvents:UIControlEventTouchUpInside];
    [cell.detailedbtn addTarget:self action:@selector(handleImageClickAction:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.btn.tag = indexPath.row;
    cell.textField.tag = indexPath.row + 1;
    cell.textField.delegate = self;
    
    cell.detailedbtn.hidden = YES;
    cell.textField.enabled = YES;
    [cell.btn setHidden:YES];

    switch (indexPath.row) {
            
        case 0:
        {
            [cell.btn setHidden:NO];
            [cell.btn setBackgroundImage:[UIImage imageNamed:@"Instagram-512@1x.png"] forState:UIControlStateNormal];

            if (nil != self.selectedImg) {
                cell.detailedbtn.hidden = NO;
                [cell.detailedbtn setBackgroundImage:self.selectedImg forState:UIControlStateNormal];
                [cell.detailedbtn setBackgroundColor:[UIColor lightGrayColor]];
            }
            else
            {
                cell.detailedbtn.hidden = YES;
            }
            
            cell.textField.text = @"Add Invoice By clicking picture";
            if (self.isReadOnlyMode) {
                cell.textField.text = @"Click on the Image to View";
            }
        }
            break;
            
        case 1:
        {
            [cell.btn setHidden:YES];
            
            cell.textField.text = [_transactionDict objectForKey:@"transactionName"];
        }
            break;
        case 2:
        {
            self.picker = [[DownPicker alloc] initWithTextField:cell.textField withData:self.categoryArray];
            self.picker.customDelegate = self;
            [cell.btn setImage:[UIImage imageNamed:@"icon - Disclosure copy@1x.png"] forState:UIControlStateNormal];
            
            cell.textField.text = [_transactionDict objectForKey:@"categoryName"];
        }
            break;
        case 3:
        {
            self.subPicker = [[DownPicker alloc] initWithTextField:cell.textField withData:self.subCategoryArray];
            self.subPicker.customDelegate = self;
            [cell.btn setImage:[UIImage imageNamed:@"icon - Disclosure copy@1x.png"] forState:UIControlStateNormal];
            
            cell.textField.text = [_transactionDict objectForKey:@"subCategoryName"];
        }
            break;
        case 4:
            
            cell.textField.text = [_transactionDict objectForKey:@"description"];
            
            break;
        case 5:
            
            cell.textField.text = [_transactionDict objectForKey:@"location"];
            
            break;
            
        default:
            break;
    }
    if (self.isReadOnlyMode) {
        [cell.btn setHidden:YES];
        cell.textField.enabled = NO;
    }
    return cell;
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

-(void)reloadTheTableCells{
    
    [self.dataTable reloadData];
}

#pragma mark - UIImagePickerControllerDelegate

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    /*
     // get the ref url
     NSURL *refURL = [info valueForKey:UIImagePickerControllerReferenceURL];
     __weak UITextField *label = self.textFieldInstance;
     // define the block to call when we get the asset based on the url (below)
     ALAssetsLibraryAssetForURLResultBlock resultblock = ^(ALAsset *imageAsset)
     {
     ALAssetRepresentation *imageRep = [imageAsset defaultRepresentation];
     NSLog(@"[imageRep filename] : %@", [imageRep filename]);
     label.text = [imageRep filename];
     };
     
     // get the asset library and fetch the asset based on the ref url (pass in block above)
     ALAssetsLibrary* assetslibrary = [[ALAssetsLibrary alloc] init];
     [assetslibrary assetForURL:refURL resultBlock:resultblock failureBlock:nil];
     */
    
    UIImage* originalImage = nil;
    originalImage = [info objectForKey:UIImagePickerControllerEditedImage];
    if(originalImage==nil)
    {
        originalImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    }
    if(originalImage==nil)
    {
        originalImage = [info objectForKey:UIImagePickerControllerCropRect];
    }
    
    self.selectedImg = originalImage;

    [picker dismissViewControllerAnimated:YES completion:NULL];
    
    [self performSelectorOnMainThread:@selector(reloadTheTableCells) withObject:nil waitUntilDone:NO];
    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(nullable NSDictionary<NSString *,id> *)editingInfo {
    
    self.selectedImg = image;
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark -
#pragma mark PickerView Delegate
-(void)downPickerDidSelectRowAtIndexPath:(NSInteger)row withPicker:(DownPicker *)downPicker
{
    if (downPicker == self.picker) {
        [_addCardDictionary setValue:[_categoryArray objectAtIndex:row] forKey:@"categoryName"];
        [self getDataSourceForPickerWithCategory:[_categoryArray objectAtIndex:row]];
        [self.subPicker setData:_subCategoryArray];
    }
    else
    {
        NSString *string = [_subCategoryArray objectAtIndex:row];
        [_addCardDictionary setValue:string forKey:@"subCategoryName"];
    }
}

#pragma mark - EPPickerDelegate Methods

-(void)epContactPicker:(EPContactsPicker *)_ didSelectMultipleContacts:(NSArray<EPContact *> *)contacts
{
    NSString *str = [NSString stringWithFormat:@"%lu Contacts Selected",(unsigned long)contacts.count];
    self.contactsFieldInstance.text = str;
}

-(void)epContactPicker:(EPContactsPicker *)_ didCancel:(NSError *)error
{
    
}

@end
