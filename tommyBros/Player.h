//
//  Player.h
//  tommyBros
//
//  Created by Tommaso Piazza on 5/12/11.
//  Copyright 2011 ChalmersTH. All rights reserved.
//

#ifndef __PLAYER_H
#define __PLAYER_H


#import "cocos2d.h"

@interface Player : CCSprite {
    
    float velX;
    float velY;
    float maxVelY;
    int direction;
    
    BOOL isJumping;
    BOOL isGrounded;
    
    CGPoint midTop;
    CGPoint midBottom;
    CGPoint midRight;
    CGPoint midLeft;
    CGPoint cornerLowerRight;
    CGPoint cornerLowerLeft;
    NSMutableArray *aabbArray;
    NSMutableArray *aabbBottomArray;
    
    
}

@property (assign) float velX;
@property (assign) float velY;
@property (assign) float maxVelY;
@property (assign) BOOL isJumping;
@property (assign) BOOL isGrounded;
@property (nonatomic, retain) NSArray *aabbArray;
@property (nonatomic, retain) NSArray *aabbBottomArray;
@property (readonly) CGPoint midTop, midBottom, midRight, midLeft, cornerLowerRight, cornerLowerLeft;

+ (Player *) playerWithFile: (NSString *) fileName tag:(const int)tag;
- (id)initWithFile:(NSString *)fileName tag:(const int)tag;
- (void) setPosition:(CGPoint)position;
- (void) updateVelY;
- (void) updatePosition;

@end

#endif