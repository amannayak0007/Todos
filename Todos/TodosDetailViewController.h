//
//  TodosDetailViewController.h
//  Todos
//
//  Created by Minh Luu on 4/5/14.
//  Copyright (c) 2014 Minh Luu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TodosDetailViewController : UIViewController

@property (strong, nonatomic) id detailItem;

@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@end
