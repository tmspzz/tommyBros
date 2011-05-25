//
//  TBActionPassingDelegate.h
//  iJPad
//
//  Created by Tommaso Piazza on 5/19/11.
//  Copyright 2011 ChalmersTH. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kActionTypeMove 100
#define kActionTypeButton 200
#define kActionJump 201

@protocol TBActionPassingProtocolDelegate <NSObject>
@optional

-(void) willSendMessageWihActionType:(int) msgActionType forPad:(int) padNumber withAction:(int) action;
-(void) didReceiveMessageWithActionType:(int) msgActionType forPad:(int) padNumber withAction:(int) action;

@end
