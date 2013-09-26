//
//  MainMenuLayer.m
//  Falling Frank
//
//  Created by Jeremy Fox on 9/3/13.
//  Copyright jeremyfox 2013. All rights reserved.
//

#import "MainMenuLayer.h"
#import "AppDelegate.h"
#import "LevelOneLayer.h"
#import "CreditsLayer.h"
#import "InstructionsLayer.h"

#pragma mark - MainMenuLayer

@interface MainMenuLayer()
@property (nonatomic, strong) ClickableSprite *cloudOne;
@property (nonatomic, strong) ClickableSprite *cloudTwo;
@property (nonatomic, strong) ClickableSprite *bird;
@property (nonatomic, strong) CCSpriteBatchNode *birdSheet;
@property (nonatomic, strong) CCAction *flyAction;
@property (nonatomic, strong) ClickableSprite *frank;
@property (nonatomic, strong) CCSpriteBatchNode *frankSheet;
@property (nonatomic, strong) CCAction *fallAction;
@property (nonatomic, assign) BOOL collision;
@end

@implementation MainMenuLayer

+ (CCScene *)scene
{
	CCScene *scene = [CCScene node];
	MainMenuLayer *layer = [MainMenuLayer node];
	[scene addChild: layer];
	return scene;
}

- (void)cleanup
{
    [self unloadAssets];
}

- (id)init
{
	if(self = [super init]) {
        [self preloadAssets];
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
        
        _cloudOne = [ClickableSprite spriteWithFile:@"cloud1.png"];
        _cloudOne.scale = (IS_IPAD || IS_RETINA_568) ? 1.0 : 0.5;
        _cloudOne.position = ccp(size.width/2.6, -331);
        _cloudOne.target = self;
        _cloudOne.selector = @selector(cloudTapped);
        
        _cloudTwo = [ClickableSprite spriteWithFile:@"cloud2.png"];
        _cloudTwo.scale = (IS_IPAD || IS_RETINA_568) ? 1.0 : 0.8;
        _cloudTwo.position = ccp(size.width/1.5, -331);
        _cloudTwo.target = self;
        _cloudTwo.selector = @selector(cloudTapped);
        
        [self addChild: _cloudOne];
        [self addChild: _cloudTwo];
        
        [self createFrankAnim];
        [self createBirdAnim];
        
        [self schedule:@selector(nextFrame:)];
        [self schedule:@selector(checkForCollision) interval:0.4];
		
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

#pragma mark -----------------------------
#pragma mark Asset Preloading/Unloading
#pragma mark -----------------------------

- (void)preloadAssets
{
    [[SimpleAudioEngine sharedEngine] preloadBackgroundMusic:@"8_Bit_Adventurer.mp3"];
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"frank_yell.mp3"];
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"wind1-short.mp3"];
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"crow1.mp3"];
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"oowh.mp3"];
}

- (void)unloadAssets
{
    [[SimpleAudioEngine sharedEngine] unloadEffect:@"8_Bit_Adventurer.mp3"];
    [[SimpleAudioEngine sharedEngine] unloadEffect:@"frank_yell.mp3"];
    [[SimpleAudioEngine sharedEngine] unloadEffect:@"wind1-short.mp3"];
    [[SimpleAudioEngine sharedEngine] unloadEffect:@"crow1.mp3"];
    [[SimpleAudioEngine sharedEngine] unloadEffect:@"oowh.mp3"];
    self.cloudOne.target = nil;
    self.cloudOne = nil;
    self.cloudTwo.target = nil;
    self.cloudTwo = nil;
    self.birdSheet = nil;
    self.bird.target = nil;
    self.bird = nil;
    [self.flyAction stop];
    self.flyAction = nil;
    self.frank.target = nil;
    self.frank = nil;
}

#pragma mark -----------------------------
#pragma mark Sound Effects
#pragma mark -----------------------------

- (void)frankTapped
{
    [[SimpleAudioEngine sharedEngine] playEffect:@"frank_yell.mp3"];
}

- (void)cloudTapped
{
    [[SimpleAudioEngine sharedEngine] playEffect:@"wind1-short.mp3"];
}

- (void)birdTapped
{
    [[SimpleAudioEngine sharedEngine] playEffect:@"crow1.mp3"];
}

#pragma mark -----------------------------
#pragma mark Animations
#pragma mark -----------------------------

- (void)createBirdAnim
{
    CGSize size = [[CCDirector sharedDirector] winSize];
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"bird.plist"];
    _birdSheet = [CCSpriteBatchNode batchNodeWithFile:@"bird.png"];
    _birdSheet.position = ccp(size.width, size.height/2);
    [self addChild: _birdSheet];
    
    NSMutableArray *birdFlyingAnim = [NSMutableArray array];
    for (int i=1; i<=5; i++) {
        [birdFlyingAnim addObject:
         [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:
          [NSString stringWithFormat:@"bird%d.png",i]]];
    }
    
    CCAnimation *flyAnim = [CCAnimation animationWithSpriteFrames:birdFlyingAnim delay:0.1f];
    _bird = [ClickableSprite spriteWithSpriteFrameName:@"bird1.png"];
    _bird.target = self;
    _bird.selector = @selector(birdTapped);
    if (IS_RETINA_568 || IS_IPAD) {
        _bird.scale = 2.0;
    }
    
    _flyAction = [CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:flyAnim]];
    
    [_bird runAction: _flyAction];
    [_birdSheet addChild: _bird];
}

