//
//  SHFoodViewController.h
//  TUTCafeterias
//
//  Created by Aleksander Grzyb on 25/04/15.
//  Copyright (c) 2015 Aleksander Grzyb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MSDynamicsDrawerViewController.h"

typedef enum : NSUInteger {
    FilterStateOn,
    FilterStateOff,
} FilterState;

@interface SHFoodViewController : UITableViewController

@property (weak, nonatomic) MSDynamicsDrawerViewController *dynamicsDrawerViewController;
@property (strong, nonatomic) NSArray *filters;
@property (strong, nonatomic) NSArray *food;

@end
