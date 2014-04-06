//
//  TaskDetailTableViewController.h
//  Todos
//
//  Created by Minh Luu on 4/5/14.
//  Copyright (c) 2014 Minh Luu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Task.h"

@interface TaskDetailTableViewController : UITableViewController

@property (nonatomic, strong) Task *task;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;


@end
