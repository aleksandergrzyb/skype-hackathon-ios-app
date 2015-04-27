//
//  SHFoodViewController.m
//  TUTCafeterias
//
//  Created by Aleksander Grzyb on 25/04/15.
//
//  This code is distributed under the terms and conditions of the MIT license.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

#import "SHFoodViewController.h"
#import "SHFood.h"
#import "SHCategoriesViewController.h"
#import "SHFoodTableViewCell.h"
#import "SHMapViewController.h"
#import "SHConstants.h"
#import "SHDishType.h"
#import "SHType.h"
#import <Parse/Parse.h>

@interface SHFoodViewController ()

- (void)updatePassedFilters;

@property (strong, nonatomic) NSMutableArray *cafeterias;
@property (strong, nonatomic) NSMutableArray *filterPassedFood;
@property (nonatomic) FilterState filterState;
@end

@implementation SHFoodViewController

#pragma mark -
#pragma mark View Controller Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self configureTableView];
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

- (void)setFood:(NSArray *)food
{
    if (_food == food) {
        return;
    }
    _food = food;
    [self parseCafeterias];
    [self.tableView reloadData];
}

#pragma mark -
#pragma mark Parsing Data

- (void)parseCafeterias
{
    for (SHFood *food in self.food) {
        if (![self.cafeterias containsObject:food.cafe_id]) {
            [self.cafeterias addObject:food.cafe_id];
        }
    }
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
                    cell.isGlutenFree = food.gluten_free;
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
}

@end
