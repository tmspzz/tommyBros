//
//  ServerController.h
//  tommyBros
//
//  Created by Tommaso Piazza on 5/18/11.
//  Copyright 2011 ChalmersTH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AsyncSocket.h"
#import "TBMessageBroker.h"


@interface ServerController : NSObject <NSNetServiceDelegate, AsyncSocketDelegate, TBMessageBrokerProtocolDelegate> {
    
    NSNetService *_netService;
    AsyncSocket *_listeningSocket;
}

@property (nonatomic, retain) NSNetService *netService;
@property (nonatomic, retain) AsyncSocket *listeningSocket;
@property (nonatomic, retain) TBMessageBroker *messageBroker;


+(ServerController *) sharedServerController;
+(id) alloc;
-(void) startService;
-(void) stopService;
-(void) dealloc;

@end
