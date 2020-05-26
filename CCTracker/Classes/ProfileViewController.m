//
//  ProfileViewController.m
//  CCTracker
//
//  Created by Patil, Chandrachud K. on 10/12/15.
//  Copyright © 2015 Patil, Chandrachud K. All rights reserved.
//

#import "ProfileViewController.h"
#import "Header.h"
#import "AddNewCardController.h"
#import "TransactionsController.h"
#import "iCarousel.h"
#import "MBProgressHUD.h"
#import "ITRAirSideMenu.h"
#import "AppDelegate.h"
#import "ServerCommunicator.h"

@interface ProfileViewController ()<MBProgressHUDDelegate,iCarouselDataSource,iCarouselDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    MBProgressHUD *HUD;
    BOOL shouldOpen;
}

@property(nonatomic, strong) AddNewCardController *addNewCardCont;
@property(nonatomic, strong) TransactionsController *transactionController;
@property(nonatomic, strong) NSArray *cardsArray;

@end

@implementation ProfileViewController

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    [self addBarButtonItems];
    [self configureaddNewCard];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(myFunc) name:UIApplicationWillEnterForegroundNotification object:nil];
    
    self.transactionInfoLbl.layer.cornerRadius = 5.0;
    _transactionInfoLbl.layer.masksToBounds = YES;
    _transactionInfoLbl.layer.borderColor = [UIColor blueColor].CGColor;
    _transactionInfoLbl.layer.borderWidth = 1.0;

    AppDelegate *del = [UIApplication sharedApplication].delegate;
    shouldOpen = del.didOpenWithURL;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self displayProfileInfo];
    self.cardsArray = [self parseLocalJSON:@"cards copy"];
    [self iCourasel];
    self.pageControl.currentPage = 0;
    self.pageControl.numberOfPages = self.cardsArray.count;
    [_carousel reloadData];
    self.navigationController.navigationBarHidden = NO;
//    self.cardView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"card"]];
    
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    
    if (shouldOpen)
    {
        [self showOptions];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    _carousel.delegate = nil;
    _carousel.dataSource = nil;
}

- (void)dealloc
{
    //it's a good idea to set these to nil here to avoid
    //sending messages to a deallocated viewcontroller
    _carousel.delegate = nil;
    _carousel.dataSource = nil;
}

#pragma mark - Other Methods

-(void)displayProfileInfo
{
    AppDelegate *del = [UIApplication sharedApplication].delegate;
    NSDictionary *dict = del.userProfileDict;
    
    NSString *firstName = [dict valueForKey:@"firstName"];
    NSString *lastName = [dict valueForKey:@"lastName"];
    self.welcomeNameLbl.text = [NSString stringWithFormat:@"Welcome %@, %@",lastName,firstName];
    self.emailLbl.text = [NSString stringWithFormat:@"%@.%@@wellsfargo.com",lastName,firstName];
}

-(void)myFunc
{
    [self showOptions];
}

-(void)iCourasel
{
    self.carousel.type = iCarouselTypeCoverFlow2;
    self.carousel.delegate = self;
    self.carousel.dataSource = self;
}

-(void)addBarButtonItems
{
    self.title = @"My Cards";
    self.navigationController.navigationBar.tintColor = RED_Color;
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setFrame:CGRectMake(0.0, 0.0, 20.0, 20.0)];
    [btn setImage:[UIImage imageNamed:@"icon - Logout@1x.png"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(logout) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barbutton = [[UIBarButtonItem alloc]initWithCustomView:btn];
    self.navigationItem.rightBarButtonItem = barbutton;
    
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn setFrame:CGRectMake(0.0, 0.0, 20.0, 20.0)];
    [leftBtn setImage:[UIImage imageNamed:@"icon - Menu@1x.png"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(presentLeftController) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *leftBarbutton = [[UIBarButtonItem alloc]initWithCustomView:leftBtn];
    self.navigationItem.leftBarButtonItem = leftBarbutton;
    
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName:RED_Color}];
    
    [self.navigationController.navigationBar  setBackgroundColor:[UIColor whiteColor]];
    self.navigationItem.hidesBackButton = YES;
    
}

