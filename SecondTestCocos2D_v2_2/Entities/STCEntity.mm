//
//  Entity.m
//  SecondTestCocos2D_v2_2
//
//  Created by Admin on 21/02/15.
//  Copyright 2015 IDPGroup. All rights reserved.
//

#import "STCEntity.h"

@interface STCEntity ()

@end

@implementation STCEntity

#pragma mark -
#pragma mark Class Methods

+ (CCSprite *)generateSprite {
    // Overridden by subclasses
    return nil;
}

#pragma mark -
#pragma mark Initialization and Dealocation

- (instancetype)initWithPosition:(CGPoint)position physicsWorld:(b2World *)world {
    CCSprite *sprite = [[self class] generateSprite];
    
    self = [super initWithTexture:sprite.texture];
    
    if (self) {
        self.physicsWorld = world;
        self.position = position;
        self.direction = CGPointZero;
    }
    
    return self;
}

#pragma mark -
#pragma mark Life Cycle

- (void)update:(CFTimeInterval)delta {

}

#pragma mark -
#pragma mark Public

- (void)configureCollisionBody
{
    // Overridden by a subclass
}

//- (void)collidedWith:(b2BodyDef *)body contact:(SKPhysicsContact*)contact
//{
//    // Overridden by a subclass
//}

@end
