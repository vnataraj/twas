//
//  FollowMeViewController.h
//  twas
//
//  Created by Vipul Nataraj on 4/20/13.
//  Copyright (c) 2013 Nakama. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FollowMeViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *followLabel;
- (IBAction)followSelected:(id)sender;
@property (weak, nonatomic) UITextField *followerSearchField;
@property (weak, nonatomic) UILabel *search;
- (IBAction)searchTwitter:(id)sender;
@end
