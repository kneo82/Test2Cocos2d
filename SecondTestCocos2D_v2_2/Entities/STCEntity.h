//
//  Entity.h
//  SecondTestCocos2D_v2_2
//
//  Created by Admin on 21/02/15.
//  Copyright 2015 IDPGroup. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface STCEntity : CCSprite
@property (nonatomic, assign)   CGPoint     direction;
@property (nonatomic ,assign)   CGFloat     health;
@property (nonatomic, assign)   CGFloat     maxHealth;

+ (CCSprite *)generateSprite;
- (instancetype)initWithPosition:(CGPoint)position;
- (void)update:(CFTimeInterval)delta;

@end
