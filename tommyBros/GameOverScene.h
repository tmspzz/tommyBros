//
//  GameOverScene.h
//  tommyBros
//
//  Created by Tommaso Piazza on 5/16/11.
//  Copyright 2011 ChalmersTH. All rights reserved.
//

#ifndef __GAMEOVER_H
#define __GAMEOVER_H

#import "cocos2d.h"

@interface GameOverLayer : CCLayerColor {
    CCLabelTTF *_label;
}
@property (nonatomic, retain) CCLabelTTF *label;
@end

@interface GameOverScene : CCScene {
    GameOverLayer *_layer;
}
@property (nonatomic, retain) GameOverLayer *layer;
@end

#endif