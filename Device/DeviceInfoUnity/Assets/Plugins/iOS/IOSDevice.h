//
//  Header.h
//  DeviceInfo
//
//  Created by zhanghaijun on 2018/10/31.
//  Copyright © 2018 zhanghaijun. All rights reserved.
//

#ifndef Header_h
#define Header_h
#import <Foundation/Foundation.h>
#import "Reachability.h"

@interface IOSDevice : NSObject
@property (nonatomic)  NSString* statusString ;
- (void)Init;
- (void)updateInterfaceWithReachability:(Reachability *)reachability;
@end
#endif /* Header_h */
