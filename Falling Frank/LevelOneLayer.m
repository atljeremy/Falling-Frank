//
//  LevelOneLayer.m
//  Falling Frank
//
//  Created by Jeremy Fox on 9/8/13.
//  Copyright (c) 2013 jeremyfox. All rights reserved.
//

#import "LevelOneLayer.h"
#import "CCTouchDispatcher.h"
#import "ContextMenu.h"
#import "MainMenuLayer.h"
#import "LevelTwoLayer.h"

static const int FEET_TILL_GROUND = 1000;

@interface LevelOneLayer()
// Clouds 
@property (nonatomic, strong) ClickableSprite *cloudOne;
@property (nonatomic, strong) ClickableSprite *cloudTwo;
// Bird 1
@property (nonatomic, strong) CCSpriteBatchNode *birdSheet;
@property (nonatomic, strong) ClickableSprite *bird;
@property (nonatomic, strong) CCAction *birdFlyAction;
// Bird 2
@property (nonatomic, strong) CCSpriteBatchNode *birdTwoSheet;
@property (nonatomic, strong) ClickableSprite *birdTwo;
@property (nonatomic, strong) CCAction *birdTwoFlyAction;
// Bird 3
@property (nonatomic, strong) CCSpriteBatchNode *birdThreeSheet;
@property (nonatomic, strong) ClickableSprite *birdThree;
@property (nonatomic, strong) CCAction *birdThreeFlyAction;
// Frank
@property (nonatomic, strong) ClickableSprite *frank;
@property (nonatomic, strong) CCSpriteBatchNode *frankSheet;
@property (nonatomic, strong) CCAction *fallAction;
// Add Life Power Up
@property (nonatomic, strong) CCSprite *addLife;
// Temp. Invincibility Power Up
@property (nonatomic, strong) CCSprite *tempInvincibility;
// Temp. Slow Motion Power Up
@property (nonatomic, strong) CCSprite *tempSlowMo;

@property (nonatomic, strong) CCLabelTTF *hitCountNumLabel;
@property (nonatomic, strong) CCLabelTTF *ftTillGroundLabel;
@property (nonatomic, strong) CCLabelTTF *gameLivesCountLabel;
@property (nonatomic, strong) CCLabelTTF *gameScoreLabel;
@property (nonatomic, strong) CCLabelTTF *powerUpTimeLabel;
@property (nonatomic, strong) __block ContextMenu *menu;

@property (nonatomic, assign) int hitCount;
@property (nonatomic, assign) int ftTillGround;
@property (nonatomic, assign) int scoreAtLevelStart;
@property (nonatomic, assign) int livesAtLevelStart;
@property (nonatomic, assign) float time;
@property (nonatomic, assign) float powerUpTime;
@property (nonatomic, assign) BOOL birdCollision;
@property (nonatomic, assign) BOOL birdTwoCollision;
@property (nonatomic, assign) BOOL birdThreeCollision;
@property (nonatomic, assign) BOOL showBirdTwo;
@property (nonatomic, assign) BOOL showBirdThree;
@property (nonatomic, assign) BOOL gameOver;
@property (nonatomic, assign) BOOL levelComplete;
@property (nonatomic, assign) BOOL addLifeCollision;
@property (nonatomic, assign) BOOL tempInvincibilityCollision;
@property (nonatomic, assign) BOOL tempSlowMoCollision;
@property (nonatomic, assign, getter = isInvincibilityActive) BOOL invincibilityActive;
@property (nonatomic, assign, getter = isSlowMoActive) BOOL slowMoActive;

@end

@implementation LevelOneLayer

+ (CCScene*)scene
{
    [[[CCDirector sharedDirector] touchDispatcher] removeAllDelegates];
	CCScene *scene = [CCScene node];
	LevelOneLayer *layer = [LevelOneLayer node];
	[scene addChild: layer];
	return scene;
}

- (void)cleanup
{
    [self unloadAssets];
}

- (void)onEnter
{
    [super onEnter];
    CGSize size = [[CCDirector sharedDirector] winSize];
    [self.frank runAction:[CCMoveTo actionWithDuration:2.0 position:ccp(size.width/2, size.height/1.5)]];
}

