//
//  STCBullet.m
//  SecondTestCocos2D_v2_2
//
//  Created by Admin on 22/02/15.
//  Copyright (c) 2015 IDPGroup. All rights reserved.
//

#import "STCBullet.h"

#import "Constants.h"

@implementation STCBullet

#pragma mark -
#pragma mark Class Methods

+ (CCSprite *)generateSprite {
    static CCSprite *sprite = nil;
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        CCLabelTTF *bullet = [CCLabelTTF labelWithString:@"✶" fontName:kSTCArialFontName fontSize:10];
        bullet.tag = kSTCNodeNameBulletSymbol;

        sprite = bullet;
    });
    
    return sprite;
}

#pragma mark -
#pragma mark Initialization and Dealocation

- (instancetype)initWithPosition:(CGPoint)position physicsWorld:(b2World *)world {
    self = [super initWithPosition:position physicsWorld:world];
    
    if (self) {
        self.tag = kSTCNodeNameBullet;
        self.color = ccRED;
        
        [self configureCollisionBody];
        [self schedule:@selector(tick:)];
    }
    
    return self;
}

#pragma mark -
#pragma mark Life Cycle

//- (void)update:(CFTimeInterval)delta {
//
//}

#pragma mark -
#pragma mark Private

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
    
    b2CircleShape circle;
    circle.m_radius = 5.0/PTM_RATIO;
    
    b2FixtureDef ballShapeDef;
    ballShapeDef.shape = &circle;
    ballShapeDef.density = 1.0f;
    ballShapeDef.friction = 0.2f;
    ballShapeDef.restitution = 0.8f;
    self.physicsBody->CreateFixture(&ballShapeDef);
}

@end
