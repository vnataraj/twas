//
//  twasFirstViewController.m
//  twas
//
//  Created by Vipul Nataraj on 4/20/13.
//  Copyright (c) 2013 Nakama. All rights reserved.
//

#import "TweetViewController.h"
#import "twasAppDelegate.h"
#import <Twitter/Twitter.h>

@interface TweetViewController () {
    SystemSoundID soundTweets;
}
@property (assign) BOOL isContaining;
- (void) dismissKeyboard;
@end

@implementation TweetViewController
@synthesize isContaining=_isContaining;

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
    UITapGestureRecognizer *tapChecker = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    tapChecker.numberOfTapsRequired = 1;
    tapChecker.cancelsTouchesInView=NO;
    [self.view addGestureRecognizer:tapChecker];
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

- (IBAction)tweetTapped:(id)sender { self.successLabel.text = @"";
    
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
