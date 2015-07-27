//
//  ParachuteScene.h
//  SpriteKitSimpleGame
//
//  Created by Maggie Newton on 6/25/15.
//  Copyright (c) 2015 Maggie Newton. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "SpirometerEffortAnalyzer.h"

@interface ParachuteScene : SKScene <UIGestureRecognizerDelegate,SKPhysicsContactDelegate,SpirometerEffortDelegate>

    @property (strong, nonatomic) UISwipeGestureRecognizer* swipeRightGesture;
    @property (strong, nonatomic) UIRotationGestureRecognizer* rotationGR;
    -(void) rightFlip:(id) sender;

@end
