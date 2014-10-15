//
//  «FILENAME»
//  «PROJECTNAME»
//
//  Created by «FULLUSERNAME» on «DATE».
//  Copyright «YEAR» «ORGANIZATIONNAME». All rights reserved.
//	File created using Singleton XCode Template by Mugunth Kumar (http://mugunthkumar.com
//  Permission granted to do anything, commercial/non-commercial with this file apart from removing the line/URL above

#import "iDevice.h"
#include <sys/socket.h>
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>

#define kApplicationUUIDKey @"ApplicaitonUUIDKey"

static iDevice *_instance;

@implementation iDevice {
    float _systemVersion;
    NSString *_systemVersionString;
    NSString *_UUID;
    NSString *_appVersion;
    NSString *_appBundleVersion;
    NSString *_deviceModel;
}


+ (iDevice *)device
{
	@synchronized(self) {
		
        if (_instance == nil) {
            _instance = [[self alloc] init];
        }
    }
    return _instance;
}

- (id)init {
    if (self = [super init]) {

    }
    return self;
}

- (float)systemVersion {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _systemVersion = [[[UIDevice currentDevice] systemVersion] floatValue];
    });
    return _systemVersion;
}

- (NSString *)systemVersionString {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _systemVersionString = [[UIDevice currentDevice] systemVersion];
    });
    return _systemVersionString;
}

- (NSString *)deviceModel {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        size_t size;

        sysctlbyname("hw.machine", NULL, &size, NULL, 0);

        char *machine = malloc(size);

        sysctlbyname("hw.machine", machine, &size, NULL, 0);

        _deviceModel = [NSString stringWithCString:machine encoding:NSUTF8StringEncoding];

        free(machine);

    });
    return _deviceModel;
}

- (NSString *)UUID {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _UUID = [[NSUserDefaults standardUserDefaults] objectForKey:kApplicationUUIDKey];
        if (!_UUID) {
            if ([[[self class] device] systemVersion] >= 6.0) {
                _UUID = [[NSUUID UUID] UUIDString];
            } else {
                CFUUIDRef UUID = CFUUIDCreate(NULL);
                _UUID = CFBridgingRelease(CFUUIDCreateString(NULL, UUID));
            }
        }
    });
    return _UUID;
}

- (NSString *)appVersion {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSDictionary* infoDict = [[NSBundle mainBundle] infoDictionary];
        NSString* version = infoDict[@"CFBundleShortVersionString"];
        _appVersion = version;
    });
    return _appVersion;
}

- (NSString *)appBundleVersion {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSDictionary* infoDict = [[NSBundle mainBundle] infoDictionary];
        NSString* version = infoDict[@"CFBundleVersion"];
        _appBundleVersion = version;
    });
    return _appBundleVersion;
}

- (BOOL)isJailbroken {
    BOOL jailbroken = NO;
    NSString *cydiaPath = @"/Applications/Cydia.app";
    NSString *aptPath = @"/private/var/lib/apt/";
    if ([[NSFileManager defaultManager] fileExistsAtPath:cydiaPath]) {
        jailbroken = YES;
    }
    if ([[NSFileManager defaultManager] fileExistsAtPath:aptPath]) {
        jailbroken = YES;
    }  
    return jailbroken;  
}  

- (NSString *)globalDeviceId {
    //2013.05.01 Apple不允许使用udid，改用mac地址
    //2013.16.19 iOS7不再支持mac地址，使用官方api，iOS5设备继续使用mac地址
    if ([[UIDevice currentDevice] respondsToSelector:@selector(identifierForVendor)]) {
        // This is will run if it is iOS6
        NSUUID *uv = [[UIDevice currentDevice] identifierForVendor];
        if (uv) {
            return [uv UUIDString];
        }else{
            return [self getMACAddress];
        }
    } else {
        return [self getMACAddress];
    }
}

- (NSString *)getMACAddress{
    static NSString *macAddress = nil;
    if (macAddress == nil)
    {
        //set up managment information base
        int mib[] =
        {
            CTL_NET,
            AF_ROUTE,
            0,
            AF_LINK,
            NET_RT_IFLIST,
            if_nametoindex("en0")
        };

        //get message size
        size_t length = 0;
        if (mib[5] == 0 || sysctl(mib, 6, NULL, &length, NULL, 0) < 0 || length == 0)
        {
            return nil;
        }

        //get message
        NSMutableData *data = [NSMutableData dataWithLength:length];
        if (sysctl(mib, 6, [data mutableBytes], &length, NULL, 0) < 0)
        {
            return nil;
        }

        //get socket address
        struct sockaddr_dl *socketAddress = ([data mutableBytes] + sizeof(struct if_msghdr));
        unsigned char *coreAddress = (unsigned char *)LLADDR(socketAddress);
        macAddress = [[NSString alloc] initWithFormat:@"%02X%02X%02X%02X%02X%02X",
                      coreAddress[0], coreAddress[1], coreAddress[2],
                      coreAddress[3], coreAddress[4], coreAddress[5]];
    }
    return macAddress;
}
#pragma mark Singleton Methods ARC
- (void)dealloc {
    // Should never be called, but just here for clarity really.
}
@end
