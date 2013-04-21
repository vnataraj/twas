//
//  twasAppDelegate.h
//  twas
//
//  Created by Vipul Nataraj on 4/20/13.
//  Copyright (c) 2013 Nakama. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Accounts/Accounts.h>

@interface twasAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) ACAccountStore *accountStore;
@property (strong, nonatomic) NSMutableDictionary *profileImages;
@property (strong, nonatomic) ACAccount *userAccount;

@end
