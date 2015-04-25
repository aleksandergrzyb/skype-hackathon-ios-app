//
//  SHMapViewController.m
//  TUTCafeterias
//
//  Created by Aleksander Grzyb on 25/04/15.
//  Copyright (c) 2015 Aleksander Grzyb. All rights reserved.
//

#import "SHMapViewController.h"

@interface SHMapViewController () <UIScrollViewDelegate>
@property (weak, nonatomic) UIImageView *mapView;
@property (weak, nonatomic) UIScrollView *scrollView;
@end

@implementation SHMapViewController

#pragma mark -
#pragma mark View Controller Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self customizeNavigationBar];
    [self addImage];
    self.view.backgroundColor = [UIColor whiteColor];
}


#pragma mark -
#pragma mark Image View

- (void)addImage
{
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    self.scrollView = scrollView;
    self.scrollView.delegate = self;
    self.scrollView.minimumZoomScale = 1.0;
    self.scrollView.maximumZoomScale = 5.0;
    self.scrollView.zoomScale = 1.0;
    [self.view addSubview:self.scrollView];

    UIImageView *mapView = [[UIImageView alloc] init];
    self.mapView = mapView;
    self.mapView.image = [UIImage imageNamed:@"map"];
    self.mapView.frame = CGRectMake(0.0f, 0.0f, self.mapView.image.size.width, self.mapView.image.size.height);
    self.scrollView.contentSize = self.mapView.image.size;
    [self.scrollView addSubview:self.mapView];
}

#pragma mark -
#pragma mark Scroll View Delegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.mapView;
}

#pragma mark -
#pragma mark Navigation Bar Customization

- (void)customizeNavigationBar
{
     self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:0.82 green:0.07 blue:0.13 alpha:1];
    [self.navigationController.navigationBar setTitleTextAttributes:@{
                                                                     NSFontAttributeName : [UIFont fontWithName:@"Homestead-Regular" size:22.0f],
                                                                     NSForegroundColorAttributeName : [UIColor colorWithRed:0.82 green:0.07 blue:0.13 alpha:1],
                                                                     NSBackgroundColorAttributeName : [UIColor clearColor],
                                                                     NSKernAttributeName : [NSNumber numberWithFloat:1.0f]
                                                                     }];


    [self.navigationItem setTitle:@"Map"];

}

@end
