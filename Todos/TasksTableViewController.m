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

@interface TasksTableViewController () <NSFetchedResultsControllerDelegate>

@property (nonatomic, strong) NSMutableArray *tasks;
@property (nonatomic, strong) NSFetchedResultsController *fetchController;

@end

@implementation TasksTableViewController

- (NSFetchedResultsController *)fetchController {
    if (_fetchController) {
        return _fetchController;
    }
    
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Task"];
    
    NSSortDescriptor *sort = [[NSSortDescriptor alloc]
                              initWithKey:@"priority" ascending:NO];
    
    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sort]];
    
    [fetchRequest setFetchBatchSize:20];
    
    _fetchController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                           managedObjectContext:self.managedObjectContext
                                                             sectionNameKeyPath:nil
                                                                      cacheName:@"Root"];

    _fetchController.delegate = self;
    
    return _fetchController;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.fetchController performFetch:nil];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.fetchController performFetch:nil];
//    [self refresh];
}

- (void)refresh {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Task"];
    self.tasks = [[self.managedObjectContext executeFetchRequest:request error:nil] mutableCopy];
    [self.tableView reloadData];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.fetchController.sections.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return nil;
}

- (NSArray *)tasksBySection:(NSInteger)section {
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
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"priority = %i", priority];
    return [self.tasks filteredArrayUsingPredicate:predicate];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    id sectionInfo = [self.fetchController.sections objectAtIndex:section];
    return [sectionInfo numberOfObjects];
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    Task *task = [self.fetchController objectAtIndexPath:indexPath];
    cell.textLabel.text = task.title;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Task Cell" forIndexPath:indexPath];
    
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        Task *task = [self.tasks objectAtIndex:indexPath.row];
        

        [self.managedObjectContext deleteObject:task];
        [self.tasks removeObject:task];
        
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}

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

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    // The fetch controller is about to start sending change notifications, so prepare the table view for updates.
    [self.tableView beginUpdates];
}


- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
    
    UITableView *tableView = self.tableView;
    
    switch(type) {
            
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [self configureCell:[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            break;
            
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:[NSArray
                                               arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:[NSArray
                                               arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}


- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id )sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
    
    switch(type) {
            
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}


- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    // The fetch controller has sent all current change notifications, so tell the table view to process all updates.
    [self.tableView endUpdates];
}

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
