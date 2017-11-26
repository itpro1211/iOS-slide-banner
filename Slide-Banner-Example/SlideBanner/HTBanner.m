//
//  HTBanner.m
//  Slide-Banner-Example
//
//  Created by Hoang Van Trung on 11/24/17.
//  Copyright © 2017 Axe. All rights reserved.
//

#import "HTBanner.h"

@implementation HTBanner
-(id)initWithPath:(NSString *)path isURL:(BOOL)isURL{
    if(self == [super init]){
        self.isURL = isURL;
        self.bannerPath = path;
    }
    return self;
}
@end