- (void)createFrankAnim
{
    CGSize size = [[CCDirector sharedDirector] winSize];
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"frank.plist"];
    _frankSheet = [CCSpriteBatchNode batchNodeWithFile:@"frank.png"];
    [self addChild: _frankSheet];
    
    NSMutableArray *frankFallingAnim = [NSMutableArray array];
    for (int i=1; i<=3; i++) {
        [frankFallingAnim addObject:
         [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:
          [NSString stringWithFormat:@"frank%d.png",i]]];
    }
    
    CCAnimation *fallAnim = [CCAnimation animationWithSpriteFrames:frankFallingAnim delay:0.1f];
    _frank = [ClickableSprite spriteWithSpriteFrameName:@"frank1.png"];
    _frank.position = ccp(size.width/2, size.height/1.3);
    _frank.target = self;
    _frank.selector = @selector(frankTapped);
    if (IS_RETINA_568 || IS_IPAD) {
        _frank.scale = 2.0;
    }
    
    _fallAction = [CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:fallAnim]];
    
    [_frank runAction: _fallAction];
    [_frankSheet addChild: _frank];
}

- (void)nextFrame:(ccTime)dt
{
    CGSize size = [[CCDirector sharedDirector] winSize];
    self.cloudOne.position = ccp( self.cloudOne.position.x, self.cloudOne.position.y + 150*dt );
    if (self.cloudOne.position.y > size.height+400) {
        self.cloudOne.position = ccp( self.cloudOne.position.x, -300 );
    }
    
    self.cloudTwo.position = ccp( self.cloudTwo.position.x, self.cloudTwo.position.y + 120*dt );
    if (self.cloudTwo.position.y > size.height+300) {
        self.cloudTwo.position = ccp( self.cloudTwo.position.x, -300 );
    }
    
    if (self.collision) {
        self.birdSheet.rotation = 180;
        [self.flyAction stop];
        self.birdSheet.position = ccp(self.birdSheet.position.x, self.birdSheet.position.y - 250*dt);
        if (self.birdSheet.position.y < -32) {
            self.birdSheet.rotation = 0;
            [self.flyAction startWithTarget:self.bird];
            self.collision = NO;
            self.birdSheet.position = ccp( size.width + 100, [self randomFloatBetween:size.height/2 and:size.height] );
        }
    } else {
        self.birdSheet.position = ccp(self.birdSheet.position.x - 100*dt, self.birdSheet.position.y);
        if (self.birdSheet.position.x < -32) {
            self.collision = NO;
            self.birdSheet.position = ccp( size.width + 100, [self randomFloatBetween:size.height/2 and:size.height] );
        }
    }
    
    [self.frank runAction:[CCShake actionWithDuration:dt amplitude:ccp(1,1) dampening:true]];
}

#pragma mark -----------------------------
#pragma mark Collision Detection
#pragma mark -----------------------------

- (void)checkForCollision
{
    if (!self.collision) {
        if (CGRectContainsRect(self.frank.boundingBox, self.birdSheet.boundingBox)) {
            self.collision = YES;
            [[SimpleAudioEngine sharedEngine] playEffect:@"oowh.mp3"];
        }
    }
}

#pragma mark -----------------------------
#pragma mark Menu
#pragma mark -----------------------------

- (void)constructMenu
{
    CGSize size = [[CCDirector sharedDirector] winSize];
    
    [CCMenuItemFont setFontSize:28];
    
    __block id copy_self = self;
    
    CCMenuItem *itemNewGame = [CCMenuItemFont itemWithString:@"New Game" block:^(id sender) {
        [[SimpleAudioEngine sharedEngine] stopBackgroundMusic];
        [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[LevelOneLayer scene]]];
    }];
    
//    CCMenuItem *itemContinueGame = [CCMenuItemFont itemWithString:@"Continue Game" block:^(id sender) {
//        // Do something
//    }];
    
    CCMenuItem *itemInstructions = [CCMenuItemFont itemWithString:@"Instructions" block:^(id sender) {
        [[SimpleAudioEngine sharedEngine] stopBackgroundMusic];
        [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[InstructionsLayer scene]]];
    }];
    
    CCMenuItem *itemCredits = [CCMenuItemFont itemWithString:@"Credits" block:^(id sender) {
        [[SimpleAudioEngine sharedEngine] stopBackgroundMusic];
        [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[CreditsLayer scene]]];
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
    
    CCMenu *menu = [CCMenu menuWithItems:itemNewGame, itemInstructions, itemCredits, itemAchievement, itemLeaderboard, nil];
    
    menu.color = ccBLACK;
    [menu alignItemsVerticallyWithPadding:12];
    [menu setPosition:ccp( size.width/2, size.height/2 - 70)];
    
    // Add the menu to the layer
    [self addChild:menu];
}

#pragma mark -----------------------------
#pragma mark Helpers
#pragma mark -----------------------------

- (float)randomFloatBetween:(float)smallNumber and:(float)bigNumber
{
    float diff = bigNumber - smallNumber;
    float retVal = (((float) (arc4random() % ((unsigned)RAND_MAX + 1)) / RAND_MAX) * diff) + smallNumber;
    return retVal;
}

#pragma mark -----------------------------
#pragma mark GameKit delegate
#pragma mark -----------------------------

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
