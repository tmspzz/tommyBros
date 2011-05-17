//
//  GameOverScene.m
//  tommyBros
//
//  Created by Tommaso Piazza on 5/16/11.
//  Copyright 2011 ChalmersTH. All rights reserved.
//

#import "CutScene.h"
#import "SimpleAudioEngine.h"
#import "HelloWorldLayer.h"

@implementation CutScene
@synthesize layer = _layer;

+(CutScene *) nodeWithString:(NSString *)text sound:(NSString *)soundString andDuration:(float) duration{

    return [[[self alloc] initWithString:text sound:soundString andDuration:duration] autorelease];
}

- (id)initWithString:(NSString *)text sound:(NSString *)soundString andDuration:(float) duration{
    
    if ((self = [super init])) {
        self.layer = [CutSceneLayer nodeWithString:text sound:soundString andDuration:duration];
        [self addChild:_layer];
    }
    return self;
}

- (void)dealloc {
    [_layer release];
    _layer = nil;
    [super dealloc];
}

@end

@implementation CutSceneLayer
@synthesize label = _label;

+(CutSceneLayer *) nodeWithString:(NSString *)text sound:(NSString *)soundString andDuration:(float) duration{
    
    return [[[self alloc] initWithString:text sound:soundString andDuration:duration] autorelease];
}

-(id) initWithString:(NSString *)text sound:(NSString *)soundString andDuration:(float) duration {
    if( (self=[super initWithColor:ccc4(0,0,0,0)] )) {
        
        CGSize winSize = [[CCDirector sharedDirector] winSize];
        self.label = [CCLabelTTF labelWithString:text fontName:@"Arial" fontSize:32];
        _label.color = ccc3(255,255,255);
        _label.position = ccp(winSize.width/2, winSize.height/2);
        [self addChild:_label];
        
        
        [[SimpleAudioEngine sharedEngine] playEffect:soundString];
        [self runAction:[CCSequence actions:
                         [CCDelayTime actionWithDuration:duration],
                         [CCCallFunc actionWithTarget:self selector:@selector(CutSceneDone)],
                         nil]];
        
        
    }	
    return self;
}

- (void) CutSceneDone {
    
    [[CCDirector sharedDirector] replaceScene:[HelloWorldLayer scene]];
    
}

- (void)dealloc {
    [_label release];
    _label = nil;
    [super dealloc];
}

@end