//
//  MyProfileController.h
//  ExpenseTracker
//
//  Created by Chandrachud on 4/20/16.
//  Copyright © 2016 Patil, Chandrachud K. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyProfileController : UIViewController

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UIImageView *profileImage;

+ (instancetype) controller;

@end
