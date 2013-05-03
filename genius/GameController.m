//
//  GameController.m
//  Genius
//
//  Created by Fabio Berger on 21/04/13.
//  Copyright (c) 2013 Berger Producoes. All rights reserved.
//

#import "GameController.h"
#import "HelpViewController.h"

@interface GameController ()

@end

@implementation GameController

static bool isSoundMuted;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"config" ofType:@"plist"];
    self.config = [NSDictionary dictionaryWithContentsOfFile:plistPath];
    
    self.imgGenius = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"genius_main.png"]];
    self.imgGenius.frame = CGRectMake(-60, -30, 440, 258);
    self.imgGenius.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:self.imgGenius];
    degree = 0;
    
    // create a background queue
    mainPageQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    // Setup background music
	NSString *soundFilePath = [[NSBundle mainBundle] pathForResource: @"background" ofType: @"caf"];
       NSURL *fileURL = [[NSURL alloc] initFileURLWithPath: soundFilePath];
       AVAudioPlayer *newPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL: fileURL error: nil];
       self.player = newPlayer;
       [self.player prepareToPlay];
       [self.player setNumberOfLoops:-1];
       [self.player play];
    
    isSoundMuted = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewWillAppear:(BOOL)animated {
    [[self navigationController] setNavigationBarHidden:YES animated:NO];

    
    //self.imgGenius.frame = CGRectMake(31, -119, 258, 440);
}

- (void) viewDidDisappear:(BOOL)animated {
    canAnimateMain = NO;
    dispatch_suspend(mainPageQueue);
}

- (void) viewDidAppear:(BOOL)animated {
    //NSLog(@"width %f, height %f", self.imgGenius.frame.size.width, self.imgGenius.frame.size.height);
    //NSLog(@"x %f, y %f", self.imgGenius.frame.origin.x, self.imgGenius.frame.origin.y);
    
    canAnimateMain = YES;

    
    // very simple Thread to animate the genius imagem at the menu
    dispatch_async(mainPageQueue, ^{
        double beginTime = 0;
        
        while (canAnimateMain) {
            // throttle the loop for desired framerate
            double sleep = (0.5 / 30.0f) - ((double)CFAbsoluteTimeGetCurrent() - beginTime);
            
            if(sleep > 0.0) {
                [NSThread sleepForTimeInterval:sleep];
            }

            dispatch_async(dispatch_get_main_queue(), ^{
                degree = (degree + 1) % 360;
                self.imgGenius.transform = CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(degree));
            });
            
            double endTime = (double)CFAbsoluteTimeGetCurrent();
            beginTime = endTime;
        }
    });
}


- (IBAction)gameButtonPressed:(id)sender {
    /*
    HelpViewController *helpViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"MainExecutionViewController"];
    [self presentViewController:helpViewController animated:NO completion:nil];
    */
    
     [self performSegueWithIdentifier:@"gameSegue" sender:self];
    
}

- (IBAction)howToPlayButtonPressed:(id)sender {
    /*
    HelpViewController *helpViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"HelpViewController"];
    [self presentViewController:helpViewController animated:YES completion:nil];
     */
    
    [self performSegueWithIdentifier:@"helpSegue" sender:self];
    
    
}

- (IBAction)highscoresButtonPressed:(id)sender {
    [self performSegueWithIdentifier:@"highscoresSegue" sender:self];
}

- (IBAction)logoButtonPresed:(id)sender {
    NSURL *url = [NSURL URLWithString:[self.config objectForKey:@"url"]];
    [[UIApplication sharedApplication] openURL:url];
}

- (IBAction)soundButtonPressed:(id)sender {
    UIButton *button = (UIButton *)sender;
    button.selected = !button.selected;
    isSoundMuted = !isSoundMuted;
}


- (IBAction)musicButtonPressed:(id)sender {
    UIButton *button = (UIButton *)sender;
    button.selected = !button.selected;
    if (self.player.isPlaying) {
        [self.player pause];
    } else {
        [self.player play];
    }
}

+ (BOOL) isSoundMuted {
    return isSoundMuted;
}

- (void) dealloc
{
    //dispatch_release(mainPageQueue);
}
@end
