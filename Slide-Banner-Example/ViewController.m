//
//  ViewController.m
//  Slide-Banner-Example
//
//  Created by Hoang Van Trung on 11/24/17.
//  Copyright © 2017 Axe. All rights reserved.
//

#import "ViewController.h"
#import "HTBannerScrollViewPad.h"

@interface ViewController ()

@end

@implementation ViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    float viewWidth = [UIScreen mainScreen].bounds.size.width;
    HTBannerScrollView *bannerScrollView;
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
       bannerScrollView = [[HTBannerScrollView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, viewWidth/2)];
    }else if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        bannerScrollView = [[HTBannerScrollViewPad alloc] initWithFrame:CGRectMake(0, 0, viewWidth, viewWidth/4)];
    }
    bannerScrollView.banners = @[[[HTBanner alloc] initWithPath:@"http://gugomo.com/media/simi/simiconnector/banner/IMG_0092.JPG" isURL:YES],[[HTBanner alloc] initWithPath:@"http://static.asiawebdirect.com/m/bangkok/portals/vietnam/shared/teasersL/hanoi/top10-hanoi/top10-hanoi-attractions/teaserMultiLarge/imageHilight/teaser.jpeg.jpg" isURL:YES],[[HTBanner alloc] initWithPath:@"http://static.asiawebdirect.com/m/bangkok/portals/vietnam/homepage/hanoi/hanoi-districts/pagePropertiesImage/hanoi-old-quarter.jpg.jpg" isURL:YES],[[HTBanner alloc] initWithPath:@"http://static.asiawebdirect.com/m/bangkok/portals/vietnam/shared/teasersL/hanoi/hanoi-attractions/teaserMultiLarge/imageHilight/teaser.jpeg.jpg" isURL:YES],[[HTBanner alloc] initWithPath:@"banner.jpg" isURL:NO]];
    [self.view addSubview:bannerScrollView];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
