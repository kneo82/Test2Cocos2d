//
//  STCEnemyA.m
//  SecondTestCocos2D_v2_2
//
//  Created by Admin on 22/02/15.
//  Copyright (c) 2015 IDPGroup. All rights reserved.
//

#import "STCEnemyA.h"
#import "AISteering.h"
#import "STCGameScene.h"

#import "Box2D.h"
#import "Constants.h"
#import "CGGeometry+ZCExtension.h"

@interface STCEnemyA ()

+ (void)loadSharedAssets;

- (void)configureCollisionBody;
//- (void)collidedWith:(b2BodyDef)body contact:(SKPhysicsContact*)contact;

@end

@implementation STCEnemyA

#pragma mark -
#pragma mark Class Methods

static CCAction *damageAction = nil;
static CCAction *hitLeftAction = nil;
static CCAction *hitRightAction = nil;
static CCAction *moveBackAction = nil;

+ (CCSprite *)generateSprite {
    static CCSprite *sprite = nil;
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        CCLabelTTF *ship = [CCLabelTTF labelWithString:@"(=⚇=)" fontName:kSTCArialFontName fontSize:20];
        ship.tag = kSTCNodeNameMainShip;
        
        sprite = ship;
    });
    
    return sprite;
}

+ (void)loadSharedAssets {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        damageAction = [CCSequence actionWithArray:@[
                                                     [CCTintBy actionWithDuration:0 red:255 green:0 blue:0],
                                                     [CCTintBy actionWithDuration:1 red:255 green:255 blue:255]]
                        ];
        
        hitLeftAction = [CCSequence actionWithArray:@[
                                                      [CCRotateTo actionWithDuration:0.25 angle:15],
                                                      [CCRotateTo actionWithDuration:0.5 angle:0]
                                                      ]];
        
        hitRightAction = [CCSequence actionWithArray:@[
                                                       [CCRotateTo actionWithDuration:0.25 angle:(-15)],
                                                       [CCRotateTo actionWithDuration:0.5 angle:0]
                                                      ]];
        
        moveBackAction = [CCSequence actionWithArray:@[
                                                       [CCMoveBy actionWithDuration:0.25 position:ccp(0, 20)]
                                                       ]];
    });
}

#pragma mark -
#pragma mark Initialization and Dealocation

- (instancetype)initWithPosition:(CGPoint)position {
    self = [super initWithPosition:position];
    
    if (self) {
        self.tag = kSTCNodeNameEnemy;

        // Get an initial waypoint
        CGPoint initialWaypoint = CGPointMake(CGFloatRandomInRange(50, 200),
                                              CGFloatRandomInRange(50, 550));
        
        // Setup the steering AI to move to that waypoint
        self.aiSteering = [[AISteering alloc] initWithEntity:self waypoint:initialWaypoint];
        
        self.healthMeterText = @"________";
        
        CCLabelTTF *healthMeterNode = [CCLabelTTF labelWithString:self.healthMeterText
                                                         fontName:kSTCArialFontName
                                                         fontSize:10];
        
        healthMeterNode.tag = kSTCNodeNameEnemyHealthMeter;
        
        healthMeterNode.color = ccGREEN;
        healthMeterNode.anchorPoint = ccp(0.5, 0);
        healthMeterNode.position = ccp(self.contentSize.width / 2, self.contentSize.height);
        
        [self addChild:healthMeterNode];
        
        self.health = 100;
        self.maxHealth = 100;
        self.score = 225;
        self.damageTakenPerShot = 5;
        
        // Load any shared assets that this entity will share with other EnemyA instances
        [STCEnemyA loadSharedAssets];
        
        [self configureCollisionBody];
        
//        [self scheduleUpdate];
    }
    
    return self;
}

#pragma mark -
#pragma mark Life Cycle

