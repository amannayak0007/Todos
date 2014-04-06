//
//  TasksTableViewController.h
//  Todos
//
//  Created by Minh Luu on 4/5/14.
//  Copyright (c) 2014 Minh Luu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TasksTableViewController : UITableViewController

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

@end