- (id)init
{
    if (self = [super init]) {
        [self preloadAssets];
        [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"wind-strong.mp3" loop:YES];
        
		CGSize size = [[CCDirector sharedDirector] winSize];
        
        _cloudOne = [ClickableSprite spriteWithFile:@"cloud1.png"];
        _cloudOne.position = ccp(size.width/2.6, -331);
        
        _cloudTwo = [ClickableSprite spriteWithFile:@"cloud2.png"];
        _cloudTwo.position = ccp(size.width/1.5, -331);
        
        _addLife = [CCSprite spriteWithFile:@"add_life.png"];
        _addLife.position = ccp(0, 0 - CGRectGetHeight(self.addLife.boundingBox));
        _addLife.scale = 0.6;
        
        _tempInvincibility = [CCSprite spriteWithFile:@"invinc.png"];
        _tempInvincibility.position = ccp(0, 0 - CGRectGetHeight(self.addLife.boundingBox));
        _tempInvincibility.scale = 0.6;
        
        _tempSlowMo = [CCSprite spriteWithFile:@"slow_mo.png"];
        _tempSlowMo.position = ccp(0, 0 - CGRectGetHeight(self.addLife.boundingBox));
        _tempSlowMo.scale = 0.6;
        
        CCSprite *background;
        if (IS_RETINA_568) {
            background = [CCSprite spriteWithFile:@"sky-568h@2x.jpg"];
            _cloudOne.scale = 1.0;
            _cloudTwo.scale = 1.0;
        } else if (IS_IPAD) {
            background = [CCSprite spriteWithFile:@"sky-568h@2x.jpg"];
            background.scale = 1.3;
            _cloudOne.scale = 1.3;
            _cloudTwo.scale = 1.3;
            _addLife.scale = 1.0;
            _tempInvincibility.scale = 1.0;
            _tempSlowMo.scale = 1.0;
        } else {
            background = [CCSprite spriteWithFile:@"sky.jpg"];
            _cloudOne.scale = 0.5;
            _cloudTwo.scale = 0.5;
        }
		background.position = ccp(size.width/2, size.height/2);
        
        _touchEnabled        = YES;
        _time                = 0;
        _hitCount            = 0;
        _ftTillGround        = FEET_TILL_GROUND;
        _birdCollision       = NO;
        _birdTwoCollision    = NO;
        _birdThreeCollision  = NO;
        _showBirdTwo         = NO;
        _showBirdThree       = NO;
        _gameOver            = NO;
        _levelComplete       = NO;
        _addLifeCollision    = NO;
        _tempSlowMoCollision = NO;
        _invincibilityActive = NO;
        _slowMoActive        = NO;
        _tempInvincibilityCollision = NO;
        
        CCLabelTTF *hitCountLabel = [CCLabelTTF labelWithString:@"Hit Count: " fontName:@"Marker Felt" fontSize:24];
        _hitCountNumLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%d", _hitCount] fontName:@"Marker Felt" fontSize:24];
        hitCountLabel.position = ccp(CGRectGetWidth(hitCountLabel.boundingBox) - 40, size.height-24);
        _hitCountNumLabel.position = ccp(CGRectGetMaxX(hitCountLabel.boundingBox) + 8, size.height-24);
        hitCountLabel.color = ccBLACK;
        _hitCountNumLabel.color = ccBLACK;
        
        NSString* ftTillGrndString = [NSString stringWithFormat:@"%d ft", _ftTillGround];
        CGSize labelSize = CGSizeMake(90, 26.5);
        _ftTillGroundLabel =[CCLabelTTF labelWithString:ftTillGrndString fontName:@"Marker Felt" fontSize:24 dimensions:labelSize hAlignment:NSTextAlignmentRight];
        float x = size.width - CGRectGetWidth(_ftTillGroundLabel.boundingBox);
        _ftTillGroundLabel.position = ccp((IS_IPAD) ? x+20 : x+35, size.height-24);
        _ftTillGroundLabel.color = ccBLACK;
        
        CCLabelTTF* levelLabel = [CCLabelTTF labelWithString:@"Level 1" fontName:@"Marker Felt" fontSize:18 dimensions:labelSize hAlignment:NSTextAlignmentRight];
        x = size.width - CGRectGetWidth(levelLabel.boundingBox);
        levelLabel.position = ccp((IS_IPAD) ? x+20 : x+35, size.height-48);
        levelLabel.color = ccBLACK;
        
        NSNumber* gameLives = [[NSUserDefaults standardUserDefaults] objectForKey:kGameLivesKey];
        if (!gameLives) {
            gameLives = @(DEFAULT_GAME_LIVES_COUNT);
            [GameSettings resetGameLives];
        }
        _livesAtLevelStart = [gameLives integerValue];
        CCLabelTTF *gameLivesLabel = [CCLabelTTF labelWithString:@"Lives Left: " fontName:@"Marker Felt" fontSize:18];
        _gameLivesCountLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%d", [gameLives integerValue]] fontName:@"Marker Felt" fontSize:18];
        gameLivesLabel.position = ccp(CGRectGetWidth(gameLivesLabel.boundingBox) - 29, size.height-48);
        _gameLivesCountLabel.position = ccp(CGRectGetMaxX(gameLivesLabel.boundingBox) + 8, size.height-48);
        gameLivesLabel.color = ccBLACK;
        _gameLivesCountLabel.color = ccBLACK;
        
        NSNumber* gameScore = [[NSUserDefaults standardUserDefaults] objectForKey:kGameScoreKey];
        if (!gameScore) {
            gameScore = @(DEFAULT_GAME_SCORE);
            [GameSettings resetGameScore];
        }
        _scoreAtLevelStart = [gameScore integerValue];
        CCLabelTTF *scoreLabel = [CCLabelTTF labelWithString:@"Score: " fontName:@"Marker Felt" fontSize:16];
        _gameScoreLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%d", [gameScore integerValue]] fontName:@"Marker Felt" fontSize:16];
        scoreLabel.position = ccp(CGRectGetWidth(scoreLabel.boundingBox) - 12, size.height-68);
        _gameScoreLabel.position = ccp(CGRectGetMaxX(scoreLabel.boundingBox) + 14, size.height-68);
        scoreLabel.color = ccBLACK;
        _gameScoreLabel.color = ccBLACK;
        
        // Add Children
        [self addChild: background];
        [self addChild: _cloudOne];
        [self addChild: _cloudTwo];
        [self addChild: hitCountLabel];
        [self addChild: _hitCountNumLabel];
        [self addChild: _ftTillGroundLabel];
        [self addChild: levelLabel];
        [self addChild: gameLivesLabel];
        [self addChild: _gameLivesCountLabel];
        [self addChild: scoreLabel];
        [self addChild: _gameScoreLabel];
        [self addChild: _addLife];
        [self addChild: _tempInvincibility];
        [self addChild: _tempSlowMo];
        
        // Create animations
        [self createFrankAnim];
        [self createBirdAnim];
        [self createBirdTwoAnim];
        [self createBirdThreeAnim];
        
        // Schedule selectors to handle animations, collison checks and timers
        [self schedule:@selector(nextFrame:)];
        [self schedule:@selector(checkForCollision) interval:0.15];
        [self schedule:@selector(incrementTime) interval:1.0];
        [self schedule:@selector(decrementFtTillGround) interval:0.01];
        
        // Construct the pause menu
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
#pragma mark Touch Event handler
#pragma mark -----------------------------

- (void)registerWithTouchDispatcher
{
	[[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
}

#pragma mark -----------------------------
#pragma mark Asset Preloading/Unloading
#pragma mark -----------------------------

- (void)preloadAssets
{
    [[SimpleAudioEngine sharedEngine] preloadBackgroundMusic:@"wind-strong.mp3"];
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"frank_yell.mp3"];
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"wind1-short.mp3"];
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"crow1.mp3"];
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"oowh.mp3"];
}

