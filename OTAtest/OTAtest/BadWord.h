//
//  BadWord.h
//  OTAtest
//
//  Created by admin on 2018/2/6.
//  Copyright © 2018年 test1. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BadWord : NSObject

+ (instancetype)getInstance;

- (NSString*)check:(NSString*)str;

@end
