//
//  JPLLiveSettingModel.m
//  jper
//
//  Created by RRRenj on 2021/6/24.
//  Copyright © 2021 MuXiao. All rights reserved.
//

#import "JPLLiveSettingModel.h"

@implementation JPLLiveSettingModel


+ (instancetype)shareInstance{
    static JPLLiveSettingModel * model = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        model = [[JPLLiveSettingModel alloc]init];
    });
    return model;
}




- (instancetype)init{
    self = [super init];
    if (self) {

    }
    return self;
}


- (BOOL)isBackCamera{
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"JPLLiveBackCamera"];
}

- (void)setIsBackCamera:(BOOL)isBackCamera{
    [[NSUserDefaults standardUserDefaults] setBool:isBackCamera forKey:@"JPLLiveBackCamera"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (BOOL)isPortrait{
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"JPLLivePortrait"];
}

- (void)setIsPortrait:(BOOL)isPortrait{
    [[NSUserDefaults standardUserDefaults] setBool:isPortrait forKey:@"JPLLivePortrait"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
