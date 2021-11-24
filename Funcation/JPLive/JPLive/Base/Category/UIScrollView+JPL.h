//
//  UIScrollView+JPL.h
//  JPLSDK
//
//  Created by 任敬 on 2021/10/22.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIScrollView (JPL)

- (void)jpl_addRefreshHeaderWithRefreshingBlock:(void(^)(void))refreshingBlock;

- (void)jpl_addRefreshFooterWithRefreshingBlock:(void(^)(void))refreshingBlock;

- (void)jpl_startHeaderRefreshing;

- (void)jpl_endHeaderAndFooterRefreshing;

@end

NS_ASSUME_NONNULL_END
