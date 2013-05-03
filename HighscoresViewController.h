//
//  HighscoresViewController.h
//  Genius
//
//  Created by Fabio Berger on 27/04/13.
//  Copyright (c) 2013 Berger Producoes. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HighscoresViewController : UITableViewController {
    //BOOL isHighscoresLoaded;
    
}


//@property (strong, nonatomic) NSArray* highScores;
//@property (strong, nonatomic) NSMutableArray *highScores;
//@property (strong, nonatomic) NSString *rootPath;
//@property (strong, nonatomic) NSString *plistPath;

+(void) loadHighScores;
+(void) addHighScore:(NSInteger)sequence name:(NSString*)name;
+(NSInteger) getMinimumScore;

@end