- (void)unloadAssets
{
    [[SimpleAudioEngine sharedEngine] unloadEffect:@"wind-strong.mp3"];
    [[SimpleAudioEngine sharedEngine] unloadEffect:@"frank_yell.mp3"];
    [[SimpleAudioEngine sharedEngine] unloadEffect:@"wind1-short.mp3"];
    [[SimpleAudioEngine sharedEngine] unloadEffect:@"crow1.mp3"];
    [[SimpleAudioEngine sharedEngine] unloadEffect:@"oowh.mp3"];
}

#pragma mark -----------------------------
#pragma mark Sprite Selectors / Sound Effects
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

- (void)showAddLife
{
    self.addLife.visible = YES;
    CGSize size = [[CCDirector sharedDirector] winSize];
    self.addLife.position = ccp([self randomFloatBetween:50.0 and:size.width - 50], 0 - CGRectGetHeight(self.addLife.boundingBox));
    CCMoveTo* moveTo = [CCMoveTo actionWithDuration:2.0 position:ccp(self.addLife.position.x, size.height + CGRectGetHeight(self.addLife.boundingBox))];
    [self.addLife runAction:moveTo];
}

- (void)showTempInvincibility
{
    self.tempInvincibility.visible = YES;
    CGSize size = [[CCDirector sharedDirector] winSize];
    self.tempInvincibility.position = ccp([self randomFloatBetween:50.0 and:size.width - 50], 0 - CGRectGetHeight(self.tempInvincibility.boundingBox));
    CCMoveTo* moveTo = [CCMoveTo actionWithDuration:2.0 position:ccp(self.tempInvincibility.position.x, size.height + CGRectGetHeight(self.tempInvincibility.boundingBox))];
    [self.tempInvincibility runAction:moveTo];
}

