//
//  twasFirstViewController.m
//  twas
//
//  thanks to Marcio Valenzuela for his Twitter web request help http://santiapps.com
//
//  Created by Vipul Nataraj on 4/20/13.
//  Copyright (c) 2013 Nakama. All rights reserved.
//

#import "TweetViewController.h"
#import "twasAppDelegate.h"
#import <Twitter/Twitter.h>

@interface TweetViewController () {
    SystemSoundID soundTweets;
    sqlite3 *tweetDB;
}
@property (assign) BOOL isContaining;
@property(strong, nonatomic) NSString *dataBase;
@property (assign) BOOL isConnected;
- (void) dismissKeyboard;
@end

@implementation TweetViewController
@synthesize isContaining=_isContaining;
@synthesize isConnected;
@synthesize dataBase=_dataBase;

-(BOOL)shouldAutorotateToInterfaceOrientation: (UIInterfaceOrientation)interfaceOrientation{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
- (void)dismissKeyboard{
    if (self.statusTextField.isFirstResponder) {
        [self.statusTextField resignFirstResponder];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _isContaining = NO;
    isConnected=YES;
    UITapGestureRecognizer *tapChecker = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    tapChecker.numberOfTapsRequired = 1;
    tapChecker.cancelsTouchesInView=NO;
    [self.view addGestureRecognizer:tapChecker];
    NSArray *dirPaths;
    NSString *docsDir;
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    docsDir = dirPaths[0];
    
    // Build the path to the database file
    _dataBase = [[NSString alloc]initWithString: [docsDir stringByAppendingPathComponent:@"Tweets.db"]];
    
    NSFileManager *filemgr = [NSFileManager defaultManager];
    
    if ([filemgr fileExistsAtPath: _dataBase ] == NO)
    {
        const char *dbpath = [_dataBase UTF8String];
        
        if (sqlite3_open(dbpath, &tweetDB) == SQLITE_OK)
        {
            char *errMsg;
            const char *sql_stmt =
            "CREATE TABLE IF NOT EXISTS TWEETS (ID INTEGER PRIMARY KEY AUTOINCREMENT, TWEET TEXT)";
            
            if (sqlite3_exec(tweetDB, sql_stmt, NULL, NULL, &errMsg) != SQLITE_OK)
            {
               NSLog(@"Failed to create table");
            }
            sqlite3_close(tweetDB);
        }
        else {
            NSLog(@"Failed to open/create database");
        }
    }
	// Do any additional setup after loading the view, typically from a nib.
}

-(IBAction)attachTapped:(id)sender{
    if(_isContaining)
    {
        self.attachedLabel.text=@"";
        _isContaining=NO;
    }
    else{
        self.attachedLabel.text=@"Attachment";
        _isContaining=YES;
    }
}

- (BOOL) connectedToNetwork
{
    return ([NSString stringWithContentsOfURL:[NSURL URLWithString:@"http://www.apple.com"]]!=NULL)?YES:NO;
}

- (void) enterVoidLoop{
    if([self connectedToNetwork]==YES){
        [self tweetTapped:nil];
    }
    else{
        [self enterVoidLoop];
    }
}

-(IBAction)syncTapped:(id)sender{
    if([self connectedToNetwork]==YES){
        const char *dbpath = [_dataBase UTF8String];
        sqlite3_stmt *statement;
        sqlite3_stmt *statement2;
        
        if (sqlite3_open(dbpath, &(tweetDB)) == SQLITE_OK)
        {
            NSString *querySQL = [NSString stringWithFormat:
                                  @"SELECT tweet FROM tweets WHERE id=1"];
            const char *query_stmt = [querySQL UTF8String];
            if (sqlite3_prepare_v2(tweetDB,
                                   query_stmt, -1, &statement, NULL) == SQLITE_OK)
            {
                if (sqlite3_step(statement) == SQLITE_ROW)
                {
                    NSString *tweetField = [[NSString alloc]
                                            initWithUTF8String:
                                            (const char *) sqlite3_column_text(statement, 0)];
                    self.statusTextField.text = tweetField;
                    NSLog(@"Match Found!");
                    NSString *querySQLs=[NSString stringWithFormat:@"DELETE * FROM tweets WHERE id=1"];
                    const char *query_stmts=[querySQLs UTF8String];
                    if(sqlite3_prepare_v2(tweetDB, query_stmts, -1, &statement2, NULL)==SQLITE_OK){
                        if(sqlite3_step(statement2)==SQLITE_DONE){
                            NSLog(@"Deleted");
                        }
                    }
                }
                else {
                    NSLog(@"Match Not Found!");
                }
                sqlite3_finalize(statement);
            }
            sqlite3_close(tweetDB);
            
            NSURL *feedURL = [NSURL URLWithString: @"http://api.twitter.com/1/statuses/update.json"];
            NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys: self.statusTextField.text, @"status", @"true", @"wrap_links", nil];
            SLRequest *twitterfeed = [SLRequest requestForServiceType:SLServiceTypeTwitter requestMethod:SLRequestMethodPOST URL:feedURL parameters:parameters];
            if (_isContaining) {
                [twitterfeed addMultipartData:UIImagePNGRepresentation([UIImage imageNamed:@"TweetImage.png"]) withName:@"media" type:@"image/png" filename:@"TweetImage.png"];
                [twitterfeed addMultipartData:[self.statusTextField.text dataUsingEncoding:NSUTF8StringEncoding] withName:@"status" type:@"text/plain" filename:@""];
            }
            twasAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
            twitterfeed.account = appDelegate.userAccount;
            UIApplication *sharedApplication = [UIApplication sharedApplication]; sharedApplication.networkActivityIndicatorVisible = YES;
            _isContaining = NO;
            self.attachedLabel.text = @"";
            [twitterfeed performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
                if (!error)
                {
                    self.successLabel.text = @"Tweeted Successfully";
                    [self playTweetSound];
                } else {
                    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Error" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    [alertView show];
                }
                sharedApplication.networkActivityIndicatorVisible = NO;
            }];
            
        }
    }
}

