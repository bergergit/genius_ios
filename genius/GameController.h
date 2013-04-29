//
//  GameController.h
//  Genius
//
//  Created by Fabio Berger on 21/04/13.
//  Copyright (c) 2013 Berger Producoes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVAudioPlayer.h>

// Degrees to radians
#define DEGREES_TO_RADIANS(angle) ((angle) / 180.0 * M_PI)
#define RADIANS_TO_DEGREES(radians) ((radians) * (180.0 / M_PI))

@interface GameController : UIViewController {
    dispatch_queue_t mainPageQueue;
    BOOL canAnimateMain;
    __block int degree;
}

//@property (strong, nonatomic) IBOutlet UIImageView *imgGenius;
@property (strong, nonatomic) UIImageView *imgGenius;
@property (strong, nonatomic) NSDictionary *config;
@property (nonatomic, retain) AVAudioPlayer *player;

- (IBAction)gameButtonPressed:(id)sender;
- (IBAction)howToPlayButtonPressed:(id)sender;
- (IBAction)highscoresButtonPressed:(id)sender;
- (IBAction)logoButtonPresed:(id)sender;

@end