- (void)showTempSlowMo
{
    self.tempSlowMo.visible = YES;
    CGSize size = [[CCDirector sharedDirector] winSize];
    self.tempSlowMo.position = ccp([self randomFloatBetween:50.0 and:size.width - 50], 0 - CGRectGetHeight(self.tempSlowMo.boundingBox));
    CCMoveTo* moveTo = [CCMoveTo actionWithDuration:2.0 position:ccp(self.tempSlowMo.position.x, size.height + CGRectGetHeight(self.tempSlowMo.boundingBox))];
    [self.tempSlowMo runAction:moveTo];
}

- (void)createBirdAnim
{
    CGSize size = [[CCDirector sharedDirector] winSize];
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"bird.plist"];
    _birdSheet = [CCSpriteBatchNode batchNodeWithFile:@"bird.png"];
    _birdSheet.position = ccp(size.width, size.height/2);
    [self addChild: _birdSheet];
    
    _bird = [ClickableSprite spriteWithSpriteFrameName:@"bird1.png"];
    _bird.target = self;
    _bird.selector = @selector(birdTapped);
    if (IS_RETINA_568 || IS_IPAD) {
        _bird.scale = 2.0;
    }
    
    if (!_birdFlyAction) {
        NSMutableArray *birdFlyingAnim = [NSMutableArray array];
        for (int i=1; i<=5; i++) {
            [birdFlyingAnim addObject:
             [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:
              [NSString stringWithFormat:@"bird%d.png",i]]];
        }
        
        CCAnimation *flyAnim = [CCAnimation animationWithSpriteFrames:birdFlyingAnim delay:0.1f];
        _birdFlyAction = [CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:flyAnim]];
    }
    
    [_bird runAction: _birdFlyAction];
    [_birdSheet addChild: _bird];
}

- (void)createBirdTwoAnim
{
    CGSize size = [[CCDirector sharedDirector] winSize];
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"bird.plist"];
    _birdTwoSheet = [CCSpriteBatchNode batchNodeWithFile:@"bird.png"];
    _birdTwoSheet.position = ccp(size.width + 32, size.height/2);
    [self addChild: _birdTwoSheet];
    
    _birdTwo = [ClickableSprite spriteWithSpriteFrameName:@"bird1.png"];
    _birdTwo.target = self;
    _birdTwo.selector = @selector(birdTapped);
    if (IS_RETINA_568 || IS_IPAD) {
        _birdTwo.scale = 2.0;
    }
    
    if (!_birdTwoFlyAction) {
        NSMutableArray *birdFlyingAnim = [NSMutableArray array];
        for (int i=1; i<=5; i++) {
            [birdFlyingAnim addObject:
             [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:
              [NSString stringWithFormat:@"bird%d.png",i]]];
        }
        
        CCAnimation *flyAnim = [CCAnimation animationWithSpriteFrames:birdFlyingAnim delay:0.1f];
        _birdTwoFlyAction = [CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:flyAnim]];
    }
    
    [_birdTwo runAction: _birdTwoFlyAction];
    [_birdTwoSheet addChild: _birdTwo];
}

- (void)createBirdThreeAnim
{
    CGSize size = [[CCDirector sharedDirector] winSize];
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"bird.plist"];
    _birdThreeSheet = [CCSpriteBatchNode batchNodeWithFile:@"bird.png"];
    _birdThreeSheet.position = ccp(size.width + 32, size.height/2);
    [self addChild: _birdThreeSheet];
    
    _birdThree = [ClickableSprite spriteWithSpriteFrameName:@"bird1.png"];
    _birdThree.target = self;
    _birdThree.selector = @selector(birdTapped);
    if (IS_RETINA_568 || IS_IPAD) {
        _birdThree.scale = 2.0;
    }
    
    if (!_birdThreeFlyAction) {
        NSMutableArray *birdFlyingAnim = [NSMutableArray array];
        for (int i=1; i<=5; i++) {
            [birdFlyingAnim addObject:
             [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:
              [NSString stringWithFormat:@"bird%d.png",i]]];
        }
        
        CCAnimation *flyAnim = [CCAnimation animationWithSpriteFrames:birdFlyingAnim delay:0.1f];
        _birdThreeFlyAction = [CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:flyAnim]];
    }
    
    [_birdThree runAction: _birdThreeFlyAction];
    [_birdThreeSheet addChild: _birdThree];
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
    _frank.position = ccp(size.width/2, size.height + CGRectGetHeight(_frank.boundingBox));
    _frank.target = self;
    _frank.selector = @selector(frankTapped);
    if (IS_RETINA_568 || IS_IPAD) {
        _frank.scale = 2.0;
    }
    
    _fallAction = [CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:fallAnim]];
    
    [_frank runAction: _fallAction];
    [_frankSheet addChild: _frank];
}

#pragma mark -----------------------------
#pragma mark Scheduled Selectors
#pragma mark -----------------------------

