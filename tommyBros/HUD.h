//
//  HUD.h
//  tommyBros
//
//  Created by Tommaso Piazza on 5/11/11.
//  Copyright 2011 ChalmersTH. All rights reserved.
//

#import "cocos2d.h"
#import "Pad.h"
#import "HUDProtocolDelegate.h"

@interface HUD : CCLayer <PadProtocolDelegate> {
    
    CCLabelTTF *_attempts;
    CCLabelTTF *_coins;
    Pad *_padP1;
    Pad *_padP2;
    CCMenu *_buttonsMenu;
    CCMenuItem *_jumpButtonP1;
    CCMenuItem *_jumpButtonP2;
    id <HUDProtocolDelegate> delegate;
}

@property (nonatomic, retain) CCLabelTTF *attempts;
@property (nonatomic, retain) CCLabelTTF *coins;
@property (nonatomic, retain) Pad *padP1;
@property (nonatomic, retain) Pad *padP2;
@property (nonatomic, retain) CCMenu *buttonsMenu;
@property (nonatomic, retain) CCMenuItem *jumpButtonP1;
@property (nonatomic, retain) CCMenuItem *jumpButtonP2;
@property (nonatomic, assign) id delegate;

- (void) jumpActionP1;
- (void) jumpActionP2;

@end
