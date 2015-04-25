//
//  SHFoodViewController.m
//  TUTCafeterias
//
//  Created by Aleksander Grzyb on 25/04/15.
//  Copyright (c) 2015 Aleksander Grzyb. All rights reserved.
//

#import "SHFoodViewController.h"
#import "SHFood.h"
#import "SHFoodTableViewCell.h"
#import <Parse/Parse.h>

@interface SHFoodViewController ()
@property NSArray *food;
@end

@implementation SHFoodViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self configureTableView];
    [self loadData];
}

#pragma mark -
#pragma mark Loading Data

- (void)loadData
{
    PFQuery *query = [SHFood query];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            self.food = objects;
            [self.tableView reloadData];
        }
        else {
            NSLog(@"%@", error.description);
        }
    }];
}

#pragma mark -
#pragma mark Table View Data Source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.food.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"FoodCell";
    SHFoodTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    SHFood *food = (SHFood *)self.food[indexPath.row];
    cell.cellType = FoodTableViewCellTypeNonCafeteria;
    cell.name = food.name;
    cell.price = food.price;
    return cell;
}

#pragma mark -
#pragma mark Table View Configuration

- (void)configureTableView
{
     [self.tableView registerClass:[SHFoodTableViewCell class] forCellReuseIdentifier:@"FoodCell"];
    self.tableView.allowsSelection = NO;
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0.97 green:0.82 blue:0.49 alpha:1];
    self.navigationController.navigationBar.translucent = NO;
}

@end