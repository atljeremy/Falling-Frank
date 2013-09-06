//
//  MainMenuLayer.m
//  Falling Frank
//
//  Created by Jeremy Fox on 9/3/13.
//  Copyright jeremyfox 2013. All rights reserved.
//

#import "MainMenuLayer.h"
#import "AppDelegate.h"
#import "SimpleAudioEngine.h"

#pragma mark - MainMenuLayer

CCSprite *cloudOne;
CCSprite *cloudTwo;
ClickableSprite *frank;

@implementation MainMenuLayer

+ (CCScene *)scene
{
	CCScene *scene = [CCScene node];
	MainMenuLayer *layer = [MainMenuLayer node];
	[scene addChild: layer];
	return scene;
}

- (id)init
{
	if(self = [super init]) {
		CGSize size = [[CCDirector sharedDirector] winSize];
		CCSprite *background = [CCSprite spriteWithFile:@"Default.png"];
		background.position = ccp(size.width/2, size.height/2);
		[self addChild: background];
        
        cloudOne = [CCSprite spriteWithFile:@"cloud1.png"];
        cloudTwo = [CCSprite spriteWithFile:@"cloud2.png"];
        cloudOne.scale = 0.5;
        cloudTwo.scale = 0.8;
        cloudOne.position = ccp(size.width/2.6, -331);
        cloudTwo.position = ccp(size.width/1.5, -331);
        [self addChild: cloudOne];
        [self addChild: cloudTwo];
        
        frank = [ClickableSprite spriteWithFile:@"frank.png"];
        frank.position = ccp(size.width/2, size.height/1.3);
        frank.target = self;
        frank.selector = @selector(spriteClicked);
        [self addChild: frank];
        
        [self schedule:@selector(nextFrame:)];
		
		[self constructMenu];
	}
	return self;
}

- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	// in this particular example nothing needs to be released.
	// cocos2d will automatically release all the children (Label)
	
	// don't forget to call "super dealloc"
	[super dealloc];
}

- (void)spriteClicked {
    [[SimpleAudioEngine sharedEngine] playEffect:@"frank_yell.mp3"];
}

- (void)nextFrame:(ccTime)dt {
    CGSize size = [[CCDirector sharedDirector] winSize];
    cloudOne.position = ccp( cloudOne.position.x, cloudOne.position.y + 150*dt );
    if (cloudOne.position.y > size.height+400) {
        cloudOne.position = ccp( cloudOne.position.x, -300 );
    }
    
    cloudTwo.position = ccp( cloudTwo.position.x, cloudTwo.position.y + 120*dt );
    if (cloudTwo.position.y > size.height+300) {
        cloudTwo.position = ccp( cloudTwo.position.x, -300 );
    }
    
    [frank runAction:[CCShake actionWithDuration:dt amplitude:ccp(2,2) dampening:true]];
}

- (void)constructMenu
{
    CGSize size = [[CCDirector sharedDirector] winSize];
    
    [CCMenuItemFont setFontSize:28];
    
    __block id copy_self = self;
    
    CCMenuItem *itemNewGame = [CCMenuItemFont itemWithString:@"New Game" block:^(id sender) {
        // Do something
    }];
    
    CCMenuItem *itemContinueGame = [CCMenuItemFont itemWithString:@"Continue Game" block:^(id sender) {
        // Do something
    }];
    
    CCMenuItem *itemSettings = [CCMenuItemFont itemWithString:@"Settings" block:^(id sender) {
        // Do something
    }];
    
    CCMenuItem *itemAchievement = [CCMenuItemFont itemWithString:@"Achievements" block:^(id sender) {
        GKAchievementViewController *achivementViewController = [[GKAchievementViewController alloc] init];
        achivementViewController.achievementDelegate = copy_self;
        AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
        [[app navController] presentViewController:achivementViewController animated:YES completion:nil];
        [achivementViewController release];
    }];
    
    CCMenuItem *itemLeaderboard = [CCMenuItemFont itemWithString:@"Leaderboard" block:^(id sender) {
        GKLeaderboardViewController *leaderboardViewController = [[GKLeaderboardViewController alloc] init];
        leaderboardViewController.leaderboardDelegate = copy_self;
        AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
        [[app navController] presentViewController:leaderboardViewController animated:YES completion:nil];
        [leaderboardViewController release];
    }];
    
    CCMenu *menu = [CCMenu menuWithItems:itemNewGame, itemContinueGame, itemSettings, itemAchievement, itemLeaderboard, nil];
    
    [menu alignItemsVerticallyWithPadding:12];
    [menu setPosition:ccp( size.width/2, size.height/2 - 70)];
    
    // Add the menu to the layer
    [self addChild:menu];
}

#pragma mark GameKit delegate

-(void) achievementViewControllerDidFinish:(GKAchievementViewController *)viewController
{
	AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
	[[app navController] dismissViewControllerAnimated:YES completion:nil];
}

-(void) leaderboardViewControllerDidFinish:(GKLeaderboardViewController *)viewController
{
	AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
	[[app navController] dismissViewControllerAnimated:YES completion:nil];
}
@end
