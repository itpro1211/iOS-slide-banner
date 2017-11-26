//
//  HTBannerScrollViewPad.m
//
//
//  Created by Hoang Van Trung on 10/1/16.
//
//

#import "HTBannerScrollViewPad.h"

#define BANNER_PADDING 3

@implementation HTBannerScrollViewPad{
}
@synthesize banners;

- (void)setBanners:(NSArray<HTBanner *> *)banners_{
    banners = banners_;
    //init view
    bannerWidth = self.frame.size.width / 2;
    bannerHeight = self.frame.size.height;
    if(!bannerScrollView){
        bannerScrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        [bannerScrollView setShowsHorizontalScrollIndicator:NO];
        bannerScrollView.delegate = self;
        [self addSubview:bannerScrollView];
    }
    //Add banners and showing items
    if(banners.count > 1){
        UIImageView* prevLeftBannerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(-bannerWidth/2 + BANNER_PADDING, 0, bannerWidth - 2 * BANNER_PADDING, bannerHeight)];
        [prevLeftBannerImageView loadBanner:[banners objectAtIndex:banners.count - 2]];
        prevLeftBannerImageView.tag = banners.count - 2;
        [bannerScrollView addSubview:prevLeftBannerImageView];
        UIImageView* leftBannerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(bannerWidth/2 + BANNER_PADDING, 0, bannerWidth - 2*BANNER_PADDING, bannerHeight)];
        [bannerScrollView addSubview:leftBannerImageView];
        HTBanner *leftBanner = [banners objectAtIndex:banners.count - 1];
        [leftBannerImageView loadBanner:leftBanner];
        leftBannerImageView.tag = banners.count - 1;
        for(int i = 0; i < banners.count; i++){
            HTBanner *banner = [banners objectAtIndex:i];
            UIImageView* bannerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(bannerWidth *  (i + 1.5) + BANNER_PADDING, 0, bannerWidth - 2*BANNER_PADDING, bannerHeight)];
            bannerImageView.tag = i;
            [bannerScrollView addSubview:bannerImageView];
            [bannerImageView loadBanner:banner];
        }
        UIImageView* rightBannerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(bannerWidth * (banners.count + 1.5) + BANNER_PADDING, 0, bannerWidth - 2*BANNER_PADDING, bannerHeight)];
        [bannerScrollView addSubview:rightBannerImageView];
        HTBanner *rightBanner = [banners objectAtIndex:0];
        [rightBannerImageView loadBanner:rightBanner];
        rightBannerImageView.tag = 0;
        
        UIImageView* nextRightBannerImageView = [[UIImageView alloc] initWithFrame:CGRectMake((banners.count +
                                                                                            2.5) * bannerWidth + BANNER_PADDING, 0, bannerWidth - 2*BANNER_PADDING, bannerHeight)];
        [nextRightBannerImageView loadBanner:[banners objectAtIndex:1]];
        nextRightBannerImageView.tag = 1;
        [bannerScrollView addSubview:nextRightBannerImageView];
        
        [bannerScrollView setContentSize:CGSizeMake(bannerWidth * (banners.count +  3), bannerHeight)];
//        [bannerScrollView setPagingEnabled:YES];
        
        currentBannerIndex = 2;
        [bannerScrollView scrollRectToVisible:CGRectMake((currentBannerIndex)*bannerWidth, 0, bannerWidth, bannerHeight) animated:NO];
        if(self.isAutoSliding)
            [self startAnimating];
    }else if(banners.count ==  1){
        HTBanner *banner = [banners objectAtIndex:0];
        UIImageView* bannerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(bannerWidth/2, 0, bannerWidth, bannerHeight)];
        bannerImageView.tag = 0;
        [bannerScrollView addSubview:bannerImageView];
        [bannerImageView loadBanner:banner];
    }
    for(UIView* subView in bannerScrollView.subviews){
        if([subView isKindOfClass:[UIImageView class]]){
            UIImageView* imageView = (UIImageView*) subView;
            imageView.userInteractionEnabled = YES;
            [imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapInBannerImage:)]];
        }
    }
}

- (void)didTapInBannerImage:(UIGestureRecognizer*) gestureRecog{
    UIImageView* bannerImage = (UIImageView*) gestureRecog.view;
    [self.delegate didTapInBanner:[banners objectAtIndex:bannerImage.tag]];
}

- (void)startAnimating{
    slideTimer = [NSTimer scheduledTimerWithTimeInterval:self.delayTime target:self selector:@selector(scrollNextBanner) userInfo:nil repeats:YES];
}

- (void)scrollNextBanner{
    currentBannerIndex++;
    if(currentBannerIndex > banners.count + 2){
        currentBannerIndex = banners.count + 2;
    }
    [bannerScrollView scrollRectToVisible:CGRectMake(bannerWidth * (currentBannerIndex), 0, bannerWidth, bannerHeight) animated:YES];
}

#pragma mark UIScrollViewDelegate
//after scroll to end of scrollview
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    if(currentBannerIndex >= banners.count + 2){
        currentBannerIndex = 2;
        [bannerScrollView scrollRectToVisible:CGRectMake(bannerWidth * (currentBannerIndex - 1), 0, bannerWidth, bannerHeight) animated:NO];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
}

//set currentBannerIndex before dragging
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint*)targetContentOffset {
    currentBannerIndex = lrint(scrollView.contentOffset.x / bannerWidth) + 1;
    if(velocity.x > 0)
        currentBannerIndex++;
    else if(velocity.x < 0)
        currentBannerIndex--;
    targetContentOffset->x = (currentBannerIndex - 1) * bannerWidth;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if(currentBannerIndex >= banners.count + 2){
        currentBannerIndex = 2;
    }
    if(currentBannerIndex <= 1){
        currentBannerIndex = banners.count + 2;
    }
    [bannerScrollView scrollRectToVisible:CGRectMake(bannerWidth * (currentBannerIndex - 1), 0, bannerWidth, bannerHeight) animated:NO];
    if(self.isAutoSliding){
        [slideTimer invalidate];
        [self startAnimating];
    }
}



@end
