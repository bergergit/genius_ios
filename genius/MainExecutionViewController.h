//
//  MainExecutionViewController.h
//  Genius
//
//  Created by Fabio Berger on 23/04/13.
//  Copyright (c) 2013 Berger Producoes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioServices.h>

@interface MainExecutionViewController : UIViewController <UIAlertViewDelegate> {
    BOOL isComputerPlaying;
    int playerSequence;
}

@property SystemSoundID redButtonSoundID;
@property SystemSoundID greenButtonSoundID;
@property SystemSoundID yellowButtonSoundID;
@property SystemSoundID blueButtonSoundID;

@property NSMutableArray *computerArray;
@property NSMutableArray *playerArray;

@property (strong, nonatomic) IBOutlet UIButton *btnRed;
@property (strong, nonatomic) IBOutlet UIButton *btnGreen;
@property (strong, nonatomic) IBOutlet UIButton *btnYellow;
@property (strong, nonatomic) IBOutlet UIButton *btnBlue;

- (IBAction)redBtnPressed:(id)sender;
- (IBAction)greenBtnPressed:(id)sender;
- (IBAction)yellowBtnPressed:(id)sender;
- (IBAction)blueBtnPressed:(id)sender;

typedef enum Button : NSUInteger {
    red,
    green,
    yellow,
    blue
} Button;

@end
