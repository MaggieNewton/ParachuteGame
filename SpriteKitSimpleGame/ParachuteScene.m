//
//
//  ParachuteScene.m
//  SpriteKitSimpleGame
//
//  Created by Maggie Newton on 6/25/15.
//  Copyright (c) 2015 Maggie Newton. All rights reserved.

#import "ParachuteScene.h"
#import "WolfScene.h"
#import "SpirometerEffortAnalyzer.h"

@interface ParachuteScene()


@property (strong, nonatomic) SpirometerEffortAnalyzer* spiro;

@end

@implementation ParachuteScene
 
SKSpriteNode *background2;
SKSpriteNode *mountains;
SKSpriteNode *parachute;

CGPoint currentposition;
CGPoint currentvelocity;

SKNode *camera;
SKNode *player;
SKNode *mountains;

static const parachuteCategory = 0x1 << 0;
static const mountainCategory = 0x1 << 1;
static const outofboundsCategory = 0x1 << 2;


- (void)didMoveToView:(SKView *)view{
    
    UISwipeGestureRecognizer *rightSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget: self action:@selector(rightFlip:)];
    [rightSwipe setDirection:UISwipeGestureRecognizerDirectionRight];
    [view addGestureRecognizer:rightSwipe];
    //NSLog(@"Working gesture");
    self.anchorPoint = CGPointMake(0.5,0.5);
    camera = [self childNodeWithName: @"//camera"];
    player = [self childNodeWithName: @"//Parachute"];
    mountains = [self childNodeWithName: @"//Mountain"];
    player.physicsBody.categoryBitMask = parachuteCategory;
    mountains.physicsBody.categoryBitMask = mountainCategory;
    player.physicsBody.contactTestBitMask = mountainCategory;
    
    self.physicsWorld.contactDelegate = self;
    
    
    //NSLog(@"camera works%@",player);
    
    self.spiro = [[SpirometerEffortAnalyzer alloc] init];
    self.spiro.delegate = self;
    
    //[self.spiro activateDebugAudioModeWithWAVFile:nil];
    
    [self.spiro beginListeningForEffort];
    
    
}

- (void)rightFlip:(id)sender{
    SKView * skView = (SKView *)self.view;
    SKScene * scene = [WolfScene sceneWithSize:skView.bounds.size];
    scene.scaleMode = SKSceneScaleModeAspectFill;
    [skView presentScene:scene transition:[SKTransition pushWithDirection:SKTransitionDirectionRight duration:0.27]];
    //NSLog(@"Working gesture");
    
}

-(void)update:(NSTimeInterval)currentTime{
 
    /*currentvelocity.x = currentvelocity.x * 0.95;
    currentvelocity.y = currentvelocity.y * 0.95;
 
 
    parachute.position = currentposition;
    currentposition.x = currentposition.x+ currentvelocity.x;
    currentposition.y = currentposition.y+ currentvelocity.y;*/
 
 
 }

-(void) didSimulatePhysics{
    //pull in camera and player sprites
    
    
    //position camera where player is
    camera.position = CGPointMake(player.position.x, player.position.y);
    //center world on the camera
    [self centerOnNode: camera];
   
}

- (void) centerOnNode: (SKNode *) node{
    CGPoint cameraPositionInScene = [node.scene convertPoint:node.position fromNode:node.parent];
    node.parent.position = CGPointMake(node.parent.position.x - cameraPositionInScene.x,
                                       node.parent.position.y - cameraPositionInScene.y);
}

-(void) didBeginContact:(SKPhysicsContact *)contact{
    SKPhysicsBody* firstBody;
    
    SKPhysicsBody* secondBody;
    
    // 2 Assign the two physics bodies so that the one with the lower category is always stored in firstBody
    
    if (contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask) {
        
        firstBody = contact.bodyA;
        
        secondBody = contact.bodyB;
        
    } else {
        
        firstBody = contact.bodyB;
        
        secondBody = contact.bodyA;
        
    }
    
    // 3 react to the contact between ball and bottom
    
    if (firstBody.categoryBitMask == parachuteCategory && secondBody.categoryBitMask == mountainCategory) {
        
        //TODO: Replace the log statement with display of Game Over Scene
        [player.physicsBody applyImpulse: CGVectorMake(0,1000)];
        NSLog(@"Hit bottom. First contact has been made.");
        
    }
 
    
}

- (IBAction)startEffort:(UIButton *)sender {
    //self.feedbackLabel.text =
    NSLog(@"Calibrating sound, please remain silent...");
    [self.spiro beginListeningForEffort];
}

- (IBAction)getPermission:(UIButton *)sender {
    [self.spiro askPermissionToUseAudioIfNotDone];
}
- (IBAction)cancelEffort:(UIButton *)sender {
    [self.spiro requestThatCurrentEffortShouldCancel];
}
-(void)didFinishCalibratingSilence{
    //self.feedbackLabel.text =
    NSLog(@"Inhale deeply ...and blast out air when ready!");
}

-(void)didTimeoutWaitingForTestToStart{
    //self.feedbackLabel.text =
    NSLog(@"No exhale heard, effort canceled");
}

-(void)didStartExhaling{
    //self.feedbackLabel.text =
    NSLog(@"Keep blasting!!");
}

-(void)willEndTestSoon{
    //self.feedbackLabel.text =
    NSLog(@"Try to push last air out!! Go, Go, Go!");
}

-(void)didCancelEffort{
    //self.feedbackLabel.text =
    NSLog(@"Effort Cancelled");
}

-(void)didEndEffortWithResults:(NSDictionary*)results{
    // right now results are an empty dictionary
    // in the future the results of the effort will all be stored as key/value pairs
    NSLog(@"%@",results);
    //self.feedbackLabel.text =
    NSLog(@"Effort Complete. Thanks!");
}

-(void)didUpdateFlow:(float)flow andVolume:(float)volume{
    // flow and volume are just placeholders right now
    // the value of "flow" will change, but it is not converted to an actual flow rate yet
    // volume is always zero right now
    
    //self.flowSlider.value = flow; // watch it jump around when updated
    //self.flowLabel.text = [NSString stringWithFormat:@"Flow: %.2f",flow];
    //NSLog(@"Flow: %.2f", flow);
}
-(void)didUpdateAudioBufferWithMaximum:(float)maxAudioValue{
    NSLog(@"%.2f", maxAudioValue);
    [player.physicsBody applyImpulse: CGVectorMake(1000*maxAudioValue,4000*maxAudioValue)];
}

@end










