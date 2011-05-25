//
//  TBMessageBroker.m
//  tommyBros
//
//  Created by Tommaso Piazza on 5/19/11.
//  Copyright 2011 ChalmersTH. All rights reserved.
//

#import "TBMessageBroker.h"

static const unsigned int MessageHeaderSize = sizeof(UInt64);
static const float SocketTimeout = -1.0;

@implementation TBMessageBroker

@synthesize isPaused = _isPaused;
@synthesize socket = _socket;
@synthesize delegate = _delegate;
@synthesize messageQueue = _messageQueue;


- (id) initWithAsyncSocket:(AsyncSocket *) newSocket{
    
    NSAssert( newSocket != nil, @"Argument must be non-nil");
    
    _isPaused = NO;

    if ( (self = [super init]) ) {
        if ( [newSocket canSafelySetDelegate] ) {
            self.socket = newSocket;
            [_socket setDelegate:self];
            self.messageQueue = [NSMutableArray arrayWithCapacity:2];
            [_socket readDataToLength:MessageHeaderSize withTimeout:SocketTimeout tag:0];
        }
        else {
            NSLog(@"Could not change delegate of socket");
            [self release];
            self = nil;
        }
    }
    return self;
    
}

- (void) sendMessage:(TBMessage *) newMessage{

    [_messageQueue addObject:newMessage];
    NSData *messageData = [NSKeyedArchiver archivedDataWithRootObject:newMessage];
    UInt64 header[1];
    header[0] = [messageData length]; 
    header[0] = CFSwapInt64HostToLittle(header[0]);  // Send header in little endian byte order
    [_socket writeData:[NSData dataWithBytes:header length:MessageHeaderSize] withTimeout:SocketTimeout tag:(long)0];
    [_socket writeData:messageData withTimeout:SocketTimeout tag:(long)1];

}

#pragma mark AsyncSocket Protocol

-(void)onSocket:(AsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag {
    if ( tag == 0 ) {
        // Header
        UInt64 header = *((UInt64*)[data bytes]);
        header = CFSwapInt64LittleToHost(header);  // Convert from little endian to native
        [_socket readDataToLength:(CFIndex)header withTimeout:SocketTimeout tag:(long)1];
    }
    else if ( tag == 1 ) { 
        // Message body. Pass to delegate
        if (_delegate && [_delegate respondsToSelector:@selector(messageBroker:didReceiveMessage:)] ) {
            TBMessage *message = [NSKeyedUnarchiver unarchiveObjectWithData:data];
            [_delegate messageBroker:self didReceiveMessage:message];
        }
        
        // Begin listening for next message
        if ( !_isPaused ) [_socket readDataToLength:MessageHeaderSize withTimeout:SocketTimeout tag:(long)0];
    }
    else {
        NSLog(@"Unknown tag in read of socket data %ld", tag);
    }
}


#pragma mark Memory Clean Up

- (void) dealloc {

    self.socket = nil;
    self.messageQueue = nil;
    
    [super dealloc];
    
}

@end
