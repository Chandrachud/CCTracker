//
//  AddNewCardController.m
//  CCTracker
//
//  Created by Patil, Chandrachud K. on 10/12/15.
//  Copyright © 2015 Patil, Chandrachud K. All rights reserved.
//

#import "AddNewCardController.h"
#import "Header.h"
#import "AddCardCell.h"
#import "IQKeyboardManager.h"
#import "ServerCommunicator.h"
#import "CCCapture-Swift.h"
#import "MBProgressHUD.h"

@interface AddNewCardController ()<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate,MBProgressHUDDelegate>
{
    MBProgressHUD *HUD;
}

@property (nonatomic, strong) NSArray *cellLabelsArray;
@property (nonatomic, strong) UITextField *dynamicTextField;
@property (nonatomic, strong) NSMutableDictionary *addCardDictionary;
@property(nonatomic, strong) NSMutableArray *cardsArray;

@end

@implementation AddNewCardController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self addBarButtonItems];
    
    self.navigationController.navigationBarHidden = false;
    
    self.cellLabelsArray = [NSArray arrayWithObjects:@"CARD NO",@"FIRST NAME",@"LAST NAME",@"USER NAME",@"PASSWORD",@"MOBILE NO.", nil];
    [[IQKeyboardManager sharedManager] setToolbarManageBehaviour:IQAutoToolbarByPosition];
    //    NSArray *array = [NSArray array];
    
    _addCardDictionary = [NSMutableDictionary dictionary];
    [_addCardDictionary setValue:@"" forKey:@"UserName"];
    [_addCardDictionary setValue:@"" forKey:@"First Name"];
    [_addCardDictionary setValue:@"" forKey:@"Last Name"];
    [_addCardDictionary setValue:@"" forKey:@"Mobile Number"];
    [_addCardDictionary setValue:@"" forKey:@"Card Number"];
    [_addCardDictionary setValue:@"1" forKey:@"approvedTransactions"];
    [_addCardDictionary setValue:@"" forKey:@"Password"];
    
    //    self.cardsArray = [NSMutableArray array];
    //    self.cardsArray = [[self parseLocalJSON:@"cards"]mutableCopy];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)addBarButtonItems
{
    self.title = @"Add New Card";
    self.navigationController.navigationBar.tintColor = RED_Color;
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setFrame:CGRectMake(0.0, 0.0, 25.0, 20.0)];
    [btn setImage:[UIImage imageNamed:@"icon - Check@1x.png"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(done) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barbutton = [[UIBarButtonItem alloc]initWithCustomView:btn];
    self.navigationItem.rightBarButtonItem = barbutton;
    
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn setFrame:CGRectMake(0.0, 0.0, 20.0, 20.0)];
    [leftBtn setImage:[UIImage imageNamed:@"icon - Close@1x.png"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *leftBarbutton = [[UIBarButtonItem alloc]initWithCustomView:leftBtn];
    self.navigationItem.leftBarButtonItem = leftBarbutton;
    
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName:RED_Color}];
    
    [self.navigationController.navigationBar  setBackgroundColor:[UIColor whiteColor]];
    self.navigationItem.hidesBackButton = YES;
}

-(void)cancel
{
    [self dismissViewControllerAnimated:YES completion:nil];
    //    [self.navigationController popViewControllerAnimated:YES];
}


-(void)onSuccessfullyAddingTheUser{
    
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    
    NSString *keyName = [NSString stringWithFormat:@"Yaay! You are now registered"];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success"
                                                    message:keyName
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}

