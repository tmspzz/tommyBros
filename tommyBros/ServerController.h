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
#import "TBActionPassingProtocolDelegate.h"

//#import "MTMessageBroker.h"
//#import "MTMessage.h"

@interface ServerController : NSObject <NSNetServiceDelegate, AsyncSocketDelegate, TBMessageBrokerProtocolDelegate> {
    
    NSNetService *_netService;
    AsyncSocket *_listeningSocket;
    AsyncSocket *_connectionSocket;
    id<TBActionPassingProtocolDelegate> _delegate;
    TBMessageBroker *_messageBroker;
}

@property (nonatomic, retain) NSNetService *netService;
@property (nonatomic, retain) AsyncSocket *listeningSocket;
@property (nonatomic, retain) AsyncSocket *connectionSocket;
@property (nonatomic, retain) TBMessageBroker *messageBroker;
@property (nonatomic, assign) id<TBActionPassingProtocolDelegate> delegate;
//@property (readwrite, retain) MTMessageBroker *messageBroker;


+(ServerController *) sharedServerController;
+(id) alloc;
-(void) startService;
-(void) stopService;
-(void) dealloc;

@end
