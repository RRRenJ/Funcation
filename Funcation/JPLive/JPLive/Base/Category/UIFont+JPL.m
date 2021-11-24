//
//  UIFont+JPL.m
//  JPLSDK
//
//  Created by 任敬 on 2021/10/22.
//

#import "UIFont+JPL.h"

@implementation UIFont (JPL)

+ (UIFont *)jpl_pingFangWithSize:(CGFloat)size {
    return [self jpl_pingFangWithSize:size weight:UIFontWeightRegular];
}

+ (UIFont *)jpl_pingFangWithSize:(CGFloat)size weight:(UIFontWeight)weight{
    UIFont * font ;
    if (weight == UIFontWeightThin) {
        font = [UIFont fontWithName:@"PingFangSC-Thin" size:size];
    }else if(weight == UIFontWeightUltraLight){
        font = [UIFont fontWithName:@"PingFangSC-Ultralight" size:size];
    }else if(weight == UIFontWeightLight){
        font = [UIFont fontWithName:@"PingFangSC-Light" size:size];
    }else if(weight == UIFontWeightRegular){
        font = [UIFont fontWithName:@"PingFangSC-Regular" size:size];
    }else if(weight == UIFontWeightMedium){
        font = [UIFont fontWithName:@"PingFangSC-Medium" size:size];
    }else if(weight == UIFontWeightSemibold){
        font = [UIFont fontWithName:@"PingFangSC-Semibold" size:size];
    }else{
        font = [UIFont fontWithName:@"PingFangSC-Regular" size:size];
    }
    return font;
}

@end
