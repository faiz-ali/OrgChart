//
//  AppDelegate.m
//  OrgChart
//
//  Created by Faij Ali on 03/08/13.
//  Copyright (c) 2013 Faij Ali. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    //[self createData];
    [self readData];
    return YES;
}

- (void)createData
{
    NSManagedObject *organization = [NSEntityDescription insertNewObjectForEntityForName:@"Organization" inManagedObjectContext:self.managedObjectContext];
    [organization setValue:@"MyCompany Inc." forKey:@"name"];
    [organization setValue:[NSNumber numberWithInt:[@"MyCompany Inc." hash]] forKey:@"id"];
    
    NSManagedObject *john = [NSEntityDescription insertNewObjectForEntityForName:@"Person" inManagedObjectContext:self.managedObjectContext];
    [john setValue:@"John" forKey:@"name"];
    [john setValue:[NSNumber numberWithInt:[@"John" hash]] forKey:@"id"];
    
    NSManagedObject *jane = [NSEntityDescription insertNewObjectForEntityForName:@"Person" inManagedObjectContext:self.managedObjectContext];
    [jane setValue:@"Jane" forKey:@"name"];
    [jane setValue:[NSNumber numberWithInt:[@"Jane" hash]] forKey:@"id"];
    
    NSManagedObject *bill = [NSEntityDescription insertNewObjectForEntityForName:@"Person" inManagedObjectContext:self.managedObjectContext];
    [bill setValue:@"Bill" forKey:@"name"];
    [bill setValue:[NSNumber numberWithInt:[@"Bill" hash]] forKey:@"id"];
    
    [organization setValue:john forKey:@"leader"];
    
    NSMutableSet *johnEmployees = [john mutableSetValueForKey:@"employees"];
    [johnEmployees addObject:jane];
    [johnEmployees addObject:bill];
    
    NSError *error;
    [self.managedObjectContext save:&error];
}

- (void)displayPerson:(NSManagedObject*)person withIndentation:(NSString*)indentation
{
    NSLog(@"%@Name: %@", indentation, [person valueForKey:@"name"]);
    indentation = [NSString stringWithFormat:@"%@ ",indentation];
    
    NSSet *employees = [person valueForKey:@"employees"];
    id employee;
    NSEnumerator *it = [employees objectEnumerator];
    while ((employee = [it nextObject]) != nil) {
        [self displayPerson:employee withIndentation:indentation];
    }
}

- (void)readData
{
    NSManagedObjectContext *context = [self managedObjectContext];
    NSEntityDescription *orgEntity = [NSEntityDescription entityForName:@"Organization" inManagedObjectContext:context];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:orgEntity];
    NSArray *organizations = [context executeFetchRequest:fetchRequest error:nil];
    id organization;
    NSEnumerator *it = [organizations objectEnumerator];
    while ((organization = [it nextObject]) != nil) {
        NSLog(@"Organization: %@", [organization valueForKey:@"name"]);
        NSManagedObject *leader = [organization valueForKey:@"leader"];
        [self displayPerson:leader withIndentation:@" "];
    }
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

- (void)saveContext
{
    NSError *error;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && [managedObjectContext save:&error]) {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

#pragma mark - Core Data Stack

/**
 Returns the managed object context for the application.
 If the object doesn't already exist, it is created and bound to the persistent store coordinate for the application.
*/

- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

/**
 Returns the managed object model for the application.
 If the model doesn't already exist, it is created from the application's model.
 */

- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"OrgChart" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

/**
 Returns the persistent store coordinator for the application.
 If the coordinator doesn't already exist, it is created and the application's store added to it.
 */

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"OrgChart.sqlite"];
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    return _persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

/**
 Returns the URL to the application's Documents directory
 */

- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask]lastObject];
}

@end