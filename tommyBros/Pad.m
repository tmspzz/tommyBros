//
//  Pad.m
//  tommyBros
//
//  Created by Tommaso Piazza on 5/11/11.
//  Copyright 2011 ChalmersTH. All rights reserved.
//

#import "Pad.h"


@implementation Pad

@synthesize delegate, isBeingUsed;

+ (Pad *) padWithFile: (NSString *) fileName tag:(const int)tag {
    
    return [[[self alloc] initWithFile:fileName tag:tag] autorelease];
        
}


- (id)initWithFile:(NSString *)fileName tag:(const int)tag{
    
	self = [super initWithFile:fileName];
    self.tag = tag;
    self.isBeingUsed = NO;
	return self;
}

- (CGRect)rectInPixels
{
	CGSize s = [self contentSizeInPixels];
	return CGRectMake(-s.width / 2, -s.height / 2, s.width, s.height);
}

- (void)onEnter {
    
	[[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
	[super onEnter];
}

- (void)onExit {
    
	[[CCTouchDispatcher sharedDispatcher] removeDelegate:self];
    self.isBeingUsed = NO;
	[super onExit];
}	

- (BOOL)containsTouchLocation:(UITouch *)touch
{
	CGPoint p = [self convertTouchToNodeSpaceAR:touch];
	CGRect r = [self rectInPixels];
	BOOL isContained = CGRectContainsPoint(r, p);
    return isContained;
}

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    
    
    if(isBeingUsed) return NO;
    
    if ( ![self containsTouchLocation:touch] ) 
        return NO;
    
    isBeingUsed = YES;
    
    if(delegate && [delegate respondsToSelector:@selector(touchAtLocation: forPad:)]){
        
        CGPoint convdtouch = [self convertTouchToNodeSpaceAR:touch];
        CGPoint modTouch = CGPointMake(convdtouch.x/(self.contentSizeInPixels.width/2), convdtouch.y/(self.contentSizeInPixels.height/2));
        
        [delegate touchAtLocation:modTouch forPad:self];
        
        return YES;
    }
    
    return NO;
}

- (void) ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event {
    
    if ( ![self containsTouchLocation:touch] ) return;
    
    if(delegate && [delegate respondsToSelector:@selector(touchAtLocation: forPad:)]){
        
        CGPoint convdtouch = [self convertTouchToNodeSpaceAR:touch];
        CGPoint modTouch = CGPointMake(convdtouch.x/(self.contentSizeInPixels.width/2), convdtouch.y/(self.contentSizeInPixels.height/2));
        
        [delegate touchAtLocation:modTouch forPad:self];
        
    }
    
	return;
}

- (void) ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event{
    
    isBeingUsed = NO;

    if(delegate && [delegate respondsToSelector:@selector(touchLiftedForPad:)]){
    
        [delegate touchLiftedForPad:self];
    }
}

@end
