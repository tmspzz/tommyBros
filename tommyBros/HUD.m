//
//  HUD.m
//  tommyBros
//
//  Created by Tommaso Piazza on 5/11/11.
//  Copyright 2011 ChalmersTH. All rights reserved.
//

#import "HUD.h"
#import "GameConfig.h"


@implementation HUD

@synthesize attempts = _attempts;
@synthesize coins = _coins;
@synthesize padP1 = _padP1;
@synthesize padP2 = _padP2;
@synthesize buttonsMenu = _buttonsMenu;
@synthesize jumpButtonP1 = _jumpButtonP1;
@synthesize jumpButtonP2 = _jumpButtonP2;
@synthesize delegate;

-(id) init {
    
    if((self = [super init])){
    
        CGSize winSize = [[CCDirector sharedDirector] winSize];
        self.attempts = [CCLabelTTF labelWithString:@"Attempts: 0" fontName:@"Verdana-Bold" fontSize:32];
        _attempts.position = ccp(winSize.width - _attempts.contentSize.width, winSize.height - _attempts.contentSize.height/2);
        self.coins = [CCLabelTTF labelWithString:@"Coins: 0" fontName:@"Verdana-Bold" fontSize:32];
        _coins.position = ccp(_coins.contentSize.width, winSize.height - _coins.contentSize.height/2);
        
        self.padP1 = [Pad padWithFile:@"padP1.png" tag:kPadP1];
        self.padP2 = [Pad padWithFile:@"padP2.png" tag:kPadP2];
        
        self.jumpButtonP1 = [CCMenuItemImage itemFromNormalImage:@"jumpButtonN.png" selectedImage:@"jumpButtonS.png" target:self selector:@selector(jumpActionP1)];
        self.jumpButtonP2 = [CCMenuItemImage itemFromNormalImage:@"jumpButtonN.png" selectedImage:@"jumpButtonS.png" target:self selector:@selector(jumpActionP2)]; 
        
        self.buttonsMenu = [CCMenu menuWithItems:_jumpButtonP1, _jumpButtonP2, nil];
        
        _padP1.delegate = self;
        _padP2.delegate = self;

                
        [self addChild:_attempts];
        [self addChild:_coins];
        [self addChild:_padP1];
        [self addChild:_padP2];
        [self addChild:_buttonsMenu];
        
    }
    
    return self;
}

- (void) jumpActionP1{

    if(delegate && [delegate respondsToSelector:@selector(jumpActionForPad:)]){
        
        [delegate jumpActionForPad:kPadP1];
        
    }

}

- (void) jumpActionP2{

    if(delegate && [delegate respondsToSelector:@selector(jumpActionForPad:)]){
        
        [delegate jumpActionForPad:kPadP2];
        
    }

}

#pragma mark PadProtocol

- (void) touchAtLocation:(CGPoint) location forPad:(Pad *)pad{
    
//    NSLog(@"Touch in Pad:%d at location X:%f Y:%f", pad.tag, location.x, location.y);
    
    if(sqrt((location.x * location.x) + (location.y * location.y)) <= kCenterTollerance) return;
    
    int dir = kDirCenter;
    
    if(location.x > 0){
        
        float ratio = (location.y/location.x);
        float atan = atanf(ratio);
        
        if( atan > M_PI/3) dir = kDirUp;
        if( atan < -M_PI/3 ) dir = kDirDown;
        if( atan >= M_PI/6 && atan <=  M_PI/3 ) dir = kDirDiagRightUp;
        if( atan <= -M_PI/6 && atan >= -M_PI/3 ) dir = kDirDiagRightDown;
        if( atan < M_PI/6 && atan > -M_PI/6 ) dir = kDirRight;
        
//        NSLog(@"Dir is: %d, atan is %f ratio is:%f", dir, atan, ratio);
        
    }
    
    if(location.x < 0){
        
        float ratio = (location.y/-location.x);
        float atan = atanf(ratio);
        
        if( atan > M_PI/3) dir = kDirUp;
        if( atan < -M_PI/3 ) dir = kDirDown;
        if( atan >= M_PI/6 && atan <=  M_PI/3 ) dir = kDirDiagLeftUp;
        if( atan <= -M_PI/6 && atan >= -M_PI/3 ) dir = kDirDiagLeftDown;
        if( atan < M_PI/6 && atan > -M_PI/6 ) dir = kDirLeft;
        
//        NSLog(@"Dir is: %d, atan is %f ratio is:%f", dir, atan, ratio);
        
    }
    

    if(delegate && [delegate respondsToSelector:@selector(direction: forPad:)]){
            
        [delegate direction:dir forPad:pad.tag];
    
    }
        
 
    
}

- (void) touchLiftedForPad:(Pad *) pad {
    
    
    if(delegate && [delegate respondsToSelector:@selector(direction: forPad:)]){
        
        [delegate direction:kDirCenter forPad:pad.tag];
        
    }

    
}


- (void) dealloc {

    self.attempts = nil;
    self.coins = nil;
    self.padP1 = nil;
    self.padP2 = nil;
    self.buttonsMenu = nil;
    self.jumpButtonP1 = nil;
    self.jumpButtonP2 = nil;
    
    [super dealloc];

}

@end
