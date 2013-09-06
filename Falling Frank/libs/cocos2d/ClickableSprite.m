//
//  ClickableSprite.m
//  Falling Frank
//
//  Created by Jeremy Fox on 9/5/13.
//  Copyright (c) 2013 jeremyfox. All rights reserved.
//

#import "ClickableSprite.h"
#import "CCTouchDispatcher.h"

@implementation ClickableSprite

- (void)onEnter {
    [super onEnter];
    [[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:self priority:self.touchPriority swallowsTouches:YES];
}

- (void)onExit {
    [[[CCDirector sharedDirector] touchDispatcher] removeDelegate:self];
    [super onExit];
}

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    return [self containsTouchLocation:touch];
}

- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event {
    if(![self containsTouchLocation:touch])
        return;
    [self.target performSelector:self.selector withObject:self];
}

- (BOOL)containsTouchLocation:(UITouch *)touch {
    CGPoint p = [self convertTouchToNodeSpaceAR:touch];
    CGSize size = self.contentSize;
    if(!CGSizeEqualToSize(self.clickableSize, CGSizeZero))
        size = self.clickableSize;
    CGRect r = CGRectMake(-size.width*0.5, -size.height*0.5, size.width, size.height);
    return CGRectContainsPoint(r, p);
}

@end
