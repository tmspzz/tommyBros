//
//  TBMessage.h
//  tommyBros
//
//  Created by Tommaso Piazza on 5/19/11.
//  Copyright 2011 ChalmersTH. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface TBMessage : NSObject <NSCoding> {
    
    int _actionType;
    int _padNumber;
    int _action;
    
}

@property (nonatomic, readonly) int actionType;
@property (nonatomic, readonly) int padNumber;
@property (nonatomic, readonly) int action;

+ (TBMessage *) messageWithActionType:(int) actionType forPad:(int) padNumber withAction:(int) action;
- (id) initWithActionType:(int) actionType forPad:(int) padNumber withAction:(int) action;

@end