- (void)incrementTime
{
    ++self.time;
    
    if (self.time >= 15) {
        self.showBirdTwo = YES;
    }
    
    if (self.time >= 30) {
        self.showBirdThree = YES;
    }
    
    if (self.time == 35 || self.time == 90) {
        [self showTempInvincibility];
    }
    
    if (self.time == 65 || self.time == 130) {
        [self showTempSlowMo];
    }
    
    if (self.time == 91) {
        [self showAddLife];
    }
}

- (void)decrementFtTillGround
{
    --self.ftTillGround;
    if (!self.levelComplete) {
        if (self.ftTillGround < FEET_TILL_GROUND_SUCCEEDED) {
            self.levelComplete = YES;
            [self showLevelCompleteMenu];
        } else {
            if (self.ftTillGround < FEET_TILL_GROUND_ORANGE && self.ftTillGround > FEET_TILL_GROUND_RED) {
                self.ftTillGroundLabel.color = ccORANGE;
            } else if (self.ftTillGround < FEET_TILL_GROUND_RED) {
                self.ftTillGroundLabel.color = ccRED;
            }
            self.ftTillGroundLabel.string = [NSString stringWithFormat:@"%d ft", self.ftTillGround];
        }
    }
}

- (void)nextFrame:(ccTime)dt
{
    float cloudOneSpeed  = (self.isSlowMoActive) ? 75  : 150;
    float cloudTwoSpeed  = (self.isSlowMoActive) ? 60  : 120;
    float birdOneSpeed   = (self.isSlowMoActive) ? 50  : 100;
    float birdTwoSpeed   = (self.isSlowMoActive) ? 75  : 150;
    float birdThreeSpeed = (self.isSlowMoActive) ? 100 : 200;
    
    CGSize size = [[CCDirector sharedDirector] winSize];
    self.cloudOne.position = ccp( self.cloudOne.position.x, self.cloudOne.position.y + cloudOneSpeed*dt );
    if (self.cloudOne.position.y > size.height+400) {
        self.cloudOne.position = ccp( [self randomFloatBetween:50.0 and:size.width - 50], -300 );
    }
    
    self.cloudTwo.position = ccp( self.cloudTwo.position.x, self.cloudTwo.position.y + cloudTwoSpeed*dt );
    if (self.cloudTwo.position.y > size.height+300) {
        self.cloudTwo.position = ccp( [self randomFloatBetween:50.0 and:size.width - 50], -300 );
    }
    
    // Bird 1 animation
    if (self.birdCollision) {
        self.birdSheet.rotation = 180;
        [self.birdFlyAction stop];
        self.birdSheet.position = ccp(self.birdSheet.position.x, self.birdSheet.position.y - 250*dt);
        if (self.birdSheet.position.y < -32) {
            self.birdSheet.rotation = 0;
            [self birdTapped];
            [self.birdFlyAction startWithTarget:self.bird];
            self.birdCollision = NO;
            self.birdSheet.position = ccp( size.width + 100, [self randomFloatBetween:32.0 and:size.height - 32] );
        }
    } else {
        self.birdSheet.position = ccp(self.birdSheet.position.x - birdOneSpeed*dt, self.birdSheet.position.y);
        if (self.birdSheet.position.x < -32) {
            self.birdCollision = NO;
            [self birdTapped];
            self.birdSheet.position = ccp( size.width + 100, [self randomFloatBetween:32.0 and:size.height - 32] );
        }
    }
    
    // Bird 2 animation
    if (self.showBirdTwo) {
        if (self.birdTwoCollision) {
            self.birdTwoSheet.rotation = 180;
            [self.birdTwoFlyAction stop];
            self.birdTwoSheet.position = ccp(self.birdTwoSheet.position.x, self.birdTwoSheet.position.y - 250*dt);
            if (self.birdTwoSheet.position.y < -32) {
                self.birdTwoSheet.rotation = 0;
                [self birdTapped];
                [self.birdTwoFlyAction startWithTarget:self.birdTwo];
                self.birdTwoCollision = NO;
                self.birdTwoSheet.position = ccp( size.width + 100, [self randomFloatBetween:32.0 and:size.height - 32] );
            }
        } else {
            self.birdTwoSheet.position = ccp(self.birdTwoSheet.position.x - birdTwoSpeed*dt, self.birdTwoSheet.position.y);
            if (self.birdTwoSheet.position.x < -32) {
                self.birdTwoCollision = NO;
                [self birdTapped];
                self.birdTwoSheet.position = ccp( size.width + 100, [self randomFloatBetween:32.0 and:size.height - 32] );
            }
        }
    }
    
    // Bird 3 animation
    if (self.showBirdThree) {
        if (self.birdThreeCollision) {
            self.birdThreeSheet.rotation = 180;
            [self.birdThreeFlyAction stop];
            self.birdThreeSheet.position = ccp(self.birdThreeSheet.position.x, self.birdThreeSheet.position.y - 250*dt);
            if (self.birdThreeSheet.position.y < -32) {
                self.birdThreeSheet.rotation = 0;
                [self birdTapped];
                [self.birdThreeFlyAction startWithTarget:self.birdThree];
                self.birdThreeCollision = NO;
                self.birdThreeSheet.position = ccp( size.width + 100, [self randomFloatBetween:32.0 and:size.height - 32] );
            }
        } else {
            self.birdThreeSheet.position = ccp(self.birdThreeSheet.position.x - birdThreeSpeed*dt, self.birdThreeSheet.position.y);
            if (self.birdThreeSheet.position.x < -32) {
                self.birdThreeCollision = NO;
                [self birdTapped];
                self.birdThreeSheet.position = ccp( size.width + 100, [self randomFloatBetween:32.0 and:size.height - 32] );
            }
        }
    }
    
    if (self.hitCount >= MAX_HIT_COUNT && !self.gameOver) {
        self.gameOver = YES;
        [self frankTapped];
        [self.frank runAction:[CCMoveTo actionWithDuration:1.0 position:ccp(self.frank.position.x, 0 - CGRectGetHeight(self.frank.boundingBox))]];
        double delayInSeconds = 1.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [self showGameOverMenu];
        });
    }
    
    [self.frank runAction:[CCShake actionWithDuration:dt amplitude:ccp(2,2) dampening:true]];
}

