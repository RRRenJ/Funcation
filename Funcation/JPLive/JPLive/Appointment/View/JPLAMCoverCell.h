//
//  JPLAMCoverCell.h
//  JPLSDK
//
//  Created by 任敬 on 2021/10/28.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JPLAMCoverCell : UITableViewCell

@property (nonatomic, strong) UIImage * coverImage;

@property (nonatomic, copy) void(^selectBlock)(void);


@end

NS_ASSUME_NONNULL_END
