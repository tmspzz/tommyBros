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
	
	// 'layer' is an autorelease object.
	HelloWorldLayer *layer = [HelloWorldLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
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
        
        self.metaLayer = [_map layerNamed:@"Meta"];
        _metaLayer.visible = NO;
        
        // create a void node, a parent node
		
        
        self.objectLayer = [_map objectGroupNamed:@"Objects"];
        self.foregroundLayer = [_map layerNamed:@"Foreground"];
        self.physicsLayer = [_map objectGroupNamed:@"Physics"];
        
        NSMutableDictionary *spawnPointP1 = [_objectLayer objectNamed:@"StartP1"];
        NSMutableDictionary *spawnPointP2 = [_objectLayer objectNamed:@"StartP2"];
		
		[self addChild:_map z:-1];
        
        self.hud = [HUD node];
        _hud.delegate = self;
        [self addChild:_hud z:0];
        
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

}

- (BOOL) resolvePlayerWorldCollision:(Player *)player
{
    int pTop = player.cornerUpperRight.y;
    int pBottom = player.cornerLowerRight.y;
    int pRight = player.cornerUpperRight.x;
    int pLeft = player.cornerLowerLeft.x;
    
    CGPoint tileCoord = [self tileCoordForPosition:player.position];
    int tileGid = [_metaLayer tileGIDAt:tileCoord];
    if(tileGid)
    {
        NSDictionary *properties = [_map propertiesForGID:tileGid];
        if (properties)
        {
            NSString *collision = [properties valueForKey:@"Collidable"];
            if([collision isEqualToString:@"True"])
            {
                int sTop = (_map.mapSize.height - tileCoord.y) * _map.tileSize.height;
                int sBottom = sTop - _map.tileSize.height;
                int sLeft = tileCoord.x * _map.tileSize.width;
                int sRight = sLeft + _map.tileSize.width;
                
                int xVelocity = player.velX;
                int yVelocity = player.velY;
                
                if (pBottom + yVelocity <= sTop && yVelocity < 0) {
                    player.position = ccp(player.position.x, player.position.y - (pBottom - sTop));
                    player.velY = 0;
                    player.isGrounded = YES;
                    player.isJumping = NO; 
                    return YES;
                }
                if (pTop + yVelocity >= sBottom && yVelocity > 0) {
                    player.position = ccp(player.position.x, player.position.y - (pTop - sBottom) + 1);
                    player.velY = 0;
                    return YES;
                }
                if (pLeft <= sRight && sRight < pRight && xVelocity <= 0) {
                    player.position = ccp(player.position.x + (sRight - pLeft), player.position.y);
                    player.velX = 0;
                    return YES;
                }
                if (pRight >= sLeft && sLeft > pLeft && xVelocity >= 0) {
                    player.position = ccp(player.position.x + (sLeft - pRight), player.position.y);
                    player.velX = 0;
                    return YES;
                }
                
            }
        }
    }
    return NO;
}

- (BOOL) isOnGround:(Player *)player
{
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

- (BOOL) willPlayerCollideOnYWithWorld:(Player *)player{
    
    return YES;
    
}

- (CGPoint)tileCoordForPosition:(CGPoint)position {
    int x = position.x / _map.tileSize.width;
    int y = ((_map.mapSize.height * _map.tileSize.height) - position.y) / _map.tileSize.height;
    return ccp(x, y);
}


#pragma mark HUD Protocol

- (void) jumpActionForPad:(const int)padNumber{
    
    switch (padNumber) {
        case kPadP1:
            if(!_player1.isJumping){
                _player1.velY = kJumpVelocity;
                _player1.isJumping = YES;
                _player1.isGrounded = NO;
            }
            break;
        case kPadP2:
            if(!_player2.isJumping){
                _player2.velY = kJumpVelocity;
                _player2.isJumping = YES;
                _player2.isGrounded = NO;
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
                    _player1.velX = kWalkVelocity-2;
                    _player1.scaleX = 1;

                    break;
                case kDirDiagLeftUp:
                    _player1.velX = -1*(kWalkVelocity-2);
                    _player1.scaleX = -1;
                    break;
                case kDirLeft:
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
                    _player2.velX = kWalkVelocity-2;
                    _player2.scaleX = 1;
                    break;
                case kDirDiagLeftUp:
                    _player2.velX = -1*(kWalkVelocity-2);
                    _player2.scaleX = -1;
                    break;
                case kDirLeft:
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