- (void)checkForCollision
{
    CGRect frankRect = self.frank.boundingBox;
    
    if (!self.isInvincibilityActive) {
        if (!self.birdCollision) {
            if (CGRectContainsRect(frankRect, self.birdSheet.boundingBox)) {
                self.birdCollision = YES;
                [[SimpleAudioEngine sharedEngine] playEffect:@"oowh.mp3"];
                ++self.hitCount;
                NSString* newLabel = [NSString stringWithFormat:@"%d", self.hitCount];
                [self.hitCountNumLabel setString:newLabel];
                [GameSettings subtractGameScore:GAME_SCORE_HIT_BY_BIRD forLabel:self.gameScoreLabel];
            }
        }
        
        if (!self.birdTwoCollision) {
            if (CGRectContainsRect(frankRect, self.birdTwoSheet.boundingBox)) {
                self.birdTwoCollision = YES;
                [[SimpleAudioEngine sharedEngine] playEffect:@"oowh.mp3"];
                ++self.hitCount;
                NSString* newLabel = [NSString stringWithFormat:@"%d", self.hitCount];
                [self.hitCountNumLabel setString:newLabel];
                [GameSettings subtractGameScore:GAME_SCORE_HIT_BY_BIRD forLabel:self.gameScoreLabel];
            }
        }
        
        if (!self.birdThreeCollision) {
            if (CGRectContainsRect(frankRect, self.birdThreeSheet.boundingBox)) {
                self.birdThreeCollision = YES;
                [[SimpleAudioEngine sharedEngine] playEffect:@"oowh.mp3"];
                ++self.hitCount;
                NSString* newLabel = [NSString stringWithFormat:@"%d", self.hitCount];
                [self.hitCountNumLabel setString:newLabel];
                [GameSettings subtractGameScore:GAME_SCORE_HIT_BY_BIRD forLabel:self.gameScoreLabel];
            }
        }
    }
    
    if (!self.addLifeCollision) {
        if (CGRectContainsRect(frankRect, self.addLife.boundingBox)) {
            self.addLifeCollision = YES;
            NSNumber* currentLives = [[NSUserDefaults standardUserDefaults] objectForKey:kGameLivesKey];
            [GameSettings addGameLives:[currentLives integerValue] + 1 forLabel:self.gameLivesCountLabel];
            [GameSettings addGameScore:GAME_SCORE_COLLECTED_POWER_UP forLabel:self.gameScoreLabel];
            self.addLife.visible = NO;
        }
        self.addLifeCollision = NO;
    }
    
    if (!self.tempSlowMoCollision) {
        if (CGRectContainsRect(frankRect, self.tempSlowMo.boundingBox)) {
            self.tempSlowMoCollision = YES;
            [self enableSlowMo];
        }
        self.tempSlowMoCollision = NO;
    }
    
    if (!self.tempInvincibilityCollision) {
        if (CGRectContainsRect(frankRect, self.tempInvincibility.boundingBox)) {
            self.tempInvincibilityCollision = YES;
            [self enableInvincibility];
        }
        self.tempInvincibilityCollision = NO;
    }
}

#pragma mark -----------------------------
#pragma mark Menu
#pragma mark -----------------------------

