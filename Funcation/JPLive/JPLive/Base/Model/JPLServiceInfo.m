//
//  JPLServiceInfo.m
//  JPLSDK
//
//  Created by 任敬 on 2021/11/1.
//

#import "JPLServiceInfo.h"


@implementation JPLServiceInfo

static JPLServiceInfo * info = nil;

+ (JPLServiceInfo *)share{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        info = [[JPLServiceInfo alloc]init];
    });
    return info;
}



@end
