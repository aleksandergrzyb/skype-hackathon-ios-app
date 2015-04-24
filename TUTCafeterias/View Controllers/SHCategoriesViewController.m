//
//  SHCategoriesViewController.m
//  TUTCafeterias
//
//  Created by Aleksander Grzyb on 25/04/15.
//  Copyright (c) 2015 Aleksander Grzyb. All rights reserved.
//

#import "SHCategoriesViewController.h"
#import "constants.h"

@interface SHCategoriesViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) UITableView *tableView;

@end

@implementation SHCategoriesViewController

#pragma mark -
#pragma mark View Controller Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:0.271 green:0.271 blue:0.271 alpha:1];
    [self customizeTableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    self.tableView.frame = CGRectMake(0.0f, TABLE_VIEW_TOP_OFSSET, self.view.bounds.size.width, self.view.bounds.size.height - TABLE_VIEW_TOP_OFSSET);
}

#pragma mark -
#pragma mark Table View Style

- (void)customizeTableView
{
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor colorWithRed:0.271 green:0.271 blue:0.271 alpha:1];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

#pragma mark -
#pragma mark Table View Data Source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return 0;
}




@end
