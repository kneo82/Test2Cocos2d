//
//  STCEnemyA.h
//  SecondTestCocos2D_v2_2
//
//  Created by Admin on 22/02/15.
//  Copyright (c) 2015 IDPGroup. All rights reserved.
//

#import "STCEntity.h"

@class AISteering;

@interface STCEnemyA : STCEntity
@property (nonatomic, assign)   NSInteger   score;
@property (nonatomic, assign)   NSInteger   damageTakenPerShot;
@property (nonatomic, strong)   NSString    *healthMeterText;

@property (strong,nonatomic) AISteering *aiSteering;

@end