-(void)done
{
    // [self showLoadingIndicator];
    //      [self dismissViewControllerAnimated:YES completion:nil];
    
    __block BOOL isStopped = NO;
    [_addCardDictionary enumerateKeysAndObjectsUsingBlock:^(id key, id value, BOOL* stop) {
        if([value  isEqual: @""])
        {
            NSString *keyName = [NSString stringWithFormat:@"%@ cannot be empty", key];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                            message:keyName
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
            *stop = YES;
            isStopped = YES;
        }
    }];
    if (!isStopped)
    {
        isStopped = NO;
        [_cardsArray addObject:self.addCardDictionary];
        [self updateJson:_cardsArray];
        
        [self showLoadingIndicator];
        ServerCommunicator *serverComm = [[ServerCommunicator alloc]init];
        [serverComm addCard:_addCardDictionary downloadHandlerBlock: ^(id returnObj,NSError *error){
            
            
            if (nil != error) {
                
                NSString *keyName = [NSString stringWithFormat:@"Sorry!,Unable to add the card!"];
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                message:keyName
                                                               delegate:nil
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
                [alert show];
            }
            else
            {
                NSDictionary *retData = returnObj;
                
                if ([[retData objectForKey:@"code"] integerValue] == 100) {
                    
                    
                    [self performSelectorOnMainThread:@selector(onSuccessfullyAddingTheUser) withObject:nil waitUntilDone:YES];
                }
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self stopProgressIndicator];
            });
        }];
    }
}

///////////////////////////Only for hardCoded Version

-(void)showLoadingIndicator
{
    HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:HUD];
    
    HUD.delegate = self;
    HUD.labelText = @"Registering";
    HUD.minSize = CGSizeMake(135.f, 135.f);
    [HUD show:YES];
}

-(void)stopProgressIndicator{
    
    [HUD hide:YES];
}

///////////////////////////Only for hardCoded Version

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
    cell.textField.tag = indexPath.row;
    cell.lbl.text = [NSString stringWithFormat:@"%@",[self.cellLabelsArray objectAtIndex:indexPath.row]];
    
    cell.textField.keyboardType = UIKeyboardTypeDefault;
    
    switch (indexPath.row) {
        case 0:
            cell.textField.keyboardType = UIKeyboardTypeNumberPad;
            break;
        case 5:
            cell.textField.keyboardType = UIKeyboardTypeNumberPad;
            break;
            
        default:
            break;
    }
    
    return cell;
}

#pragma mark - UITextfieldDelegate Methods

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
    switch (textField.tag) {
        case 0:
            [self.addCardDictionary setValue:textField.text forKey:@"Card Number"];
            break;
        case 1:
            [self.addCardDictionary setValue:textField.text forKey:@"First Name"];
            break;
        case 2:
            [self.addCardDictionary setValue:textField.text forKey:@"Last Name"];
            break;
        case 3:
            [self.addCardDictionary setValue:textField.text forKey:@"UserName"];
            break;
        case 4:
            [self.addCardDictionary setValue:textField.text forKey:@"Password"];
            break;
        case 5:
            [self.addCardDictionary setValue:textField.text forKey:@"Mobile Number"];
            break;
        default:
            break;
    }
}

#pragma mark - Other Methods

-(id)parseLocalJSON:(NSString*)fileName
{
    // NSMutableArray *arrTemp = [[NSMutableArray alloc]init];
    
    // serialize the request JSON
    NSError *error;
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:fileName ofType:@"json"];
    NSData *tempData = [NSData dataWithContentsOfFile:filePath];
    // NSDictionary *tempDict = [[NSDictionary alloc]init];
    
    id tempDict = [NSJSONSerialization
                   JSONObjectWithData:tempData
                   
                   options:kNilOptions
                   error:&error];
    NSArray *arrTemp = [tempDict objectForKey:@"cards"];
    return arrTemp;
}

-(void)updateJson:(NSArray *)cardsArray
{
    NSMutableDictionary *myJSONDict = [NSMutableDictionary dictionary];
    [myJSONDict setValue:cardsArray forKey:@"cards"];
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:myJSONDict options:0 error:&error];
    NSString * myString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    if (jsonData != nil) {
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"cards" ofType:@"json"];
        
        //        BOOL status = [jsonData writeToFile:filePath atomically:YES];
        BOOL status = [myString writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:&error];
        
        if (!status) {
            NSLog(@"Oh no!");
        }
    } else {
        NSLog(@"My JSON wasn't valid: %@", error);
    }
}


@end
