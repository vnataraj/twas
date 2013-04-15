//
//  twasViewController.h
//  twas
//
//  Created by Vipul Nataraj on 4/14/13.
//  Copyright (c) 2013 Nakama. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Twitter/Twitter.h>

@interface twasViewController : UIViewController

if([TWTweetComposeViewController canSendTweet])
{
    NSLog(@"Connected and Authorized");
}
else{
    NSString *msg= @"Please configure your twitter account";
}

@end
