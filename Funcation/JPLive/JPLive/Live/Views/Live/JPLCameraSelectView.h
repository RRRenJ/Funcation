//
//  JPLCameraSelectView.h
//  jper
//
//  Created by RRRenJ on 2020/5/28.
//  Copyright © 2020 MuXiao. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JPLCameraSelectView : UIView

@property (nonatomic, copy) NSString *  selectTitle;

@property (nonatomic, copy) void(^selectBlock)(NSString * title);


- (void)show;

@end

NS_ASSUME_NONNULL_END
