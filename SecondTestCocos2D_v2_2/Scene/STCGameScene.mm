//
//  MyCocos2DClass.m
//  SecondTestCocos2D_v2_2
//
//  Created by Voronok Vitaliy on 2/20/15.
//  Copyright 2015 IDPGroup. All rights reserved.
//

#import "STCGameScene.h"
#import "Box2D.h"
#import "GLES-Render.h"

#define isIPad UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad
#define PTM_RATIO (isIPad ? 64 : 32)

@interface STCGameScene ()
@property (nonatomic, assign)   CGSize  winSize;

@property (nonatomic, strong)   CCSprite        *square;
@property (nonatomic, strong)   CCSprite        *circle;
@property (nonatomic, strong)   CCSprite        *triangle;

@property (nonatomic, assign)   b2World         *physicsWorld;
@property (nonatomic, assign)   GLESDebugDraw   *debugDraw;

- (void)setupSprites;
- (void)setupPhysics;
- (void)bodyWithCircleForSprite:(CCSprite *)sprite;

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

- (void)dealloc {
    delete self.physicsWorld;
}

- (id)init {
    self = [super init];
    
    if (self) {
        self.winSize = [CCDirector sharedDirector].winSize;
        
        NSLog(@"---- %@", NSStringFromCGSize(self.winSize));
        self.touchEnabled = YES;
        
        CCLayerColor *layerColor = [CCLayerColor layerWithColor:ccc4(50, 45, 30, 255)];
        [self addChild:layerColor z:-10];
        
        [self setupPhysics];

        [self setupSprites];
        
        [self scheduleUpdate];
        [self schedule:@selector(tick:)];
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
#pragma mark Life Cycle

- (void)update:(ccTime)delta {

}

//#if DEBUG

- (void)draw {
    [super draw];
    ccGLEnableVertexAttribs(kCCVertexAttribFlag_Position);
    kmGLPushMatrix();
    self.physicsWorld  -> DrawDebugData();
    kmGLPopMatrix();
}

//#endif

#pragma mark -
#pragma mark Public

#pragma mark -
#pragma mark Private

- (void)tick:(ccTime) dt {
    self.physicsWorld->Step(dt, 10, 10);
    
    b2Body *body = self.physicsWorld->GetBodyList();

    while (body) {
        CCSprite *sprite = (__bridge CCSprite *)body->GetUserData();
        
        b2Vec2 position = body->GetPosition();
        
        sprite.position = ccp(position.x * PTM_RATIO, position.y * PTM_RATIO);
        sprite.rotation = CC_RADIANS_TO_DEGREES(body->GetAngle());
        
        body = body->GetNext();
    }
    
    
//    b2Body *physicsBody = (b2Body *)self.circle.userData;
//    b2Vec2 position = physicsBody->GetPosition();
//    
//    self.circle.position = ccp(position.x * PTM_RATIO, position.y * PTM_RATIO);
//    self.circle.rotation = CC_RADIANS_TO_DEGREES(self.physicsBody->GetAngle());
    
//    CGPoint position = self.position;
//    CGPoint box2dPosition = ccp(position.x / PTM_RATIO, position.y / PTM_RATIO);
//    self.physicsBody->SetTransform(b2Vec2(box2dPosition.x,box2dPosition.y), self.physicsBody->GetAngle());
}

- (void)setupPhysics {
    b2Vec2 gravity = b2Vec2(0.0f, -1.0f);
    self.physicsWorld = new b2World(gravity);
    self.physicsWorld->DrawDebugData();
    
    _debugDraw = new GLESDebugDraw(PTM_RATIO);
    self.physicsWorld->SetDebugDraw(_debugDraw);
    uint32 flags = 0;
    flags += b2Draw::e_shapeBit;
    flags += b2Draw::e_jointBit;
    flags += b2Draw::e_aabbBit;
    flags += b2Draw::e_pairBit;
    flags += b2Draw::e_centerOfMassBit;
    _debugDraw->SetFlags(flags);
}

- (void)setupSprites {
    CCSprite *square = [CCSprite spriteWithFile:@"square@2x.png"];
    square.position = ccp(self.winSize.width * 0.25, self.winSize.height * 0.50);
    self.square = square;
    
    [self addChild:square];
    
    CCSprite *circle = [CCSprite spriteWithFile:@"circle.png"];
    circle.position = ccp(self.winSize.width * 0.5, self.winSize.height * 0.50);
    self.circle = circle;
    
    [self addChild:circle];
    [self bodyWithCircleForSprite:circle];
    
    CCSprite *triangle = [CCSprite spriteWithFile:@"triangle.png"];
    triangle.position = ccp(self.winSize.width * 0.75, self.winSize.height * 0.50);
    self.triangle = triangle;
    
    [self addChild:triangle];
}

- (void)bodyWithCircleForSprite:(CCSprite *)sprite {
    b2BodyDef physicsBodyDef;
    
    physicsBodyDef.type = b2_dynamicBody;
    physicsBodyDef.position.Set(sprite.position.x / PTM_RATIO, sprite.position.y / PTM_RATIO);
    
    physicsBodyDef.userData = (__bridge void *)sprite;
    
    b2Body *physicsBody = self.physicsWorld->CreateBody(&physicsBodyDef);
    
    b2CircleShape circleShape;
    CGFloat radiusPhysic = (sprite.contentSize.width / 2) / PTM_RATIO;
    circleShape.m_radius = radiusPhysic;
    
    b2FixtureDef ballShapeDef;
    ballShapeDef.shape = &circleShape;
    ballShapeDef.density = 01.0f;
    ballShapeDef.friction = 0.2f;
    ballShapeDef.restitution = 0.8f;
    physicsBody->CreateFixture(&ballShapeDef);
    
//    physicsBody->SetUserData((__bridge void *)sprite);
}

@end
