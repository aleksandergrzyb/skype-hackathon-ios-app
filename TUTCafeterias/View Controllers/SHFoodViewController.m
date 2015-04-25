//
//  SHFoodViewController.m
//  TUTCafeterias
//
//  Created by Aleksander Grzyb on 25/04/15.
//  Copyright (c) 2015 Aleksander Grzyb. All rights reserved.
//

#import "SHFoodViewController.h"
#import "SHFood.h"
#import "SHCategoriesViewController.h"
#import "SHFoodTableViewCell.h"
#import "SHConstants.h"
#import "SHDishType.h"
#import "SHType.h"
#import <Parse/Parse.h>

@interface SHFoodViewController ()

- (void)updatePassedFilters;

@property (strong, nonatomic) NSArray *food;
@property (strong, nonatomic) NSMutableArray *cafeterias;
@property (strong, nonatomic) NSMutableArray *filterPassedFood;
@property (nonatomic) FilterState filterState;
@end

@implementation SHFoodViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self configureTableView];
    [self configureNavigationItemButtons];
    [self configureDynamicsDrawer];
    [self loadData];
    self.filterState = FilterStateOff;
    [self updatePassedFilters];
}

#pragma mark -
#pragma mark Getters

- (NSMutableArray *)cafeterias
{
    if (!_cafeterias) {
        _cafeterias = [NSMutableArray new];
    }
    return _cafeterias;
}

- (NSMutableArray *)filterPassedFood
{
    if (!_filterPassedFood) {
        _filterPassedFood = [NSMutableArray new];
    }
    return _filterPassedFood;
}

#pragma mark -
#pragma mark Setters

- (void)setFilters:(NSArray *)filters
{
    if (_filters == filters) {
        return;
    }
    _filters = filters;
    [self updatePassedFilters];
    if (self.filterPassedFood.count == self.food.count) {
        self.filterState = FilterStateOff;
    } else {
        self.filterState = FilterStateOn;
    }
}

- (void)setFilterState:(FilterState)filterState
{
    if (_filterState == filterState) {
        return;
    }
    _filterState = filterState;
    [self.tableView reloadData];
}

#pragma mark -
#pragma mark Private Methods

- (void)updatePassedFilters
{
    self.filterPassedFood = [self.food mutableCopy];
    for (SHFood *food in self.food) {
        BOOL passedFilter = YES;
        for (NSDictionary *filter in self.filters) {
            switch (((NSNumber *)filter[CATEGORY_TYPE_KEY]).integerValue) {
                case DishTypeFilter:
                    {
                        SHDishType *dishType = food.dish_type_id;
                        if ([[dishType.name lowercaseString] isEqualToString:[filter[NAME_KEY] lowercaseString]] ) {
                            passedFilter = NO;
                        }
                    }
                    break;
                case TypeFilter:
                    {
                        SHType *type = food.type_id;
                        if ([[type.name lowercaseString] isEqualToString:[filter[NAME_KEY] lowercaseString]] ) {
                            passedFilter = NO;
                        }
                    }
                    break;
                case CafeteriaFilter:
                    {
                        SHCafeteria *cafeteria = food.cafe_id;
                        if ([[cafeteria.name lowercaseString] isEqualToString:[filter[NAME_KEY] lowercaseString]] ) {
                            passedFilter = NO;
                        }
                    }
                    break;
            }
        }
        if (!passedFilter) {
            [self.filterPassedFood removeObject:food];
        }
    }
    [self.tableView reloadData];
}

#pragma mark -
#pragma mark Loading Data

- (void)loadData
{
    PFQuery *query = [SHFood query];
    [query includeKey:@"cafe_id"];
    [query includeKey:@"type_id"];
    [query includeKey:@"dish_type_id"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            self.food = objects;
            [self parseCafeterias];
            [self.tableView reloadData];
        }
        else {
            NSLog(@"%@", error.description);
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Check your network connection" message:error.description delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [alertView show];
        }
    }];
}

- (void)parseCafeterias
{
    for (SHFood *food in self.food) {
        if (![self.cafeterias containsObject:food.cafe_id]) {
            [self.cafeterias addObject:food.cafe_id];
        }
    }
}

