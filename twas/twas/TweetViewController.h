//
//  twasFirstViewController.h
//  twas
//
//  Created by Vipul Nataraj on 4/20/13.
//  Copyright (c) 2013 Nakama. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h>
@interface TweetViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *attachedLabel;
@property (weak, nonatomic) IBOutlet UITextField *statusTextField;
@property (weak, nonatomic) IBOutlet UILabel *successLabel;
- (IBAction)attachTapped:(id)sender;
- (IBAction)tweetTapped:(id)sender;
@end