- (void)constructMenu
{
    CGSize size = [[CCDirector sharedDirector] winSize];
    __block LevelOneLayer* _self = self;
    CCMenuItem *pauseMenuItem = [CCMenuItemFont itemWithString:@"Pause" block:^(id sender) {
        if (!_self.gameOver && ![_self.children containsObject:_self.menu]) {
            [self showPausedMenu];
            [[CCDirector sharedDirector] pause];
        }
    }];
    pauseMenuItem.position = CGPointZero;
    CCMenu* starMenu = [CCMenu menuWithItems:pauseMenuItem, nil];
    starMenu.color = ccBLACK;
    starMenu.position = ccp(size.width/2, 20);
    [self addChild:starMenu];
}

- (void)showGameOverMenu
{
    CGSize size = [[CCDirector sharedDirector] winSize];
    [[SimpleAudioEngine sharedEngine] pauseBackgroundMusic];
    self.menu = [ContextMenu node];
    CGPoint position = ccp(size.width/2, size.height/2);
    position = ccpSub(position, self.position);
    [self.menu setMenuPosition:position];
    self.invincibilityActive = YES;
    
    NSNumber* livesLeft = [[NSUserDefaults standardUserDefaults] objectForKey:kGameLivesKey];
    if ([livesLeft integerValue] <= 0) { // Game Over
        [self.menu setTitle:@"Game Over"];
        [self.menu setTitleColor:ccRED];
        
        [self.menu addLabel:@"Start New Game" withBlock:^(id sender) {
            [GameSettings resetGameLives];
            [GameSettings resetGameScore];
            [[SimpleAudioEngine sharedEngine] resumeBackgroundMusic];
            [[CCDirector sharedDirector] resume];
            [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[LevelOneLayer scene]]];
        }];
        
        [self.menu addLabel:@"Main Menu" withBlock:^(id sender) {
            [GameSettings resetGameLives];
            [GameSettings resetGameScore];
            [[SimpleAudioEngine sharedEngine] resumeBackgroundMusic];
            [[CCDirector sharedDirector] resume];
            [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[MainMenuLayer scene]]];
        }];
    } else { // Level Failed
        [self.menu setTitle:@"Level Failed"];
        [self.menu setTitleColor:ccRED];
        
        [self.menu addLabel:@"Retry Level" withBlock:^(id sender) {
            [GameSettings subtractGameLives:1 forLabel:self.gameLivesCountLabel];
            [GameSettings setGameScore:self.scoreAtLevelStart];
            [GameSettings setGameLives:self.livesAtLevelStart];
            [[SimpleAudioEngine sharedEngine] resumeBackgroundMusic];
            [[CCDirector sharedDirector] resume];
            [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[LevelOneLayer scene]]];
        }];
        
        [self.menu addLabel:@"Quit Game" withBlock:^(id sender) {
            [GameSettings resetGameLives];
            [GameSettings resetGameScore];
            [[SimpleAudioEngine sharedEngine] resumeBackgroundMusic];
            [[CCDirector sharedDirector] resume];
            [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[MainMenuLayer scene]]];
        }];
    }
    
    [self unschedule:@selector(decrementFtTillGround)];
    [self unschedule:@selector(incrementTime)];
    [self.menu build];
    [self addChild:self.menu];
}

- (void)showLevelCompleteMenu
{
    CGSize size = [[CCDirector sharedDirector] winSize];
    [[SimpleAudioEngine sharedEngine] pauseBackgroundMusic];
    self.menu = [ContextMenu node];
    CGPoint position = ccp(size.width/2, size.height/2);
    position = ccpSub(position, self.position);
    [self.menu setMenuPosition:position];
    [self.menu setTitle:@"You Won!"];
    [self.menu setTitleColor:ccGREEN];
    self.invincibilityActive = YES;
    
    if (self.hitCount == 0) {
        [GameSettings addGameScore:GAME_SCORE_PERFECT_LEVEL forLabel:self.gameScoreLabel];
    }
    [GameSettings addGameScore:GAME_SCORE_COMPLETED_LEVEL forLabel:self.gameScoreLabel];
    
    GKLeaderboard* frankBoard = [GameKitManager sharedInstance].frankboard;
    if (frankBoard) {
        int gameScore = [[[NSUserDefaults standardUserDefaults] objectForKey:kGameScoreKey] integerValue];
        NSString* identifier = (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7")) ? frankBoard.identifier : frankBoard.category;
        [GameKitManager reportScore:gameScore forLeaderboardID:identifier];
    }
    
    [self.menu addLabel:@"Next Level" withBlock:^(id sender) {
        [[SimpleAudioEngine sharedEngine] resumeBackgroundMusic];
        [[CCDirector sharedDirector] resume];
        [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[LevelTwoLayer scene]]];
    }];
    
    [self.menu addLabel:@"Start Over" withBlock:^(id sender) {
        [GameSettings setGameScore:self.scoreAtLevelStart];
        [GameSettings setGameLives:self.livesAtLevelStart];
        [[SimpleAudioEngine sharedEngine] resumeBackgroundMusic];
        [[CCDirector sharedDirector] resume];
        [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[LevelOneLayer scene]]];
    }];
    
    [self.menu addLabel:@"Quit Game" withBlock:^(id sender) {
        [[SimpleAudioEngine sharedEngine] resumeBackgroundMusic];
        [[CCDirector sharedDirector] resume];
        [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[MainMenuLayer scene]]];
    }];
    
    [self.menu build];
    [self addChild:self.menu];
}

