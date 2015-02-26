//
//  MyCocos2DClass.h
//  SecondTestCocos2D_v2_2
//
//  Created by Voronok Vitaliy on 2/20/15.
//  Copyright 2015 IDPGroup. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "STCScoreProtocol.h"

@interface STCGameScene : CCLayer <STCScoreProtocol>

@property (nonatomic, strong) CCLayer *playerLayerNode;
@property (nonatomic, strong) CCLayer *hudLayerNode;
@property (nonatomic, strong) CCLayer *bulletLayerNode;
@property (nonatomic, strong) CCLayer *enemyLayerNode;
@property (nonatomic, strong) CCLayer *starsLayerNode;

+ (CCScene *)scene;

@end
