//
//  Constants.h
//  SecondTestCocos2D_v2_2
//
//  Created by Admin on 21/02/15.
//  Copyright (c) 2015 IDPGroup. All rights reserved.
//

#ifndef SecondTestCocos2D_v2_2_Constants_h
#define SecondTestCocos2D_v2_2_Constants_h

typedef NS_ENUM(NSUInteger, STCNodesName) {
    kSTCNodeNameScoreLabel              = 100,
    kSTCNodeNamePlayerHealthBackground  = 120,
    kSTCNodeNamePlayerHealth            = 125,
    kSTCNodeNameShipSprite              = 200,
    kSTCNodeNameMainShip                = 202,
    kSTCNodeNameWings                   = 204,
};

static const NSUInteger kSTCBarHeightSize       = 45;
static const NSUInteger kSTCBarFontSize         = 20;
static const NSUInteger kSTCHealthBarFontSize   = 14;
static NSString * const kSTCScoreFontName       = @"Thirteen Pixel Fonts";
static NSString * const kSTCArialFontName       = @"Arial";
static NSString * const kSTCScoreLabel          = @"Score: 0";
static NSString * const kSTCHealthBar           = @"=======================================";

#endif
