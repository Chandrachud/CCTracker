//
//  ServerCommunicator.m
//  ExpenseTracker
//
//  Created by Chandrachud on 4/15/16.
//  Copyright © 2016 Patil, Chandrachud K. All rights reserved.
//

#import "ServerCommunicator.h"
#import "AFNetworking.h"
#import "CCCapture-Swift.h"
#import "AppDelegate.h"


NSString *baseUrl = @"http://ec2-52-38-248-25.us-west-2.compute.amazonaws.com:8080/cccapture/rest/v0/service/";

NSString *activateCard = @"activate";
NSString *login = @"user/login";
NSString *changePassword = @"change/password/";
NSString *uploadImage = @"upload/tran/file";
NSString *saveTransaction = @"save/transaction/detail";
NSString *getUserInfo = @"get/detail/user/";
NSString *getAllCards = @"get/card/user/";
NSString *getAllTransactions = @"get/all/transaction/card/";
NSString *getReceipt = @"get/receipt/transaction/";
NSString *updateUserInfo = @"update/user/detail";

@implementation ServerCommunicator

-(void)addCard:(NSDictionary *)dictionary downloadHandlerBlock:(downloadHandler)downloadHandlerBlock
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    NSString *cardNum = [dictionary valueForKey:@"Card Number"];
    long long cardNumVal = [cardNum longLongValue];
    
    [parameters setValue:[NSNumber numberWithLongLong:cardNumVal] forKey:@"cardNumber"];
    [parameters setValue:[dictionary valueForKey:@"Mobile Number"] forKey:@"phone"];
    
    NSString *lanId = [dictionary valueForKey:@"Mobile Number"];
    long long lanIdVal = [lanId longLongValue];
    
    [parameters setValue:[NSNumber numberWithLongLong:lanIdVal] forKey:@"lanId"];
    [parameters setValue:[dictionary valueForKey:@"Password"] forKey:@"password"];
    [parameters setValue:[dictionary valueForKey:@"UserName"] forKey:@"username"];
    [parameters setValue:[dictionary valueForKey:@"First Name"] forKey:@"firstName"];
    [parameters setValue:[dictionary valueForKey:@"Last Name"] forKey:@"lastName"];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSString *urlString = [NSString stringWithFormat:@"%@%@/",baseUrl,activateCard];
    
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    [DataManager makeRequestWithTheDetails:urlString httpMethod:@"POST" httpReqbody:parameters httpReqHeader:nil requestOrgnalData:FALSE onCompletionHandler:^(id returnObj,NSURLResponse *responseType,NSError *error){
        
        if ( nil != downloadHandlerBlock){
            
            downloadHandlerBlock(returnObj,error);
        }
    }];
    
    /*
     
     [manager POST:urlString parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
     
     } progress:^(NSProgress * _Nonnull uploadProgress) {
     
     } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
     NSLog(@"%@", responseObject);
     if ([self.delegate respondsToSelector:@selector(didActivateCardSuccessFully:)]) {
     [self.delegate didActivateCardSuccessFully:responseObject];
     }
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
     NSLog(@"%@", error);
     if ([self.delegate respondsToSelector:@selector(didFailToActivateCard:)]) {
     [self.delegate didFailToActivateCard:error];
     }
     }];
     
     */
}

-(void)processLogin:(NSString*)userName pwd:(NSString *)password downloadHandlerBlock:(downloadHandler)downloadHandlerBlock
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@/",baseUrl,login];
    
    [parameters setValue:userName forKey:@"username"];
    [parameters setValue:password forKey:@"password"];
    
    [DataManager makeRequestWithTheDetails:urlString httpMethod:@"POST" httpReqbody:parameters httpReqHeader:nil requestOrgnalData:FALSE onCompletionHandler:^(id returnObj,NSURLResponse *responseType,NSError *error){
        
        if ( nil != downloadHandlerBlock){
            
            downloadHandlerBlock(returnObj,error);
        }
    }];
}

-(void)getTheAllTransactions:(NSString *)UserId downloadHandlerBlock:(downloadHandler)downloadHandlerBlock{
    
    AppDelegate *del = [UIApplication sharedApplication].delegate;
    NSString *cardId  = [del.cardDict valueForKey:@"cardId"];
    NSString *urlString = [NSString stringWithFormat:@"%@%@%@/",baseUrl,getAllTransactions,cardId];
    
    [DataManager makeRequestWithTheDetails:urlString httpMethod:@"GET" httpReqbody:nil httpReqHeader:nil requestOrgnalData:FALSE onCompletionHandler:^(id returnObj,NSURLResponse *responseType,NSError *error){
        
        if ( nil != downloadHandlerBlock){
            
            downloadHandlerBlock(returnObj,error);
        }
    }];
}

