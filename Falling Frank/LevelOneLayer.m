//
//  LevelOneLayer.m
//  Falling Frank
//
//  Created by Jeremy Fox on 9/8/13.
//  Copyright (c) 2013 jeremyfox. All rights reserved.
//

#import "LevelOneLayer.h"
#import "CCTouchDispatcher.h"

@interface LevelOneLayer()
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
    
}

- (id)init
{
    if (self = [super init]) {
        [self preloadAssets];
        [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"wind-strong.mp3" loop:YES];
        
		CGSize size = [[CCDirector sharedDirector] winSize];
        
        CCSprite *background;
        if (IS_RETINA_568) {
            background = [CCSprite spriteWithFile:@"sky-568h@2x.jpg"];
        } else {
            background = [CCSprite spriteWithFile:@"sky.jpg"];
        }
		
		background.position = ccp(size.width/2, size.height/2);
		[self addChild: background];
        
        _cloudOne = [ClickableSprite spriteWithFile:@"cloud1.png"]; 
        _cloudOne.position = ccp(size.width/2.6, -331);
        _cloudOne.target = self;
        _cloudOne.selector = @selector(cloudTapped);
        
        _cloudTwo = [ClickableSprite spriteWithFile:@"cloud2.png"];
        _cloudTwo.position = ccp(size.width/1.5, -331);
        _cloudTwo.target = self;
        _cloudTwo.selector = @selector(cloudTapped);
        
        [self addChild: _cloudOne];
        [self addChild: _cloudTwo];
        
        [self createFrankAnim];
        [self createBirdAnim];
        
        [self schedule:@selector(nextFrame:)];
        [self schedule:@selector(checkForCollision) interval:0.2];
        
        _touchEnabled = YES;
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

- (void)preloadAssets {
    [[SimpleAudioEngine sharedEngine] preloadBackgroundMusic:@"wind-strong.mp3"];
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"frank_yell.mp3"];
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"wind1-short.mp3"];
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"crow1.mp3"];
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"oowh.mp3"];
}

- (void)unloadAssets {
    [[SimpleAudioEngine sharedEngine] unloadEffect:@"wind-strong.mp3"];
    [[SimpleAudioEngine sharedEngine] unloadEffect:@"frank_yell.mp3"];
    [[SimpleAudioEngine sharedEngine] unloadEffect:@"wind1-short.mp3"];
    [[SimpleAudioEngine sharedEngine] unloadEffect:@"crow1.mp3"];
    [[SimpleAudioEngine sharedEngine] unloadEffect:@"oowh.mp3"];
    
}

#pragma mark -----------------------------
#pragma mark Sound Effects
#pragma mark -----------------------------

- (void)frankTapped {
    [[SimpleAudioEngine sharedEngine] playEffect:@"frank_yell.mp3"];
}

- (void)cloudTapped {
    [[SimpleAudioEngine sharedEngine] playEffect:@"wind1-short.mp3"];
}

- (void)birdTapped {
    [[SimpleAudioEngine sharedEngine] playEffect:@"crow1.mp3"];
}

#pragma mark -----------------------------
#pragma mark Animations
#pragma mark -----------------------------

- (void)createBirdAnim {
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
    if (IS_RETINA_568) {
        _bird.scale = 2.0;
    }
    
    _flyAction = [CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:flyAnim]];
    
    [_bird runAction: _flyAction];
    [_birdSheet addChild: _bird];
}

- (void)createFrankAnim {
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
    if (IS_RETINA_568) {
        _frank.scale = 2.0;
    }
    
    _fallAction = [CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:fallAnim]];
    
    [_frank runAction: _fallAction];
    [_frankSheet addChild: _frank];
}

#pragma mark -----------------------------
#pragma mark Scheduled Selectors
#pragma mark -----------------------------

- (void)nextFrame:(ccTime)dt {
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
            [self birdTapped];
            [self.flyAction startWithTarget:self.bird];
            self.collision = NO;
            self.birdSheet.position = ccp( size.width + 100, [self randomFloatBetween:size.height/2 and:size.height] );
        }
    } else {
        self.birdSheet.position = ccp(self.birdSheet.position.x - 100*dt, self.birdSheet.position.y);
        if (self.birdSheet.position.x < -32) {
            self.collision = NO;
            [self birdTapped];
            self.birdSheet.position = ccp( size.width + 100, [self randomFloatBetween:size.height/2 and:size.height] );
        }
    }
    
    [self.frank runAction:[CCShake actionWithDuration:dt amplitude:ccp(2,2) dampening:true]];
}

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

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    return YES;
}

- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event {
	CGPoint location = [self convertTouchToNodeSpace: touch];
    
	[self.frank runAction:[CCMoveTo actionWithDuration:0.3 position:location]];
}

@end
