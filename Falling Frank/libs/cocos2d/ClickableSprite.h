//
//  ClickableSprite.h
//  Falling Frank
//
//  Created by Jeremy Fox on 9/5/13.
//  Copyright (c) 2013 jeremyfox. All rights reserved.
//

#import "CCSprite.h"
#import "CCTouchDelegateProtocol.h"

@interface ClickableSprite : CCSprite <CCTouchOneByOneDelegate>

@property (nonatomic) CGSize clickableSize;
@property (nonatomic) int touchPriority;
@property (nonatomic, assign) id<NSObject> target;
@property (nonatomic) SEL selector;

@end
