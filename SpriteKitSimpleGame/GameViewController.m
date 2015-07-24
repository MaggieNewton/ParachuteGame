//
//  GameViewController.m
//  SpriteKitSimpleGame
//
//  Created by Maggie Newton on 6/16/15.
//  Copyright (c) 2015 Maggie Newton. All rights reserved.
//

#import "GameViewController.h"
#import "WolfScene.h"
#import "SpirometerEffortAnalyzer.h"
#import "ParachuteScene.h"

@interface GameViewController()
@property (strong, nonatomic) SpirometerEffortAnalyzer* spiro;

@end

@implementation SKScene (Unarchive)

+ (instancetype)unarchiveFromFile:(NSString *)file {
    /* Retrieve scene file path from the application bundle */
    NSString *nodePath = [[NSBundle mainBundle] pathForResource:file ofType:@"sks"];
    /* Unarchive the file to an SKScene object */
    NSData *data = [NSData dataWithContentsOfFile:nodePath
                                          options:NSDataReadingMappedIfSafe
                                            error:nil];
    NSKeyedUnarchiver *arch = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
    [arch setClass:self forClassName:@"SKScene"];
    SKScene *scene = [arch decodeObjectForKey:NSKeyedArchiveRootObjectKey];
    [arch finishDecoding];
    
    return scene;
}

@end

@implementation GameViewController

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    // Configure the view.
    SKView * skView = (SKView *)self.view;
    if (!skView.scene) {
        skView.showsFPS = YES;
        skView.showsNodeCount = YES;
        
        // Create and configure the scene.
        //SKScene * scene = [WolfScene sceneWithSize:skView.bounds.size];
        ParachuteScene *scene = [ParachuteScene unarchiveFromFile:@"GameScene"];
        scene.scaleMode = SKSceneScaleModeAspectFill;
        
        // Present the scene.
        [skView presentScene:scene];
        
    }
    self.spiro = [[SpirometerEffortAnalyzer alloc] init];
    self.spiro.delegate = self;
   // self.spiro.prefferredAudioMaxUpdateIntervalInSeconds = 1.0/24.0; // the default is 30FPS, so setting lower
    // the FPS possible on this depends on the audio buffer size and sampling rate, which is different for different phones
    // most likely this has a maximum update rate of about 100 FPS
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    } else {
        return UIInterfaceOrientationMaskAll;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

#pragma mark SpirometerDelegate Methods
// all delegate methods are called from the main queue for UI updates
// as such, you should add the operation to another queue if it is not UI related
-(void)didFinishCalibratingSilence{
    //self.feedbackLabel.text = @"Inhale deeply ...and blast out air when ready!";
}

-(void)didTimeoutWaitingForTestToStart{
    //self.feedbackLabel.text = @"No exhale heard, effort canceled";
}

-(void)didStartExhaling{
    //self.feedbackLabel.text = @"Keep blasting!!";
}

-(void)willEndTestSoon{
    //self.feedbackLabel.text = @"Try to push last air out!! Go, Go, Go!";
}

-(void)didCancelEffort{
    //self.feedbackLabel.text = @"Effort Cancelled";
}


-(void)didEndEffortWithResults:(NSDictionary*)results{
    // right now results are an empty dictionary
    // in the future the results of the effort will all be stored as key/value pairs
    NSLog(@"%@",results);
    //self.feedbackLabel.text = @"Effort Complete. Thanks!";
}

-(void)didUpdateFlow:(float)flow andVolume:(float)volume{
    // A calibrated flow measurement that will come back dynamically and some time after the flow is detected
    // flow and volume are just placeholders right now
    // the value of "flow" will change, but it is not converted to an actual flow rate yet
    // volume is always zero right now
    
    //self.flowSlider.value = flow; // watch it jump around when updated
    //self.flowLabel.text = [NSString stringWithFormat:@"Flow: %.2f",flow];
}

-(void)didUpdateAudioBufferWithMaximum:(float)maxAudioValue{
    // once silence has been calibrated, you will start getting this message
    // This happens many times per second, depending on the preferred time interval (default is 30 times per scond)
    // for updating a game UI quickly, this is the better option but does not give you a valid flow rate
    NSLog(@"Audio Max: %.4f", maxAudioValue);
}


@end
