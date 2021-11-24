//
//  JPLLiveVideoAPMFooterView.h
//  jper
//
//  Created by RRRenJ on 2020/9/27.
//  Copyright © 2020 MuXiao. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JPLLiveVideoAPMFooterView : UITableViewHeaderFooterView

@property (nonatomic, copy) void(^appointmentBlock)();

@end

NS_ASSUME_NONNULL_END
