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
    NSMutableArray *_connectionSocketArray;
    id<TBActionPassingProtocolDelegate> _delegate;
    NSMutableArray *_messageBrokerArray;
}

@property (nonatomic, retain) NSNetService *netService;
@property (nonatomic, retain) AsyncSocket *listeningSocket;
@property (nonatomic, retain) NSMutableArray *connectionSocketArray;
@property (nonatomic, retain) NSMutableArray *messageBrokerArray;
@property (nonatomic, assign) id<TBActionPassingProtocolDelegate> delegate;
//@property (readwrite, retain) MTMessageBroker *messageBroker;


+(ServerController *) sharedServerController;
+(id) alloc;
-(void) startService;
-(void) stopService;
-(void) dealloc;

@end
