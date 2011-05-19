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
        _action = _action;
    
    }
    
    return self;
}

@end
