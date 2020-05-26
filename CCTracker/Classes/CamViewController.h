//
//  CamViewController.h
//  CCTracker
//
//  Created by Patil, Chandrachud K. on 14/12/15.
//  Copyright © 2015 Patil, Chandrachud K. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CamViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

- (IBAction)takePhoto:  (UIButton *)sender;
- (IBAction)selectPhoto:(UIButton *)sender;


@end
