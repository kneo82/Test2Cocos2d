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

typedef NS_ENUM(NSInteger, SpriteTagName) {
    kSTCSpriteTagSandName = 1,
};

@interface STCGameScene ()
@property (nonatomic, assign)   CGSize  winSize;

@property (nonatomic, strong)   CCSprite        *square;
@property (nonatomic, strong)   CCSprite        *circle;
@property (nonatomic, strong)   CCSprite        *triangle;
@property (nonatomic, strong)   CCSprite        *octagon;

@property (nonatomic, assign)   b2World         *physicsWorld;
@property (nonatomic, assign)   GLESDebugDraw   *debugDraw;

- (void)setupSprites;
- (void)setupPhysics;
- (void)bodyWithCircleForSprite:(CCSprite *)sprite;
- (void)bodyWithRectangleForSprite:(CCSprite *)sprite;
- (void)bodyWithTriangleForSprite:(CCSprite *)sprite;
- (void)bodyWithPathPoints:(NSArray *)pathPoints forSprite:(CCSprite *)sprite;

- (void)spawnSand;

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
        
        CCAction *repeatAction = [CCRepeat actionWithAction:[CCCallFunc actionWithTarget:self
                                                                                selector:@selector(spawnSand)]
                                                      times:100];
        
        [self runAction:repeatAction];
        
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
    
    for (CCSprite *node in self.children) {
        if (kSTCSpriteTagSandName == node.tag) {
            b2Body *body = (b2Body *)node.userData;
            
            b2Vec2 vector = b2Vec2(0, arc4random_uniform(50));
            body -> ApplyLinearImpulse(vector, body->GetPosition(), true);// ->ApplyForceToCenter(vector, true);
        }
    }
    
    CCMoveBy *shake = [CCMoveBy actionWithDuration:0.05 position:ccp(0, 10)];
    CCRepeat *repeart = [CCRepeat actionWithAction:[CCSequence actionWithArray:@[shake, shake.reverse]] times:5];
    
    [self runAction:repeart];
    
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
        CGPoint spritePosition = ccp(position.x * PTM_RATIO, position.y * PTM_RATIO);

        if (spritePosition.x < -self.winSize.width
            || spritePosition.y < -self.winSize.height
            || spritePosition.x > 2 * self.winSize.width
            || spritePosition.y > 2 * self.winSize.height)
        {
            b2Body *nextBody = body->GetNext();

            self.physicsWorld->DestroyBody(body);
            [sprite removeFromParent];
            body = nextBody;
        } else {
            sprite.position = spritePosition;
            sprite.rotation = -1 * CC_RADIANS_TO_DEGREES(body->GetAngle());
            body = body->GetNext();
        }
    }
}

- (void)setupPhysics {
    b2Vec2 gravity = b2Vec2(0.0f, -1.0f);
    self.physicsWorld = new b2World(gravity);
    self.physicsWorld->DrawDebugData();
    
    //************** Physic border around screan *******************//
    
    // for the screenBorder body we'll need these values
    CGSize screenSize = self.winSize;
    float widthInMeters = screenSize.width / PTM_RATIO;
    float heightInMeters = screenSize.height / PTM_RATIO;
    b2Vec2 lowerLeftCorner = b2Vec2(0, 0);
    b2Vec2 lowerRightCorner = b2Vec2(widthInMeters, 0);
    b2Vec2 upperLeftCorner = b2Vec2(0, heightInMeters);
    b2Vec2 upperRightCorner = b2Vec2(widthInMeters, heightInMeters);
    
    // static container body, with the collisions at screen borders
    b2BodyDef screenBorderDef;
    screenBorderDef.position.Set(0, 0);
    b2Body* screenBorderBody = self.physicsWorld->CreateBody(&screenBorderDef);
    b2EdgeShape screenBorderShape;
    
    // Create fixtures for the four borders (the border shape is re-used)
    screenBorderShape.Set(lowerLeftCorner, lowerRightCorner);
    screenBorderBody->CreateFixture(&screenBorderShape, 0);
    screenBorderShape.Set(lowerRightCorner, upperRightCorner);
    screenBorderBody->CreateFixture(&screenBorderShape, 0);
    screenBorderShape.Set(upperRightCorner, upperLeftCorner);
    screenBorderBody->CreateFixture(&screenBorderShape, 0);
    screenBorderShape.Set(upperLeftCorner, lowerLeftCorner);
    screenBorderBody->CreateFixture(&screenBorderShape, 0);
    
    //************************************************************//
    
    _debugDraw = new GLESDebugDraw(PTM_RATIO);
    self.physicsWorld->SetDebugDraw(_debugDraw);
    uint32 flags = 0;
    flags += b2Draw::e_shapeBit;
//    flags += b2Draw::e_jointBit;
//    flags += b2Draw::e_aabbBit;
//    flags += b2Draw::e_pairBit;
//    flags += b2Draw::e_centerOfMassBit;
    _debugDraw->SetFlags(flags);
}

- (void)spawnSand {
    CCSprite *sand = [CCSprite spriteWithFile:@"sand.png"];
    
    sand.position = ccp((float)(arc4random()%(int)self.winSize.width),
                        self.winSize.height - sand.contentSize.height);
    
    [self bodyWithCircleForSprite:sand];
    sand.tag = kSTCSpriteTagSandName;
    
    [self addChild:sand];
}

