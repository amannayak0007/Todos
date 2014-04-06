//
//  TasksTableViewController.m
//  Todos
//
//  Created by Minh Luu on 4/5/14.
//  Copyright (c) 2014 Minh Luu. All rights reserved.
//

#import "TasksTableViewController.h"
#import "TaskDetailTableViewController.h"
#import "Task.h"

@interface TasksTableViewController ()

@property (nonatomic, strong) NSArray *tasks;

@end

@implementation TasksTableViewController

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self refresh];
}

- (void)refresh {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Task"];
    self.tasks = [self.managedObjectContext executeFetchRequest:request error:nil];
    [self.tableView reloadData];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return @"high";
            break;
        case 1:
            return @"medium";
            break;
        case 2:
            return @"low";
            break;
        default:
            break;
    }
    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int priority;
    switch (section) {
        case 0:
            priority = HIGH;
            break;
        case 1:
            priority = MEDIUM;
            break;
        case 2:
            priority = LOW;
            break;
        default:
            break;
    }
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"priority == %i", priority];
    NSArray *tasks = [self.tasks filteredArrayUsingPredicate:predicate];
    
    return tasks.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Task Cell" forIndexPath:indexPath];
    Task *task = [self.tasks objectAtIndex:indexPath.row];
    cell.textLabel.text = task.title;
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    TaskDetailTableViewController *taskVC = segue.destinationViewController;
    if ([sender isKindOfClass:[UITableViewCell class]]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        Task *task = [self.tasks objectAtIndex:indexPath.row];
        taskVC.task = task;
    }
    taskVC.managedObjectContext = self.managedObjectContext;
}

@end
