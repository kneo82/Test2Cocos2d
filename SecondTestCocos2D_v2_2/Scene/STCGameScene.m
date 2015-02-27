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

@property (nonatomic, strong)   CCSprite    *square;
@property (nonatomic, strong)   CCSprite    *circle;
@property (nonatomic, strong)   CCSprite    *triangle;

- (void)setupSprites;

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
    [scene addChild: layer];
    
    // return the scene
    return scene;
}

#pragma mark -
#pragma mark Initialization and Dealocation

- (id)init {
    self = [super init];
    
    if (self) {
        self.winSize = [CCDirector sharedDirector].winSize;
        
        self.touchEnabled = YES;
        
        CCLayerColor *layerColor = [CCLayerColor layerWithColor:ccc4(50, 45, 30, 255)];
        [self addChild:layerColor];

        [self setupSprites];
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

- (void)setupSprites {
    CCSprite *square = [CCSprite spriteWithFile:@"square.png"];
    square.position = ccp(self.winSize.width * 0.25, self.winSize.height * 0.50);
    self.square = square;
    
    [self addChild:square];
    
}



@end
