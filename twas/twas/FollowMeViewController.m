//
//  FollowMeViewController.m
//  twas
//
//  Created by Vipul Nataraj on 4/20/13.
//  Copyright (c) 2013 Nakama. All rights reserved.
//

#import "FollowMeViewController.h"
#import "twasAppDelegate.h"
#import <Twitter/Twitter.h>
#define kAccountToFollow @"vipulnataraj"

@interface FollowMeViewController ()
@property (assign) BOOL isFollowing;
- (void)checkIfFollowing;
@end

@implementation FollowMeViewController

@synthesize followLabel = _followLabel;
@synthesize isFollowing = _isFollowing;

- (void)checkFollowing{
    NSURL *feedURL = [NSURL URLWithString:@"http://api.twitter.com/1/friendships/exists.json"];
    twasAppDelegate *appDelegate =[[UIApplication sharedApplication] delegate];
    NSDictionary *parameters =
    [NSDictionary dictionaryWithObjectsAndKeys: appDelegate.userAccount.username, @"screen_name_a", kAccountToFollow, @"screen_name_b", nil];
    SLRequest *twitterFeed = [SLRequest requestForServiceType:SLServiceTypeTwitter requestMethod:SLRequestMethodGET URL:feedURL parameters:parameters];
    twitterFeed.account = appDelegate.userAccount;
    UIApplication *sharedApplication = [UIApplication sharedApplication]; sharedApplication.networkActivityIndicatorVisible = YES;
    [twitterFeed performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
        if (!error) {
            NSString *responseString =
            [[NSString alloc] initWithBytes:[responseData bytes] length:[responseData length] encoding:NSUTF8StringEncoding];
            // 8. Set label's text to follower or not.
            if ([responseString isEqualToString:@"true"])
            {
                self.followLabel.text =
                @"Follow KaimanQ";
                _isFollowing = YES; }
            else
            {
                self.followLabel.text =
                @"Unfollow KaimanQ";
                _isFollowing = NO;
            }
        } else {
            // 9. If TWR unsuccessful, show alertview w/ error
            UIAlertView *alertView = [[UIAlertView alloc]
                                      initWithTitle:@"Error" message:[error localizedDescription] delegate:nil
                                      cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alertView show];
        }
        // 10. Stop activity indicator
        sharedApplication.networkActivityIndicatorVisible = NO;
    }];
}

- (IBAction)followTapped:(id)sender{
    NSURL *feedURL;
    if (_isFollowing) {
        feedURL = [NSURL URLWithString:@"http://api.twitter.com/1/friendships/destroy.json"];
    } else {
        feedURL = [NSURL URLWithString:@"http://api.twitter.com/1/friendships/create.json"];
    }
    twasAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSDictionary *parameters =
    [NSDictionary dictionaryWithObjectsAndKeys: @"true", @"follow",
     kAccountToFollow, @"screen_name", nil];
    SLRequest *twitterFeed = [SLRequest requestForServiceType:SLServiceTypeTwitter requestMethod:SLRequestMethodPOST URL:feedURL parameters:parameters];
    twitterFeed.account = appDelegate.userAccount;
    UIApplication *sharedApplication = [UIApplication sharedApplication]; sharedApplication.networkActivityIndicatorVisible = YES;
    [twitterFeed performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
        if (!error) {
            if (!_isFollowing)
            {
                self.followLabel.text =
                @"Unfollow KaimanQ";
                _isFollowing = YES;
            } else {
                self.followLabel.text =
                @"Follow KaimanQ";
                _isFollowing = NO;
            }
        } else {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                message:[error localizedDescription] delegate:nil
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil]; [alertView show];
        }
        sharedApplication.networkActivityIndicatorVisible = NO;
    }];
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _isFollowing=NO;
    [self checkFollowing];
    
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
