//
//  Pad.h
//  tommyBros
//
//  Created by Tommaso Piazza on 5/11/11.
//  Copyright 2011 ChalmersTH. All rights reserved.
//

#ifndef __PAD_H
#define __PAD_H

#import "cocos2d.h"
#import "PadProtocolDelegate.h"

@interface Pad : CCSprite  <CCTargetedTouchDelegate> {
    
    id <PadProtocolDelegate> delegate;
    
}

@property (nonatomic, assign) id delegate;

+ (Pad *) padWithFile: (NSString *) fileName tag:(const int) tag;
- (Pad *) initWithFile: (NSString *) fileName tag:(const int) tag;;
- (BOOL)containsTouchLocation:(UITouch *)touch;
- (CGRect)rectInPixels;

@end

#endif