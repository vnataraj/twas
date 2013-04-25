//
//  twasSecondViewController.m
//  twas
//
//  Created by Vipul Nataraj on 4/20/13.
//  Copyright (c) 2013 Nakama. All rights reserved.
//

#import "ProfileViewController.h"
#import "twasAppDelegate.h"
#import <Twitter/Twitter.h>

@interface ProfileViewController ()

@end

@implementation ProfileViewController
@synthesize usernameLabel=_usernameLabel;
@synthesize descriptionLabel=_descriptionLabel;
@synthesize tweetsLabel=_tweetsLabel;
@synthesize favoritesLabel=_favoritesLabel;
@synthesize followingLabel=_followingLabel;
@synthesize followersLabel=_followersLabel;

- (void)loadProfileStats{
    NSURL *feedURL = [NSURL URLWithString:@"http://api.twitter.com/1/users/show.json"];
    twasAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    self.usernameLabel.text = appDelegate.userAccount.username;
    // 4. Create parameters dict
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:appDelegate.userAccount.username, @"screen_name", nil];
    SLRequest *twitterfeed = [SLRequest requestForServiceType:SLServiceTypeTwitter requestMethod:SLRequestMethodGET URL:feedURL parameters:parameters];
    twitterfeed.account = appDelegate.userAccount;
    UIApplication *sharedApplication = [UIApplication sharedApplication];
    sharedApplication.networkActivityIndicatorVisible = YES;
    [twitterfeed performRequestWithHandler:^(NSData *responseData,NSHTTPURLResponse *urlResponse,NSError *error) {
        if (!error) {
            NSError *jsonError = nil;
            id feedData = [NSJSONSerialization JSONObjectWithData:responseData options:0 error:&jsonError];
            if (!jsonError) {
                NSDictionary *profileDictionary = (NSDictionary *)feedData;
                self.descriptionLabel.text = [profileDictionary valueForKey:@"description"];
                self.favoritesLabel.text = [[profileDictionary valueForKey:@"favourites_count"] stringValue];
                self.followersLabel.text = [[profileDictionary valueForKey:@"followers_count"] stringValue];
                self.followingLabel.text = [[profileDictionary valueForKey:@"friends_count"] stringValue];
                self.tweetsLabel.text = [[profileDictionary valueForKey:@"statuses_count"] stringValue];
            } else {
                UIAlertView *alertView = [[UIAlertView alloc]
                                          initWithTitle:@"Error"
                                          message:[jsonError localizedDescription] delegate:nil
                                          cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alertView show];
            }
        } else {
            UIAlertView *alertView = [[UIAlertView alloc]
                                      initWithTitle:@"Error" message:[error localizedDescription] delegate:nil
                                      cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alertView show];
        }
        sharedApplication.networkActivityIndicatorVisible = NO;
    }];
}

-(void)viewWillAppear:(BOOL)animated{
    [self loadProfileStats];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
