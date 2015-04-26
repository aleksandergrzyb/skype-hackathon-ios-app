//
//  SHMenusViewController.h
//  TUTCafeterias
//
//  Created by Aleksander Grzyb on 26/04/15.
//  Copyright (c) 2015 Aleksander Grzyb. All rights reserved.
//

#import "ViewPagerController.h"
#import "MSDynamicsDrawerViewController.h"
#import "SHFoodViewController.h"

@interface SHMenusViewController : ViewPagerController

@property (weak, nonatomic) MSDynamicsDrawerViewController *dynamicsDrawerViewController;
@property (strong, nonatomic) NSArray *filters;

@end
