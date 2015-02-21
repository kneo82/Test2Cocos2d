//
//  Entity.m
//  SecondTestCocos2D_v2_2
//
//  Created by Admin on 21/02/15.
//  Copyright 2015 IDPGroup. All rights reserved.
//

#import "STCEntity.h"

@interface STCEntity ()

@end

@implementation STCEntity

#pragma mark -
#pragma mark Class Methods

+ (CCSprite *)generateSprite {
    // Overridden by subclasses
    return nil;
}

#pragma mark -
#pragma mark Initialization and Dealocation

- (instancetype)initWithPosition:(CGPoint)position {
    CCSprite *sprite = [[self class] generateSprite];
    
    self = [super initWithTexture:sprite.texture];
    
    if (self) {
        self.position = position;
        self.direction = CGPointZero;
    }
    
    return self;
}

#pragma mark -
#pragma mark Life Cycle

- (void)update:(CFTimeInterval)delta {

}

@end
