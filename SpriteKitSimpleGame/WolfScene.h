//
//  WolfScene.h
//  SpriteKitSimpleGame
//
//  Created by Maggie Newton on 6/24/15.
//  Copyright (c) 2015 Maggie Newton. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface WolfScene : SKScene <UIGestureRecognizerDelegate>

    @property (strong, nonatomic) UISwipeGestureRecognizer* swipeLeftGesture;
    @property (strong, nonatomic) UIRotationGestureRecognizer* rotationGR;
    @property (strong, nonatomic) UISwipeGestureRecognizer* swipeRightGesture;



@end