-(void)logout
{
    //   [self.navigationController popToRootViewControllerAnimated:NO];
    
    [((AppDelegate *)[UIApplication sharedApplication].delegate) showTheLoginScreen];
}

-(void)configureaddNewCard
{
    self.addNewCard.layer.borderWidth = 1.0;
    self.addNewCard.layer.cornerRadius = 25.0;
    self.addNewCard.layer.borderColor = BLACK_Color.CGColor;
    self.addNewCard.titleLabel.textColor = BLACK_Color;
    
    ServerCommunicator *serverComm = [[ServerCommunicator alloc] init];

    AppDelegate *del = [UIApplication sharedApplication].delegate;
    NSDictionary *dict = del.userProfileDict;

    [serverComm getAllCards:[dict valueForKey:@"userId"] downloadHandlerBlock:^(id data, NSError *error) {
        
        if (nil != error) {
            
        }
        else
        {
            del.cardDict = data;
        }
    }];
}

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


- (IBAction)addNewCard:(id)sender
{
//        _addNewCardCont = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"AddNewCardController"];
//        UINavigationController *navCont = [[UINavigationController alloc]initWithRootViewController:_addNewCardCont];
//    
//        [self.navigationController presentViewController:navCont animated:YES completion:nil];
   // [self showOptions];
    
    self.transactionController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"NewTransactionController"];
    [self.navigationController pushViewController:self.transactionController animated:YES];
   }

- (IBAction)didClickCard:(id)sender
{
    self.transactionController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"TransactionsController"];
    NSDictionary *dict = [self.cardsArray objectAtIndex:0];
    _transactionController.cardNum = dict[@"cardNumber"];
    _transactionController.transactions = dict[@"transactions"];
    [self.navigationController pushViewController:self.transactionController animated:YES];
}

-(void)showOptions
{
    [self addNewCard:self];
    shouldOpen = NO;
    AppDelegate *del = [UIApplication sharedApplication].delegate;
    del.didOpenWithURL = NO;
//    UIActionSheet *sheet = [[UIActionSheet alloc]initWithTitle:@"Select Photo" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil     otherButtonTitles:@"Camera",@"Choose from Gallery", nil];
//    [sheet showInView:self.view];

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
    HUD.labelText = @"Connecting";
    HUD.minSize = CGSizeMake(135.f, 135.f);
    
    [HUD showWhileExecuting:@selector(myMixedTask) onTarget:self withObject:nil animated:YES];
}

- (void)myMixedTask {
    // Indeterminate mode
    sleep(2);
    // Switch to determinate mode
    HUD.mode = MBProgressHUDModeDeterminate;
    HUD.labelText = @"Uploading";
    float progress = 0.0f;
    while (progress < 1.0f)
    {
        progress += 0.01f;
        HUD.progress = progress;
        usleep(50000);
    }
    // Back to indeterminate mode
    //HUD.mode = MBProgressHUDModeIndeterminate;
    //HUD.labelText = @"Uploading";
    //sleep(2);
    // UIImageView is a UIKit class, we have to initialize it on the main thread
    __block UIImageView *imageView;
    dispatch_sync(dispatch_get_main_queue(), ^{
        UIImage *image = [UIImage imageNamed:@"37x-Checkmark.png"];
        imageView = [[UIImageView alloc] initWithImage:image];
    });
    HUD.customView = imageView;
    HUD.mode = MBProgressHUDModeCustomView;
    HUD.labelText = @"Completed";
    sleep(2);
}

#pragma mark - CardsCarouselDataSource Methods

- (NSInteger)numberOfItemsInCarousel:(__unused iCarousel *)carousel
{
    return self.cardsArray.count;
}

