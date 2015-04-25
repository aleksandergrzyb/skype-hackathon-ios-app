//
//  SHCategoriesViewController.m
//  TUTCafeterias
//
//  Created by Aleksander Grzyb on 25/04/15.
//  Copyright (c) 2015 Aleksander Grzyb. All rights reserved.
//

#import "SHCategoriesViewController.h"
#import "SHConstants.h"
#import "SHCategoriesTableViewCell.h"
#import "SHCategoriesHeader.h"

@interface SHCategoriesViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSDictionary *cafeteriasDictionary;
@property (strong, nonatomic) NSDictionary *dishTypeDictionary;
@property (strong, nonatomic) NSDictionary *typeDictionary;
@end

@implementation SHCategoriesViewController

#pragma mark -
#pragma mark View Controller Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:0.271 green:0.271 blue:0.271 alpha:1];
    [self customizeTableView];
}

- (void)loadView
{
    [super loadView];
    UITableView *tableView = [[UITableView alloc] init];
    self.tableView = tableView;
    [self.view addSubview:tableView];
}

- (void)viewWillLayoutSubviews
{
    self.tableView.frame = CGRectMake(0.0f, TABLE_VIEW_TOP_OFSSET, self.view.bounds.size.width,
                                      self.view.bounds.size.height - TABLE_VIEW_TOP_OFSSET);
}

#pragma mark -
#pragma mark Getters

- (NSDictionary *)cafeteriasDictionary
{
    if (!_cafeteriasDictionary) {
        _cafeteriasDictionary = @{
                                  @(SCI_POSITION) : SCI_TEXT,
                                  @(SOC_POSITION) : SOC_TEXT,
                                  @(U06_POSITION) : U06_TEXT,
                                  @(LIB_POSITION) : LIB_TEXT,
                                  @(U04_POSITION) : U04_TEXT,
                                  @(U01_POSITION) : U01_TEXT
                                  };
    }
    return _cafeteriasDictionary;
}

- (NSDictionary *)dishTypeDictionary
{
    if (!_dishTypeDictionary) {
        _dishTypeDictionary = @{
                                @(DISH_TYPE_DRINK_POSITION) : DISH_TYPE_DRINK_TEXT,
                                @(DISH_TYPE_MEAT_POSITION) : DISH_TYPE_MEAT_TEXT,
                                @(DISH_TYPE_VEGETARIAN_POSITION) : DISH_TYPE_VEGETARIAN_TEXT,
                                @(DISH_TYPE_VEGAN_POSITION) : DISH_TYPE_VEGAN_TEXT
                                };
    }
    return _dishTypeDictionary;
}

- (NSDictionary *)typeDictionary
{
    if (!_typeDictionary) {
        _typeDictionary = @{
                            @(TYPE_PIZZA_POSITION) : TYPE_PIZZA_TEXT,
                            @(TYPE_DRINK_POSITION) : TYPE_DRINK_TEXT,
                            @(TYPE_FRUIT_POSITION) : TYPE_FRUIT_TEXT,
                            @(TYPE_SNACK_POSITION) : TYPE_SNACK_TEXT,
                            @(TYPE_SOUP_POSITION) : TYPE_SOUP_TEXT,
                            @(TYPE_DESERT_POSITION) : TYPE_DESERT_TEXT,
                            @(TYPE_LUNCH_POSITION) : TYPE_LUNCH_TEXT,
                            @(TYPE_DINNER_POSITION) : TYPE_DINNER_TEXT,
                            @(TYPE_BREAKFEST_POSITION) : TYPE_BREAKFEST_TEXT
                            };
    }
    return _typeDictionary;
}

#pragma mark -
#pragma mark Table View Data Source

#define NUMBER_OF_SECTIONS 3

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return NUMBER_OF_SECTIONS;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case CAFETERIA_HEADER_POSITION:
            return self.cafeteriasDictionary.count;
            break;
        case DISH_TYPE_HEADER_POSITION:
            return self.dishTypeDictionary.count;
            break;
        case TYPE_HEADER_POSITION:
            return self.typeDictionary.count;
            break;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    SHCategoriesHeader *categoriesHeader = [[SHCategoriesHeader alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 18)];
    categoriesHeader.textColor = [UIColor colorWithRed:0.867 green:0.867 blue:0.867 alpha:1];
    categoriesHeader.backgroundColor = [UIColor colorWithWhite:0.130 alpha:1.000];
    switch (section) {
        case CAFETERIA_HEADER_POSITION:
            categoriesHeader.text = CAFETERIA_HEADER_TEXT;
            return categoriesHeader;
            break;
        case DISH_TYPE_HEADER_POSITION:
            categoriesHeader.text = DISH_TYPE_HEADER_TEXT;
            return categoriesHeader;
            break;
        case TYPE_HEADER_POSITION:
            categoriesHeader.text = TYPE_HEADER_TEXT;
            return categoriesHeader;
            break;
    }
    return categoriesHeader;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 28.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CategoriesCell";
    SHCategoriesTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    switch (indexPath.section) {
        case CAFETERIA_HEADER_POSITION:
            cell.textLabel.text = self.cafeteriasDictionary[@(indexPath.row)];
            break;
        case TYPE_HEADER_POSITION:
            cell.textLabel.text = self.typeDictionary[@(indexPath.row)];
            break;
        case DISH_TYPE_HEADER_POSITION:
            cell.textLabel.text = self.dishTypeDictionary[@(indexPath.row)];
            break;
    }
    return cell;
}

#pragma mark -
#pragma mark Table View Customization

- (void)customizeTableView
{
    [self.tableView registerClass:[SHCategoriesTableViewCell class] forCellReuseIdentifier:@"CategoriesCell"];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor colorWithRed:0.271 green:0.271 blue:0.271 alpha:1];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

@end
