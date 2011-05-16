//
//  GameConfig.h
//  tommyBros
//
//  Created by Tommaso Piazza on 5/11/11.
//  Copyright ChalmersTH 2011. All rights reserved.
//

#ifndef __GAME_CONFIG_H
#define __GAME_CONFIG_H

//
// Supported Autorotations:
//		None,
//		UIViewController,
//		CCDirector
//
#define kGameAutorotationNone 0
#define kGameAutorotationCCDirector 1
#define kGameAutorotationUIViewController 2

#define kGravity -2.0f

#pragma mark Pad Constants

#define kPadP1 1
#define kPadP2 2

#define kCenterTollerance 0.3f

#define kDirRight 1
#define kDirDiagRightUp 2
#define kDirUp 3
#define kDirDiagLeftUp 4
#define kDirLeft 5
#define kDirDiagLeftDown 6
#define kDirDown 7
#define kDirDiagRightDown 8
#define kDirCenter -1

#pragma makr Player Constants

#define kPlayer1 1
#define kPlayer2 2
#define kWalkVelocity 6
#define kJumpVelocity 28

//
// Define here the type of autorotation that you want for your game
//
#define GAME_AUTOROTATION kGameAutorotationUIViewController


#endif // __GAME_CONFIG_H