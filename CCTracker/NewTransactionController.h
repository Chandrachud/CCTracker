//
//  NewTransactionController.h
//  CCTracker
//
//  Created by Patil, Chandrachud K. on 11/12/15.
//  Copyright © 2015 Patil, Chandrachud K. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewTransactionController : UIViewController


@property (nonatomic,assign) BOOL   isReadOnlyMode;
@property (nonatomic, strong) NSMutableDictionary *addCardDictionary;
@property (nonatomic, strong) NSDictionary *transactionDict;

@end
