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
      
    //if(_player1.isJumping) p1velY = _player1.velY - kGravity;
    //if(_player2.isJumping) p2velY = _player2.velY - kGravity;
    
     
    for(int i=0; i < steps; i++){ 
        
        CGPoint nextLocationAlongY = ccp(_player1.position.x, _player1.position.y + _player1.velY*delta + 0.5 *(kGravity) * (delta*delta));

        //CGPoint nextLocation = ccp(nextLocationAlongX.x, nextLocationAlongY.y);
        
        _player1.velY += kGravity*delta;
        if (_player1.velY <= 120 && _player1.velY >= 100 ) {
            
            NSLog(@"here!");
        }
        
        if(![self willPlayer:_player1 collideOnYWithWorldAtLocation:nextLocationAlongY]){

            _player1.position = nextLocationAlongY;
            NSLog(@"No COLL ON Y , velY is %f", _player1.velY);
            
        } else{
            
           _player1.velY = 0;
           _player1.isJumping = NO;
        
        }
        
        CGPoint nextLocationAlongX = ccp(_player1.position.x + _player1.velX, _player1.position.y);
        
        if(![self willPlayer:_player1 collideOnXWithWorldAtLocation:nextLocationAlongX]){
            
            _player1.position = nextLocationAlongX; 
            NSLog(@"No COLL ON X ");
            
        } else{
            
            _player1.velX = 0;
            
        }
        
    }
//    if(![self willPlayer:_player2 collideWithWorldAtLocation:ccp(_player2.position.x + _player2.velX , _player2.position.y + p2velY)]){
//
//        if(_player2.isJumping) _player2.velY -= 1.0f;
//        _player2.position = ccp(_player2.position.x + _player2.velX , _player2.position.y + _player2.velY);
//    
//    } else{
//    
//        _player2.velY= 0;
//        _player2.isJumping = NO;
//    
//    }
    
}

- (BOOL) willPlayer:(Player *)player collideOnYWithWorldAtLocation:(CGPoint)location{
    
    BOOL collided = NO;
    player.position = location;
    
    for (NSValue *value in player.cornerArray){
        
        CGPoint corner = [value CGPointValue];

        CGPoint tileCoord = [self tileCoordForPosition:corner];
        int tileGid = [_metaLayer tileGIDAt:tileCoord];
        if(tileGid){
        
            NSDictionary *properties = [_map propertiesForGID:tileGid];
            if (properties) {
            
                NSString *collision = [properties valueForKey:@"Collidable"];
                if([collision isEqualToString:@"True"]){
                    
                    CGPoint displacement  = CGPointMake(0, 0);
                    short int hitSide = 0;
                 
                    float tileTop = (_map.mapSize.height - tileCoord.y) * _map.tileSize.height;
                    float tileBottom = tileTop - _map.tileSize.height;
                    
                    float playerTop = player.cornerUpperRight.y;
                    float playerBottom = player.cornerLowerRight.y;
                    
                    if(playerBottom < tileTop && playerBottom > tileBottom){
                        
                        displacement.y = tileTop - playerBottom;
                        //hitSide = 1;
                    
                    }
                        
                    if(playerTop < tileTop && playerTop > tileBottom){ 
                        
                        displacement.y = (playerTop - tileBottom)*-1;
                        //hitSide = -1;
                    }
                    
                    player.position = ccp(player.position.x, player.position.y + displacement.y + hitSide );

                    return collided = YES;
                }
            
            }
        }
    }


    return collided;
}

- (BOOL) willPlayer:(Player *)player collideOnXWithWorldAtLocation:(CGPoint)location{
    
    BOOL collided = NO;
    player.position = location;
    
    for (NSValue *value in player.cornerArray){
        
        CGPoint corner = [value CGPointValue];
        
        CGPoint tileCoord = [self tileCoordForPosition:corner];
        int tileGid = [_metaLayer tileGIDAt:tileCoord];
        if(tileGid){
            
            NSDictionary *properties = [_map propertiesForGID:tileGid];
            if (properties) {
                
                NSString *collision = [properties valueForKey:@"Collidable"];
                if([collision isEqualToString:@"True"]){
                    
                    CGPoint displacement  = CGPointMake(0, 0);
                    short int hitSide = 0;
                    
                    float tileLeft = tileCoord.x * _map.tileSize.width;
                    float tileRight = tileLeft + _map.tileSize.width;
                    
                    float playerLeft = player.cornerLowerLeft.x;
                    float playerRight = player.cornerLowerRight.x;
                    
                    if(playerRight > tileLeft && playerRight < tileRight) {
                        
                        displacement.x = (playerRight - tileLeft)*-1;
                        //hitSide  = -1;
                    }
                    if(playerLeft < tileRight && playerLeft > tileLeft){ 
                        
                        displacement.x = tileRight - playerLeft;
                        //hitSide  = 1;
                    }
                    
                    player.position = ccp(player.position.x + displacement.x, player.position.y + hitSide);
                    
                    return collided = YES;
                }
                
            }
        }
    }
    
    
    return collided;
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
                _player1.velY = 64.0f;
                _player1.isJumping = YES;
            }
            break;
        case kPadP2:
            if(!_player2.isJumping){
                _player2.velY = 64.0f;
                _player2.isJumping = YES;
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
                    _player1.velX = 4.0f;
                    _player1.scaleX = 1;
                    break;
                case kDirDiagRightUp:
                    _player1.velX = 2.0f;
                    _player1.scaleX = 1;

                    break;
                case kDirDiagLeftUp:
                    _player1.velX = -2.0f;
                    _player1.scaleX = -1;
                    break;
                case kDirLeft:
                    _player1.velX = -4.0f;
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
                    _player2.velX = 4.0f;
                    _player2.scaleX = 1;
                    break;
                case kDirDiagRightUp:
                    _player2.velX = 2.0f;
                    _player2.scaleX = 1;
                    break;
                case kDirDiagLeftUp:
                    _player2.velX = -2.0f;
                    _player2.scaleX = -1;
                    break;
                case kDirLeft:
                    _player2.velX = -4.0f;
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
