//
//  TransactionsController.h
//  CCTracker
//
//  Created by Patil, Chandrachud K. on 14/12/15.
//  Copyright © 2015 Patil, Chandrachud K. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TransactionsController : UIViewController

@property(nonatomic, strong) NSArray *transactions;
@property(nonatomic, strong) NSString *cardNum;

@property (weak, nonatomic) IBOutlet UITableView *transactionsTable;
@end