#pragma mark - Helpers

- (UIView *)carousel:(__unused iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view
{
    NSString *label = [NSString stringWithFormat:@"%i", (int)index];
    return [self createCardViewWithLabel:label forIndex:index];
}

- (void)carousel:(__unused iCarousel *)carousel didSelectItemAtIndex:(NSInteger)index
{
    self.transactionController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"TransactionsController"];
    NSDictionary *dict = [self.cardsArray objectAtIndex:index];
    _transactionController.cardNum = dict[@"cardNumber"];
    _transactionController.transactions = dict[@"transactions"];
    [self.navigationController pushViewController:self.transactionController animated:YES];
}

- (void)carouselCurrentItemIndexDidChange:(__unused iCarousel *)carousel
{
    self.pageControl.currentPage = self.carousel.currentItemIndex;
}

- (UIView*)createCardViewWithLabel:(NSString*)label forIndex:(NSInteger)index
{
    NSDictionary *dict = [self.cardsArray objectAtIndex:index];
    
    UIView *cardView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width - 50, 250)];
    [cardView setBackgroundColor:[UIColor whiteColor]];
    [cardView.layer setShadowColor:[UIColor blackColor].CGColor];
    [cardView.layer setShadowOpacity:.5];
    [cardView.layer setShadowOffset:CGSizeMake(0, 0)];
    
    //Card Image
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(cardView.frame.size.width/2 + 20, 10, cardView.frame.size.width/2 - 30, 85)];
    imageView.image = [UIImage imageNamed:@"Card Background copy@1x.png"];
    [cardView addSubview:imageView];
    
    //Name Label
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectInset(cardView.frame, 20, 20)];
    nameLabel.frame = CGRectMake(10, 15, cardView.frame.size.width/2, 15);
    nameLabel.text = dict[@"cardHolder"];
    [nameLabel setFont:[UIFont systemFontOfSize:12]];
    nameLabel.textColor = [UIColor darkGrayColor];
    [cardView addSubview:nameLabel];
    
    //Company Name label
    UILabel *companyLabel = [[UILabel alloc] initWithFrame:CGRectInset(cardView.frame, 20, 20)];
    companyLabel.frame = CGRectMake(10, nameLabel.frame.origin.y + 15, cardView.frame.size.width/2, 15);
    companyLabel.text = dict[@"company"];
    [companyLabel setFont:[UIFont systemFontOfSize:10]];
    companyLabel.textColor = [UIColor lightGrayColor];
    
    [cardView addSubview:companyLabel];
    
    //Card Type
    UILabel *cardTypeLabel = [[UILabel alloc] initWithFrame:CGRectInset(cardView.frame, 20, 20)];
    cardTypeLabel.frame = CGRectMake(10, companyLabel.frame.origin.y + 15, cardView.frame.size.width/2, 15);
    cardTypeLabel.text = dict[@"cardType"];
    [cardTypeLabel setFont:[UIFont systemFontOfSize:10]];
    cardTypeLabel.textColor = [UIColor lightGrayColor];
    
    [cardView addSubview:cardTypeLabel];
    
    //Card Number
    UILabel *cardNumberLabel = [[UILabel alloc] initWithFrame:CGRectInset(cardView.frame, 20, 20)];
    cardNumberLabel.frame = CGRectMake(10, cardTypeLabel.frame.origin.y + 15, cardView.frame.size.width/2, 15);
    cardNumberLabel.text = dict[@"cardNumber"];
    [cardNumberLabel setFont:[UIFont systemFontOfSize:10]];
    cardNumberLabel.textColor = [UIColor lightGrayColor];
    
    [cardView addSubview:cardNumberLabel];
    
    
    UIView *newStatusView = [[UIView alloc]initWithFrame:CGRectMake(cardView.frame.size.width*(.25) - 25, 150, 10, 10)];
    newStatusView.backgroundColor = COLOR_NEW;
    newStatusView.layer.cornerRadius = 5;
    [cardView addSubview:newStatusView];
    
    UIView *submittedStatusView = [[UIView alloc]initWithFrame:CGRectMake(cardView.frame.size.width*(.5) - 5, 150, 10, 10)];
    submittedStatusView.backgroundColor = COLOR_PENDING;
    submittedStatusView.layer.cornerRadius = 5;
    [cardView addSubview:submittedStatusView];
    
    UIView *approvedStatusView = [[UIView alloc]initWithFrame:CGRectMake((cardView.frame.size.width)*(.75)+15, 150, 10, 10)];
    approvedStatusView.backgroundColor = COLOR_APPROVED;
    approvedStatusView.layer.cornerRadius = 5;
    [cardView addSubview:approvedStatusView];
    
    CGRect newStatuslabelRect =CGRectMake(cardView.frame.size.width*(.25) - 35, 160, 30, 50);
    [self addLabelWithFrame:newStatuslabelRect text:@"2" inView:cardView withFont:24];
    
    CGRect submittedStatuslabelRect = CGRectMake(cardView.frame.size.width*(.5) - 15, 160, 30, 50);
    [self addLabelWithFrame:submittedStatuslabelRect text:@"0" inView:cardView withFont:24];
    
    CGRect approvedStatuslabel = CGRectMake(cardView.frame.size.width*(.75), 160, 30, 50);
    [self addLabelWithFrame:approvedStatuslabel text:@"20" inView:cardView withFont:24];
    
    CGRect newtitlelabelRect = CGRectMake(cardView.frame.size.width*(.25) - 45, 190, 50, 50);
    [self addLabelWithFrame:newtitlelabelRect text:@"New" inView:cardView withFont:15];
    
    CGRect submittedTitlelabelRect = CGRectMake(cardView.frame.size.width*(.5) - 35, 190, 80, 50);
    [self addLabelWithFrame:submittedTitlelabelRect text:@"Submitted" inView:cardView withFont:15];
    
    CGRect approvedTitlelabelRect = CGRectMake(cardView.frame.size.width*(.75) - 20, 190, 70, 50);
    [self addLabelWithFrame:approvedTitlelabelRect text:@"Approved" inView:cardView withFont:15];
    
    return cardView;
}

