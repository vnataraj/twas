//
//  twineAppDelegate.h
//  twine
//
//  Created by Vipul Nataraj on 3/22/13.
//  Copyright (c) 2013 Nakama. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface twineAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
