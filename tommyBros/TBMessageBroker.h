//
//  TBMessageBroker.h
//  tommyBros
//
//  Created by Tommaso Piazza on 5/19/11.
//  Copyright 2011 ChalmersTH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TBMessage.h"
#import "TBMessageBrokerProtocolDelegate.h"
#import "AsyncSocket.h"

@interface TBMessageBroker : NSObject <AsyncSocketDelegate> {
    

    BOOL _connectionLostUnexpectedly;
    BOOL _isPaused;
    
    id<TBMessageBrokerProtocolDelegate> _delegate;
    
    @private
    AsyncSocket *_socket;
    NSMutableArray *_messageQueue;
    
}

@property (nonatomic, retain) AsyncSocket *socket;
@property (nonatomic, assign) id<TBMessageBrokerProtocolDelegate> delegate;
@property (nonatomic, assign) BOOL isPaused;
@property (nonatomic, retain) NSMutableArray *messageQueue;

- (id) initWithAsyncSocket:(AsyncSocket *) socket;
- (void) sendMessage:(TBMessage *) newMessage;

@end
