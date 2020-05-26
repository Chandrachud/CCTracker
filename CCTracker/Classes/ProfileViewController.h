//
//  ProfileViewController.h
//  CCTracker
//
//  Created by Patil, Chandrachud K. on 10/12/15.
//  Copyright © 2015 Patil, Chandrachud K. All rights reserved.
//
@class iCarousel;

#import <UIKit/UIKit.h>
#import "ITRAirSideMenu.h"

@interface ProfileViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIButton *addNewCard;
@property (nonatomic, weak) IBOutlet iCarousel *carousel;
@property (nonatomic, weak) IBOutlet UIView *cardView;

@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (weak, nonatomic) IBOutlet UILabel *transactionInfoLbl;
@property ITRAirSideMenu *itrAirSideMenu;

@property (weak, nonatomic) IBOutlet UILabel *welcomeNameLbl;
@property (weak, nonatomic) IBOutlet UILabel *emailLbl;
@property (weak, nonatomic) IBOutlet UILabel *phnLabel;


- (IBAction)addNewCard:(id)sender;

- (IBAction)didClickCard:(id)sender;

+ (instancetype) controller;

@end
