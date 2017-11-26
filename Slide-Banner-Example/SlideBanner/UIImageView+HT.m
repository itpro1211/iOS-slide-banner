//
//  UIImageView+HT.m
//  Slide-Banner-Example
//
//  Created by Hoang Van Trung on 11/24/17.
//  Copyright © 2017 Axe. All rights reserved.
//

#import "UIImageView+HT.h"
#import "UIImageView+WebCache.h"

@implementation UIImageView (HT)
- (void)loadBanner:(HTBanner *)banner{
    if(banner.isURL){
        self.contentMode = UIViewContentModeScaleAspectFit;
        [self sd_setImageWithURL:[NSURL URLWithString:banner.bannerPath] placeholderImage:[UIImage imageNamed:@"loading"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            if(!error){
                self.clipsToBounds = YES;
                self.contentMode = UIViewContentModeScaleAspectFill;
            }
        }];
    }else{
        [self setImage:[UIImage imageNamed:banner.bannerPath]];
    }
}
@end