#pragma mark -
#pragma mark Table View Data Source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.filterState == FilterStateOn) {
        return 1;
    } else {
        return self.cafeterias.count;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int count = 0;
    if (self.filterState == FilterStateOff) {
        SHCafeteria *sectionCafeteria = (SHCafeteria *)self.cafeterias[section];
        for (SHFood *food in self.food) {
            SHCafeteria *cafeteria = food.cafe_id;
            if ([cafeteria isEqual:sectionCafeteria]) {
                count++;
            }
        }
    } else {
        return self.filterPassedFood.count;
    }
    return count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (self.filterState == FilterStateOn) {
        return @"Results of filter";
    } else {
        SHCafeteria *sectionCafeteria = (SHCafeteria *)self.cafeterias[section];
        return sectionCafeteria.name;
    }
    return @"";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"FoodCell";
    SHFoodTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    if (self.filterState == FilterStateOff) {
        SHCafeteria *cafeteria = self.cafeterias[indexPath.section];
        int count = 0;
        for (SHFood *food in self.food) {
            SHCafeteria *currentCafeteria = food.cafe_id;
            if ([cafeteria isEqual:currentCafeteria]) {
                if (count == indexPath.row) {
                    cell.cellType = FoodTableViewCellTypeNonCafeteria;
                    cell.name = food.name;
                    cell.price = food.price;
                    return cell;
                } else {
                    count++;
                }
            }
        }
    } else {
        if (self.filterPassedFood.count > 0) {
            SHFood *food = (SHFood *)self.filterPassedFood[indexPath.row];
            SHCafeteria *cafeteria = (SHCafeteria *)food.cafe_id;
            cell.cellType = FoodTableViewCellTypeCafeteria;
            cell.name = food.name;
            cell.price = food.price;
            cell.cafeteria = cafeteria.name;
        }
    }
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

    // Configuring font
    CGFloat x = self.navigationItem.titleView.frame.origin.x;
    CGFloat y = self.navigationItem.titleView.frame.origin.x;
    CGFloat width = self.view.frame.size.width;
    CGFloat height = self.navigationController.navigationBar.frame.size.height;
    CGRect navigationItemFrame = CGRectMake(x, y, width, height);
    UILabel *navigationItemView = [[UILabel alloc] initWithFrame:navigationItemFrame];
    NSDictionary *atrributedStringAttributes = @{
                                                 NSFontAttributeName : [UIFont fontWithName:@"Homestead-Regular" size:22.0f],
                                                 NSForegroundColorAttributeName : [UIColor colorWithRed:0.82 green:0.07 blue:0.13 alpha:1],
                                                 NSBackgroundColorAttributeName : [UIColor clearColor],
                                                 NSKernAttributeName : [NSNumber numberWithFloat:1.0f]
                                                 };
    navigationItemView.attributedText = [[NSAttributedString alloc] initWithString:@"TUT Cafeterias" attributes:atrributedStringAttributes];
    navigationItemView.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView = navigationItemView;
}

#pragma mark -
#pragma mark Dynamics Drawer Configuration

- (void)configureDynamicsDrawer
{
    [self.dynamicsDrawerViewController setRevealWidth:self.view.frame.size.width - REVEAL_OFFSET forDirection:MSDynamicsDrawerDirectionLeft];
}

#pragma mark -
#pragma mark Navigation Bar Configuration

- (void)configureNavigationItemButtons
{
    UIImage *leftImage = [UIImage imageNamed:@"reveal_new"];
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setFrame:CGRectMake(0.0f, 0.0f, leftImage.size.width, leftImage.size.height)];
    [leftButton setBackgroundImage:leftImage forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(leftButtonPushed) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;

    UIImage *rightImage = [UIImage imageNamed:@"compass"];
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton setFrame:CGRectMake(0.0f, 0.0f, rightImage.size.width, rightImage.size.height)];
    [rightButton setBackgroundImage:rightImage forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(rightButtonPushed)
          forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
}

#pragma mark -
#pragma mark Actions

- (void)leftButtonPushed
{
    [self.dynamicsDrawerViewController setPaneState:MSDynamicsDrawerPaneStateOpen
                                           animated:YES
                              allowUserInterruption:YES
                                         completion:^{

    }];
}

- (void)rightButtonPushed
{

}

@end
