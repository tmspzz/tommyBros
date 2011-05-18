//
//  ServerController.h
//  tommyBros
//
//  Created by Tommaso Piazza on 5/18/11.
//  Copyright 2011 ChalmersTH. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ServerController : NSObject <NSNetServiceDelegate> {
    
    NSNetService *_netService;
    
}

@property (nonatomic, retain) NSNetService *netService;

+(ServerController *) sharedServerController;
+(id) alloc;
-(void) startService;
-(void) stopService;
-(void) dealloc;

@end
