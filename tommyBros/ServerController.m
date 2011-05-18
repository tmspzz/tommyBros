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
    _netService = [[NSNetService alloc] initWithDomain:@"" type:@"_tommyBros._tcp." name:@"" port:7865];
    _netService.delegate = self;
    [_netService publish];

}

-(void)stopService 
{
    [_netService stop];
    self.netService = nil;
}

#pragma mark Net Service Delegate Methods
-(void)netService:(NSNetService *)aNetService didNotPublish:(NSDictionary *)dict {
    NSLog(@"Failed to publish: %@", dict);
}


#pragma mark Memory Clean up

-(void) dealloc
{
    [self stopService];
    [super dealloc];
    
}

@end
