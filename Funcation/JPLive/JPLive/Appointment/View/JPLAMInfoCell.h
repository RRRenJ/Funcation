//
//  JPLAMInfoCell.h
//  JPLSDK
//
//  Created by 任敬 on 2021/10/28.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JPLAMInfoCell : UITableViewCell

@property (nonatomic, copy) NSString * title;

@property (nonatomic, copy) NSString * startTime;

@property (nonatomic, copy) NSString * endTime;

@property (nonatomic, copy) void(^liveNameBlock)(NSString * name);

@property (nonatomic, copy) void(^startTimeBlock)(NSString * startTime);

@property (nonatomic, copy) void(^endTimeBlock)(NSString * endtTime);

@end

NS_ASSUME_NONNULL_END
