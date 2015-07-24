//
//  WolfScene.m
//  SpriteKitSimpleGame
//
//  Created by Maggie Newton on 6/24/15.
//  Copyright (c) 2015 Maggie Newton. All rights reserved.
//

#import "WolfScene.h"
#import "ParachuteScene.h"


@implementation WolfScene{
    
    BOOL myBool;
    
    SKSpriteNode *player;
    SKSpriteNode *house;
    SKSpriteNode *background1;
    
    
    SKTexture *wolf1;
    SKTexture *wolf2;
    //SKTexture *wolf3;
    SKTexture *house1;
    SKTexture *house2;
    
    CGPoint currentposition;
    CGPoint currentvelocity;
    
    
}

-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        
        
        
        SKTexture *backgroundTexture = [SKTexture textureWithImageNamed:@"Background1.png"];
        background1 = [SKSpriteNode spriteNodeWithTexture:backgroundTexture];
        background1.size = self.frame.size;
        background1.position = (CGPoint){CGRectGetMidX(self.frame), CGRectGetMidY(self.frame)};
        [self addChild: background1];
        myBool = false;
        
        wolf1 = [SKTexture textureWithImageNamed:@"Wolf.png"];
        wolf2 = [SKTexture textureWithImageNamed:@"WolfBlowing.png"];
        
        //wolf3 = [SKTexture textureWithImageNamed:@"Wolf3.png"];
        
        player = [SKSpriteNode spriteNodeWithTexture:wolf1];
        currentposition = CGPointMake(173, 115);
        player.position = currentposition;
        
        //CGPoint velocity=CGPointMake(10, 1);
        //currentvelocity = velocity;
        
        house1 = [SKTexture textureWithImageNamed:@"House.png"];
        house2 = [SKTexture textureWithImageNamed:@"House2.png"];
        
        house = [SKSpriteNode spriteNodeWithTexture:house1];
        house.position = CGPointMake(550,150);
        
        
        [self addChild:player];
        [self addChild:house];
                
        
    }
    return self;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
   if(myBool == true){
        
        player.texture = wolf1;
        house.texture = house1;
        myBool = false;
        
    }else{
        player.texture = wolf2;
        house.texture = house2;
        
        myBool = true;
    }
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    SKNode *node = [self nodeAtPoint:location];
    
    if ([node.name isEqualToString:@"scene button"]) {
        
        SKTransition *reveal = [SKTransition fadeWithDuration:3];
        
        ParachuteScene *scene = [ParachuteScene sceneWithSize:self.view.bounds.size];
        scene.scaleMode = SKSceneScaleModeAspectFill;
        [self.view presentScene:scene transition:reveal];
    }
    
}

- (void)didMoveToView:(SKView *)view{
    
    UISwipeGestureRecognizer *leftSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(leftFlip:)];
    [leftSwipe setDirection:UISwipeGestureRecognizerDirectionLeft];
    [view addGestureRecognizer:leftSwipe];
    NSLog(@"Working gesture");

}


- (void)leftFlip:(id)sender{
    SKView * skView = (SKView *)self.view;
    SKScene * scene = [ParachuteScene sceneWithSize:skView.bounds.size];
    scene.scaleMode = SKSceneScaleModeAspectFill;
    [skView presentScene:scene transition:[SKTransition pushWithDirection:SKTransitionDirectionLeft duration:0.27]];
    NSLog(@"Working gesture");
    
}



/*-(void)update:(NSTimeInterval)currentTime{
    
    
    //currentvelocity.x = currentvelocity.x * 0.95;
    //currentvelocity.y = currentvelocity.y * 0.95;
    
    
    // player.position = currentposition;
    // currentposition.x = currentposition.x+ currentvelocity.x;
    // currentposition.y = currentposition.y+ currentvelocity.y;
    
    
}*/

@end

