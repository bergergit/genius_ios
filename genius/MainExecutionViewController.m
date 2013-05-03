//
//  MainExecutionViewController.m
//  Genius
//
//  Created by Fabio Berger on 23/04/13.
//  Copyright (c) 2013 Berger Producoes. All rights reserved.
//

#import "MainExecutionViewController.h"
#import "HighscoresViewController.h"
#import "GameController.h"

@interface MainExecutionViewController ()

@end

@implementation MainExecutionViewController

static double PAUSE_SPEED = 0.4;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void) viewWillAppear:(BOOL)animated {
    
    [self disableButtons];
    
    // intializes player and computer arrays that will stores the color sequence
    self.playerArray = [NSMutableArray array];
    self.computerArray = [NSMutableArray array];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // red button sound
    NSString *redButtonSoundPath = [[NSBundle mainBundle] pathForResource:@"red" ofType:@"caf"];
    NSURL *redButtonSoundURL = [NSURL fileURLWithPath:redButtonSoundPath];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)redButtonSoundURL, &_redButtonSoundID);

    // green button sound
    NSString *greenButtonSoundPath = [[NSBundle mainBundle] pathForResource:@"green" ofType:@"caf"];
    NSURL *greenButtonSoundURL = [NSURL fileURLWithPath:greenButtonSoundPath];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)greenButtonSoundURL, &_greenButtonSoundID);

    // yellow button sound
    NSString *yellowButtonSoundPath = [[NSBundle mainBundle] pathForResource:@"yellow" ofType:@"caf"];
    NSURL *yellowButtonSoundURL = [NSURL fileURLWithPath:yellowButtonSoundPath];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)yellowButtonSoundURL, &_yellowButtonSoundID);

    // blue button sound
    NSString *blueButtonSoundPath = [[NSBundle mainBundle] pathForResource:@"blue" ofType:@"caf"];
    NSURL *blueButtonSoundURL = [NSURL fileURLWithPath:blueButtonSoundPath];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)blueButtonSoundURL, &_blueButtonSoundID);
    
    // load highscores to speed up Game Over message
    [HighscoresViewController loadHighScores];
    
}

-(void) viewDidAppear:(BOOL)animated {
    [self playComputer];
}

/**
 Method for the computer to play
 */
-(void) playComputer {
    isComputerPlaying = YES;
    [self disableButtons];
    playerSequence = 0;
    int randomInt = arc4random() % 4;
    NSNumber *randomButton = [NSNumber numberWithInteger:randomInt];
    [self.computerArray addObject:randomButton];
    [self playAnimation];
}

/*
 Plays the computer animation - light the button for each buttons in the array
 */
-(void) playAnimation {
    
    dispatch_queue_t concurrentQueue =
    dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);

    dispatch_async(concurrentQueue, ^{
        [NSThread sleepForTimeInterval:PAUSE_SPEED];
        
        for (id btn in self.computerArray) {
            [NSThread sleepForTimeInterval:PAUSE_SPEED];

            dispatch_async(dispatch_get_main_queue(), ^{
                
                switch ((int)[btn integerValue]) {
                    case red:
                        [self redBtnPressed:nil];
                        self.btnRed.highlighted=YES;
                        break;
                    case green:
                        [self greenBtnPressed:nil];
                        self.btnGreen.highlighted=YES;
                        break;
                    case yellow:
                        [self yellowBtnPressed:nil];
                        self.btnYellow.highlighted=YES;
                        break;
                    case blue:
                        [self blueBtnPressed:nil];
                        self.btnBlue.highlighted=YES;
                        break;
                    default:
                        break;
                }
            });

            // Sleep a bit, dehighlight buttons and sleep again. Crapy animation for the win
            [NSThread sleepForTimeInterval:PAUSE_SPEED / 2];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self dehighlightButtons];
            });
            
            [NSThread sleepForTimeInterval:PAUSE_SPEED / 2];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self enableButtons];
            isComputerPlaying = NO;
        });
    });
}

/*
 Deactive the highlight of the button
 */
- (void) dehighlightButtons {
    self.btnRed.highlighted=NO;
    self.btnGreen.highlighted=NO;
    self.btnYellow.highlighted=NO;
    self.btnBlue.highlighted=NO;
}

/*
 Disables the buttons so the computer can play
 */
- (void) disableButtons {
    self.btnRed.userInteractionEnabled = NO;
    self.btnGreen.userInteractionEnabled = NO;
    self.btnYellow.userInteractionEnabled = NO;
    self.btnBlue.userInteractionEnabled = NO;
}

/*
 Enables the buttons so the computer can play
 */
- (void) enableButtons {
    self.btnRed.userInteractionEnabled = YES;
    self.btnGreen.userInteractionEnabled = YES;
    self.btnYellow.userInteractionEnabled = YES;
    self.btnBlue.userInteractionEnabled = YES;
}

/*
 Checks to see if user is in the right sequence. If not, DIE!
 */
- (void) checkState:(Button) btn {
    if (isComputerPlaying) return;
    
    Button computerButton = [[self.computerArray objectAtIndex:playerSequence++] intValue];
    
    // wrong sequence baby
    if (computerButton != btn) {
        // do we have a highscore?
        if (([self.computerArray count] - 1) > [HighscoresViewController getMinimumScore]) {
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Game Over" message:[NSString stringWithFormat:@"Points: %i - New Highscore!", [self.computerArray count] - 1] delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
            
            alert.alertViewStyle = UIAlertViewStylePlainTextInput;
            UITextField *alertTextField = [alert textFieldAtIndex:0];
            alertTextField.placeholder = @"Enter your name";
            [alert show];
            
        } else {
             UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Game Over!"
             message:[NSString stringWithFormat:@"You Lost! Points: %i", [self.computerArray count] - 1]
             delegate:self
             cancelButtonTitle:@"OK"
             otherButtonTitles:nil];
             
             [message show];
        }
        return;
    }
    
    if (playerSequence >= [self.computerArray count]) {
        [self playComputer];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)redBtnPressed:(id)sender {
    if (![GameController isSoundMuted])
        AudioServicesPlaySystemSound(_redButtonSoundID);
    [self checkState:red];
}

- (IBAction)greenBtnPressed:(id)sender {
    if (![GameController isSoundMuted])
        AudioServicesPlaySystemSound(_greenButtonSoundID);
    [self checkState:green];
}

- (IBAction)yellowBtnPressed:(id)sender {
    if (![GameController isSoundMuted])
        AudioServicesPlaySystemSound(_yellowButtonSoundID);
    [self checkState:yellow];
}

- (IBAction)blueBtnPressed:(id)sender {
    if (![GameController isSoundMuted])
        AudioServicesPlaySystemSound(_blueButtonSoundID);
    [self checkState:blue];
}

#pragma UIAlertViewDelegate
-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        // save the Highscore
        NSString *name = [[alertView textFieldAtIndex:0] text];
        NSInteger points = [self.computerArray count] - 1;
        
        [HighscoresViewController addHighScore:points name:name];
    }
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
