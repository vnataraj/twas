//
//  twasAppDelegate.m
//  twas
//
//  Created by Vipul Nataraj on 4/20/13.
//  Copyright (c) 2013 Nakama. All rights reserved.
//

#import "twasAppDelegate.h"

@implementation twasAppDelegate
@synthesize window = _window;
@synthesize accountStore= _accountStore;
@synthesize profileImages=_profileImages;
@synthesize userAccount=_userAccount;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    self.accountStore = [[ACAccountStore alloc] init];
    self.profileImages = [NSMutableDictionary dictionary];
    ACAccountType *twitter = [self.accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    [self.accountStore requestAccessToAccountsWithType:ACAccountTypeIdentifierTwitter options:nil completion:^(BOOL granted, NSError *error) {
        if(granted)
        {
            NSArray *twitterAccountList= [self.accountStore accountsWithAccountType:ACAccountTypeIdentifierTwitter];
            if([twitterAccountList count])
            {
                self.userAccount = [twitterAccountList objectAtIndex:0];
                [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"AccountAccessGotTwitterNotification" object:nil]];
            }
            else{
                NSLog(@"No Twitter Accounts found! Please be sure to add Twitter in your Accounts list!");
            }
        }
    }];
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
