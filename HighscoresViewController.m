//
//  HighscoresViewController.m
//  Genius
//
//  Created by Fabio Berger on 27/04/13.
//  Copyright (c) 2013 Berger Producoes. All rights reserved.
//

#import "HighscoresViewController.h"

#define kPlistName @"highscores.plist"
#define kNameKey @"name"
#define kSequenceKey @"sequence"
#define MAX_SCORES 10

@interface HighscoresViewController ()
@end

@implementation HighscoresViewController

static NSMutableArray *highScores;
static BOOL isHighscoresLoaded;
static NSString *rootPath;
static NSString *plistPath;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView reloadData];
    [self.navigationController setNavigationBarHidden:NO animated:NO];

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [HighscoresViewController loadHighScores];
    
    // trash - test - <<
    //[self addHighScore:2 name:@"Fabio"];
    //[self addHighScore:5 name:@"The master"];
    //[self addHighScore:3 name:@"Average guy"];
    //[self getMinimumScore];
    // - >> end trash
    
    // reading highscores.plist
    //NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"highscores" ofType:@"plist"];
    //self.highScores = [NSArray arrayWithContentsOfFile:plistPath];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 Loads the highscores from file
 */
+(void) loadHighScores {
    if (!isHighscoresLoaded) {
        // loading the plust
        NSString *errorDesc = nil;
        NSPropertyListFormat format;
        rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentationDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        plistPath = [rootPath stringByAppendingPathComponent:kPlistName];
        NSData *plistXML = [[NSFileManager defaultManager] contentsAtPath:plistPath];
        NSArray *unarchivedData = (NSArray*)[NSPropertyListSerialization propertyListFromData:plistXML mutabilityOption:NSPropertyListMutableContainersAndLeaves format:&format errorDescription:&errorDesc];
        
        NSLog(@"Root path: %@", rootPath);

        if (!unarchivedData) {
            // file doesnt exist yet. create it
            highScores = [[NSMutableArray alloc] init];
            
            // Create a serialized NSData instance, which can be written to a plist, from the data we've been storing in our NSMutableDictionary
            NSString *errorDescription;
            NSData *serializedData = [NSPropertyListSerialization dataFromPropertyList:highScores
                                                                                format:NSPropertyListXMLFormat_v1_0
                                                                      errorDescription:&errorDescription];
            
            if (serializedData) {
                // Write file
                NSError *errorPath, *errorWrite;
                BOOL pathCreated = [[NSFileManager defaultManager] createDirectoryAtPath:rootPath  withIntermediateDirectories:YES attributes:nil error:&errorPath];
                BOOL didWrite = [serializedData writeToFile:plistPath options:NSDataWritingFileProtectionComplete error:&errorWrite];
                
                
                if (pathCreated)
                    NSLog(@"Path created");
                else
                    NSLog(@"Path creation error: %@", errorPath);

                
                if (didWrite) {
                    NSLog(@"Hiscores file wrote");
                    isHighscoresLoaded = true;
                }
                else {
                    NSLog(@"Hiscores file write failed: %@", errorWrite);
                }
            } else {
                NSLog(@"Error in creating state data dictionary: %@", errorDescription);
            }
        } else {
            highScores = [unarchivedData mutableCopy];
            isHighscoresLoaded = true;
        }
    }
}

+(NSInteger) getMinimumScore {
    if (!isHighscoresLoaded) {
        [self loadHighScores];
    }
    
    //NSArray *keys = [[self.highScores allKeys] sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
    NSNumber *sequence = [[highScores lastObject] objectForKey:kSequenceKey];
    
    return [sequence intValue];
}

+(void) addHighScore:(NSInteger)sequence name:(NSString*)name {
    [self loadHighScores];
    
    // if highscores have reached the limit, we have to remove the worst result
    if (highScores.count > MAX_SCORES) {
        [highScores removeLastObject];
    }
    
    // Creating a new Dictionay containing user name and sequence
    NSMutableDictionary *scoreDictionary = [[NSMutableDictionary alloc] init];
    [scoreDictionary setValue:[NSNumber numberWithInt:sequence] forKey:kSequenceKey];
    [scoreDictionary setValue:name forKey:kNameKey];
    
    // get the position to be added in the array
    int i = 0;
    for (NSDictionary *thisDictionary in highScores) {
        //NSDictionary *thisDictionary = self.highScores[i];
        if ([[thisDictionary objectForKey:kSequenceKey] intValue] <= sequence) {
            [highScores insertObject:scoreDictionary atIndex:i];
            break;
        }
        i++;
    }
    if ([highScores count] == i) {
        [highScores addObject:scoreDictionary];
    }
    
    // Create a serialized NSData instance, which can be written to a plist, from the data we've been storing in our NSMutableDictionary
    NSString *errorDescription;
    NSData *serializedData = [NSPropertyListSerialization dataFromPropertyList:highScores
                                                                        format:NSPropertyListXMLFormat_v1_0
                                                              errorDescription:&errorDescription];
    if(serializedData)
    {
        // Write file
        NSError *error;
        BOOL didWrite = [serializedData writeToFile:plistPath options:NSDataWritingFileProtectionComplete error:&error];
        
        //NSLog(@"addHighScore:Error while writing: %@", [error description]);
        
        if (didWrite)
            NSLog(@"addHighScore:File did write");
        else
            NSLog(@"addHighScore:File write failed");
    }
    else
    {
        NSLog(@"addHighScore:Error in creating state data dictionary: %@", errorDescription);
    }
}


#pragma mark - Table View

- (void)insertNewObject:(id)sender
{
    /*
    if (!_objects) {
        _objects = [[NSMutableArray alloc] init];
    }
    [_objects insertObject:[NSDate date] atIndex:0];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
     */
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [highScores count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];

    NSDictionary *scoreDictionary = highScores[indexPath.row];
    NSNumber *sequence = [scoreDictionary objectForKey:kSequenceKey];
    NSString *name = [scoreDictionary objectForKey:kNameKey];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%i. %@ (%i points)", indexPath.row + 1, name,[sequence intValue]];
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return NO;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        
        // [_objects removeObjectAtIndex:indexPath.row];
        //[self.bugs removeObjectAtIndex:indexPath.row];
        //[tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}

@end
