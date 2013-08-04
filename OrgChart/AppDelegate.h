//
//  AppDelegate.h
//  OrgChart
//
//  Created by Faij Ali on 03/08/13.
//  Copyright (c) 2013 Faij Ali. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;
- (void)createData;
- (void)readData;
- (void)displayPerson:(NSManagedObject*)person withIndentation:(NSString*)indentation;

@end