-(void)addLabelWithFrame:(CGRect)frame text:(NSString*)text inView:(UIView *)cardView withFont:(CGFloat)font
{
    UILabel *label = [[UILabel alloc]initWithFrame:frame];
    label.frame = frame;
    label.text = text;
    label.textAlignment = NSTextAlignmentCenter;
    [label setFont:[UIFont systemFontOfSize:font]];
    [cardView addSubview:label];
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

#pragma mark - UIImagePickerControllerDelegate

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
   // UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    //    self.imageView.image = chosenImage;
    [picker dismissViewControllerAnimated:YES completion:NULL];
    [self showLoadingIndicator];

}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - MBProgressHUDDelegate

- (void)hudWasHidden:(MBProgressHUD *)hud {
    // Remove HUD from screen when the HUD was hidded
    [HUD removeFromSuperview];
//    [HUD release];
    HUD = nil;
}

- (void)viewDidUnload {
//    [self setButtons:nil];
    [super viewDidUnload];
}


#pragma mark - Slide Navigation Methods

+ (instancetype) controller{
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    return [storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([ProfileViewController class])];
}

- (void) presentLeftController{
    
    [((AppDelegate *)[UIApplication sharedApplication].delegate) showTheHomeScreenWithAnimationFlag:YES];

    //show left menu with animation
    
    ITRAirSideMenu *itrSideMenu = ((AppDelegate *)[UIApplication sharedApplication].delegate).itrAirSideMenu;
    [itrSideMenu presentLeftMenuViewController];
    
}



@end
