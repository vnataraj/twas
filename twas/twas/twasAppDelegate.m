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
    self.window.backgroundColor = [UIColor blackColor];
    [self.window makeKeyAndVisible];
    //self.window.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"testbg.png"]];
    
    // Set StatusBar Color
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackTranslucent];
    
    // Add the tab bar controller's current view as a subview of the window
    // Override point for customization after application launch.
    _accountStore = [[ACAccountStore alloc] init];
    self.profileImages = [NSMutableDictionary dictionary];
    ACAccountType *twitter = [self.accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    [self.accountStore requestAccessToAccountsWithType:twitter options:nil completion:^(BOOL granted, NSError *error) {
        if(granted == YES)
        {
            NSLog(@"Access should be granted");
            NSArray *twitterAccountList= [self.accountStore accountsWithAccountType:twitter];
            if([twitterAccountList count] > 0)
            {
                NSLog(@"here's the account");
                self.userAccount = [twitterAccountList objectAtIndex:0];
                [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"AccountAccessGotTwitterNotification" object:nil]];
            }
        }
            else{
                NSLog(@"No Twitter Accounts found! Please be sure to add Twitter in your Accounts list!");
                return;
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
