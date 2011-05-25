//
//  TBMessage.m
//  tommyBros
//
//  Created by Tommaso Piazza on 5/19/11.
//  Copyright 2011 ChalmersTH. All rights reserved.
//

#import "TBMessage.h"


@implementation TBMessage

@synthesize actionType = _actionType;
@synthesize action = _action;
@synthesize padNumber = _padNumber;

+ (TBMessage *) messageWithActionType:(int) actionType forPad:(int) padNumber withAction:(int) action
{
    return [[[self alloc] initWithActionType:actionType forPad:padNumber withAction:action] autorelease];

}

- (id) initWithActionType:(int) actionType forPad:(int) padNumber withAction:(int) action
{
    
    if((self = [super init]))
    {
    
        _actionType = actionType;
        _padNumber = padNumber;
        _action = action;
    
    }
    
    return self;
}

#pragma mark NSCoding Protocol

- (id) initWithCoder:(NSCoder *)aDecoder {

    if((self = [super init])){
    
        
        _actionType = [aDecoder decodeInt32ForKey:@"_actionType"];
        _padNumber = [aDecoder decodeInt32ForKey:@"_padNumber"];
        _action = [aDecoder decodeInt32ForKey:@"_action"] ;
    }

    return self;
}

- (void) encodeWithCoder:(NSCoder*)encoder {
    
    [encoder encodeInt32:_actionType forKey:@"_actionType"];
    [encoder encodeInt32:_padNumber forKey:@"_padNumber"];
    [encoder encodeInt32:_action forKey:@"_action"];
    
}

@end
