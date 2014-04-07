//
//  DatePickerTableViewController.m
//  Todos
//
//  Created by Minh Luu on 4/6/14.
//  Copyright (c) 2014 Minh Luu. All rights reserved.
//

#import "DatePickerTableViewController.h"

@interface DatePickerTableViewController ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;

@end

@implementation DatePickerTableViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationController.title = self.title;
    
    

    // Handle dates
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateStyle = NSDateFormatterMediumStyle;
    formatter.timeStyle = NSDateFormatterShortStyle;
    
    self.titleLabel.text = self.title;
    
    self.detailLabel.text = [formatter stringFromDate:self.date];
    if (self.date) {
        self.datePicker.date = self.date;
    }
}

@end
