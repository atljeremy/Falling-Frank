//
//  InstructionsLayer.m
//  Falling Frank
//
//  Created by Jeremy Fox on 9/26/13.
//  Copyright (c) 2013 jeremyfox. All rights reserved.
//

#import "InstructionsLayer.h"
#import "MainMenuLayer.h"

@implementation InstructionsLayer

+ (CCScene *)scene
{
	CCScene *scene = [CCScene node];
	InstructionsLayer *layer = [InstructionsLayer node];
	[scene addChild: layer];
	return scene;
}

- (id)init {
    if (self = [super init]) {
        [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"8_Bit_Adventurer.mp3" loop:YES];
        
        CGSize size = [[CCDirector sharedDirector] winSize];
        
        CCSprite *background;
        if (IS_RETINA_568) {
            background = [CCSprite spriteWithFile:@"sky-568h@2x.jpg"];
        } else if (IS_IPAD) {
            background = [CCSprite spriteWithFile:@"sky-568h@2x.jpg"];
            background.scale = 1.3;
        } else {
            background = [CCSprite spriteWithFile:@"sky.jpg"];
        }
		background.position = ccp(size.width/2, size.height/2);
        [self addChild: background];
        
        if (IS_RETINA_568) {
            background = [CCSprite spriteWithFile:@"instructions.png"];
        } else if (IS_IPAD) {
            background = [CCSprite spriteWithFile:@"instructions.png"];
            background.scale = 0.9;
        } else {
            background = [CCSprite spriteWithFile:@"instructions.png"];
            background.scale = 0.4;
        }
        
        background.position = ccp(size.width/2, size.height/2);
		[self addChild: background];
        
        [self constructMenu];
    }
    return self;
}

- (void)constructMenu
{
    CGSize size = [[CCDirector sharedDirector] winSize];
    CCMenuItem *menuItem = [CCMenuItemFont itemWithString:@"Main Menu" block:^(id sender) {
        [[SimpleAudioEngine sharedEngine] stopBackgroundMusic];
        [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[MainMenuLayer scene]]];
    }];
    menuItem.position = CGPointZero;
    CCMenu* menu = [CCMenu menuWithItems:menuItem, nil];
    menu.color = ccBLACK;
    menu.position = ccp(size.width/2, 20);
    [self addChild:menu];
}

@end
