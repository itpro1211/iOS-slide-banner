//
//  HTBannerScrollView.m
//
//  Created by Hoang Van Trung on 8/10/16.
//
//

#import "HTBannerScrollView.h"

#define DEFAULT_DELAY_TIME 4

@interface HTBannerScrollView()
@end

@implementation HTBannerScrollView

- (id)initWithFrame:(CGRect)frame{
    return [self initWithFrame:frame delayTime:DEFAULT_DELAY_TIME];
}

- (id)initWithFrame:(CGRect)frame delayTime:(float)delayTime{
    return [self initWithFrame:frame delayTime:delayTime isShowedItemsView:YES];
}

- (id)initWithFrame:(CGRect)frame delayTime:(float)delayTime isShowedItemsView:(BOOL)isShowedItemsView{
    return [self initWithFrame:frame delayTime:delayTime isShowedItemsView:isShowedItemsView isAutoSliding:YES];
}

- (id)initWithFrame:(CGRect)frame delayTime:(float)delayTime isShowedItemsView:(BOOL)isShowedItemsView isAutoSliding:(BOOL)isAutoSliding{
    if(self == [super initWithFrame:frame]){
        _delayTime = delayTime;
        _isShowedItemsView = isShowedItemsView;
        _isAutoSliding = isAutoSliding;
    }
    return self;
}

- (void)setBanners:(NSArray<HTBanner *> *)banners{
    _banners = banners;
    //Create item showing view
    float itemSize = 10;
    float itemPaddingWidth = 5;
    //init values
    bannerWidth = self.frame.size.width;
    bannerHeight = self.frame.size.height;
    if(!bannerScrollView){
        bannerScrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        [bannerScrollView setShowsHorizontalScrollIndicator:NO];
        bannerScrollView.delegate = self;
        [self addSubview:bannerScrollView];
    }
    float itemPaddingHeight = 5;
    float itemShowingViewWidth = banners.count * (itemSize + itemPaddingWidth);
    if(!itemShowingView){
        itemShowingView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.frame) - itemShowingViewWidth, CGRectGetHeight(self.frame) - itemSize - itemPaddingHeight , itemShowingViewWidth, itemSize)];
        if(self.isShowedItemsView){
            [self addSubview:itemShowingView];
        }
        itemShowingImages = [[NSMutableArray alloc] initWithCapacity:0];
    }
    //Add banners and showing items
    if(banners.count > 1){
        UIImageView* leftBannerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, bannerWidth, bannerHeight)];
        [bannerScrollView addSubview:leftBannerImageView];
        HTBanner* leftBanner = [banners objectAtIndex:banners.count - 1];
        [leftBannerImageView loadBanner:leftBanner];
        leftBannerImageView.tag = banners.count - 1;
        
        for(int i = 0; i < banners.count; i++){
            HTBanner *banner = [banners objectAtIndex:i];
            UIImageView* bannerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(bannerWidth * (i+1), 0, bannerWidth, bannerHeight)];
            [bannerScrollView addSubview:bannerImageView];
            [bannerImageView loadBanner:banner];
            bannerImageView.tag = i;
            UIImageView* itemImageView = [[UIImageView alloc] initWithFrame:CGRectMake(i*(itemSize + itemPaddingWidth), 0, itemSize, itemSize)];
            [itemImageView setContentMode:UIViewContentModeScaleAspectFit];
            [itemShowingView addSubview:itemImageView];
            [itemShowingImages addObject:itemImageView];
        }
        UIImageView* rightBannerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(bannerWidth * (banners.count + 1), 0, bannerWidth, bannerHeight)];
        [bannerScrollView addSubview:rightBannerImageView];
        HTBanner *rightBanner = [banners objectAtIndex:0];
        [rightBannerImageView loadBanner:rightBanner];
        rightBannerImageView.tag = 0;
        
        [bannerScrollView setContentSize:CGSizeMake(bannerWidth * (banners.count +  2), bannerHeight)];
        [bannerScrollView setPagingEnabled:YES];
        currentBannerIndex = 1;
        [bannerScrollView scrollRectToVisible:CGRectMake(bannerWidth, 0, bannerWidth, bannerHeight) animated:NO];
        [self setShowingItemImage];
        if(_isAutoSliding)
            [self startAnimating];
    }else if(banners.count == 1){
        HTBanner *banner = [banners objectAtIndex:0];
        UIImageView* bannerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, bannerWidth, bannerHeight)];
        bannerImageView.tag = 0;
        [bannerScrollView addSubview:bannerImageView];
        [bannerImageView loadBanner:banner];
    }
    
    for(UIView* subView in bannerScrollView.subviews){
        if([subView isKindOfClass:[UIImageView class]]){
            UIImageView* imageView = (UIImageView*) subView;
            imageView.clipsToBounds = YES;
            imageView.userInteractionEnabled = YES;
            [imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapInBannerImage:)]];
        }
    }
}

- (void)didTapInBannerImage:(UIGestureRecognizer*)gestureRecog{
    UIImageView* bannerImage = (UIImageView*) gestureRecog.view;
    [self.delegate didTapInBanner:[_banners objectAtIndex:bannerImage.tag]];
}

- (void)startAnimating{
    slideTimer = [NSTimer scheduledTimerWithTimeInterval:_delayTime target:self selector:@selector(scrollNextBanner) userInfo:nil repeats:YES];
}

- (void)scrollNextBanner{
    currentBannerIndex++;
    [bannerScrollView scrollRectToVisible:CGRectMake(bannerWidth * currentBannerIndex, 0, bannerWidth, bannerHeight) animated:YES];
    if(currentBannerIndex < _banners.count)
       [self setShowingItemImage];
}

#pragma mark UIScrollViewDelegate
//after scroll to end of scrollview
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    if(currentBannerIndex == _banners.count + 1){
        [bannerScrollView scrollRectToVisible:CGRectMake(bannerWidth, 0, bannerWidth, bannerHeight) animated:NO];
        currentBannerIndex = 1;
    }
    [self setShowingItemImage];
}

//set currentBannerIndex after scroll manually
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    currentBannerIndex = scrollView.contentOffset.x / bannerWidth;
    if(currentBannerIndex == _banners.count + 1){
        [bannerScrollView scrollRectToVisible:CGRectMake(bannerWidth, 0, bannerWidth, bannerHeight) animated:NO];
        currentBannerIndex = 1;
    }else if(currentBannerIndex == 0){
        [bannerScrollView scrollRectToVisible:CGRectMake(_banners.count * bannerWidth, 0, bannerWidth, bannerHeight) animated:NO];
        currentBannerIndex = _banners.count;
    }
    [self setShowingItemImage];
    [slideTimer invalidate];
    if(_isAutoSliding)
        [self startAnimating];
}

//handle showing circle images
- (void)setShowingItemImage{
    for(UIImageView* imageView in itemShowingImages){
        if(imageView == [itemShowingImages objectAtIndex:currentBannerIndex-1]){
            [imageView setImage:[UIImage imageNamed:@"ic_pagecontrolchoice"]];
        }else{
            [imageView setImage:[UIImage imageNamed:@"ic_pagecontrolnochoice"]];
        }
        imageView.image = [imageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    }
}

@end
