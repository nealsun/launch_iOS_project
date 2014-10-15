//
//  iDevice.h
//  memory
//
//  Created by neal on 14/10/16.
//  Copyright (c) 2014年 orz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface iDevice : NSObject

+ (iDevice *) device;

@property (readonly, nonatomic, unsafe_unretained) CGFloat systemVersion;
@property (readonly, nonatomic, strong) NSString *systemVersionString;
@property (readonly, nonatomic, strong) NSString *deviceModel;
@property (readonly, nonatomic, strong) NSString *UUID;
@property (readonly, nonatomic, strong) NSString *appVersion;
@property (readonly, nonatomic, strong) NSString *appBundleVersion;
@property (readonly, nonatomic, strong) NSString *globalDeviceId;

- (BOOL)isJailbroken;

@end
