//
//  GameOverScene.h
//  tommyBros
//
//  Created by Tommaso Piazza on 5/16/11.
//  Copyright 2011 ChalmersTH. All rights reserved.
//

#ifndef __CUTSCENE_H
#define __CUTSCENE_H

#import "cocos2d.h"


@interface CutSceneLayer : CCLayerColor {
    CCLabelTTF *_label;
}
@property (nonatomic, retain) CCLabelTTF *label;
+(CutSceneLayer *) nodeWithString:(NSString *)text sound:(NSString *)soundString andDuration:(float) duration;
-(id) initWithString:(NSString *)text sound:(NSString *)soundString andDuration:(float) duration;
-(void) CutSceneDone;
@end

@interface CutScene : CCScene {
    CutSceneLayer *_layer;
}
@property (nonatomic, retain) CutSceneLayer *layer;
+(CutScene *) nodeWithString:(NSString *)text sound:(NSString *)soundString andDuration:(float) duration;
-(id) initWithString:(NSString *)text sound:(NSString *)soundString andDuration:(float) duration;
@end

#endif