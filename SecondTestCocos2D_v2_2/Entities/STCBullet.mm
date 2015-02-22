//
//  STCBullet.m
//  SecondTestCocos2D_v2_2
//
//  Created by Admin on 22/02/15.
//  Copyright (c) 2015 IDPGroup. All rights reserved.
//

#import "STCBullet.h"

#import "Constants.h"

@implementation STCBullet

#pragma mark -
#pragma mark Class Methods

+ (CCSprite *)generateSprite {
    static CCSprite *sprite = nil;
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        CCLabelTTF *bullet = [CCLabelTTF labelWithString:@"✶" fontName:kSTCArialFontName fontSize:20];
        bullet.tag = kSTCNodeNameBulletSymbol;

        sprite = bullet;
    });
    
    return sprite;
}

#pragma mark -
#pragma mark Initialization and Dealocation

- (instancetype)initWithPosition:(CGPoint)position {
    self = [super initWithPosition:position];
    
    if (self) {
        self.tag = kSTCNodeNameBullet;
        self.color = ccRED;
    }
    
    return self;
}

#pragma mark -
#pragma mark Life Cycle

//- (void)update:(CFTimeInterval)delta {
//
//}

@end