- (void)setupSprites {
    CCSprite *square = [CCSprite spriteWithFile:@"square.png"];
    square.position = ccp(self.winSize.width * 0.25, self.winSize.height * 0.50);
    self.square = square;
    
    [self addChild:square];
    [self bodyWithRectangleForSprite:square];
    
    CCSprite *circle = [CCSprite spriteWithFile:@"circle.png"];
    circle.position = ccp(self.winSize.width * 0.5, self.winSize.height * 0.50);
    self.circle = circle;
    
    [self addChild:circle];
    [self bodyWithCircleForSprite:circle];
    
    CCSprite *triangle = [CCSprite spriteWithFile:@"triangle.png"];
    triangle.position = ccp(self.winSize.width * 0.75, self.winSize.height * 0.50);
    self.triangle = triangle;
    
    [self addChild:triangle];
    
    [self bodyWithTriangleForSprite:triangle];
    
    CCSprite *octagon = [CCSprite spriteWithFile:@"octagon.png"];
    octagon.position = ccp(self.winSize.width * 0.5, self.winSize.height * 0.75);
    self.octagon = octagon;
    
    [self addChild:octagon];
    
    CGFloat width = octagon.contentSize.width;
    CGFloat height = octagon.contentSize.height;
    
    NSArray *pathPoints = @[[NSValue valueWithCGPoint:ccp(-width / 4 / width, -height / 2 / height)],
                            [NSValue valueWithCGPoint:ccp(-width / 2 / width, -height / 4 / height)],
                            [NSValue valueWithCGPoint:ccp(-width / 2 / width, height / 4 / height)],
                            [NSValue valueWithCGPoint:ccp(-width / 4 / width, height / 2 / height)],
                            [NSValue valueWithCGPoint:ccp(width / 4 / width, height / 2 / height)],
                            [NSValue valueWithCGPoint:ccp(width / 2 / width, height / 4 / height)],
                            [NSValue valueWithCGPoint:ccp(width / 2 / width, -height / 4 / height)],
                            [NSValue valueWithCGPoint:ccp(width / 4 / width, -height / 2 / height)]];
    
    [self bodyWithPathPoints:pathPoints forSprite:octagon];
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
    ballShapeDef.restitution = 1;
    ballShapeDef.density = 20.0f;
    ballShapeDef.friction = 1.2f;
    ballShapeDef.restitution = 0.8f;
    
    physicsBody->CreateFixture(&ballShapeDef);
    
    sprite.userData = physicsBody;
}

- (void)bodyWithRectangleForSprite:(CCSprite *)sprite {
    b2BodyDef physicsBodyDef;
    
    physicsBodyDef.type = b2_dynamicBody;
    physicsBodyDef.position.Set(sprite.position.x / PTM_RATIO, sprite.position.y / PTM_RATIO);
    
    physicsBodyDef.userData = (__bridge void *)sprite;
    
    b2Body *physicsBody = self.physicsWorld->CreateBody(&physicsBodyDef);
    
    b2PolygonShape spriteShape;
    spriteShape.SetAsBox(sprite.contentSize.width / PTM_RATIO / 2, sprite.contentSize.height / PTM_RATIO / 2);

    b2FixtureDef spriteShapeDef;
    spriteShapeDef.shape = &spriteShape;
    spriteShapeDef.density = 10.00;
    spriteShapeDef.friction = .2f;
    spriteShapeDef.restitution = .8f;
    
    physicsBody->CreateFixture(&spriteShapeDef);
}

- (void)bodyWithTriangleForSprite:(CCSprite *)sprite {
    NSArray *pathPoints = @[[NSValue valueWithCGPoint:ccp(-0.5f, -0.5f)],
                            [NSValue valueWithCGPoint:ccp(0.0f, 0.5f)],
                            [NSValue valueWithCGPoint:ccp(0.5f, -0.5f)]];
    
    [self bodyWithPathPoints:pathPoints forSprite:sprite];
}

- (void)bodyWithPathPoints:(NSArray *)pathPoints forSprite:(CCSprite *)sprite {
    b2BodyDef physicsBodyDef;
    
    physicsBodyDef.type = b2_dynamicBody;
    physicsBodyDef.position.Set(sprite.position.x / PTM_RATIO, sprite.position.y / PTM_RATIO);
    
    physicsBodyDef.userData = (__bridge void *)sprite;
    
    b2Body *physicsBody = self.physicsWorld->CreateBody(&physicsBodyDef);
    
    b2PolygonShape spriteShape;
    int32 count = pathPoints.count;

    b2Vec2 *vertices = new b2Vec2[count];
    
    NSUInteger index = 0;
    for (NSValue *item in pathPoints) {
        CGPoint point = [item CGPointValue];
        vertices[index++].Set(point.x, point.y);
    }
    
    spriteShape.Set(vertices, count);
    
    b2FixtureDef spriteShapeDef;
    spriteShapeDef.shape = &spriteShape;
    spriteShapeDef.density = 10.00;
    spriteShapeDef.friction = .2f;
    spriteShapeDef.restitution = .8f;
    
    physicsBody->CreateFixture(&spriteShapeDef);
    
    delete []vertices;
}

@end