- (void)showPausedMenu
{
    CGSize size = [[CCDirector sharedDirector] winSize];
    [[SimpleAudioEngine sharedEngine] pauseBackgroundMusic];
    self.menu = [ContextMenu node];
    CGPoint position = ccp(size.width/2, size.height/2);
    position = ccpSub(position, self.position);
    [self.menu setMenuPosition:position];
    [self.menu setTitleColor:ccWHITE];
    
    [self.menu addLabel:@"Start Over" withBlock:^(id sender) {
        [GameSettings setGameScore:self.scoreAtLevelStart];
        [GameSettings setGameLives:self.livesAtLevelStart];
        [[SimpleAudioEngine sharedEngine] resumeBackgroundMusic];
        [[CCDirector sharedDirector] resume];
        [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[LevelOneLayer scene]]];
    }];
    
    [self.menu addLabel:@"Quit Game" withBlock:^(id sender) {
        [GameSettings resetGameLives];
        [GameSettings resetGameScore];
        [[SimpleAudioEngine sharedEngine] resumeBackgroundMusic];
        [[CCDirector sharedDirector] resume];
        [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[MainMenuLayer scene]]];
    }];
    
    [self.menu addLabel:@"Resume Game" withBlock:^(id sender) {
        [[SimpleAudioEngine sharedEngine] resumeBackgroundMusic];
        [[CCDirector sharedDirector] resume];
        [self.menu removeFromParentAndCleanup:YES];
    }];
    
    [self.menu build];
    [self addChild:self.menu];
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
#pragma mark CCTouchOneByOneDelegate
#pragma mark -----------------------------

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    return (self.gameOver) ? NO : YES;
}

- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
	CGPoint location = [self convertTouchToNodeSpace: touch];
    
	[self.frank runAction:[CCMoveTo actionWithDuration:0.3 position:location]];
}

#pragma mark -----------------------------
#pragma mark Power Up Handlers
#pragma mark -----------------------------

- (void)enableInvincibility
{
    self.invincibilityActive = YES;
    self.tempInvincibility.visible = NO;
    [self showTempPowerUpTimer];
    [GameSettings addGameScore:GAME_SCORE_COLLECTED_POWER_UP forLabel:self.gameScoreLabel];
}

- (void)disableInvincibility
{
    self.invincibilityActive = NO;
}

- (void)enableSlowMo
{
    self.slowMoActive = YES;
    self.tempSlowMo.visible = NO;
    [self showTempPowerUpTimer];
    [GameSettings addGameScore:GAME_SCORE_COLLECTED_POWER_UP forLabel:self.gameScoreLabel];
}

- (void)disableSlowMo
{
    self.slowMoActive = NO;
}

- (void)showTempPowerUpTimer
{
    self.powerUpTime = TEMP_POWER_UP_SECONDS;
    if (!self.powerUpTimeLabel) {
        self.powerUpTimeLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%.0f", self.powerUpTime] fontName:@"Marker Felt" fontSize:18];
        self.powerUpTimeLabel.color = ccGRAY;
        CGSize size = [[CCDirector sharedDirector] winSize];
        self.powerUpTimeLabel.position = ccp(size.width/2, size.height - CGRectGetHeight(self.powerUpTimeLabel.boundingBox) - 5);
    }
    self.powerUpTimeLabel.visible = YES;
    if (![self.children containsObject:self.powerUpTimeLabel]) {
        [self addChild:self.powerUpTimeLabel];
    }
    [self schedule:@selector(tempPowerUpTimer) interval:1.0];
}

- (void)tempPowerUpTimer
{
    --self.powerUpTime;
    self.powerUpTimeLabel.string = [NSString stringWithFormat:@"%.0f", self.powerUpTime];
    
    if (self.powerUpTime <= 0) {
        [self unschedule:@selector(tempPowerUpTimer)];
        self.powerUpTimeLabel.visible = NO;
        if (self.isInvincibilityActive) self.invincibilityActive = NO;
        if (self.isSlowMoActive) self.slowMoActive = NO;
    }
}

@end
