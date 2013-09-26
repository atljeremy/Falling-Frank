//
//  CreditsLayer.m
//  Falling Frank
//
//  Created by Jeremy Fox on 9/25/13.
//  Copyright (c) 2013 jeremyfox. All rights reserved.
//

#import "CreditsLayer.h"
#import "MainMenuLayer.h"

@implementation CreditsLayer

+ (CCScene *)scene
{
	CCScene *scene = [CCScene node];
	CreditsLayer *layer = [CreditsLayer node];
	[scene addChild: layer];
	return scene;
}

- (id)init {
    if (self = [super init]) {
        [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"8_Bit_Adventurer.mp3" loop:YES];
        
        CGSize size = [[CCDirector sharedDirector] winSize];
        
        CCSprite *background;
        if (IS_RETINA_568) {
            background = [CCSprite spriteWithFile:@"Default-568h@2x.png"];
        } else if (IS_IPAD) {
            background = [CCSprite spriteWithFile:@"Default-568h@2x.png"];
            background.scale = 1.3;
        } else {
            background = [CCSprite spriteWithFile:@"Default.png"];
        }

        background.position = ccp(size.width/2, size.height/2);
		[self addChild: background];
        
        CCLabelTTF *spritesTitle = [CCLabelTTF labelWithString:@"Graphics/Sprites:" fontName:@"Arial" fontSize:20];
        CCLabelTTF *spritesCredits1 = [CCLabelTTF labelWithString:@"- Frank: http://www.graphicsfactory.com/Clip_Art/People/falling202_154205.html" fontName:@"Arial" fontSize:8];
        CCLabelTTF *spritesCredits2 = [CCLabelTTF labelWithString:@"- Birds: http://opengameart.org/content/animated-birds-32x32" fontName:@"Arial" fontSize:10];
        CCLabelTTF *spritesCredits3 = [CCLabelTTF labelWithString:@"- Clouds: I created the clouds myself" fontName:@"Arial" fontSize:10];
        
        spritesTitle.color = ccBLACK;
        spritesCredits1.color = ccBLACK;
        spritesCredits2.color = ccBLACK;
        spritesCredits3.color = ccBLACK;
        
        spritesTitle.position = ccp(CGRectGetWidth(spritesTitle.boundingBox) - 60, size.height-40);
        spritesCredits1.position = ccp(CGRectGetMinX(spritesTitle.boundingBox) + (CGRectGetWidth(spritesCredits1.boundingBox) / 2), size.height-60);
        spritesCredits2.position = ccp(CGRectGetMinX(spritesTitle.boundingBox) + (CGRectGetWidth(spritesCredits2.boundingBox) / 2), size.height-75);
        spritesCredits3.position = ccp(CGRectGetMinX(spritesTitle.boundingBox) + (CGRectGetWidth(spritesCredits3.boundingBox) / 2), size.height-90);
        
        CCLabelTTF *soundsTitle = [CCLabelTTF labelWithString:@"Sound Effects/Music:" fontName:@"Arial" fontSize:20];
        CCLabelTTF *soundsCredits1 = [CCLabelTTF labelWithString:@"Main Menu Background Music: \n http://www.jamendo.com/en/track/645280/8-bit-adventurer" fontName:@"Arial" fontSize:11];
        CCLabelTTF *soundsCredits2 = [CCLabelTTF labelWithString:@"Wind Sound Effect: \n http://www.soundjay.com/wind-sound-effect.html (Wind Strong 1)" fontName:@"Arial" fontSize:10];
        CCLabelTTF *soundsCredits3 = [CCLabelTTF labelWithString:@"Crow Sound Effect: \n http://www.sounddogs.com/results.asp?CategoryID=1009&SubcategoryID=10&Type=1 \n (Birds - Crow Caws - Exterior - Medium - \n Lots Of Crow Caws and Some Other Birds, \n But Also Constant Distant Traffic Hum)" fontName:@"Arial" fontSize:7];
        CCLabelTTF *soundsCredits4 = [CCLabelTTF labelWithString:@"Man Falling Sound Effect: \n http://www.freesfx.co.uk/sfx/man?p=2 (Man Falls And Screams)" fontName:@"Arial" fontSize:10];
        
        soundsTitle.color = ccBLACK;
        soundsCredits1.color = ccBLACK;
        soundsCredits2.color = ccBLACK;
        soundsCredits3.color = ccBLACK;
        soundsCredits4.color = ccBLACK;
        
        soundsTitle.position = ccp(CGRectGetWidth(soundsTitle.boundingBox) - 78, size.height-120);
        soundsCredits1.position = ccp(CGRectGetMinX(soundsTitle.boundingBox) + (CGRectGetWidth(soundsCredits1.boundingBox) / 2), size.height-145);
        soundsCredits2.position = ccp(CGRectGetMinX(soundsTitle.boundingBox) + (CGRectGetWidth(soundsCredits2.boundingBox) / 2), size.height-170);
        soundsCredits3.position = ccp(CGRectGetMinX(soundsTitle.boundingBox) + (CGRectGetWidth(soundsCredits3.boundingBox) / 2), size.height-205);
        soundsCredits4.position = ccp(CGRectGetMinX(soundsTitle.boundingBox) + (CGRectGetWidth(soundsCredits4.boundingBox) / 2), size.height-240);
        
        [self addChild:spritesTitle];
        [self addChild:spritesCredits1];
        [self addChild:spritesCredits2];
        [self addChild:spritesCredits3];
        [self addChild:soundsTitle];
        [self addChild:soundsCredits1];
        [self addChild:soundsCredits2];
        [self addChild:soundsCredits3];
        [self addChild:soundsCredits4];
        
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
