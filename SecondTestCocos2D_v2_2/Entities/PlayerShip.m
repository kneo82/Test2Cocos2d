//
//  PlayerShip.m
//  SecondTestCocos2D_v2_2
//
//  Created by Admin on 21/02/15.
//  Copyright (c) 2015 IDPGroup. All rights reserved.
//

#import "PlayerShip.h"

#import "Constants.h"



@implementation PlayerShip

#pragma mark -
#pragma mark Class Methods

+ (CCSprite *)generateSprite {
    static CCSprite *sprite = nil;
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        CCLabelTTF *mainShip = [CCLabelTTF labelWithString:@"▲" fontName:kSTCArialFontName fontSize:20];
        mainShip.tag = kSTCNodeNameMainShip;
        mainShip.color = ccWHITE;

        CCLabelTTF *wings = [CCLabelTTF labelWithString:@"< >" fontName:kSTCArialFontName fontSize:20];
        wings.tag = kSTCNodeNameWings;
        wings.color = ccWHITE;
        
        mainShip.rotation = 180;
        CGFloat width = mainShip.contentSize.width > wings.contentSize.width
                        ? mainShip.contentSize.width
                        : wings.contentSize.width;
        
        CGFloat height = (mainShip.contentSize.height + wings.contentSize.height) / 2;

        CCNode *node = [CCNode node];
        node.contentSize = CGSizeMake(width, height);
        mainShip.anchorPoint = ccp(0.5, 1);
        mainShip.position = ccp(width / 2, -height / 3 + 1);
        [node addChild:mainShip];
        
        wings.anchorPoint = ccp(0.5, 0.0);
        wings.position = ccp(width / 2, height / 3 - 3);
        [node addChild:wings];
        
        
        CCRenderTexture *renderTexture = [CCRenderTexture renderTextureWithWidth:width height:height];
        [renderTexture begin];
        [node visit];

        [renderTexture end];
        sprite = [CCSprite spriteWithTexture:renderTexture.sprite.texture];
    });
    
    return sprite;
}

#pragma mark -
#pragma mark Initialization and Dealocation

- (instancetype)initWithPosition:(CGPoint)position {
    self = [super initWithPosition:position];
    
    if (self) {
        self.tag = kSTCNodeNameShipSprite;
    }
    
    return self;
}

#pragma mark -
#pragma mark Life Cycle

- (void)update:(CFTimeInterval)delta {
    
}

@end
