//
//  ContextMenu.m
//  Falling Frank
//
//  Created by Jeremy Fox on 9/10/13.
//  Copyright (c) 2013 jeremyfox. All rights reserved.
//

#import "ContextMenu.h"

static const int MAX_MENU_ITEMS = 5;
static const int MENU_TAG = 1;

@interface ContextMenu()<CCTouchOneByOneDelegate>
@property (nonatomic, strong) CCMenu* menu;
@property (nonatomic, strong) NSMutableArray* menuItems;
@property (nonatomic, strong) NSString* title;
@property (nonatomic, assign) CGPoint menuPosition;
@end

@implementation ContextMenu

- (id)init
{
    if (self = [super init]) {
        _menuItems = [@[] mutableCopy];
        [self setTouchEnabled:YES];
    }
    return self;
}

- (void)addLabel:(NSString*)label withBlock:(void(^)(id sender))block
{
    if (label && block && self.menuItems.count < MAX_MENU_ITEMS) {
        CCLabelTTF* labelFont = [CCLabelTTF labelWithString:label fontName:@"Courier" fontSize:18];
        CCMenuItemFont* item = [CCMenuItemFont itemWithLabel:labelFont block:block];
        [self.menuItems addObject:item];
    }
}

- (void)setTitle:(NSString *)title
{
    _title = title;
}

- (void)show
{
    BOOL hasCustomPosition = !CGPointEqualToPoint(self.menuPosition, CGPointZero);
    
    CCSprite* bg = [CCSprite spriteWithFile:@"context_menu_bg.png"];
    if (hasCustomPosition) {
        bg.position = self.menuPosition;
    }
    [self addChild:bg];
    
    if (self.title) {
        CCLabelTTF* titleLabel = [CCLabelTTF labelWithString:self.title fontName:@"Courier" fontSize:30];
        titleLabel.position = ccp(self.menuPosition.x, self.menuPosition.y + 60);
        titleLabel.color = ccRED;
        [self addChild:titleLabel];
    }
    
    self.menu = [CCMenu menuWithArray:self.menuItems];
    if (hasCustomPosition) {
        self.menu.position = self.menuPosition;
    }
    self.menu.color = ccWHITE;
    [self.menu alignItemsVertically];
    
    [self addChild:self.menu];
}

- (void)setMenuPosition:(CGPoint)position
{
    _menuPosition = position;
}

- (void)registerWithTouchDispatcher
{
    [[CCDirector sharedDirector].touchDispatcher addTargetedDelegate:self priority:-1 swallowsTouches:YES];
}

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    return YES;
}

- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
    // Do nohting, this is only here to appease cocos2d and to swallow touches on the game board
}

@end