//
//  Task.h
//  Todos
//
//  Created by Minh Luu on 4/5/14.
//  Copyright (c) 2014 Minh Luu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

typedef enum {
    LOW,
    MEDIUM,
    HIGH
} Priority;

@interface Task : NSManagedObject

@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSNumber * priority;
@property (nonatomic, retain) NSDate * creationDate;
@property (nonatomic, retain) NSString * note;
@property (nonatomic, retain) NSDate * dueDate;

@end
