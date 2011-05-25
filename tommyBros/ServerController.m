//
//  ServerController.m
//  tommyBros
//
//  Created by Tommaso Piazza on 5/18/11.
//  Copyright 2011 ChalmersTH. All rights reserved.
//

#import "ServerController.h"



@implementation ServerController

@synthesize netService = _netService;
@synthesize listeningSocket = _listeningSocket;
@synthesize messageBroker = _messageBroker;
@synthesize delegate = _delegate;
@synthesize connectionSocket = _connectionSocket;

static ServerController *_sharedServerController = nil;

+ (ServerController *) sharedServerController
{
    @synchronized([ServerController class])
    {
        if (!_sharedServerController)
            [[self alloc] init];
        return _sharedServerController;
    }
    // to avoid compiler warning
    return nil;
}

+(id)alloc
{
    @synchronized([ServerController class])
    {
        NSAssert(_sharedServerController == nil, @"Attempted to allocate a second instance of a singleton.");
        _sharedServerController = [super alloc];
        return _sharedServerController;
    }
    // to avoid compiler warning
    return nil;
}

#pragma mark Instance Methods

-(void) startService
{
    NSError *error;
    self.listeningSocket = [[[AsyncSocket alloc] initWithDelegate:self] autorelease];
    //[_listeningSocket setRunLoopModes:[NSArray arrayWithObject:NSRunLoopCommonModes]];
    if ( ![self.listeningSocket acceptOnPort:0 error:&error] ) {
        NSLog(@"Failed to create listening socket");
        return;
    }
    
    // Advertise service with bonjour
    NSString *serviceName = [NSString stringWithFormat:@"TommyBros on %@", [[NSProcessInfo processInfo] hostName]];
    _netService = [[NSNetService alloc] initWithDomain:@"" type:@"_tommyBros._tcp." name:serviceName port:self.listeningSocket.localPort];
    _netService.delegate = self;
    [_netService publish];

}

-(void)stopService 
{
    self.messageBroker.delegate = nil;
    self.messageBroker = nil;
    [_netService stop];
    self.netService = nil;
}

#pragma mark TBMessageBroker Delegate Methods

-(void)messageBroker:(TBMessageBroker *)server didReceiveMessage:(TBMessage *)message{

    NSLog(@"Message of actionType:%d, from Pad: %d, with action: %d", message.actionType, message.padNumber, message.action);
    if ( (_delegate && [_delegate respondsToSelector:@selector(didReceiveMessageWithActionType: forPad: withAction:)])) {
        
        [_delegate didReceiveMessageWithActionType:message.actionType forPad:message.padNumber withAction:message.action];

    }

}

#pragma mark AsyncSocket Delegate Methods

-(BOOL)onSocketWillConnect:(AsyncSocket *)sock {

    if ( self.connectionSocket == nil ) {
        self.connectionSocket = sock;
        return YES;
    }
    return NO;

}

- (void)onSocket:(AsyncSocket *)sock didAcceptNewSocket:(AsyncSocket *)newSocket{

    int i = 0;
}

-(void)onSocket:(AsyncSocket *)sock didConnectToHost:(NSString *)host port:(UInt16)port {
    
    TBMessageBroker *newBroker = [[[TBMessageBroker alloc] initWithAsyncSocket:sock] autorelease];
    newBroker.delegate = self;
    self.messageBroker = newBroker;
}

- (void)onSocket:(AsyncSocket *)sender willDisconnectWithError:(NSError *)error{
    
    NSLog(@"AsyncScoket willDisconnectWithError:%@", error);

}


-(void) onSocketDidDisconnect:(AsyncSocket *)sock{

    if ( sock == self.connectionSocket ) {
        NSLog(@"Server Controller: SOCKET DISCONNECTED!!!");
        self.connectionSocket = nil;
        self.messageBroker = nil;
    }
}

#pragma mark Net Service Delegate Methods

-(void)netService:(NSNetService *)aNetService didNotPublish:(NSDictionary *)dict {
    NSLog(@"Failed to publish: %@", dict);
}


#pragma mark Memory Clean up

-(void) dealloc
{
    [self stopService];
    self.listeningSocket = nil;
    self.connectionSocket = nil;

    [super dealloc];
    
}

@end
