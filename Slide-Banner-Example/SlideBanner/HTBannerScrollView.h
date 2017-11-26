//
//  HTBannerScrollView.h
//
//
//  Created by Hoang Van Trung on 8/10/16.
//  
//
#import <UIKit/UIKit.h>
#import "HTBanner.h"
#import "UIImageView+HT.h"

@protocol HTBannerScrollViewDelegate <NSObject>

-(void) didTapInBanner:(HTBanner *) banner;

@end

@interface HTBannerScrollView : UIView<UIScrollViewDelegate>{
    UIScrollView* bannerScrollView;
    NSInteger currentBannerIndex;
    float bannerWidth, bannerHeight;
    NSMutableArray<UIImageView*>* itemShowingImages;
    UIView* itemShowingView;
    NSTimer* slideTimer;
}

@property float delayTime;
@property BOOL isShowedItemsView, isAutoSliding;
@property (strong, nonatomic) NSArray<HTBanner*> *banners;
@property id<HTBannerScrollViewDelegate> delegate;

-(void) startAnimating;
-(id) initWithFrame:(CGRect)frame delayTime:(float) delayTime;
-(id) initWithFrame:(CGRect)frame delayTime:(float)delayTime isShowedItemsView:(BOOL) isShowedItemsView;
-(id) initWithFrame:(CGRect)frame delayTime:(float)delayTime isShowedItemsView:(BOOL) isShowedItemsView isAutoSliding:(BOOL) isAutoSliding;

-(void) scrollNextBanner;

@end
