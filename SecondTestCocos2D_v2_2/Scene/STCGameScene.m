//
//  MyCocos2DClass.m
//  SecondTestCocos2D_v2_2
//
//  Created by Voronok Vitaliy on 2/20/15.
//  Copyright 2015 IDPGroup. All rights reserved.
//

#import "STCGameScene.h"

@interface STCGameScene ()
@property (nonatomic, assign)   CGSize      winSize;
@property (nonatomic, assign)   NSInteger   familyIdx;

- (void)showCurFamily;

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
        
        CCLayerColor *layerColor = [CCLayerColor layerWithColor:ccc4(20, 35, 20, 255)];
        
        [self addChild:layerColor];
        
        self.isTouchEnabled = YES;
        
        [self showCurFamily];
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
//    NSLog(@"ccTouchBegan");
    
    self.familyIdx ++;
    
    if (self.familyIdx >= [UIFont familyNames].count) {
        self.familyIdx = 0;
    }
    
    [self showCurFamily];
    
    return YES;
}

- (void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event {
//    NSLog(@"ccTouchMoved");
}

- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event {
//    NSLog(@"ccTouchEnded");
}

#pragma mark -
#pragma mark Public

#pragma mark -
#pragma mark Private

- (void)showCurFamily {
    [self removeAllChildren];
    
    CCLayerColor *layerColor = [CCLayerColor layerWithColor:ccc4(20, 35, 20, 255)];
    [self addChild:layerColor];
    
    NSString *familyName = [UIFont familyNames][self.familyIdx];
    NSLog(@"%lu - %@", (unsigned long)self.familyIdx, familyName);
    
    NSArray * fontNames = [UIFont fontNamesForFamilyName:familyName];
    
    [fontNames enumerateObjectsUsingBlock:^(NSString *fontName, NSUInteger idx, BOOL *stop) {
        CCLabelTTF * label = [CCLabelTTF labelWithString:fontName fontName:fontName fontSize:20];
        label.position = ccp(self.winSize.width / 2,
                             (self.winSize.height * (idx + 1) / (fontNames.count + 1)));

        
        [self addChild:label];
     }];
}

@end
