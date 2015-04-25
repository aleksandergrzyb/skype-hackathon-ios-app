//
//  SHCategoriesViewController.h
//  TUTCafeterias
//
//  Created by Aleksander Grzyb on 25/04/15.
//  Copyright (c) 2015 Aleksander Grzyb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MSDynamicsDrawerViewController.h"

typedef enum : NSUInteger {
    CafeteriaFilter,
    DishTypeFilter,
    TypeFilter,
} CategoryType;

@class SHCategoriesViewController;

@protocol SHCategoriesViewControllerDelegate <NSObject>

- (void)viewController:(SHCategoriesViewController *)categoriesViewController didUpdateFilters:(NSArray *)filters;

@end

@interface SHCategoriesViewController : UIViewController

@property (weak, nonatomic) MSDynamicsDrawerViewController *dynamicsDrawerViewController;
@property (weak, nonatomic) id <SHCategoriesViewControllerDelegate> delegate;

@end
