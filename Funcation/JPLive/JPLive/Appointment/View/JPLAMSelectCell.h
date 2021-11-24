//
//  JPLAMSelectCell.h
//  JPLSDK
//
//  Created by 任敬 on 2021/10/28.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JPLAMSelectCell : UITableViewCell

@property (nonatomic, copy) NSString * title;

@property (nonatomic, copy) NSString * content;

@property (nonatomic, assign) BOOL isDefault;

@property (nonatomic, assign) BOOL  haveArrow;

@property (nonatomic, copy) void (^selectBlock)(NSString * content);


@end

NS_ASSUME_NONNULL_END