- (IBAction)tweetTapped:(id)sender { self.successLabel.text = @"";
    if([self connectedToNetwork] == NO){
        sqlite3_stmt *stmtForFiller;
        const char *dbPath = [_dataBase UTF8String];
        if(sqlite3_open(dbPath, &tweetDB) == SQLITE_OK){
            NSString *query= [NSString stringWithFormat:@"INSERT INTO tweets(tweet) Values(\"%@\")", self.statusTextField.text];
            const char *query_insert= [query UTF8String];
            sqlite3_prepare_v2(tweetDB, query_insert, -1, &stmtForFiller, NULL);
            if(sqlite3_step(stmtForFiller) == SQLITE_DONE){
                self.statusTextField.text = @"";
                self.successLabel.text=@"Tweet Saved in SQL Database!";
            }
            else{
                self.statusTextField.text=@"";
                self.successLabel.text=@"Failure to save in database, please try again!";
            }
            sqlite3_finalize(stmtForFiller);
            sqlite3_close(tweetDB);
            
            NSLog(@"Internet connection not present!!");
        }
        //[self enterVoidLoop];
        return;
    }
    NSURL *feedURL;
    if (_isContaining)
    {
        feedURL = [NSURL URLWithString: @"https://upload.twitter.com/1/statuses/update_with_media.json"];
    }
    else
    {
        feedURL = [NSURL URLWithString: @"http://api.twitter.com/1/statuses/update.json"]; }
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys: self.statusTextField.text, @"status", @"true", @"wrap_links", nil];
    SLRequest *twitterfeed = [SLRequest requestForServiceType:SLServiceTypeTwitter requestMethod:SLRequestMethodPOST URL:feedURL parameters:parameters];
    if (_isContaining) {
        [twitterfeed addMultipartData:UIImagePNGRepresentation([UIImage imageNamed:@"TweetImage.png"]) withName:@"media" type:@"image/png" filename:@"TweetImage.png"];
        [twitterfeed addMultipartData:[self.statusTextField.text dataUsingEncoding:NSUTF8StringEncoding] withName:@"status" type:@"text/plain" filename:@""];
    }
    twasAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    twitterfeed.account = appDelegate.userAccount;
    UIApplication *sharedApplication = [UIApplication sharedApplication]; sharedApplication.networkActivityIndicatorVisible = YES;
    _isContaining = NO;
    self.attachedLabel.text = @"";
    [twitterfeed performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
        if (!error)
        {
            self.successLabel.text = @"Tweeted Successfully";
            [self playTweetSound];
        } else {
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Error" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alertView show];
        }
        sharedApplication.networkActivityIndicatorVisible = NO;
    }];
}

-(void)playTweetSound{
    SystemSoundID sound1;
    NSLog(@"playingtweetsound");
    NSURL *soundURL = [[NSBundle mainBundle] URLForResource:@"Cardinal" withExtension:@"wav"];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)soundURL, &sound1);
    AudioServicesPlaySystemSound(sound1);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
