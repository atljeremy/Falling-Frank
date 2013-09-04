//
//  AppDelegate.h
//  Falling Frank
//
//  Created by Jeremy Fox on 9/3/13.
//  Copyright jeremyfox 2013. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyNavigationController : UINavigationController <CCDirectorDelegate>
@end

@interface AppController : NSObject <UIApplicationDelegate>

@property (nonatomic, retain) UIWindow *window;
@property (readonly) MyNavigationController *navController;
@property (readonly) CCDirectorIOS *director;

@end
