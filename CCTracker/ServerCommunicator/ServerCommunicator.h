//
//  ServerCommunicator.h
//  ExpenseTracker
//
//  Created by Chandrachud on 4/15/16.
//  Copyright © 2016 Patil, Chandrachud K. All rights reserved.
//


@protocol ServerCommunicatorDelegate;

#import <Foundation/Foundation.h>


#define             USERNAME            @"USERNAME"
#define             USERID            @"USERID"


#define             ERROR_TIMEDOUT                  @"1"
#define             MESSAGE_CALL_SUCCESS            @"2"
#define             ERROR_INVALID_PARAMS            @"3"
#define             ERROR_NOINTERNET                @"4"




typedef void (^downloadHandler)(id data,NSError *error);

@interface ServerCommunicator : NSObject

@property(nonatomic, assign) id<ServerCommunicatorDelegate>delegate;



-(void)addCard:(NSDictionary *)dictionary downloadHandlerBlock:(downloadHandler)downloadHandlerBlock;
-(void)processLogin:(NSString*)userName pwd:(NSString *)password downloadHandlerBlock:(downloadHandler)downloadHandlerBlock;

-(void)uploadImage:(NSURL *)imgUrl image:(id)imgToUpload downloadHandlerBlock:(downloadHandler)downloadHandlerBlock;

-(void)saveTheNewTransaction:(NSDictionary *)dictionary downloadHandlerBlock:(downloadHandler)downloadHandlerBlock;

-(void)getTheAllTransactions:(NSString *)UserId downloadHandlerBlock:(downloadHandler)downloadHandlerBlock;

-(void)getTheUserInfo:(NSString *)userId downloadHandlerBlock:(downloadHandler)downloadHandlerBlock;
-(void)getAllCards:(NSString *)userId downloadHandlerBlock:(downloadHandler)downloadHandlerBlock;
-(void)getTransactionreceipt:(NSString *)transactionId downloadHandlerBlock:(downloadHandler)downloadHandlerBlock;
-(void)updateUserInfo:(NSMutableDictionary *)dictionary downloadHandlerBlock:(downloadHandler)downloadHandlerBlock;

@end

@protocol ServerCommunicatorDelegate <NSObject>

-(void)didActivateCardSuccessFully:(NSDictionary *)responseDict;
-(void)didFailToActivateCard:(NSError *)error;

-(void)didLoginSuccessFully:(NSDictionary *)responseDict;
-(void)didFailToLogin:(NSError *)error;

-(void)didChangePassword:(NSDictionary *)responseDict;
-(void)didFailToChangePassword:(NSError *)error;
@end