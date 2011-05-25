//
//  HelloWorldLayer.m
//  tommyBros
//
//  Created by Tommaso Piazza on 5/11/11.
//  Copyright ChalmersTH 2011. All rights reserved.
//


// Import the interfaces
#import "HelloWorldLayer.h"
#import "GameConfig.h"
#import "SimpleAudioEngine.h"
#import "CutScene.h"
#import "ServerController.h"

static int numAttempts;

// HelloWorldLayer implementation
@implementation HelloWorldLayer

@synthesize map = _map;
@synthesize backgroundLayer = _backgroundLayer;
@synthesize foregroundLayer = _foregroundLayer;
@synthesize metaLayer = _metaLayer;
@synthesize objectLayer = _objectLayer;
@synthesize physicsLayer = _physicsLayer;
@synthesize hud = _hud;
@synthesize player1 = _player1;
@synthesize player2 = _player2;


+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
    
    HUD *hud = [HUD sharedHUD];
    
	[scene addChild:hud z:10];
	
	// 'layer' is an autorelease object.
	HelloWorldLayer *layer = [HelloWorldLayer node];
    [[ServerController sharedServerController] setDelegate:layer];
	
	// add layer as a child to scene
	[scene addChild: layer z:0 tag:1];
    
	// return the scene
	return scene;
}

// on "init" you need to initialize your instance
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
	if( (self=[super init])) {
		
        CGSize winSize = [[CCDirector sharedDirector] winSize];
        
        self.map = [CCTMXTiledMap tiledMapWithTMXFile:@"Scroller.tmx"];
        self.backgroundLayer = [_map layerNamed:@"Background"];
        self.backgroundLayer.visible = YES;
        
        self.metaLayer = [_map layerNamed:@"Meta"];
        _metaLayer.visible = NO;
        
        // create a void node, a parent node
		
        
        self.objectLayer = [_map objectGroupNamed:@"Objects"];
        self.foregroundLayer = [_map layerNamed:@"Foreground"];
        self.physicsLayer = [_map objectGroupNamed:@"Physics"];
        
        NSMutableDictionary *spawnPointP1 = [_objectLayer objectNamed:@"StartP1"];
        NSMutableDictionary *spawnPointP2 = [_objectLayer objectNamed:@"StartP2"];
		
		[self addChild:_map z:-1];
        
        self.hud = [HUD sharedHUD];
        _hud.delegate = self;
        numCoins = 0;
        
        _hud.padP1.position = ccp(_map.tileSize.width * 1.5, _map.tileSize.height * 1.5);
        _hud.padP2.position = ccp(winSize.width - _map.tileSize.width * 4.5, _map.tileSize.height * 1.5);
        _hud.jumpButtonP2.anchorPoint=ccp(0, 0);
        _hud.jumpButtonP2.position = ccp(_map.tileSize.width *6, _map.tileSize.height*-5);
        _hud.jumpButtonP1.anchorPoint=ccp(0, 0);
        _hud.jumpButtonP1.position = ccp(_map.tileSize.width *-4, _map.tileSize.height*-5);
        
        self.player1 = [Player playerWithFile:@"Player1.png" tag:kPlayer1];
        float contSizeW = self.player1.contentSize.width;
        float contSizeH = self.player1.contentSize.height;
        self.player1.position = ccp([[spawnPointP1 valueForKey:@"x"] floatValue] + contSizeW/2, [[spawnPointP1 valueForKey:@"y"] floatValue] + contSizeH/2);
        
        self.player2 = [Player playerWithFile:@"Player2.png" tag:kPlayer2];
        contSizeW = self.player2.contentSize.width;
        contSizeH = self.player2.contentSize.height;
        self.player2.position = ccp([[spawnPointP2 valueForKey:@"x"] floatValue] + contSizeW/2, [[spawnPointP2 valueForKey:@"y"] floatValue] + contSizeH/2);

        [self addChild:_player1];
        [self addChild:_player2];
        
        [[SimpleAudioEngine sharedEngine] preloadEffect:@"coin.caf"];
        [[SimpleAudioEngine sharedEngine] preloadEffect:@"jump.caf"];
        [[SimpleAudioEngine sharedEngine] preloadEffect:@"game_over.caf"];
        [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"smb_over.caf"];
        
        [self scheduleUpdate];

        
	}
	return self;
}

