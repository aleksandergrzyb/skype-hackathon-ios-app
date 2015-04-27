//
//  SHMapViewController.m
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
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 64)];
    self.scrollView = scrollView;
    self.scrollView.delegate = self;
    self.scrollView.minimumZoomScale = 0.7;
    self.scrollView.maximumZoomScale = 1.0;
    self.scrollView.zoomScale = 1.0;
    [self.view addSubview:self.scrollView];

    UIImage *mapImage = [UIImage imageNamed:@"map"];
    UIImageView *mapView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, mapImage.size.width, mapImage.size.height)];
    self.mapView = mapView;
    self.mapView.image = mapImage;
    self.mapView.contentMode = UIViewContentModeTopLeft;
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
