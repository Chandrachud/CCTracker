//
//  TransactionsController.m
//  CCTracker
//
//  Created by Patil, Chandrachud K. on 14/12/15.
//  Copyright © 2015 Patil, Chandrachud K. All rights reserved.
//

#import "TransactionsController.h"
#import "NewTransactionController.h"
#import "Header.h"
#import "TransactionCell.h"
#import "ServerCommunicator.h"
#import "CCCapture-Swift.h"
#import "MBProgressHUD.h"

@interface TransactionsController ()<UITableViewDataSource, UITableViewDelegate,MBProgressHUDDelegate>
{
    MBProgressHUD *HUD;
}

@property(nonatomic, strong) NewTransactionController *showNewTransaction;
@property(nonatomic, strong) NSArray *transactionArr;
@end

@implementation TransactionsController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = _cardNum;
    [self GetAllTheTransactions];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


-(void)GetAllTheTransactions{
    
    NSString *userId = [DataManager getTheUserId];
    
    [self showLoadingIndicator];
    ServerCommunicator *serverComm = [[ServerCommunicator alloc] init];
    
    [serverComm getTheAllTransactions:userId downloadHandlerBlock:^(id returnObj,NSError *error){
        
        if (nil != error)
        {
            NSString *keyName = [NSString stringWithFormat:@"Uh Oh! Something is not right"];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                            message:keyName
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
        }
        else
        {
            self.transactionArr = returnObj;
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.transactionsTable reloadData];
            });
        }
        dispatch_async(dispatch_get_main_queue(), ^{
        [self stopProgressIndicator];
        });
    }];
}

#pragma mark - UITableView Delegate Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.transactionArr.count;
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 50)];
    [headerView setBackgroundColor:TABLE_HEADER];
    
    UILabel *lbl = [[UILabel alloc]initWithFrame:CGRectMake(10, 15, 200, 15)];
    lbl.textColor = [UIColor blackColor];
    lbl.text = @"May - 2016";
    [headerView addSubview:lbl];
    
    return headerView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = @"transactionCell";
    
    TransactionCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    NSDictionary *cardDict = [self.transactionArr objectAtIndex:indexPath.row];
    
    cell.cellTitle.text = [cardDict valueForKey:@"merchantName"];
    NSString *descriptiontext = [NSString stringWithFormat:@"%@ | %@",[cardDict valueForKey:@"transactionDate"],[cardDict valueForKey:@"description"]];
    cell.descriptionLabel.text = descriptiontext;
    
    if ([[cardDict valueForKey:@"statusCode"] isEqualToString:@"1"]) {
        cell.statusView.backgroundColor = COLOR_NEW;
        cell.leftBarView.backgroundColor = COLOR_NEW;
        cell.rightBarView.backgroundColor = COLOR_NEW;
    }
    else if ([[cardDict valueForKey:@"statusCode"] isEqualToString:@"0"])
    {
        cell.statusView.backgroundColor = COLOR_PENDING;
    }
    else
    {
        cell.statusView.backgroundColor = COLOR_APPROVED;
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    self.showNewTransaction = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"NewTransactionController"];
    self.showNewTransaction.isReadOnlyMode = YES;
    self.showNewTransaction.transactionDict = [self.transactionArr objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:self.showNewTransaction animated:YES];
}

#pragma mark - Loading Indicator Methods
-(void)showLoadingIndicator
{
    HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:HUD];
    
    HUD.delegate = self;
    HUD.labelText = @"Fetching..";
    HUD.minSize = CGSizeMake(135.f, 135.f);
    HUD.removeFromSuperViewOnHide = YES;
    [HUD show:YES];
}

-(void)stopProgressIndicator{
    
    [HUD hide:YES];
}

@end
