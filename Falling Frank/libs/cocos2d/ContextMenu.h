//
//  ContextMenu.h
//  Falling Frank
//
//  Created by Jeremy Fox on 9/10/13.
//  Copyright (c) 2013 jeremyfox. All rights reserved.
//

#import "cocos2d.h"

@interface ContextMenu : CCLayer

- (void)build;
- (void)setTitle:(NSString *)title;
- (void)setTitleColor:(ccColor3B)titleColor;
- (void)setMenuPosition:(CGPoint)position;
- (void)addLabel:(NSString*)label withBlock:(void(^)(id sender))block;

@end

