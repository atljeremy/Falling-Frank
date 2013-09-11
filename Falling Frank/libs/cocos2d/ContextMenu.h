//
//  ContextMenu.h
//  Falling Frank
//
//  Created by Jeremy Fox on 9/10/13.
//  Copyright (c) 2013 jeremyfox. All rights reserved.
//

#import "cocos2d.h"

@interface ContextMenu : CCLayer

- (void)show;
- (void)setTitle:(NSString *)title;
- (void)setMenuPosition:(CGPoint)position;
- (void)addLabel:(NSString*)label withBlock:(void(^)(id sender))block;

@end