-(void) update: (ccTime) delta
{
    int steps = 1;
	CGFloat dt = delta/(CGFloat)steps;
    
    [_player1 updateVelY];
    if(![self resolvePlayerWorldCollision:_player1])
    {
    
        [_player1 updatePosition];
        if(![self isOnGround:_player1]){
            
            _player1.isGrounded = NO;
        
        }
        
    }
    
    [_player2 updateVelY];
    if(![self resolvePlayerWorldCollision:_player2])
    {
        
        [_player2 updatePosition];
        if(![self isOnGround:_player2]){
            
            _player2.isGrounded = NO;
            
        }
        
    }
    
    if([self isVictory]){

        [[SimpleAudioEngine sharedEngine] stopBackgroundMusic];
        CutScene *victoryScene = [CutScene nodeWithString:[NSString stringWithFormat:@"Hooray! You Win! Attempts:%d Coins:%d", numAttempts, numCoins] sound:@"victory.caf" andDuration:30.0];
        numCoins = 0;
        [_hud.coins setString:[NSString stringWithFormat:@"Coins :%d", numCoins]];
        [[CCDirector sharedDirector] replaceScene:victoryScene];
    
    }
    [self scrollMap];

}

#pragma mark Game States

- (BOOL) isVictory
{
    int lastTileX = _map.mapSize.width * _map.tileSize.width - (_map.tileSize.width*3/4);
    if ( _player1.position.x > lastTileX && _player2.position.x > lastTileX)
    {
        return YES;
    }

    return NO;
}

#pragma mark Map Scrolling

- (void) scrollMap {
    
    CGPoint actualPosition;
    int x = 0;

    CGSize winSize = [[CCDirector sharedDirector] winSize];
    CGPoint centerOfView = ccp(winSize.width/2, winSize.height/2);
    
    int p1DistCenterScrX = _player1.position.x -  _map.mapSize.width/2*_map.tileSize.width;
    int p2DistCenterScrX = _player2.position.x -  _map.mapSize.width/2*_map.tileSize.width;
    
    int furthest = MAX(abs(p1DistCenterScrX), abs(p2DistCenterScrX));
    
    if(furthest == abs(p1DistCenterScrX)){
        
        x = MAX(_player1.position.x, winSize.width/2);
    
    }else if(furthest == abs(p2DistCenterScrX)){
    
        x = MAX(_player2.position.x, winSize.width/2);
    
    }
   
    x = MIN(x, (_map.mapSize.width * _map.tileSize.width) - winSize.width/2);
    
    actualPosition = ccp(x, winSize.height/2);
    
   
    
    CGPoint viewPoint = ccpSub(centerOfView, actualPosition);

    self.position = viewPoint;

}


#pragma mark Collission Detection

