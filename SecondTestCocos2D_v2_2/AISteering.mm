//
//  AISteering.m
//  XBlaster
//
//  Created by Mike Daley on 22/07/2013.
//  Copyright (c) 2013 www.raywenderlich.com. All rights reserved.
//

#import "AISteering.h"
#import "STCEntity.h"
#import "CGGeometry+ZCExtension.h"

@implementation AISteering

#pragma mark -
#pragma mark AI Creation

- (id)initWithEntity:(STCEntity *)entity waypoint:(CGPoint)waypoint{
  self = [super init];
  if (self) {
    _entity = entity;
    _waypoint = waypoint;
    
    _maxVelocity = 5.0f;
    _maxSteeringForce = 0.03f;
    _waypointRadius = 50.0;
    _waypointReached = NO;
    _faceDirectionOfTravel = NO;
  }
  return self;
}

#pragma mark -
#pragma mark Update

- (void)update:(CFTimeInterval)delta
{
  // Get the entities current position
  _currentPosition = self.entity.position;
  
  // Work out the direction to the waypoint from where the entity currently is
  CGPoint desiredDirection = CGSubtractionVectors(self.waypoint, _currentPosition);
  
  // Calculate the distance from the entity to the waypoint
  float distanceToWaypoint = CGLengthVector(desiredDirection);
  
  // Update the desired location based on the maxVelocity that has been defined and distance to the waypoint
  desiredDirection = CGMultiplicationVectorOnScalar(desiredDirection, _maxVelocity / distanceToWaypoint);
  
  // Calculate the steering force needed to turn towards the waypoint
  CGPoint force = CGSubtractionVectors(desiredDirection, _currentDirection);
  CGPoint steeringForce = CGMultiplicationVectorOnScalar(force, _maxSteeringForce / _maxVelocity);
  
  // Calculate the direction for the entity based on the direction and steering force that can be applied
  _currentDirection = CGAddVectors(_currentDirection, steeringForce);
  
  // The final position for the entity is calculated by adding the current position of the entity to the direction
  _currentPosition = CGAddVectors(_currentPosition, _currentDirection);
  
  // Rotate the entity to face in the direction of travel if that property has been set
  if (_faceDirectionOfTravel) {
    float angle = atan2f(self.entity.position.x - _currentPosition.x, self.entity.position.y - _currentPosition.y);
    self.entity.rotation = RADIANS_TO_DEGREES(angle);
  }
  
  // Update the position of the entity based on the steering calculations that have been performed
  self.entity.position = _currentPosition;
  
  // If the entity is within the waypointRadius then set the waypoint reached flag
  if (distanceToWaypoint < _waypointRadius) {
    _waypointReached = YES;
  }
}

- (void)updateWaypoint:(CGPoint)waypoint
{
  self.waypoint = waypoint;
  _waypointReached = NO;
}

@end
