//
//  GameOverScene.m
//  tommyBros
//
//  Created by Tommaso Piazza on 5/16/11.
//  Copyright 2011 ChalmersTH. All rights reserved.
//

#import "GameOverScene.h"
#import "SimpleAudioEngine.h"
#import "HelloWorldLayer.h"

@implementation GameOverScene
@synthesize layer = _layer;

- (id)init {
    
    if ((self = [super init])) {
        self.layer = [GameOverLayer node];
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

@implementation GameOverLayer
@synthesize label = _label;

-(id) init
{
    if( (self=[super initWithColor:ccc4(0,0,0,0)] )) {
        
        CGSize winSize = [[CCDirector sharedDirector] winSize];
        self.label = [CCLabelTTF labelWithString:@"Awwww snap :[" fontName:@"Arial" fontSize:32];
        _label.color = ccc3(255,255,255);
        _label.position = ccp(winSize.width/2, winSize.height/2);
        [self addChild:_label];
        
        
        [[SimpleAudioEngine sharedEngine] playEffect:@"game_over.caf"];
        [self runAction:[CCSequence actions:
                         [CCDelayTime actionWithDuration:4],
                         [CCCallFunc actionWithTarget:self selector:@selector(gameOverDone)],
                         nil]];
        
        
    }	
    return self;
}

- (void)gameOverDone {
    
    [[CCDirector sharedDirector] replaceScene:[HelloWorldLayer scene]];
    
}

- (void)dealloc {
    [_label release];
    _label = nil;
    [super dealloc];
}

@end