-(void)getAllCards:(NSString *)UserId downloadHandlerBlock:(downloadHandler)downloadHandlerBlock{
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@%@/",baseUrl,getAllCards,UserId];
    
    [DataManager makeRequestWithTheDetails:urlString httpMethod:@"GET" httpReqbody:nil httpReqHeader:nil requestOrgnalData:FALSE onCompletionHandler:^(id returnObj,NSURLResponse *responseType,NSError *error){
        
        if ( nil != downloadHandlerBlock){
            
            downloadHandlerBlock(returnObj,error);
        }
    }];
}

-(void)getTheUserInfo:(NSString *)userId downloadHandlerBlock:(downloadHandler)downloadHandlerBlock{
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@%@/",baseUrl,getUserInfo,userId];
    
    [DataManager makeRequestWithTheDetails:urlString httpMethod:@"GET" httpReqbody:nil httpReqHeader:nil requestOrgnalData:FALSE onCompletionHandler:^(id returnObj,NSURLResponse *responseType,NSError *error){
        
        if ( nil != downloadHandlerBlock){
            
            downloadHandlerBlock(returnObj,error);
        }
    }];
}

-(void)saveTheNewTransaction:(NSDictionary *)dictionary downloadHandlerBlock:(downloadHandler)downloadHandlerBlock
{
    NSString *theamount = [dictionary valueForKey:@"amount"];
    long long amount = [theamount longLongValue];
    [dictionary setValue:[NSNumber numberWithLongLong:amount] forKey:@"amount"];
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@/",baseUrl,saveTransaction];
    
    [DataManager makeRequestWithTheDetails:urlString httpMethod:@"POST" httpReqbody:dictionary httpReqHeader:nil requestOrgnalData:FALSE onCompletionHandler:^(id returnObj,NSURLResponse *responseType,NSError *error){
        
        if ( nil != downloadHandlerBlock){
            
            downloadHandlerBlock(returnObj,error);
        }
    }];
}

-(void)uploadImage:(NSURL *)imgUrl image:(id)imgToUpload downloadHandlerBlock:(downloadHandler)downloadHandlerBlock{
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@/",baseUrl,uploadImage];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager setTaskDidSendBodyDataBlock:^(NSURLSession *session, NSURLSessionTask *task, int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend) {
        //during the progress
    }];
    
    NSData *imgData = UIImageJPEGRepresentation(imgToUpload,1.0);
    
    [manager POST:urlString parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:imgData name:@"file" fileName:@"photo_Uploaded.png" mimeType:@"image/png"];
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        
        if ( nil != downloadHandlerBlock){
            
            downloadHandlerBlock(responseObject,nil);
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        if ( nil != downloadHandlerBlock){
            
            downloadHandlerBlock(nil,error);
        }
    }];
}

-(void)getTransactionreceipt:(NSString *)transactionId downloadHandlerBlock:(downloadHandler)downloadHandlerBlock;
{
    NSString *urlString = [NSString stringWithFormat:@"%@%@%@",baseUrl,getReceipt,transactionId];
    
    [DataManager makeRequestWithTheDetails:urlString httpMethod:@"GET" httpReqbody:nil httpReqHeader:nil requestOrgnalData:YES onCompletionHandler:^(id returnObj,NSURLResponse *responseType,NSError *error){
        
        if ( nil != downloadHandlerBlock){
            
            downloadHandlerBlock(returnObj,error);
        }
    }];
}

-(void)updateUserInfo:(NSMutableDictionary *)dictionary downloadHandlerBlock:(downloadHandler)downloadHandlerBlock
{
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@/",baseUrl,updateUserInfo];
    
    [dictionary setValue:@"" forKey:@"address"];
    [DataManager makeRequestWithTheDetails:urlString httpMethod:@"POST" httpReqbody:dictionary httpReqHeader:nil requestOrgnalData:FALSE onCompletionHandler:^(id returnObj,NSURLResponse *responseType,NSError *error){
        
        if ( nil != downloadHandlerBlock){
            
            downloadHandlerBlock(returnObj,error);
        }
    }];
}
-(void)changePassword:(NSDictionary *)dictionary
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue:[dictionary valueForKey:@"userId"] forKey:@"user_id"];
    [parameters setValue:[dictionary valueForKey:@"UserName"] forKey:@"username"];
    [parameters setValue:[dictionary valueForKey:@"password"] forKey:@"psassword"];
    [parameters setValue:[dictionary valueForKey:@"newPassword"] forKey:@"new_password"];
}

@end
