//
//  TaskDetailTableViewController.m
//  Todos
//
//  Created by Minh Luu on 4/5/14.
//  Copyright (c) 2014 Minh Luu. All rights reserved.
//

#import "TaskDetailTableViewController.h"


@interface TaskDetailTableViewController ()
@property (weak, nonatomic) IBOutlet UITextField *nameTF;
@property (weak, nonatomic) IBOutlet UILabel *creationDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *dueDateLabel;
@property (weak, nonatomic) IBOutlet UISegmentedControl *prioritySegment;
@property (weak, nonatomic) IBOutlet UITextView *noteTV;

@property (nonatomic, strong) NSDate *creationDate;
@property (nonatomic, strong) NSDate *dueDate;

@end

@implementation TaskDetailTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.task) {
        self.title = self.task.title;
    }
    
    self.creationDate = self.task.creationDate ? self.task.creationDate : [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateStyle = NSDateFormatterMediumStyle;
    formatter.timeStyle = NSDateFormatterShortStyle;
    
    // Task name
    self.nameTF.text = self.task.title;
    
    // Task priority
    self.prioritySegment.selectedSegmentIndex = [self.task.priority intValue];
    
    // Task creation and due date
    self.creationDateLabel.text = [formatter stringFromDate:self.creationDate];
    if (self.task.dueDate) {
        self.dueDateLabel.text = [formatter stringFromDate:self.task.dueDate];
    }
    
    // Task note
    if (self.task.note) {
        self.noteTV.text = self.task.note;
    }
    
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
}

- (void)dismissKeyboard {
    [self.view endEditing:YES];
}

- (IBAction)save:(id)sender {
    if (self.task) {
        [self updateTask];
    } else {
        [self createTask];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)updateTask {
    [self setupTask:self.task];
    [self.managedObjectContext save:nil];
}

- (void)createTask {
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Task" inManagedObjectContext:self.managedObjectContext];
    Task *newTask = [[Task alloc] initWithEntity:entity insertIntoManagedObjectContext:self.managedObjectContext];
    [self setupTask:newTask];
    
    [self.managedObjectContext save:nil];

}

- (void)setupTask:(Task *)task {
    task.title = self.nameTF.text;
    task.priority = [NSNumber numberWithInteger: self.prioritySegment.selectedSegmentIndex];
    task.creationDate = self.creationDate;
    task.note = self.noteTV.text;
}

@end
