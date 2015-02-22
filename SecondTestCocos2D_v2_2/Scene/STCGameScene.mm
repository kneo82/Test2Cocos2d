//
//  MyCocos2DClass.m
//  SecondTestCocos2D_v2_2
//
//  Created by Voronok Vitaliy on 2/20/15.
//  Copyright 2015 IDPGroup. All rights reserved.
//

#import "STCGameScene.h"

#import "STCPlayerShip.h"
#import "STCBullet.h"
#import "STCEnemyA.h"
#import "STCEnemyB.h"

#import "Constants.h"

#import "CGGeometry+ZCExtension.h"

@interface STCGameScene ()
@property (nonatomic, strong)   CCAction        *scoreFlashAction;
@property (nonatomic, strong)   CCLabelBMFont   *playerHealthLabel;
@property (nonatomic, strong)   STCPlayerShip   *playerShip;
@property (nonatomic, strong)   CCAction        *gameOverPulse;
@property (nonatomic, strong)   CCLabelTTF      *gameOverLabel;
@property (nonatomic, strong)   CCLabelTTF      *tapScreenLabel;

@property (nonatomic, assign)   CGSize          winSize;
@property (nonatomic, assign)   CGPoint         deltaPoint;
@property (nonatomic, assign)   CGFloat         bulletInterval;
@property (nonatomic, assign)   NSTimeInterval  dt;
@property (nonatomic, assign)   CGFloat         score;
@property (nonatomic, assign)   NSInteger       gameState;

- (void)setupSceneLayer;
- (void)setupUI;
- (void)setupEntitys;
- (void)increaseScoreBy:(float)increment;
- (void)restartGame;

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
    if (self.gameState == GameOver) {
        [self restartGame];
    }
    
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
    CGPoint newPoint = CGAddVectors(self.playerShip.position, self.deltaPoint);

    newPoint.x = clampf(newPoint.x,
                        self.playerShip.contentSize.width / 2,
                        self.winSize.width - self.playerShip.contentSize.width / 2);
    
    newPoint.y = clampf(newPoint.y,
                       self.playerShip.contentSize.height / 2,
                       self.winSize.height - self.playerShip.contentSize.height / 2 - kSTCBarHeightSize);

    self.playerShip.position = newPoint;
    self.deltaPoint = CGPointZero;
    
    self.dt = delta;
    
    switch (self.gameState) {
        case GameRunning: {
            self.bulletInterval += delta;
            
            if (self.bulletInterval > 0.15) {
                self.bulletInterval = 0;
                
                CGPoint bulletPosition = ccp(self.playerShip.position.x,
                                             self.playerShip.position.y + self.playerShip.contentSize.height / 2);
                
                STCBullet *bullet = [[STCBullet alloc] initWithPosition:bulletPosition];
                bullet.color = ccRED;
                
                [self.bulletLayerNode addChild:bullet];
                
                CCMoveBy *moveAction = [CCMoveBy actionWithDuration:1 position:ccp(0, self.winSize.height)];
                CCCallBlock *removeAction = [CCCallBlock actionWithBlock:^{
                    [bullet removeFromParent];
                }];
                
                CCSequence *sequence = [CCSequence actionWithArray:@[moveAction, removeAction]];
                [bullet runAction:sequence];
            }

            // Update player
            [self.playerShip update:delta];
            
            // Update all enemies
            for (CCNode *node in self.enemyLayerNode.children) {
                if (node.tag == kSTCNodeNameEnemy) {
                    [(STCEntity *)node update:delta];
                }
            }
            
            // Update the healthbar color and length based on the...urm...players health :)
            self.playerHealthLabel.string = [kSTCHealthBar substringToIndex:(self.playerShip.health / 100 * kSTCHealthBar.length)];
            self.playerHealthLabel.color = ccc3(255 * 2.0f * (1.0f - self.playerShip.health / 100.0f),
                                                255 * 2.0f * self.playerShip.health / 100.0f,
                                                0);
            
            // If the players health has dropped to <= 0 then set the game state to game over
            if (self.playerShip.health <= 0) {
                self.gameState = GameOver;
            }
        }
            
            break;
        case GameOver: {
            // If the game over message has not been added to the scene yet then add it
            
            if (!self.gameOverLabel.parent) {
//                 Remove the bullets, enemites and player from the scene as the game is over
                [self.bulletLayerNode removeAllChildren];
                [self.enemyLayerNode removeAllChildren];
                
                [self.playerShip removeFromParent];
                [self.hudLayerNode addChild:self.gameOverLabel];
                [self.hudLayerNode addChild:self.tapScreenLabel];
                
                [self.tapScreenLabel runAction:self.gameOverPulse];
            }
            
            // Randonly set the color of the game over label
            ccColor3B color = ccc3(arc4random_uniform(255), arc4random_uniform(255), arc4random_uniform(255));
            
            self.gameOverLabel.color = color;
        }
    }
}

#pragma mark -
#pragma mark Public

#pragma mark -
#pragma mark Private

