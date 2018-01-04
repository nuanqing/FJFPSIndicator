//
//  FJFPSIndicator.h
//  FJFPSIndicator
//
//  Created by MacBook on 2018/1/3.
//  Copyright © 2018年 MacBook. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface FJFPSIndicator : NSObject

+ (FJFPSIndicator *)sharedInstance;

- (void)start;

- (void)paused;

- (void)close;

@end
