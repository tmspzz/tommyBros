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
@synthesize velX, velY, maxVelY, isJumping, aabbArray, aabbBottomArray;
@synthesize midTop, midBottom, midRight, midLeft, cornerLowerLeft, cornerLowerRight, isGrounded;


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
    
    self.aabbArray = [NSMutableArray arrayWithCapacity:6];
    self.aabbBottomArray = [NSMutableArray arrayWithCapacity:3];
    
	return self;
}

- (void) setPosition:(CGPoint)position {

    [super setPosition:position];
    
    midTop = CGPointMake(self.position.x , self.position.y + (self.contentSize.height/2)-1);
    midBottom = CGPointMake(self.position.x, self.position.y - (self.contentSize.height/2)+1);
    midRight = CGPointMake(self.position.x + (self.contentSize.width/2)-1, self.position.y);
    midLeft = CGPointMake(self.position.x - (self.contentSize.width/2)+1, self.position.y);
    cornerLowerRight = CGPointMake(self.position.x + (self.contentSize.width/2)-10, self.position.y - (self.contentSize.height/2)+1);
    cornerLowerLeft = CGPointMake(self.position.x - (self.contentSize.width/2)+10, self.position.y - (self.contentSize.height/2)+1);
    
    [aabbArray removeAllObjects];
    [aabbArray addObject:[NSValue valueWithCGPoint:midTop]];
    [aabbArray addObject:[NSValue valueWithCGPoint:midBottom]];
    [aabbArray addObject:[NSValue valueWithCGPoint:midRight]];
    [aabbArray addObject:[NSValue valueWithCGPoint:midLeft]];
    [aabbArray addObject:[NSValue valueWithCGPoint:cornerLowerLeft]];
    [aabbArray addObject:[NSValue valueWithCGPoint:cornerLowerRight]];
    
    [aabbBottomArray removeAllObjects];
    [aabbBottomArray addObject:[NSValue valueWithCGPoint:midBottom]];
    [aabbBottomArray addObject:[NSValue valueWithCGPoint:cornerLowerLeft]];
    [aabbBottomArray addObject:[NSValue valueWithCGPoint:cornerLowerRight]];
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

    self.aabbArray = nil;
    self.aabbBottomArray = nil;
    [super dealloc];

}

@end
