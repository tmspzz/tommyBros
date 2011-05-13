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
    float accX;
    float accY;
    int direction;
    BOOL isJumping;
    CGPoint cornerUpperRight;
    CGPoint cornerLowerRight;
    CGPoint cornerUpperLeft;
    CGPoint cornerLowerLeft;
    NSMutableArray *cornerArray;
    
    
}

@property (assign) float velX;
@property (assign) float velY;
@property (assign) float accX;
@property (assign) float accY;
@property (assign) BOOL isJumping;
@property (nonatomic, retain) NSArray *cornerArray;
@property (readonly) CGPoint cornerUpperRight, cornerUpperLeft, cornerLowerLeft, cornerLowerRight;

+ (Player *) playerWithFile: (NSString *) fileName tag:(const int)tag;
- (id)initWithFile:(NSString *)fileName tag:(const int)tag;
- (void) setPosition:(CGPoint)position;

@end

#endif