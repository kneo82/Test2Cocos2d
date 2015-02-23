//
//  Entity.h
//  SecondTestCocos2D_v2_2
//
//  Created by Admin on 21/02/15.
//  Copyright 2015 IDPGroup. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Box2D.h"
#import "Constants.h"
#import "MyContactListener.h"

@interface STCEntity : CCSprite
@property (nonatomic, assign)   b2World     *physicsWorld;
@property (nonatomic, assign)   b2Body      *physicsBody;
@property (nonatomic, assign)   CGPoint     direction;
@property (nonatomic ,assign)   CGFloat     health;
@property (nonatomic, assign)   CGFloat     maxHealth;

+ (CCSprite *)generateSprite;
- (instancetype)initWithPosition:(CGPoint)position physicsWorld:(b2World *)world;
- (void)update:(ccTime)delta;

/**
 Called to configure the physics body that will be used to handle collison detection. The collision body is a shape that covers the area of the entity with which collisions should be reported
 */
- (void)configureCollisionBody;

/**
 Called when a collision is detected so that some action can be taken e.g. reduce health or maybe collect a powerup
 @param body the physics body with which the physics body for this entity has collided
 */
- (void)collidedWith:(STCEntity *)entity contact:(MyContact)contact;

@end
