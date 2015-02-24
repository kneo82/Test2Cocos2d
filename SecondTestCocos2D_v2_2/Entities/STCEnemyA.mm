//
//  STCEnemyA.m
//  SecondTestCocos2D_v2_2
//
//  Created by Admin on 22/02/15.
//  Copyright (c) 2015 IDPGroup. All rights reserved.
//

#import "STCEnemyA.h"
#import "STCGameScene.h"

#import "Box2D.h"
#import "Constants.h"
#import "CGGeometry+ZCExtension.h"

@interface STCEnemyA ()

- (void)configureCollisionBody;
- (void)changeScore;

@end

@implementation STCEnemyA

#pragma mark -
#pragma mark Class Methods

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

#pragma mark -
#pragma mark Initialization and Dealocation

- (instancetype)initWithPosition:(CGPoint)position physicsWorld:(b2World *)world {
    self = [super initWithPosition:position physicsWorld:world];
    
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
                                                         fontSize:15];
        
        healthMeterNode.tag = kSTCNodeNameEnemyHealthMeter;
        
        healthMeterNode.color = ccGREEN;
        healthMeterNode.anchorPoint = ccp(0.5, 0);
        healthMeterNode.position = ccp(self.contentSize.width / 2, self.contentSize.height);
        
        [self addChild:healthMeterNode];
        
        self.health = 100;
        self.maxHealth = 100;
        self.score = 225;
        self.damageTakenPerShot = 5;
        
        [self configureCollisionBody];
        [self schedule:@selector(tick:)];
    }
    
    return self;
}

#pragma mark -
#pragma mark Accessors 

- (CCAction *)damageAction {
    return [CCSequence actionWithArray:@[
                                         [CCTintTo actionWithDuration:0 red:255 green:0 blue:0],
                                         [CCTintTo actionWithDuration:1 red:255 green:255 blue:255]]
            ];

}

- (CCAction *)hitLeftAction {
    return [CCSequence actionWithArray:@[
                                         [CCRotateTo actionWithDuration:0.25 angle:15],
                                         [CCRotateTo actionWithDuration:0.5 angle:0]
                                         ]];
}

- (CCAction *)hitRightAction {
    return  [CCSequence actionWithArray:@[
                                          [CCRotateTo actionWithDuration:0.25 angle:(-15)],
                                          [CCRotateTo actionWithDuration:0.5 angle:0]
                                          ]];
}

- (CCAction *)moveBackAction {
    return [CCSequence actionWithArray:@[
                                         [CCMoveBy actionWithDuration:0.25 position:ccp(0, 20)]
                                         ]];
}

- (CCAction *)scoreLabelAction {
    CCScaleTo *scaleOffAction = [CCScaleTo actionWithDuration:0 scale:0];
    CCFadeTo *fadeOffAction = [CCFadeOut actionWithDuration:0];
    
    CCScaleTo *scaleOnAction = [CCScaleTo actionWithDuration:0.5 scale:1];
    CCFadeTo *fadeOnAction = [CCFadeTo actionWithDuration:0.5 opacity:255];
    
    CCMoveBy *moveAction = [CCMoveBy actionWithDuration:0.5 position:ccp(0, 20)];
    
    CCSpawn *offLableAction = [CCSpawn actionWithArray:@[scaleOffAction, fadeOffAction]];
    CCSpawn *onLableAction = [CCSpawn actionWithArray:@[scaleOnAction, fadeOnAction, moveAction]];
    
    CCSequence *showAction = [CCSequence actionWithArray:@[offLableAction, onLableAction]];
    
    CCMoveBy *moveDisappearsAction = [CCMoveBy actionWithDuration:1 position:ccp(0, 40)];
    CCFadeOut *fadeOurDisappearsAction  = [CCFadeOut actionWithDuration:1];
    
    CCSpawn *disappearsAction = [CCSpawn actionWithArray:@[moveDisappearsAction, fadeOurDisappearsAction]];
    
    CCAction *labelAction = [CCSequence actionWithArray:@[showAction, disappearsAction]];
    
    return labelAction;
}

- (CCLabelTTF *)scoreLable {
    NSString *scoreText = [NSString stringWithFormat:@"%lu", (unsigned long)self.score];
    CCLabelTTF *scorelabel = [CCLabelTTF labelWithString:scoreText fontName:kSTCScoreFontName fontSize:25];
    scorelabel.color = ccc3(125, 255, 255);
    scorelabel.position = self.position;
    scorelabel.opacity = 0;
    scorelabel.scale = 0;
    
    [scorelabel runAction:self.scoreLabelAction];
    
    return scorelabel;
}

#pragma mark -
#pragma mark Life Cycle

- (void)update:(ccTime)delta  {
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
    healthMeter.color = ccc3(255 * (1.0 - self.health / 100.0), 255 * self.health / 100.0, 0);
}

#pragma mark -
#pragma mark Physics and Collision

- (void)tick:(ccTime) dt {
    self.physicsWorld->Step(dt, 10, 10);
    
    CGPoint position = self.position;
    CGPoint box2dPosition = ccp(position.x / PTM_RATIO, position.y / PTM_RATIO);
    self.physicsBody->SetTransform(b2Vec2(box2dPosition.x,box2dPosition.y), self.physicsBody->GetAngle());
}

- (void)configureCollisionBody {
    b2BodyDef physicsBody;
    physicsBody.type = b2_dynamicBody;
    physicsBody.position.Set(self.position.x / PTM_RATIO, self.position.y / PTM_RATIO);
    
    physicsBody.userData = (__bridge void *)self;
    
    self.physicsBody = self.physicsWorld->CreateBody(&physicsBody);

    b2PolygonShape spriteShape;
    spriteShape.SetAsBox(self.contentSize.width/PTM_RATIO/2, self.contentSize.height/PTM_RATIO/2);
    


    b2FixtureDef spriteShapeDef;
    spriteShapeDef.shape = &spriteShape;
    spriteShapeDef.density = .00;
    spriteShapeDef.friction = .0f;
    spriteShapeDef.restitution = .0f;

    self.physicsBody->CreateFixture(&spriteShapeDef);
}

- (void)collidedWith:(STCEntity *)entity contact:(CGPoint)contactPosition {
    if (entity.tag == kSTCNodeNameEnemy || entity.tag == kSTCNodeNameShipSprite) {
        return;
    }
    
    CGPoint localContactPoint = [self convertToNodeSpace:contactPosition];

    [self stopAllActions];

    if (localContactPoint.x < 0) {
        [self runAction:self.hitLeftAction];
    } else {
        [self runAction:self.hitRightAction];
    }
    
    [self runAction:self.damageAction];
    
    if (self.aiSteering.currentDirection.y < 0) {
        [self runAction:self.moveBackAction];
    }

    self.health -= self.damageTakenPerShot;

    if (self.health <= 0) {
        [self.parent addChild:self.scoreLable];
        
        self.health = self.maxHealth;
        [self changeScore];

        self.position = ccp(CGFloatRandomInRange(100, self.parent.contentSize.width - 100),
                                    self.parent.contentSize.height + 50);
        
    }

}

- (void)changeScore {
    if ([self.delegate respondsToSelector:@selector(increaseScoreBy:)]) {
        [self.delegate increaseScoreBy:self.score];
    }
}

@end