- (void)update:(CFTimeInterval)delta {
    // Check to see if we have reached the current waypoint and if so set the next one
    if (self.aiSteering.waypointReached) {
        [self.aiSteering updateWaypoint:
         ccp(CGFloatRandomInRange(100, self.parent.contentSize.width - 100),
             CGFloatRandomInRange(100, self.parent.contentSize.height - 100))];
    }
    
    // Update the steering AI which will position the entity based on randomly generated waypoints
    [self.aiSteering update:delta];
    
    // Update the health meter
    CCLabelTTF *healthMeter = (CCLabelTTF *)[self getChildByTag:kSTCNodeNameEnemyHealthMeter];

    healthMeter.string = [self.healthMeterText substringToIndex:(self.health / 100 * _healthMeterText.length)];
    healthMeter.color = ccc3(255 * 2.0 * (1.0 - self.health / 100.0), 255 * 2.0 * self.health / 100.0, 0);
}

#pragma mark -
#pragma mark Physics and Collision

- (void)configureCollisionBody {
//    b2Vec2 gravity = b2Vec2(0.0f, 0.0f);
//    b2World *world = new b2World(gravity);
//    b2World *w = b2WorldManifold
//    b2BodyDef phisicBody;
//    phisicBody.type = b2_dynamicBody;
//    phisicBody.position.Set(self.position.x / PTM_RATIO, self.position.y / PTM_RATIO);
//    
//    phisicBody.userData = (__bridge void *)self;
//    
//    world->CreateBody(&phisicBody);
    
    /*
    self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.frame.size];
    
    self.physicsBody.affectedByGravity = NO;
    
    // Set the category of the physics object that will be used for collisions
    self.physicsBody.categoryBitMask = ColliderTypeEnemy;
    
    // We want to know when a collision happens but we dont want the bodies to actually react to each other so we
    // set the collisionBitMask to 0
    self.physicsBody.collisionBitMask = 0;
    
    // Make sure we get told about these collisions
    self.physicsBody.contactTestBitMask = ColliderTypePlayer | ColliderTypeBullet;


     ballBodyDef.userData = _ball;
     _body = _world->CreateBody(&ballBodyDef);
     
     b2CircleShape circle;
     circle.m_radius = 26.0/PTM_RATIO;
     
     b2FixtureDef ballShapeDef;
     ballShapeDef.shape = &circle;
     ballShapeDef.density = 1.0f;
     ballShapeDef.friction = 0.2f;
     ballShapeDef.restitution = 0.8f;
     _body->CreateFixture(&ballShapeDef);
     
     */
}
//
//- (void)collidedWith:(b2BodyDef *)body contact:(SKPhysicsContact*)contact {
//    
//    // Get the contact point at which the bodies collided
//    CGPoint localContactPoint = [self.parent convertPoint:contact.contactPoint toNode:self];
//    
//    // Remove all the current actions. Their current effect on the enemy ship will remain unchanged so the new action
//    // will transition smoothly to the new action
//    [self removeAllActions];
//    
//    // Depending on which side the enemy was hit, rotate the ship
//    if (localContactPoint.x < 0) {
//        [self runAction:hitLeftAction];
//    } else {
//        [self runAction:hitRightAction];
//    }
//    
//    // Set up an action that will make the entity flash red with damage
//    [self runAction:damageAction];
//    
//    // If the entity is moving down the screen then make the ship slow down by moving it back a little with an action
//    if (self.aiSteering.currentDirection.y < 0)
//        [self runAction:moveBackAction];
//    
//    // Reduce the health of the enemy ship
//    self.health -= _damageTakenPerShot;
//    
//    // If the enemies health is now below 0 then add the enemyDeath emitter to the scene and reset the enemies position to off screen
//    if (self.health <= 0) {
//        
//        // Reference the main scene
//        MyScene *mainScene = (MyScene*)self.scene;
//        
//        self.health = self.maxHealth;
//        [mainScene increaseScoreBy:_score];
//        
//        // Now position the entity above the top of the screen so it can fly into view
//        self.position = CGPointMake(RandomFloatRange(100, self.scene.size.width - 100),
//                                    self.scene.size.height + 50);
//        
//    }
//    
//}

@end
