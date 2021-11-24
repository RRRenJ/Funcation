//
//  UIScrollView+JPL.m
//  JPLSDK
//
//  Created by 任敬 on 2021/10/22.
//

#import "UIScrollView+JPL.h"
#import "MJRefresh.h"

@implementation UIScrollView (JPL)

- (void)jpl_addRefreshHeaderWithRefreshingBlock:(void(^)(void))refreshingBlock{

    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:refreshingBlock];
    header.stateLabel.textColor = [UIColor jpl_colorWithHexString:@"#999999"];
    header.stateLabel.font = [UIFont jpl_pingFangWithSize:14];
    header.lastUpdatedTimeLabel.hidden = YES;
    header.arrowView.image = nil;
    [header setTitle:@"加载中..." forState:MJRefreshStateRefreshing];
    self.mj_header = header;
}

- (void)jpl_addRefreshFooterWithRefreshingBlock:(void(^)(void))refreshingBlock{
    MJRefreshBackStateFooter *normalFooter =[MJRefreshBackStateFooter footerWithRefreshingBlock:refreshingBlock];
    normalFooter.stateLabel.textColor = [UIColor jpl_colorWithHexString:@"#757575"];
    normalFooter.stateLabel.font = [UIFont jpl_pingFangWithSize:14];
    [normalFooter setTitle:@"上拉加载更多" forState:MJRefreshStateIdle];
    [normalFooter setTitle:@"已经全部加载完毕" forState:MJRefreshStateNoMoreData];
    [normalFooter setTitle:@"加载中..." forState:MJRefreshStateRefreshing];
    self.mj_footer = normalFooter;
    self.mj_footer.hidden = YES;
}

- (void)jpl_startHeaderRefreshing{
    [self.mj_header beginRefreshing];
}

- (void)jpl_endHeaderAndFooterRefreshing{
    [self.mj_header endRefreshing];
    [self.mj_footer endRefreshing];
}


@end
