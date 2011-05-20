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
    [_netService stop];
    self.netService = nil;
}

#pragma mark TBMessageBroker Delegate Methods

-(void)messageBroker:(TBMessageBroker *)server didReceiveMessage:(TBMessage *)message{

    NSLog(@"Message of actionType:%d, from Pad: %d, with action: %d", message.actionType, message.padNumber, message.action);

}

#pragma mark AsyncSocket Delegate Methods

-(void)onSocket:(AsyncSocket *)sock didConnectToHost:(NSString *)host port:(UInt16)port {
    TBMessageBroker *newBroker = [[[TBMessageBroker alloc] initWithAsyncSocket:sock] autorelease];
    newBroker.delegate = self;
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

    
    [super dealloc];
    
}

@end
