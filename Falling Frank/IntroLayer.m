//
//  IntroLayer.m
//  Falling Frank
//
//  Created by Jeremy Fox on 9/3/13.
//  Copyright jeremyfox 2013. All rights reserved.
//

#import "IntroLayer.h"
#import "MainMenuLayer.h"

#pragma mark - IntroLayer

@implementation IntroLayer

+ (CCScene *)scene
{
	CCScene *scene = [CCScene node];
	IntroLayer *layer = [IntroLayer node];
	[scene addChild: layer];
	return scene;
}

- (id)init
{
	if( (self=[super init])) {
		CGSize size = [[CCDirector sharedDirector] winSize];
		CCSprite *background = [CCSprite spriteWithFile:@"Default.png"];
		background.position = ccp(size.width/2, size.height/2);
		[self addChild: background];
	}
	return self;
}

- (void)onEnter
{
	[super onEnter];
	[[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[MainMenuLayer scene] ]];
}
@end
