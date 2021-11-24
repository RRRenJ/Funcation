//
//  JPManager.m
//  JPSDK
//
//  Created by 任敬 on 2021/10/21.
//

#import "JPManager.h"
#import "JPStartSheetView.h"

@implementation JPManager

+ (void)loadConfige{
    [JPUtil createJperFolder];
    [JPUtil createJperFolderInDocument];
    [JPUtil loadCustomFont];
}

+ (void)showVideoEditAlert:(UIViewController *)vc hide:(nonnull void (^)(void))hideBlock{
    JPStartSheetView * view = [[JPStartSheetView alloc]init];
    [view show:vc];
    view.viewHideBlock = ^{
        hideBlock();
    };
   
}



@end
