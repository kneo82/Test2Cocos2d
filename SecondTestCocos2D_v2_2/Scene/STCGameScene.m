//
//  MyCocos2DClass.m
//  SecondTestCocos2D_v2_2
//
//  Created by Voronok Vitaliy on 2/20/15.
//  Copyright 2015 IDPGroup. All rights reserved.
//

#import "STCGameScene.h"

typedef NS_ENUM(NSUInteger, STCNodesName) {
    kSTCNodeNameScoreLabel              = 100,
    kSTCNodeNamePlayerHealthBackground  = 120,
    kSTCNodeNamePlayerHealth            = 125,
};

static const NSUInteger kSTCBarHeightSize       = 45;
static const NSUInteger kSTCBarFontSize         = 20;
static const NSUInteger kSTCHealthBarFontSize   = 14;
static NSString * const kSTCScoreFontName       = @"Thirteen Pixel Fonts";
static NSString * const kSTCHealthBarFontName   = @"Arial";
static NSString * const kSTCScoreLabel          = @"Score: 0";
static NSString * const kSTCHealthBar           = @"=======================================";
;

@interface STCGameScene ()
@property (nonatomic, assign)   CGSize  winSize;
@property (nonatomic, strong)   CCLayer         *playerLaerNode;
@property (nonatomic, strong)   CCLayer         *hudLaerNode;
@property (nonatomic, strong)   CCAction        *scoreFlashAction;
@property (nonatomic, strong)   CCLabelBMFont   *playerHealthLabel;

- (void)setupSceneLayer;
- (void)setupUI;

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
        
        
//        CCLabelTTF *label = [CCLabelTTF labelWithString:@"Thirteen Pixel Fonts" fontName:@"Thirteen Pixel Fonts" fontSize:40];
//
//        label.position = ccp(self.winSize.width / 2, self.winSize.height / 2);
//        label.anchorPoint = ccp(1, 0);
//        [self addChild:label];
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
    
    self.playerHealthLabel = [CCLabelTTF labelWithString:kSTCHealthBar fontName:kSTCHealthBarFontName fontSize:0];
    
    CCLabelTTF *playerHealthBackgroundLabel = [CCLabelTTF labelWithString:kSTCHealthBar
                                                                 fontName:kSTCHealthBarFontName
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
                                                       fontName:kSTCHealthBarFontName
                                                       fontSize:kSTCHealthBarFontSize];
    
    playerHealthLabel.tag = kSTCNodeNamePlayerHealth;
    playerHealthLabel.color = ccGREEN;
    
//    CGFloat yPosition = size.height - hudBarBackground.contentSize.height - kSTCHealthBarFontSize / 3;
//    CGPoint position = ccp(0, yPosition);
    playerHealthLabel.position = position;
    playerHealthLabel.anchorPoint = ccp(0, 0);
    
    [self.hudLaerNode addChild:playerHealthLabel];
    

//    playerHealthLabel.name = "playerHealthLabel" playerHealthLabel.fontColor = SKColor.greenColor() playerHealthLabel.fontSize = 50 playerHealthLabel.text =
//    healthBarString.substringToIndex(20*75/100) playerHealthLabel.horizontalAlignmentMode = .Left playerHealthLabel.verticalAlignmentMode = .Top playerHealthLabel.position = CGPoint(
//                                                                                                                                                                                      x: CGRectGetMinX(playableRect),
//                                                                                                                                                                                      y: size.height - CGFloat(hudHeight) + playerHealthLabel.frame.size.height) hudLayerNode.addChild(playerHealthLabel)
//    ￼￼￼￼￼￼￼￼￼￼￼￼￼￼￼￼￼￼￼￼￼￼￼￼￼￼￼￼￼￼￼￼￼￼￼￼￼￼￼￼￼￼￼￼￼￼￼￼￼￼￼￼￼￼￼￼￼
}

@end
