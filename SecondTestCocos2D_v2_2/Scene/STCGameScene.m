//
//  MyCocos2DClass.m
//  SecondTestCocos2D_v2_2
//
//  Created by Voronok Vitaliy on 2/20/15.
//  Copyright 2015 IDPGroup. All rights reserved.
//

#import "STCGameScene.h"

@interface STCGameScene ()
@property (nonatomic, assign)   CGSize  winSize;
@property (nonatomic, strong)   CCLayer *playerLaerNode;
@property (nonatomic, strong)   CCLayer *hudLaerNode;

- (void)setupSceneLayer;

@end

@implementation STCGameScene

#pragma mark -
#pragma mark Class Methods

+(CCScene *) scene
{
    // 'scene' is an autorelease object.
    CCScene *scene = [CCScene node];
    
    // 'layer' is an autorelease object.
    STCGameScene *layer = [STCGameScene node];
    
    // add layer as a child to scene
    [scene addChild:layer];
    
    // return the scene
    return scene;
}

#pragma mark -
#pragma mark Initialization and Dealocation

- (id)init {
    self = [super init];
    
    if (self) {
        self.touchEnabled = YES;
        self.winSize = [CCDirector sharedDirector].winSize;

        [self setupSceneLayer];
        
        
//        CCLabelTTF *label = [CCLabelTTF labelWithString:@"Thirteen Pixel Fonts" fontName:@"Thirteen Pixel Fonts" fontSize:40];
//
//        label.position = ccp(self.winSize.width / 2, self.winSize.height / 2);
//        label.anchorPoint = ccp(1, 0);
//        [self addChild:label];
    }
    
    return self;
}

#pragma mark -
#pragma mark Accessors

#pragma mark -
#pragma mark Touch Handle

- (void)registerWithTouchDispatcher {
    [[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:self priority:kCCMenuHandlerPriority swallowsTouches:NO];
}

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    NSLog(@"ccTouchBegan");
    
    return YES;
}

- (void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event {
    NSLog(@"ccTouchMoved");
}

- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event {
    NSLog(@"ccTouchEnded");
}

#pragma mark -
#pragma mark Public

#pragma mark -
#pragma mark Private

- (void)setupSceneLayer {
    self.playerLaerNode = [CCLayer node];
    [self addChild:self.playerLaerNode];
    
    self.hudLaerNode = [CCLayer node];
    [self addChild:self.hudLaerNode];
}


@end
