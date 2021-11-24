//
//  JPFUtil.m
//  JPFuncationSDK
//
//  Created by 任敬 on 2021/11/3.
//

#import "JPFUtil.h"

@implementation JPFUtil


+ (NSBundle *)bundleWithName:(NSString *)name{
    static NSBundle *bundle = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        bundle = [NSBundle bundleWithPath:[[NSBundle bundleForClass:[self class]] pathForResource:name ofType:@"bundle"]];
    });
    return bundle;
}

+ (UIImage *)imageNamed:(NSString *)name withBundle:(NSBundle *)bundle{
    if (name.length == 0) return nil;

    UIImage * image = [UIImage imageNamed:name inBundle:bundle compatibleWithTraitCollection:nil];
    
    return image;
}

@end
