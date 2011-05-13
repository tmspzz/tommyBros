//
//  HUDProtocolDelegate.h
//  tommyBros
//
//  Created by Tommaso Piazza on 5/12/11.
//  Copyright 2011 ChalmersTH. All rights reserved.
//

#ifndef __HUDPROTOCOLDELEGATE_H
#define __HUDPROTOCOLDELEGATE_H

#import <Foundation/Foundation.h>


@protocol HUDProtocolDelegate <NSObject>

@required
- (void) jumpActionForPad:(const int) padNumber;
- (void) direction:(const int) direction forPad: (const int) pad;

@end

#endif