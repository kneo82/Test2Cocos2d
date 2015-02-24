//
//  STCEnemyB.m
//  SecondTestCocos2D_v2_2
//
//  Created by Admin on 22/02/15.
//  Copyright (c) 2015 IDPGroup. All rights reserved.
//

#import "STCEnemyB.h"

@implementation STCEnemyB

#pragma mark -
#pragma mark Class Methods

+ (CCSprite *)generateSprite {
    static CCSprite *sprite = nil;
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        CCLabelTTF *ship = [CCLabelTTF labelWithString:@"⎛⚉⎞" fontName:kSTCArialFontName fontSize:20];
        ship.tag = kSTCNodeNameMainShip;
        
        sprite = ship;
    });
    
    return sprite;
}

#pragma mark -
#pragma mark Initialization and Dealocation

- (instancetype)initWithPosition:(CGPoint)position physicsWorld:(b2World *)world {
    self = [super initWithPosition:position physicsWorld:world];
    
    if (self) {
        // Modify the steering AI to move these enemies differently from EnemyA
        self.aiSteering.maxVelocity = 8.0f;
        self.aiSteering.maxSteeringForce = 0.05f;
        
        // Change the score for this enemy type
        self.score = 445;
        self.damageTakenPerShot = 10;
    }
    
    return self;
}

@end