- (BOOL) resolvePlayerWorldCollision:(Player *)player
{
    
    int xVelocity = player.velX;
    int yVelocity = player.velY;
    
    if(player.position.x + xVelocity <= (_map.mapSize.width * _map.tileSize.width) &&
       player.position.y + yVelocity <= (_map.mapSize.height * _map.tileSize.height) &&
       player.position.y + yVelocity >= 0 &&
       player.position.x + xVelocity >= 0 )
    {
        for( NSValue *value in player.aabbArray)
        {
            int pTop = player.midTop.y;
            int pBottom = player.midBottom.y;
            int pRight = player.midRight.x;
            int pLeft = player.midLeft.x;
            
            CGPoint position = [value CGPointValue];
            CGPoint nextPosition = ccpAdd(position, ccp(xVelocity, yVelocity));
            
            CGPoint tileCoord = [self tileCoordForPosition:nextPosition];
            int tileGid = [_metaLayer tileGIDAt:tileCoord];
            if(tileGid)
            {
                NSDictionary *properties = [_map propertiesForGID:tileGid];
                if (properties)
                {
                    NSString *collision = [properties valueForKey:@"Collidable"];
                    if(collision && [collision isEqualToString:@"True"])
                    {
                        int sTop = (_map.mapSize.height - tileCoord.y) * _map.tileSize.height;
                        int sBottom = sTop - _map.tileSize.height;
                        int sLeft = tileCoord.x * _map.tileSize.width;
                        int sRight = sLeft + _map.tileSize.width;
                        
                        if ( 
                            (
                              ccpDistance (player.midBottom, position) == 0       ||
                              ccpDistance (player.cornerLowerLeft, position) == 0 ||
                              ccpDistance (player.cornerLowerRight, position) == 0
                              ) 
                            && pBottom + yVelocity <= sTop && yVelocity < 0
                            ) 
                        {
                            player.position = ccp(player.position.x, player.position.y - (pBottom - sTop) -1);
                            player.velY = 0;
                            player.isGrounded = YES;
                            player.isJumping = NO; 
                            return YES;
                        }
                        if (ccpDistance (player.midTop, position) == 0 && pTop + yVelocity >= sBottom && yVelocity > 0) {
                            player.position = ccp(player.position.x, player.position.y - (pTop - sBottom) + 1);
                            player.velY = 0;
                            return YES;
                        }
                        if (ccpDistance (player.midLeft, position) == 0 && pLeft + xVelocity  <= sRight && sRight < pRight && xVelocity <= 0) {
                            player.position = ccp(player.position.x + (sRight - pLeft) +1, player.position.y);
                            player.velX = 0;
                            return YES;
                        }
                        if (ccpDistance (player.midRight, position) == 0 && pRight + xVelocity >= sLeft && sLeft > pLeft && xVelocity >= 0) {
                            player.position = ccp(player.position.x + (sLeft - pRight) -1, player.position.y);
                            player.velX = 0;
                            return YES;
                        }
                        
                    }
                    NSString *collectable = [properties valueForKey:@"Collectable"];
                    if(collectable && [collectable isEqualToString:@"True"])
                    {
                        
                        [_metaLayer removeTileAt:tileCoord];
                        [_foregroundLayer removeTileAt:tileCoord];
                        [[SimpleAudioEngine sharedEngine] playEffect:@"coin.caf"];
                        numCoins++;
                        [_hud.coins setString:[NSString stringWithFormat:@"Coins :%d", numCoins]];
                        
                    }
                    
                }
            }
        }
        
        return NO;
    }
    
    return YES;
}

- (BOOL) isOnGround:(Player *)player
{
    int numFatal = 0;    
    
    for(NSValue *value in player.aabbBottomArray)
    {
        CGPoint point = [value CGPointValue];
        CGPoint checkpoint = CGPointMake(point.x, point.y+1);
        
        CGPoint tileCoord = [self tileCoordForPosition:checkpoint];
        int tileGid = [_metaLayer tileGIDAt:tileCoord];
        if(tileGid)
        {
            NSDictionary *properties = [_map propertiesForGID:tileGid];
            if (properties)
            {
                
                NSString *fatality = [properties valueForKey:@"Fatal"];
                if(fatality && [fatality isEqualToString:@"True"])
                {
                    numFatal++;
                    if(numFatal >=2 )
                    {
                        numAttempts++;  
                        [_hud.attempts setString:[NSString stringWithFormat:@"Attempts :%d", numAttempts]];
                        [[SimpleAudioEngine sharedEngine] stopBackgroundMusic];
                        CutScene *gameOverScene = [CutScene nodeWithString:@"Awwwww, snap :[" sound:@"game_over.caf" andDuration:5.0];
                        numCoins = 0;
                        [_hud.coins setString:[NSString stringWithFormat:@"Coins :%d", numCoins]];
                        [[ServerController sharedServerController] setDelegate:nil];
                        [[CCDirector sharedDirector] replaceScene:gameOverScene];
                        
                        return YES;
                    }
                    
                }
            }
        }
    }
    
    CGPoint belowPlayer = ccp(player.position.x, player.position.y - player.contentSize.height/2);    
    CGPoint tileCoord = [self tileCoordForPosition:belowPlayer];
    int tileGid = [_metaLayer tileGIDAt:tileCoord];
    if(tileGid)
    {
        NSDictionary *properties = [_map propertiesForGID:tileGid];
        if (properties)
        {
            
            NSString *collision = [properties valueForKey:@"Collidable"];
            if([collision isEqualToString:@"True"])
            {
                return YES;
            }
        }
    }
    
    return NO;
}

