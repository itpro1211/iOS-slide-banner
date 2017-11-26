//
//  HTBanner.h
//  Slide-Banner-Example
//
//  Created by Hoang Van Trung on 11/24/17.
//  Copyright © 2017 Axe. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HTBanner : NSObject
@property (nonatomic) BOOL isURL;
@property (strong, nonatomic) NSString *bannerPath;

-(id)initWithPath:(NSString *)path isURL:(BOOL)isURL;
@end
