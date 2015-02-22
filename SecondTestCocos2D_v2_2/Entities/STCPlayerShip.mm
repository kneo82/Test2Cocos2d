//
//  PlayerShip.m
//  SecondTestCocos2D_v2_2
//
//  Created by Admin on 21/02/15.
//  Copyright (c) 2015 IDPGroup. All rights reserved.
//

#import "STCPlayerShip.h"

#import "Constants.h"

@implementation STCPlayerShip

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

- (instancetype)initWithPosition:(CGPoint)position physicsWorld:(b2World *)world {
    self = [super initWithPosition:position physicsWorld:world];
    
    if (self) {
        self.tag = kSTCNodeNameShipSprite;
        self.health = 100;
        
        [self configureCollisionBody];
        [self schedule:@selector(tick:)];
    }
    
    return self;
}

#pragma mark -
#pragma mark Accessors


#pragma mark -
#pragma mark Life Cycle

- (void)tick:(ccTime) dt {
    CGPoint position = self.position;
    CGPoint box2dPosition = ccp(position.x / PTM_RATIO, position.y / PTM_RATIO);
    self.physicsBody->SetTransform(b2Vec2(box2dPosition.x,box2dPosition.y), self.physicsBody->GetAngle());
}


- (void)configureCollisionBody {
    //    self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:[self childNodeWithName:@"shipSprite"].frame.size];
    b2BodyDef physicsBody;
    physicsBody.type = b2_dynamicBody;
    physicsBody.position.Set(self.position.x / PTM_RATIO, self.position.y / PTM_RATIO);
    
    physicsBody.userData = (__bridge void *)self;

    self.physicsBody = self.physicsWorld->CreateBody(&physicsBody);
    
    b2CircleShape circle;
    circle.m_radius = 15.0/PTM_RATIO;
    
    b2FixtureDef ballShapeDef;
    ballShapeDef.shape = &circle;
    ballShapeDef.density = 1.0f;
    ballShapeDef.friction = 0.2f;
    ballShapeDef.restitution = 0.8f;
    self.physicsBody->CreateFixture(&ballShapeDef);
    
//    self.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:15];
//    
//    self.physicsBody.affectedByGravity = NO;
//    
    // Set the category of the physics object that will be used for collisions
//    self.physicsBody.categoryBitMask = ColliderTypePlayer;
//    
    // We want to know when a collision happens but we dont want the bodies to actually react to each other so we
    // set the collisionBitMask to 0
//    self.physicsBody.collisionBitMask = 0;
//    
    // Make sure we get told about these collisions
//    self.physicsBody.contactTestBitMask = ColliderTypeEnemy;
}

//- (void)collidedWith:(SKPhysicsBody *)body contact:(SKPhysicsContact*)contact
//{
//    self.health -= 5;
//    if (self.health < 0)
//        self.health = 0;
//}

@end
