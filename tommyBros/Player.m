//
//  Player.m
//  tommyBros
//
//  Created by Tommaso Piazza on 5/12/11.
//  Copyright 2011 ChalmersTH. All rights reserved.
//

#import "Player.h"
#import "GameConfig.h"


@implementation Player
@synthesize velX, velY, maxVelY, isJumping, cornerArray, cornerLowerLeft;
@synthesize cornerLowerRight, cornerUpperLeft, cornerUpperRight, isGrounded;


+ (Player *) playerWithFile: (NSString *) fileName tag:(const int)tag {
    
    return [[[self alloc] initWithFile:fileName tag:tag] autorelease];
    
}


- (id)initWithFile:(NSString *)fileName tag:(const int)tag{
    
	self = [super initWithFile:fileName];
    self.tag = tag;
    
    velX = 0.0f;
    velY = 0.0f;
    maxVelY = -62.0f;
    isJumping = NO;
    isGrounded = YES;
    
    self.cornerArray = [NSMutableArray arrayWithCapacity:4];
    
	return self;
}

- (void) setPosition:(CGPoint)position {

    [super setPosition:position];
    
    cornerUpperRight = CGPointMake(self.position.x + (self.contentSize.width/2)-1, self.position.y + (self.contentSize.height/2)-1);
    cornerLowerRight = CGPointMake(self.position.x + (self.contentSize.width/2)-1, self.position.y - (self.contentSize.height/2)+1);
    cornerUpperLeft = CGPointMake(self.position.x - (self.contentSize.width/2)+1, self.position.y + (self.contentSize.height/2)-1);
    cornerLowerLeft = CGPointMake(self.position.x - (self.contentSize.width/2)+1, self.position.y - (self.contentSize.height/2)+1);
    
    [cornerArray removeAllObjects];
    [cornerArray addObject:[NSValue valueWithCGPoint:cornerLowerLeft]];
    [cornerArray addObject:[NSValue valueWithCGPoint:cornerUpperLeft]];
    [cornerArray addObject:[NSValue valueWithCGPoint:cornerUpperRight]];
    [cornerArray addObject:[NSValue valueWithCGPoint:cornerLowerRight]];

}

- (void) updateVelY {

    if(!isGrounded){
    
        velY += kGravity;
        if(velY < maxVelY){
            velY = maxVelY; 
        
        }
    
    }

}
- (void) updatePosition {

    self.position = ccp(self.position.x + velX, self.position.y + velY);

}

- (void) dealloc{

    self.cornerArray = nil;
    [super dealloc];

}

@end
