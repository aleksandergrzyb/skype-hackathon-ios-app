//
//  SHMenusViewController.m
//  TUTCafeterias
//
//  Created by Aleksander Grzyb on 26/04/15.
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

#import "SHMenusViewController.h"
#import "SHMapViewController.h"
#import "SHConstants.h"
#import "SHDishType.h"
#import "SHType.h"
#import "SHFood.h"
#import <DateTools.h>
#import <Parse/Parse.h>

@interface SHMenusViewController () <ViewPagerDataSource, ViewPagerDelegate>
@property (strong, nonatomic) NSArray *food;
@property (strong, nonatomic) NSMutableArray *cafeterias;
@property (strong, nonatomic) SHFoodViewController *todayFoodViewController;
@property (strong, nonatomic) SHFoodViewController *tomorrowFoodViewController;
@end

@implementation SHMenusViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self loadData];
    [self configureNavigationController];
    [self configureDynamicsDrawer];
    self.dataSource = self;
    self.delegate = self;
}

#pragma mark -
#pragma mark Getters

- (SHFoodViewController *)todayFoodViewController
{
    if (!_todayFoodViewController) {
        _todayFoodViewController = [SHFoodViewController new];
    }
    return _todayFoodViewController;
}

- (SHFoodViewController *)tomorrowFoodViewController
{
    if (!_tomorrowFoodViewController) {
        _tomorrowFoodViewController = [SHFoodViewController new];
    }
    return _tomorrowFoodViewController;
}

#pragma mark -
#pragma mark Setters

- (void)setFilters:(NSArray *)filters
{
    if (_filters == filters) {
        return;
    }
    _filters = filters;
    self.tomorrowFoodViewController.filters = filters;
    self.todayFoodViewController.filters = filters;
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
            [self loadFoodToViewControllers];
        }
        else {
            NSLog(@"%@", error.description);
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Check your network connection" message:error.description delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [alertView show];
        }
    }];
}

- (void)loadFoodToViewControllers
{
    NSDate *today = [NSDate date];
    NSInteger todayNumber = today.dayOfYear;

    NSMutableArray *todayFood = [NSMutableArray new];
    NSMutableArray *tomorrowFood = [NSMutableArray new];

    for (SHFood *food in self.food) {
        NSInteger foodDayNumber = food.date.dayOfYear;
        if (foodDayNumber == todayNumber) {
            [todayFood addObject:food];
        } else if (foodDayNumber == todayNumber + 1){
            [tomorrowFood addObject:food];
        }
    }

    self.todayFoodViewController.food = [todayFood copy];
    self.tomorrowFoodViewController.food = [tomorrowFood copy];
}

#pragma mark -
#pragma mark Navigation Configuration

- (void)configureNavigationController
{
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
    SHMapViewController *mapViewController = [SHMapViewController new];
    [self.navigationController pushViewController:mapViewController animated:YES];
}

#pragma mark -
#pragma mark Dynamics Drawer Configuration

- (void)configureDynamicsDrawer
{
    [self.dynamicsDrawerViewController setPaneDragRevealEnabled:NO forDirection:MSDynamicsDrawerDirectionAll];
    [self.dynamicsDrawerViewController setRevealWidth:self.view.frame.size.width - REVEAL_OFFSET forDirection:MSDynamicsDrawerDirectionLeft];
}

#pragma mark -
#pragma mark View Pager Data Source

#define NUMBER_OF_TABS 2

- (NSUInteger)numberOfTabsForViewPager:(ViewPagerController *)viewPager
{
    return NUMBER_OF_TABS;
}

- (UIView *)viewPager:(ViewPagerController *)viewPager viewForTabAtIndex:(NSUInteger)index
{
    UILabel *label = [UILabel new];
    if (index == 0) {
        label.text = [NSString stringWithFormat:@"Today"];
    } else {
        label.text = [NSString stringWithFormat:@"Tomorrow"];
    }
    [label sizeToFit];
    return label;
}

- (UIViewController *)viewPager:(ViewPagerController *)viewPager contentViewControllerForTabAtIndex:(NSUInteger)index
{
    if (index == 0) {
        return self.todayFoodViewController;
    } else {
        return self.tomorrowFoodViewController;
    }
}

#pragma mark -
#pragma mark View Pager Delegate

- (void)viewPager:(ViewPagerController *)viewPager willChangeTabToIndex:(NSUInteger)index
{
    [self.todayFoodViewController.tableView setShowsVerticalScrollIndicator:NO];
    [self.tomorrowFoodViewController.tableView setShowsVerticalScrollIndicator:NO];
}

- (void)viewPager:(ViewPagerController *)viewPager didChangeTabToIndex:(NSUInteger)index
{
    [self.todayFoodViewController.tableView setShowsVerticalScrollIndicator:YES];
    [self.tomorrowFoodViewController.tableView setShowsVerticalScrollIndicator:YES];
}

- (CGFloat)viewPager:(ViewPagerController *)viewPager valueForOption:(ViewPagerOption)option withDefault:(CGFloat)value;
{
    if (option == ViewPagerOptionTabWidth) {
        return self.view.frame.size.width * 0.5;
    } else {
        return value;
    }
}

- (UIColor *)viewPager:(ViewPagerController *)viewPager colorForComponent:(ViewPagerComponent)component withDefault:(UIColor *)color
{
    if (component == ViewPagerIndicator) {
        return [UIColor colorWithRed:0.82 green:0.07 blue:0.13 alpha:1];
    }
    else if (component == ViewPagerTabsView || component == ViewPagerContent) {
        return [UIColor colorWithRed:1 green:0.9 blue:0.67 alpha:1];
    }
    return color;
}

@end
