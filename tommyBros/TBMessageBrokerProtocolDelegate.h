//
//  TBMessageBrokerProtocolDelegate.h
//  tommyBros
//
//  Created by Tommaso Piazza on 5/19/11.
//  Copyright 2011 ChalmersTH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TBMessageBroker.h"
#import "TBMessage.h"

@class TBMessageBroker;

@protocol TBMessageBrokerProtocolDelegate <NSObject>
@optional

-(void)messageBroker:(TBMessageBroker *)server didSendMessage:(TBMessage *)message;
-(void)messageBroker:(TBMessageBroker *)server didReceiveMessage:(TBMessage *)message;
-(void)messageBrokerDidDisco:nnectUnexpectedly:(TBMessageBroker *)server;

@end
