//
//  TransactionCell.h
//  CCTracker
//
//  Created by Patil, Chandrachud K. on 15/12/15.
//  Copyright © 2015 Patil, Chandrachud K. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TransactionCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *cellImage;
@property (weak, nonatomic) IBOutlet UILabel *cellTitle;

@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;

@property (weak, nonatomic) IBOutlet UIView *statusView;
@property (weak, nonatomic) IBOutlet UILabel *amountLabel;
@property (weak, nonatomic) IBOutlet UIView *rightBarView;
@property (weak, nonatomic) IBOutlet UIView *leftBarView;

@end
