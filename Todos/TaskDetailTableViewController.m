//
//  TaskDetailTableViewController.m
//  Todos
//
//  Created by Minh Luu on 4/5/14.
//  Copyright (c) 2014 Minh Luu. All rights reserved.
//

#import "TaskDetailTableViewController.h"
#import "DatePickerTableViewController.h"


@interface TaskDetailTableViewController () <UITextViewDelegate, UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *nameTF;
@property (weak, nonatomic) IBOutlet UILabel *creationDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *dueDateLabel;
@property (weak, nonatomic) IBOutlet UISegmentedControl *prioritySegment;
@property (weak, nonatomic) IBOutlet UITextView *noteTV;

@property (weak, nonatomic) IBOutlet UITableViewCell *creationDateCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *dueDateCell;

@property (nonatomic, strong) NSDate *creationDate;
@property (nonatomic, strong) NSDate *dueDate;

@end

@implementation TaskDetailTableViewController

- (IBAction)priorityChanged:(id)sender {
    [self.view endEditing:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.task) {
        self.title = self.task.title;
    }
    
    // Handle dates
    self.creationDate = self.task.creationDate ? self.task.creationDate : [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateStyle = NSDateFormatterMediumStyle;
    formatter.timeStyle = NSDateFormatterShortStyle;
    
    // Task name
    self.nameTF.text = self.task.title;
    
    // Task priority
    if (self.task) {
        self.prioritySegment.selectedSegmentIndex = [self.task.priority intValue];
    }
    
    // Task creation and due date
    self.creationDateLabel.text = [formatter stringFromDate:self.creationDate];
    if (self.task.dueDate) {
        self.dueDateLabel.text = [formatter stringFromDate:self.task.dueDate];
    }
    
    // Task note
    if (self.task.note) {
        self.noteTV.text = self.task.note;
    }
    
    self.nameTF.delegate = self;
    self.noteTV.delegate = self;
    
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard:)];
//    [self.view addGestureRecognizer:tap];
    
//    UIDatePicker *datePicker = [[UIDatePicker alloc] init];
//    datePicker.datePickerMode = UIDatePickerModeDate;
//    [datePicker addTarget:self action:@selector(datePickerValueChanged:) forControlEvents:UIControlEventValueChanged];
////    datePicker.tag = indexPath.row;
//    self.creationDateCell.textLabel.inputView = datePicker;
}

- (void)dismissKeyboard:(id)sender {
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.view endEditing:YES];
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    if (cell == self.dueDateCell) {
        NSIndexPath *nextIndexPath = [NSIndexPath indexPathForRow:indexPath.row + 1 inSection:indexPath.section];
        UITableViewCell *dateCell = [self.tableView cellForRowAtIndexPath:nextIndexPath];
        [UIView transitionWithView:dateCell duration:1 options:UIViewAnimationOptionTransitionCrossDissolve animations:NULL completion:NULL];
        dateCell.hidden = NO;
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    DatePickerTableViewController *datePickerVC = segue.destinationViewController;
    if (sender == self.creationDateCell) {
        datePickerVC.title = self.creationDateCell.textLabel.text;
        datePickerVC.date = self.creationDate;
        
    } else if (sender == self.dueDateCell) {
        datePickerVC.title = self.dueDateCell.textLabel.text;
        datePickerVC.date = self.dueDate;
    }
    
}

@end
