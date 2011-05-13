//
//  padProtocol.h
//  tommyBros
//
//  Created by Tommaso Piazza on 5/11/11.
//  Copyright 2011 ChalmersTH. All rights reserved.
//

#ifndef __PADPROTOCOLDELEGATE_H
#define __PADPROTOCOLDELEGATE_H

#import <Foundation/Foundation.h>


@protocol PadProtocolDelegate <NSObject>

@required
- (void) touchAtLocation:(CGPoint) location forPad:(id) pad;
- (void) touchLiftedForPad:(id) pad;

@end

#endif

