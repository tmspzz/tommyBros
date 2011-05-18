//
//  AppDelegate.h
//  tommyBros
//
//  Created by Tommaso Piazza on 5/11/11.
//  Copyright ChalmersTH 2011. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ServerController.h"

@class RootViewController;

@interface AppDelegate : NSObject <UIApplicationDelegate> {
	UIWindow			*window;
	RootViewController	*viewController;
    ServerController    *sharedServerController;
}

@property (nonatomic, retain) UIWindow *window;

@end
