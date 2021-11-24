//
//  JPLLiveSettingSelectView.h
//  jper
//
//  Created by RRRenj on 2021/6/25.
//  Copyright © 2021 MuXiao. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JPLLiveSettingSelectView : UIView

@property (nonatomic, strong) NSArray <NSString *>* dataSource;

@property (nonatomic, copy) NSString *  selectTitle;

@property (nonatomic, copy) void(^selectBlock)(NSString * title);

- (void)show;

@end

NS_ASSUME_NONNULL_END
