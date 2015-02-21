//
//  MyCocos2DClass.m
//  SecondTestCocos2D_v2_2
//
//  Created by Voronok Vitaliy on 2/20/15.
//  Copyright 2015 IDPGroup. All rights reserved.
//

#import "STCGameScene.h"

#import "PlayerShip.h"

#import "Constants.h"

#import "CGGeometry+ZCExtension.h"

@interface STCGameScene ()
@property (nonatomic, assign)   CGSize  winSize;
@property (nonatomic, strong)   CCLayer         *playerLaerNode;
@property (nonatomic, strong)   CCLayer         *hudLaerNode;
@property (nonatomic, strong)   CCAction        *scoreFlashAction;
@property (nonatomic, strong)   CCLabelBMFont   *playerHealthLabel;
@property (nonatomic, strong)   PlayerShip      *playerShip;
@property (nonatomic, assign)   CGPoint         deltaPoint;

- (void)setupSceneLayer;
- (void)setupUI;
- (void)setupEntitys;

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
    [scene addChild:layer];
    
    // return the scene
    return scene;
}

#pragma mark -
#pragma mark Initialization and Dealocation

- (id)init {
    self = [super init];
    
    if (self) {
        self.touchEnabled = YES;
        self.winSize = [CCDirector sharedDirector].winSize;

        [self setupSceneLayer];
        [self setupUI];
        [self setupEntitys];
        
        [self scheduleUpdate];
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
    CGPoint currentPoint = [touch locationInView:[touch view]];
    currentPoint = [[CCDirector sharedDirector] convertToGL:currentPoint];
    
    CGPoint previousPoint = [touch previousLocationInView:[touch view]];
    previousPoint = [[CCDirector sharedDirector] convertToGL:previousPoint];
    
    self.deltaPoint =  CGSubtractionVectors(currentPoint, previousPoint);
}

- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event {
    self.deltaPoint = CGPointZero;
}

- (void)ccTouchCancelled:(UITouch *)touch withEvent:(UIEvent *)event {
    self.deltaPoint = CGPointZero;
}

#pragma mark -
#pragma mark Life Cycle

- (void)update:(ccTime)delta {
    // 1
    CGPoint newPoint = CGAddVectors(self.playerShip.position, self.deltaPoint);
    // 2
    newPoint.x = clampf(newPoint.x,
                        self.playerShip.contentSize.width / 2,
                        self.winSize.width - self.playerShip.contentSize.width / 2);
    
    newPoint.y = clampf(newPoint.y,
                       self.playerShip.contentSize.height / 2,
                       self.winSize.height - self.playerShip.contentSize.height / 2 - kSTCBarHeightSize);
    // 3
    self.playerShip.position = newPoint;
    self.deltaPoint = CGPointZero;
}

#pragma mark -
#pragma mark Public

#pragma mark -
#pragma mark Private

- (void)setupSceneLayer {
    self.playerLaerNode = [CCLayer node];
    [self addChild:self.playerLaerNode];
    
    self.hudLaerNode = [CCLayer node];
    [self addChild:self.hudLaerNode];
}

- (void)setupUI {
    CGSize size = self.winSize;
    
    CGSize backgroundSize = CGSizeMake(size.width, kSTCBarHeightSize);
    ccColor4B backgroundColor = ccc4BFromccc4F(ccc4f(0.5, 0, 0.05, 1));
    
    CCLayerColor *hudBarBackground = [CCLayerColor layerWithColor:backgroundColor
                                                            width:backgroundSize.width
                                                           height:backgroundSize.height];
    
    hudBarBackground.position = ccp(0, size.height - kSTCBarHeightSize);
    
    hudBarBackground.anchorPoint = CGPointZero;
    [self.hudLaerNode addChild:hudBarBackground];
    
    CCLabelTTF *scoreLabel = [CCLabelTTF labelWithString:kSTCScoreLabel
                                                fontName:kSTCScoreFontName
                                                fontSize:kSTCBarFontSize];
    
    scoreLabel.position = ccp(size.width / 2, size.height - scoreLabel.contentSize.height / 2);
    scoreLabel.tag = kSTCNodeNameScoreLabel;
    
    [self.hudLaerNode addChild:scoreLabel];
    
    CCAction *scaleInAction = [CCScaleTo actionWithDuration:0.1 scale:1.5];
    CCAction *scaleOutAction = [CCScaleTo actionWithDuration:0.1 scale:1.0];
    CCSequence *flashAction = [CCSequence actionWithArray:@[scaleInAction, scaleOutAction]];
    CCAction *repeartAction = [CCRepeat actionWithAction:flashAction times:20];
    
    CCSequence *fulFlashAction = [CCSequence actionWithArray:@[repeartAction, scaleOutAction]];
    
    [scoreLabel runAction:fulFlashAction];
    
    self.playerHealthLabel = [CCLabelTTF labelWithString:kSTCHealthBar fontName:kSTCArialFontName fontSize:0];
    
    CCLabelTTF *playerHealthBackgroundLabel = [CCLabelTTF labelWithString:kSTCHealthBar
                                                                 fontName:kSTCArialFontName
                                                                 fontSize:kSTCHealthBarFontSize];
    
    playerHealthBackgroundLabel.tag = kSTCNodeNamePlayerHealthBackground;
    playerHealthBackgroundLabel.color = ccGRAY;
    
    CGFloat yPosition = size.height - hudBarBackground.contentSize.height - kSTCHealthBarFontSize / 3;
    CGPoint position = ccp(0, yPosition);
    playerHealthBackgroundLabel.position = position;
    playerHealthBackgroundLabel.anchorPoint = ccp(0, 0);

    [self.hudLaerNode addChild:playerHealthBackgroundLabel];
    
    
    CGFloat testHealth = 75;
    NSString * actualHealth = [kSTCHealthBar substringToIndex:
                               (testHealth / 100 * kSTCHealthBar.length)];
    
    CCLabelTTF *playerHealthLabel = [CCLabelTTF labelWithString:actualHealth
                                                       fontName:kSTCArialFontName
                                                       fontSize:kSTCHealthBarFontSize];
    
    playerHealthLabel.tag = kSTCNodeNamePlayerHealth;
    playerHealthLabel.color = ccGREEN;

    playerHealthLabel.position = position;
    playerHealthLabel.anchorPoint = ccp(0, 0);
    
    [self.hudLaerNode addChild:playerHealthLabel];
}

- (void)setupEntitys {
    self.playerShip = [[PlayerShip alloc] initWithPosition:CGPointMake(self.winSize.width / 2, 100)];
    [self.playerLaerNode addChild:self.playerShip];
}

@end
