//
//  Constants.h
//  SecondTestCocos2D_v2_2
//
//  Created by Admin on 21/02/15.
//  Copyright (c) 2015 IDPGroup. All rights reserved.
//

#ifndef SecondTestCocos2D_v2_2_Constants_h
#define SecondTestCocos2D_v2_2_Constants_h

#define PTM_RATIO 32.0

typedef NS_ENUM(NSUInteger, STCNodesName) {
    kSTCNodeNameScoreLabel              = 100,
    kSTCNodeNameGameOver                = 102,
    kSTCNodeNameTapScrean               = 104,
    kSTCNodeNamePlayerHealthBackground  = 120,
    kSTCNodeNamePlayerHealth            = 125,
    kSTCNodeNameEnemyHealthMeter        = 128,
    kSTCNodeNameShipSprite              = 200,
    kSTCNodeNameMainShip                = 202,
    kSTCNodeNameWings                   = 204,
    kSTCNodeNameBullet                  = 210,
    kSTCNodeNameBulletSymbol            = 212,
    kSTCNodeNameEnemy                   = 220,
    
};

typedef enum : uint8_t {
    ColliderTypePlayer      = 1,
    ColliderTypeEnemy       = 2,
    ColliderTypeBullet      = 4,
    ColliderTypePowerup     = 8
} ColliderType;

typedef enum : NSUInteger {
    GameRunning      = 0,
    GameOver         = 1,
} GameState;

static const NSUInteger kSTCBarHeightSize       = 45;
static const NSUInteger kSTCBarFontSize         = 20;
static const NSUInteger kSTCHealthBarFontSize   = 14;
static NSString * const kSTCScoreFontName       = @"Thirteen Pixel Fonts";
static NSString * const kSTCArialFontName       = @"Arial";
static NSString * const kSTCScoreLabel          = @"Score: 0";
static NSString * const kSTCHealthBar           = @"=======================================";

#endif
