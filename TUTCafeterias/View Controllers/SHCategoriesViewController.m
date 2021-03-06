//
//  SHCategoriesViewController.m
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

#import "SHCategoriesViewController.h"
#import "SHConstants.h"
#import "SHCategoriesTableViewCell.h"
#import "SHCategoriesHeader.h"

@interface SHCategoriesViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) UITableView *tableView;
@property (weak, nonatomic) UILabel *categorizeByLabel;
@property (strong, nonatomic) NSDictionary *cafeteriasDictionary;
@property (strong, nonatomic) NSDictionary *dishTypeDictionary;
@property (strong, nonatomic) NSDictionary *typeDictionary;
@property (strong, nonatomic) NSMutableArray *nonSelectedCheckmarksArray;
@property (strong, nonatomic) NSDictionary *categoriesPhotoDictionary;
@property (strong, nonatomic) NSMutableArray *filters;
@end

@implementation SHCategoriesViewController

#pragma mark -
#pragma mark View Controller Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:0.27 green:0.27 blue:0.27 alpha:1];
    [self customizeTableView];
}

- (void)loadView
{
    [super loadView];
    UITableView *tableView = [[UITableView alloc] init];
    self.tableView = tableView;
    [self.view addSubview:tableView];

    UILabel *categorizeByLabel = [[UILabel alloc] initWithFrame:CGRectMake(CATEGORIZE_BY_LABEL_LEFT_OFFSET,
                                                                           CATEGORIZE_BY_LABEL_TOP_OFFSET,
                                                                           0.0f, 0.0f)];
    self.categorizeByLabel = categorizeByLabel;


    NSDictionary *atrributedStringAttributes = @{
                                                 NSFontAttributeName : [UIFont fontWithName:@"Homestead-Regular" size:22.0f],
                                                 NSForegroundColorAttributeName : [UIColor whiteColor],
                                                 NSBackgroundColorAttributeName : [UIColor clearColor],
                                                 NSKernAttributeName : [NSNumber numberWithFloat:1.0f]
                                                 };

    self.categorizeByLabel.attributedText = [[NSAttributedString alloc] initWithString:@"Categories" attributes:atrributedStringAttributes];;
    [self.categorizeByLabel sizeToFit];
    [self.view addSubview:self.categorizeByLabel];
}

- (void)viewWillLayoutSubviews
{
    self.tableView.frame = CGRectMake(0.0f, TABLE_VIEW_TOP_OFSSET, self.view.frame.size.width - REVEAL_OFFSET,
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

- (NSDictionary *)categoriesPhotoDictionary
{
    if (!_categoriesPhotoDictionary) {
        _categoriesPhotoDictionary = @{
                                       @(TYPE_FRUIT_POSITION) : [UIImage imageNamed:@"fruit"],
                                       @(TYPE_FRUIT_POSITION) : [UIImage imageNamed:@"fruit"],
                                       @(TYPE_FRUIT_POSITION) : [UIImage imageNamed:@"fruit"],
                                       @(TYPE_FRUIT_POSITION) : [UIImage imageNamed:@"fruit"],
                                       @(TYPE_FRUIT_POSITION) : [UIImage imageNamed:@"fruit"],
                                       @(TYPE_FRUIT_POSITION) : [UIImage imageNamed:@"fruit"],
                                       @(TYPE_FRUIT_POSITION) : [UIImage imageNamed:@"fruit"],
                                       @(TYPE_FRUIT_POSITION) : [UIImage imageNamed:@"fruit"],
                                       @(TYPE_FRUIT_POSITION) : [UIImage imageNamed:@"fruit"],
                                       };
    }
    return _categoriesPhotoDictionary;
}

- (NSMutableArray *)nonSelectedCheckmarksArray
{
    if (!_nonSelectedCheckmarksArray) {
        _nonSelectedCheckmarksArray = [NSMutableArray new];
    }
    return _nonSelectedCheckmarksArray;
}

- (NSMutableArray *)filters
{
    if (!_filters) {
        _filters = [NSMutableArray new];
    }
    return _filters;
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
    return HEADER_HEIGHT;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CategoriesCell";
    SHCategoriesTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
//    cell.imageView.image = self.categoriesPhotoDictionary[@(TYPE_FRUIT_POSITION)];
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
    if ([self.nonSelectedCheckmarksArray containsObject:indexPath]) {
        cell.accessoryView = nil;
    } else {
        cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"check"]];
    }
    return cell;
}

#pragma mark -
#pragma mark Table View Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SHCategoriesTableViewCell *cell = (SHCategoriesTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    if ([self.nonSelectedCheckmarksArray containsObject:indexPath]) {
        cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"check"]];
        [self.nonSelectedCheckmarksArray removeObject:indexPath];
        [self.filters removeObject:[self getFilterForIndexPath:indexPath]];
    } else {
        cell.accessoryView = nil;
        [self.nonSelectedCheckmarksArray addObject:indexPath];
        [self.filters addObject:[self getFilterForIndexPath:indexPath]];
    }
    [self.delegate viewController:self didUpdateFilters:[self.filters copy]];
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

#pragma mark -
#pragma mark Helpers

- (NSDictionary *)getFilterForIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *filter;
    switch (indexPath.section) {
        case DISH_TYPE_HEADER_POSITION:
            filter = @{
                       CATEGORY_TYPE_KEY : @(DishTypeFilter),
                       NAME_KEY : self.dishTypeDictionary[@(indexPath.row)]
                       };
            break;
        case TYPE_HEADER_POSITION:
            filter = @{
                       CATEGORY_TYPE_KEY : @(TypeFilter),
                       NAME_KEY : self.typeDictionary[@(indexPath.row)]
                       };
            break;
        case CAFETERIA_HEADER_POSITION:
            filter = @{
                       CATEGORY_TYPE_KEY : @(CafeteriaFilter),
                       NAME_KEY : self.cafeteriasDictionary[@(indexPath.row)]
                       };
            break;
    }
    return filter;
}

@end