- (void)setupSceneLayer {
    self.playerLayerNode = [CCLayer node];
    [self addChild:self.playerLayerNode];
    
    self.hudLayerNode = [CCLayer node];
    [self addChild:self.hudLayerNode];

    self.bulletLayerNode = [CCLayer node];
    [self addChild:self.bulletLayerNode];
    
    self.enemyLayerNode = [CCLayer node];
    [self addChild:self.enemyLayerNode];
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
    [self.hudLayerNode addChild:hudBarBackground];
    
    CCLabelTTF *scoreLabel = [CCLabelTTF labelWithString:kSTCScoreLabel
                                                fontName:kSTCScoreFontName
                                                fontSize:kSTCBarFontSize];
    
    scoreLabel.position = ccp(size.width / 2, size.height - scoreLabel.contentSize.height / 2);
    scoreLabel.tag = kSTCNodeNameScoreLabel;
    
    [self.hudLayerNode addChild:scoreLabel];
    
    CCAction *scaleInAction = [CCScaleTo actionWithDuration:0.1 scale:0.1];
    CCAction *scaleOutAction = [CCScaleTo actionWithDuration:0.1 scale:0.1];
    CCSequence *flashAction = [CCSequence actionWithArray:@[scaleInAction, scaleOutAction]];
    CCAction *repeartAction = [CCRepeat actionWithAction:flashAction times:10];
    
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

    [self.hudLayerNode addChild:playerHealthBackgroundLabel];
    
    
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
    
    [self.hudLayerNode addChild:playerHealthLabel];
    
    CCLabelTTF *gameOverLabel = [CCLabelTTF labelWithString:@"GAME OVER"
                                                   fontName:kSTCScoreFontName
                                                   fontSize:40.0f];
    
    gameOverLabel.tag = kSTCNodeNameGameOver;
    gameOverLabel.color = ccWHITE;
    gameOverLabel.position = ccp(self.winSize.width / 2, self.winSize.height / 2);
    self.gameOverLabel = gameOverLabel;
    
    CCLabelTTF *tapScreenLabel = [CCLabelTTF labelWithString:@"Tap Screen To Restart"
                                                    fontName:kSTCScoreFontName
                                                    fontSize:20.0f];
    
    tapScreenLabel.tag = kSTCNodeNameTapScrean;
    tapScreenLabel.color = ccWHITE;
    tapScreenLabel.position = ccp(self.winSize.width / 2, self.winSize.height / 2 - 100);
    self.tapScreenLabel = tapScreenLabel;

    CCAction *fadeOutAction = [CCFadeOut actionWithDuration:1.0f];
    CCAction *fadeInAction = [CCFadeIn actionWithDuration:1.0f];
    CCSequence *sequence = [CCSequence actionWithArray:@[fadeOutAction, fadeInAction]];
    CCAction *repeatAction = [CCRepeatForever actionWithAction:sequence];
    
    self.gameOverPulse = repeatAction;
}

- (void)setupEntitys {
    self.playerShip = [[STCPlayerShip alloc] initWithPosition:CGPointMake(self.winSize.width / 2, 100)];
    [self.playerLayerNode addChild:self.playerShip];
    
    for (NSUInteger index = 0; index < 5; index++) {
        STCEnemyA *enemy = [[STCEnemyA alloc] initWithPosition:ccp(CGFloatRandomInRange(50, self.winSize.width - 50),
                                                                                        self.winSize.height + 50)];
        
        [self.enemyLayerNode addChild:enemy];
    }
    
    for (NSUInteger index = 0; index < 4; index++) {
        STCEnemyB *enemy = [[STCEnemyB alloc] initWithPosition:ccp(CGFloatRandomInRange(50, self.winSize.width - 50),
                                                                                        self.winSize.height + 50)];
        
        [self.enemyLayerNode addChild:enemy];
    }
}

- (void)increaseScoreBy:(float)increment {
    self.score += increment;
    CCLabelTTF *scoreLabel = (CCLabelTTF *)[self.hudLayerNode getChildByTag:kSTCNodeNameScoreLabel];
    scoreLabel.string = [NSString stringWithFormat:@"Score: %1.0f", self.score];
    [scoreLabel stopAllActions];
//    [scoreLabel removeAllActions];
    [scoreLabel runAction:self.scoreFlashAction];
}

- (void)restartGame {
    // Reset the state of the game
    self.gameState = GameRunning;
    
    // Set up the entities again and the score
    [self setupEntitys];
    self.score = 0;
    
    // Reset the score and the players health
    CCLabelTTF *scoreLabel = (CCLabelTTF *)[self.hudLayerNode getChildByTag:kSTCNodeNameScoreLabel];
    scoreLabel.string = @"Score: 0";
    self.playerShip.health = 100;
    self.playerShip.position = CGPointMake(self.winSize.width / 2, 100);
    
    // Remove the game over HUD labels
    [self.gameOverLabel removeFromParent];
    [self.tapScreenLabel stopAllActions];
    [self.tapScreenLabel removeFromParent];
}

#pragma mark -
#pragma mark Physics Contact Delegate

//- (void)didBeginContact:(SKPhysicsContact *)contact
//{
//    
//    // Grab the first body that has been involved in the collision and call it's collidedWith method
//    // allowing it to react to the collision...
//    SKNode *node = contact.bodyA.node;
//    if ([node isKindOfClass:[Entity class]]) {
//        [(Entity*)node collidedWith:contact.bodyB contact:contact];
//    }
//    
//    // ... and do the same for the second body
//    node = contact.bodyB.node;
//    if ([node isKindOfClass:[Entity class]]) {
//        [(Entity*)node collidedWith:contact.bodyA contact:contact];
//    }
//    
//}

@end