#pragma mark Utility methods

- (CGPoint)tileCoordForPosition:(CGPoint)position {
    int x = position.x / _map.tileSize.width;
    int y = ((_map.mapSize.height * _map.tileSize.height) - position.y) / _map.tileSize.height;
    return ccp(x, y);
}

#pragma mark TBActionPassing Protocol

-(void) didReceiveMessageWithActionType:(int) msgActionType forPad:(int) padNumber withAction:(int) action{

    NSAssert(msgActionType == kActionTypeMove || msgActionType == kActionTypeButton, @"Pad Action unknown");
    
    
    if (msgActionType == kActionTypeButton){
    
        if(action == kActionJump)
            [self jumpActionForPad:padNumber];    
    }else if(msgActionType == kActionTypeMove){
    
        [self direction:action forPad:padNumber];
    
    }
    
}


#pragma mark HUD Protocol

- (void) jumpActionForPad:(const int)padNumber{
    
    switch (padNumber) {
        case kPadP1:
            if(!_player1.isJumping){
                _player1.velY = kJumpVelocity;
                _player1.isJumping = YES;
                _player1.isGrounded = NO;
                [[SimpleAudioEngine sharedEngine] playEffect:@"jump.caf"];

            }
            break;
        case kPadP2:
            if(!_player2.isJumping){
                _player2.velY = kJumpVelocity;
                _player2.isJumping = YES;
                _player2.isGrounded = NO;
                [[SimpleAudioEngine sharedEngine] playEffect:@"jump.caf"];

            }
            break;
            
        default:
            break;
    }

}

-(void) direction:(const int)direction forPad:(const int)pad{
    
    switch (pad) {
        case kPadP1:
            switch (direction) {
                case kDirRight:
                    _player1.velX = kWalkVelocity;
                    _player1.scaleX = 1;
                    break;
                case kDirDiagRightUp:
                    _player1.velX = kWalkVelocity;
                    _player1.scaleX = 1;
                    break;
                case kDirDiagRightDown:
                    _player1.velX = kWalkVelocity;
                    _player1.scaleX = 1;
                    break;
                case kDirDiagLeftUp:
                    _player1.velX = -1*(kWalkVelocity);
                    _player1.scaleX = -1;
                    break;
                case kDirLeft:
                    _player1.velX = -kWalkVelocity;
                    _player1.scaleX = -1;
                    break;
                case kDirDiagLeftDown:
                    _player1.velX = -kWalkVelocity;
                    _player1.scaleX = -1;
                    break;
                default:
                    _player1.velX = 0.0f;
                    break;
            }
            break;
        
        case kPadP2:
            switch (direction) {
                case kDirRight:
                    _player2.velX = kWalkVelocity;
                    _player2.scaleX = 1;
                    break;
                case kDirDiagRightUp:
                    _player2.velX = kWalkVelocity;
                    _player2.scaleX = 1;
                    break;
                case kDirDiagRightDown:
                    _player2.velX = kWalkVelocity;
                    _player2.scaleX = 1;
                    break;
                case kDirDiagLeftUp:
                    _player2.velX = -1*(kWalkVelocity);
                    _player2.scaleX = -1;
                    break;
                case kDirLeft:
                    _player2.velX = -kWalkVelocity;
                    _player2.scaleX = -1;
                    break;
                case kDirDiagLeftDown:
                    _player2.velX = -kWalkVelocity;
                    _player2.scaleX = -1;
                    break;
                default:
                    _player2.velX = 0.0f;
                    break;
            }
            break;
        
        default:
        break;
    }


}

#pragma mark Memory cleanup
// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	// in this particular example nothing needs to be released.
	// cocos2d will automatically release all the children (Label)
    
    self.map = nil;
    self.backgroundLayer = nil;
    self.foregroundLayer = nil;
    self.metaLayer = nil;
    self.objectLayer = nil;
    self.physicsLayer = nil;
    self.hud = nil;
    self.player1 = nil;
    self.player2 = nil;
	
	// don't forget to call "super dealloc"
	[super dealloc];
}
@end
