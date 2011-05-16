//
//  HelloWorldLayer.h
//  tommyBros
//
//  Created by Tommaso Piazza on 5/11/11.
//  Copyright ChalmersTH 2011. All rights reserved.
//


// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"
#import "HUD.h"
#import "HUDProtocolDelegate.h"
#import "Player.h"
#import "GameOverScene.h"

static int numAttempts;

// HelloWorldLayer
@interface HelloWorldLayer : CCLayer <HUDProtocolDelegate>
{
    
    CCTMXTiledMap *_map;
    CCTMXLayer *_backgroundLayer;
    CCTMXLayer *_foregroundLayer;
    CCTMXLayer *_metaLayer;
    CCTMXObjectGroup *_objectLayer;
    CCTMXObjectGroup *_physicsLayer;
    HUD *_hud;
    Player *_player1;
    Player *_player2;
    int numCoins;
    
}

@property (nonatomic, retain) CCTMXTiledMap *map;
@property (nonatomic, retain) CCTMXLayer *backgroundLayer;
@property (nonatomic, retain) CCTMXLayer *foregroundLayer;
@property (nonatomic, retain) CCTMXLayer *metaLayer;
@property (nonatomic, retain) CCTMXObjectGroup *objectLayer;
@property (nonatomic, retain) CCTMXObjectGroup *physicsLayer;
@property (nonatomic, retain) HUD *hud;
@property (nonatomic, retain) Player *player1;
@property (nonatomic, retain) Player *player2;


// returns a CCScene that contains the HelloWorldLayer as the only child
+(CCScene *) scene;
- (CGPoint)tileCoordForPosition:(CGPoint)position;
- (BOOL) resolvePlayerWorldCollision:(Player *) player;
- (BOOL) isOnGround:(Player *) player;
- (void) scrollMap;

@end
