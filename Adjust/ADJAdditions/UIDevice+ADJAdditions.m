//
//  UIDevice+ADJAdditions.m
//  Adjust
//
//  Created by Christian Wellenbrock on 23.07.12.
//  Copyright (c) 2012-2014 adjust GmbH. All rights reserved.
//

#import "UIDevice+ADJAdditions.h"
#import "NSString+ADJAdditions.h"

#import <sys/socket.h>
#import <sys/sysctl.h>
#import <net/if.h>
#import <net/if_dl.h>

#if !ADJUST_NO_IDFA
#import <AdSupport/ASIdentifierManager.h>
#endif

#if !ADJUST_NO_IDA
#import <iAd/iAd.h>
#endif

@implementation UIDevice(ADJAdditions)

- (BOOL)adjTrackingEnabled {
#if !ADJUST_NO_IDFA
    NSString *className  = [NSString adjJoin:@"A", @"S", @"identifier", @"manager", nil];
    NSString *keyManager = [NSString adjJoin:@"shared", @"manager", nil];
    NSString *keyEnabled = [NSString adjJoin:@"is", @"advertising", @"tracking", @"enabled", nil];

    Class class = NSClassFromString(className);
    if (class) {
        @try {
            SEL selManager = NSSelectorFromString(keyManager);
            SEL selEnabled = NSSelectorFromString(keyEnabled);

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            id manager   = [class performSelector:selManager];
            BOOL enabled = (BOOL)[manager performSelector:selEnabled];
#pragma clang diagnostic pop

            return enabled;
        } @catch (NSException *e) {
            return NO;
        }
    } else
#endif
    {
        return NO;
    }
}

- (NSString *)adjIdForAdvertisers {
#if !ADJUST_NO_IDFA
    NSString *className     = [NSString adjJoin:@"A", @"S", @"identifier", @"manager", nil];
    NSString *keyManager    = [NSString adjJoin:@"shared", @"manager", nil];
    NSString *keyIdentifier = [NSString adjJoin:@"advertising", @"identifier", nil];
    NSString *keyString     = [NSString adjJoin:@"UUID", @"string", nil];

    Class class = NSClassFromString(className);
    if (class) {
        @try {
            SEL selManager    = NSSelectorFromString(keyManager);
            SEL selIdentifier = NSSelectorFromString(keyIdentifier);
            SEL selString     = NSSelectorFromString(keyString);

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            id manager       = [class performSelector:selManager];
            id identifier    = [manager performSelector:selIdentifier];
            NSString *string = [identifier performSelector:selString];
#pragma clang diagnostic pop

            return string;
        } @catch (NSException *e) {
            return @"";
        }
    } else
#endif
    {
        return @"";
    }
}

- (NSString *)adjFbAttributionId {
    NSString *result = [UIPasteboard pasteboardWithName:@"fb_app_attribution" create:NO].string;
    if (result == nil) return @"";
    return result;
}

- (NSString *)adjMacAddress {
    int                 mib[6];
    size_t              len;
    char                *buf;
    unsigned char       *ptr;
    struct if_msghdr    *ifm;
    struct sockaddr_dl  *sdl;

    mib[0] = CTL_NET;
    mib[1] = AF_ROUTE;
    mib[2] = 0;
    mib[3] = AF_LINK;
    mib[4] = NET_RT_IFLIST;

    if ((mib[5] = if_nametoindex("en0")) == 0) {
        printf("Error: if_nametoindex error\n");
        return NULL;
    }

    if (sysctl(mib, 6, NULL, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 1\n");
        return NULL;
    }

    if ((buf = malloc(len)) == NULL) {
        printf("Could not allocate memory. error!\n");
        return NULL;
    }

    if (sysctl(mib, 6, buf, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 2");
        free(buf);
        return NULL;
    }

    ifm = (struct if_msghdr *)buf;
    sdl = (struct sockaddr_dl *)(ifm + 1);
    ptr = (unsigned char *)LLADDR(sdl);

    NSString *macAddress = [NSString stringWithFormat:@"%02X:%02X:%02X:%02X:%02X:%02X",
                            *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];

    free(buf);

    return macAddress;
}

- (NSString *)adjDeviceType {
    NSString *type = [self.model stringByReplacingOccurrencesOfString:@" " withString:@""];
    return type;
}

- (NSString *)adjDeviceName {
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *name = malloc(size);
    sysctlbyname("hw.machine", name, &size, NULL, 0);
    NSString *machine = [NSString stringWithUTF8String:name];
    free(name);
    return machine;
}

- (NSString *)adjCreateUuid {
    CFUUIDRef newUniqueId = CFUUIDCreate(kCFAllocatorDefault);
    CFStringRef stringRef = CFUUIDCreateString(kCFAllocatorDefault, newUniqueId);
    NSString *uuidString = (__bridge_transfer NSString*)stringRef;
    NSString *lowerUuid = [uuidString lowercaseString];
    CFRelease(newUniqueId);
    return lowerUuid;
}

- (NSString *)adjVendorId {
    if ([UIDevice.currentDevice respondsToSelector:@selector(identifierForVendor)]) {
        return [UIDevice.currentDevice.identifierForVendor UUIDString];
    }
    return @"";
}

- (void) adjSetIad:(ADJActivityHandler *) activityHandler{
#if !ADJUST_NO_IDA
    Class ADClientClass = NSClassFromString(@"ADClient");

    if (ADClientClass) {
        @try {
            SEL sharedClientSelector = NSSelectorFromString(@"sharedClient");
            SEL iadDateSelector = NSSelectorFromString(@"lookupAdConversionDetails:");
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            id ADClientSharedClientInstance = [ADClientClass performSelector:sharedClientSelector];

            [ADClientSharedClientInstance performSelector:iadDateSelector
                                               withObject:^(NSDate *appPurchaseDate, NSDate *iAdImpressionDate) {
                                                   [activityHandler setIadDate:iAdImpressionDate withPurchaseDate:appPurchaseDate];
                                               }];
#pragma clang diagnostic pop
        }
        @catch (NSException *exception) {
        }
    }
#endif
}
@end
