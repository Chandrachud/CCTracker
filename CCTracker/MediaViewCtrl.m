//
//  MediaViewCtrl.m
//  ExpenseTracker
//
//  Created by Reddy, Tharakeswara V. on 4/21/16.
//  Copyright © 2016 Patil, Chandrachud K. All rights reserved.
//

#import "MediaViewCtrl.h"

@interface MediaViewCtrl ()
@property (weak, nonatomic) IBOutlet UIImageView *imageToShow;

@end

@implementation MediaViewCtrl

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.imageToShow.image = self.imageToDisplay;
    
    [self addBarButtonItems];
    
}


-(void)done{
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)addBarButtonItems
{
    UIBarButtonItem *barbutton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(done)];
    self.navigationItem.rightBarButtonItem = barbutton;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
