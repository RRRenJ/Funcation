//
//  JPLLiveAddView.m
//  jper
//
//  Created by RRRenJ on 2020/5/29.
//  Copyright © 2020 MuXiao. All rights reserved.
//

#import "JPLLiveAddView.h"
#import "JPLLiveAddGoodsCell.h"

@interface JPLLiveAddView ()<UITableViewDelegate,UITableViewDataSource, UISearchBarDelegate,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>

@property (nonatomic, strong) UITableView * tableView;

@property (nonatomic, strong) UILabel * remindLb;

@property (nonatomic, strong) UIButton * comfirmBt;

@property (nonatomic, strong) UISearchBar * searchBar;

@property (nonatomic, strong) NSMutableArray <JPLLiveGoodsModel *>* dataArray;

@property (nonatomic, strong) NSMutableArray <JPLLiveGoodsModel *>* searchArray;

@property (nonatomic, strong) NSMutableArray <JPLLiveGoodsModel*> * addArray;

@property (nonatomic, assign) NSInteger page;

@property (nonatomic, assign) NSInteger searchPage;

@property (nonatomic, copy) NSString * keyword;

@property (nonatomic, assign) BOOL isSearch;



@end

@implementation JPLLiveAddView

- (instancetype)init{
    self = [super init];
    if (self) {
        [self setupViews];
        [self addActions];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self){
        [self setupViews];
        [self addActions];
    }
    return self;
}

- (void)dealloc{
    [self removeObserver:self forKeyPath:@"addArray"];
}

- (void)updateLayoutWithOrientation:(BOOL)isPortrait{
    if (isPortrait) {
        [self layoutWithPortrait];
    }else{
        [self layoutWithLandscape];
    }
}

- (void)setupViews{
    
    [self addSubview:self.remindLb];
    [self addSubview:self.comfirmBt];
    [self addSubview:self.searchBar];
    [self addSubview:self.tableView];
    
    
    self.keyword = @"";
    self.searchPage = 1;
    self.page = 1;
    __weak typeof(self) weakself  = self;
    [self.tableView jpl_addRefreshHeaderWithRefreshingBlock:^{
        if (weakself.isSearch) {
            weakself.searchPage = 1;
        }else{
            weakself.page = 1;
        }
        [weakself requestAllGoods];
    }];
    
    [self.tableView jpl_addRefreshFooterWithRefreshingBlock:^{
        if (weakself.isSearch) {
            weakself.searchPage++;
        }else{
            weakself.page++;
        }
        [weakself requestAllGoods];
    }];

    [self addViewMoveTopAnimation:NO];
}

- (void)layoutWithLandscape{
    CGFloat left = 0;
    if ((int)(JPL_SCR_WIDTH / JPL_SCR_HEIGHT * 100) == 216) {
         left = 34;
    }
    self.bounds = CGRectMake(0, 0, 0.62 * JPL_SCR_WIDTH - left, JPL_SCR_HEIGHT - 73);
    
    [self.comfirmBt mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.top.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(88, 30));
    }];
    [self.remindLb mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(self.comfirmBt.left).mas_offset(-10);
        make.centerY.mas_equalTo(self.comfirmBt.mas_centerY);
    }];
    
    [self.searchBar mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.top.mas_equalTo(self.comfirmBt.mas_bottom).mas_offset(15);
        make.height.mas_equalTo(30);
    }];
    
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.searchBar.mas_bottom).mas_offset(12);
        make.bottom.right.mas_equalTo(0);
        make.left.mas_equalTo(15);
    }];
    
    self.tableView.contentInset = UIEdgeInsetsZero;
    
}

- (void)layoutWithPortrait{

    self.bounds = CGRectMake(0, 0, JPL_SCR_WIDTH, 472 - 68);
    
    [self.comfirmBt mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.top.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(88, 30));
    }];
    [self.remindLb mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(self.comfirmBt.left).mas_offset(-10);
        make.centerY.mas_equalTo(self.comfirmBt.mas_centerY);
    }];
    
    [self.searchBar mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.top.mas_equalTo(self.comfirmBt.mas_bottom).mas_offset(15);
        make.height.mas_equalTo(30);
    }];
    
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.searchBar.mas_bottom).mas_offset(12);
        make.bottom.right.mas_equalTo(0);
        make.left.mas_equalTo(15);
    }];
    
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 20, 0);
    
}


- (void)addActions{
    [self addObserver:self forKeyPath:@"addArray" options:NSKeyValueObservingOptionNew context:nil];

    
}




- (void)addViewMoveTopAnimation:(BOOL)animation{
    self.remindLb.hidden = YES;
    self.comfirmBt.hidden = YES;
    [UIView animateWithDuration:animation ? 0.3 : 0 animations:^{
        [self.searchBar mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.right.mas_equalTo(-15);
            make.top.mas_equalTo(0);
            make.height.mas_equalTo(30);
        }];
        [self layoutIfNeeded];
    }];
    
}

- (void)addViewMoveBottomAnimation:(BOOL)animation{
    self.remindLb.hidden = NO;
    self.comfirmBt.hidden = NO;
    [UIView animateWithDuration:animation ? 0.3 : 0 animations:^{
        [self.searchBar mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.right.mas_equalTo(-15);
            make.top.mas_equalTo(self.comfirmBt.mas_bottom).mas_offset(15);
            make.height.mas_equalTo(30);
        }];
        [self layoutIfNeeded];
    }];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:@"addArray"]) {
        
        if ([self checkDataUpdate]) {

            [self addViewMoveBottomAnimation:YES];
            if (self.addArray.count > 0) {
                self.remindLb.text = @"确认添加选中商品?";
            }else{
                self.remindLb.text = @"确认删除所有待售商品?";
            }
        }else{

            [self addViewMoveTopAnimation:YES];
        }
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return  self.isSearch ? self.searchArray.count : self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    JPLLiveAddGoodsCell * cell = [tableView dequeueReusableCellWithIdentifier:@"JPLLiveAddGoodsCell" forIndexPath:indexPath];
    JPLLiveGoodsModel * model;
    if (self.isSearch) {
        model = self.searchArray[indexPath.row];
    }else{
        model = self.dataArray[indexPath.row];
    }
    cell.model = model;
    
    cell.selectBlock = ^BOOL(BOOL isSelect) {
        BOOL ishave = NO;
        JPLLiveGoodsModel * haveModel;
        for (JPLLiveGoodsModel * goodsModel in self.addArray) {
            if ([model.goods_id isEqualToString:goodsModel.goods_id]) {
                ishave = YES;
                haveModel = goodsModel;
            }
        }
       if (ishave) {
           
           if ([self.saleModel.goods_id isEqualToString:haveModel.goods_id]) {
               [MBProgressHUD jpl_showMessage:@"该商品正在展示,不能取消"];
               return  NO;
           }else{
               [[self mutableArrayValueForKey:@"addArray"] removeObject:haveModel];
               model.isSelect = NO;
               [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
               return  YES;
           }
       }else{
           [[self mutableArrayValueForKey:@"addArray"] addObject:model];
           model.isSelect = YES;
           [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
           return  YES;
       }
       
    };
    return  cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return  74;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    JPLLiveGoodsModel * model = self.dataArray[indexPath.row];
    BOOL ishave = NO;
    JPLLiveGoodsModel * haveModel;
    for (JPLLiveGoodsModel * goodsModel in self.addArray) {
        if ([model.goods_id isEqualToString:goodsModel.goods_id]) {
            ishave = YES;
            haveModel = goodsModel;
        }
    }
    if (ishave) {
        [[self mutableArrayValueForKey:@"addArray"] removeObject:haveModel];
        model.isSelect = NO;
    }else{
        [[self mutableArrayValueForKey:@"addArray"] addObject:model];
        model.isSelect = YES;
    }
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];

}

#pragma mark - <DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>
- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView {
    if (self.isSearch) {
        return self.searchArray.count == 0;
    }else{
        return self.dataArray.count == 0;
    }
}

// 返回图片
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView{
    return nil;
}

- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *text = @"";
    if (self.isSearch) {
        text = @"没有相关商品";
    }else{
        text = @"暂无商品内容";
    }
    NSMutableParagraphStyle *paragraph = [NSMutableParagraphStyle new];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    paragraph.alignment = NSTextAlignmentCenter;
    NSDictionary *attribute = @{NSFontAttributeName:[UIFont jpl_pingFangWithSize:14], NSForegroundColorAttributeName: [UIColor jpl_colorWithHexString:@"#666666"], NSParagraphStyleAttributeName: paragraph};
    return [[NSAttributedString alloc] initWithString:text attributes:attribute];
}

- (nullable UIColor *)backgroundColorForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIColor clearColor];
}

// 是否允许点击，默认NO
- (BOOL)emptyDataSetShouldAllowTouch:(UIScrollView *)scrollView {
    return YES;
}

- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView {
    return YES;
}

- (void)emptyDataSet:(UIScrollView *)scrollView didTapView:(UIView *)view {
    [self.tableView jpl_startHeaderRefreshing];
}


- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    if (self.searchBar.text > 0) {
        [self.searchBar endEditing:YES];
        self.isSearch = YES;
        self.keyword = searchBar.text;
        self.searchPage = 1;
        [self requestAllGoods];
    }else{
        [MBProgressHUD jpl_showMessage:@"请输入商品ID或名称"];
    }
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    if (self.beginEditBlock) {
        self.beginEditBlock();
    }
    return YES;
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar{
    if (self.endEditBlock) {
        self.endEditBlock();
    }
    return YES;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    if (searchText.length == 0) {
        self.isSearch = NO;
        self.keyword = @"";
        [self checkData];
    }
}

- (void)comfirmBtClicked{
    [self requestAddGoods];
    
}

- (void)endSearchEdit{
    [self.searchBar endEditing:YES];
}

- (void)refreshRequestData{
    self.isSearch = NO;
    self.keyword = @"";
    [self.tableView jpl_startHeaderRefreshing];

    [self addViewMoveTopAnimation:NO];
}

- (void)checkData{
    if (self.isSearch) {
        for (JPLLiveGoodsModel * searchModel in self.searchArray) {
            BOOL ishave = NO;
            for (JPLLiveGoodsModel * selectModel in self.addArray) {
                if ([selectModel.goods_id isEqualToString:searchModel.goods_id]) {
                    ishave = YES;
                }
            }
            searchModel.isSelect = ishave;
        }
    }else{
       for (JPLLiveGoodsModel * model in self.dataArray) {
            BOOL ishave = NO;
            for (JPLLiveGoodsModel * selectModel in self.addArray) {
                if ([selectModel.goods_id isEqualToString:model.goods_id]) {
                    ishave = YES;
                }
            }
            model.isSelect = ishave;
        }
    }
    [self.tableView reloadData];
}

- (BOOL)checkDataUpdate{
    if (self.selectArray.count == self.addArray.count) {
        for (JPLLiveGoodsModel * selectModel in self.selectArray) {
            BOOL isHave = NO;
            for (JPLLiveGoodsModel * model in self.addArray) {
                if ([model.goods_id isEqualToString:selectModel.goods_id]) {
                    isHave = YES;
                }
            }
            if (!isHave) {
                return YES;
            }
        }
        return  NO;
    }else{
        return YES;
    }
    
}

#pragma mark - request
- (void)requestAllGoods{
//    NSInteger page;
//    if (self.isSearch) {
//        page = self.searchPage;
//    }else{
//         page = self.page;
//    }
//
//    NSMutableDictionary *dic = @{@"service":@"App.Live_Goods.Lists",
//                                 @"token":[JPUserInfo shareInstance].token,
//                                 @"page" : @(page),
//                                 @"limit" : @(10),
//                                 @"keyword" : self.keyword
//                                }.mutableCopy;
//
//    [JPService requestWithURLString:API_HOST parameters:dic type:JPHttpRequestTypePost success:^(JPResultBase *response) {
//        if ([response.ret integerValue] == 200) {
//            NSArray * array = [JPLLiveGoodsModel mj_objectArrayWithKeyValuesArray:response.data];
//            if (self.isSearch) {
//                if (self.searchPage == 1) {
//                    [self.tableView resetNoMoreData];
//                    [self.searchArray removeAllObjects];
//                }
//                [self.searchArray addObjectsFromArray:array];
//            }else{
//                if (self.page == 1) {
//                    [self.tableView resetNoMoreData];
//                    [self.dataArray removeAllObjects];
//                }
//                [self.dataArray addObjectsFromArray:array];
//            }
//
//            if (array.count == 0) {
//                if (self.dataArray.count > 0) {
//                    [self.tableView endRefreshingWithNoMoreData];
//                }else{
//                    [self.tableView endHeaderAndFooterRefreshing];
//                }
//            }else{
//                [self.tableView showFooter];
//                [self.tableView endHeaderAndFooterRefreshing];
//            }
//            [self checkData];
//        }else {
//            if (self.isSearch) {
//                if (self.searchPage > 1) {
//                    self.searchPage--;
//                }
//            }else{
//                if (self.page > 1) {
//                    self.page--;
//                }
//            }
//            [MBProgressHUD jpl_showMessage:response.msg];
//            [self.tableView endHeaderAndFooterRefreshing];
//        }
//        self.tableView.emptyDataSetSource = self;
//        self.tableView.emptyDataSetDelegate = self;
//        [self.tableView reloadData];
//    } failure:^(NSError *error) {
//        if (self.isSearch) {
//            if (self.searchPage > 1) {
//                self.searchPage--;
//            }
//        }else{
//            if (self.page > 1) {
//                self.page--;
//            }
//        }
//        self.tableView.emptyDataSetSource = self;
//        self.tableView.emptyDataSetDelegate = self;
//        [self.tableView reloadData];
//        [self.tableView endHeaderAndFooterRefreshing];
//    } withErrorMsg:@"网络出错，请稍后重试"];
}

- (void)requestAddGoods{
//    [[JPLUtil currentViewController] jpl_showHUD];
//    NSMutableArray * array = [NSMutableArray array];
//    for (JPLLiveGoodsModel * model in self.addArray) {
//        [array addObject:model.goods_id];
//    }
//
//    NSMutableDictionary *dic = @{@"service":@"App.Live_Goods.Add",
//                                 @"token":[JPUserInfo shareInstance].token,
//                                 @"live_id" : @([self.live_id integerValue]),
//                                 @"live_goods_ids" : array,
//                                }.mutableCopy;
//
//    [JPService requestWithURLString:API_HOST parameters:dic type:JPHttpRequestTypePost success:^(JPResultBase *response) {
//
//        if ([response.ret integerValue] == 200) {
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                [[JPLUtil currentViewController] hidHUD];
//                [self.selectArray removeAllObjects];
//                [self.selectArray addObjectsFromArray:self.addArray];
//                [self checkData];
//                if (array.count > 0) {
//                    [MBProgressHUD jpl_showMessage:@"商品添加成功"];
//                }else{
//                    [MBProgressHUD jpl_showMessage:@"删除待售商品成功"];
//                }
//                [self addViewMoveTopAnimation:YES];
//            });
//        }else {
//            [[JPLUtil currentViewController] hidHUD];
//            [MBProgressHUD jpl_showMessage:response.msg];
//            [self.tableView endHeaderAndFooterRefreshing];
//        }
//    } failure:^(NSError *error) {
//        [[JPLUtil currentViewController] hidHUD];
//    } withErrorMsg:@"网络出错，请稍后重试"];
}

#pragma mark - set

- (void)setSelectArray:(NSMutableArray<JPLLiveGoodsModel *> *)selectArray{
    _selectArray = selectArray;
    for (JPLLiveGoodsModel * selectModel in selectArray) {
        BOOL isHave = NO;
        for (JPLLiveGoodsModel * model in self.addArray) {
            if ([model.goods_id isEqualToString:selectModel.goods_id]) {
                isHave = YES;
            }
        }
        if (!isHave) {
             [[self mutableArrayValueForKey:@"addArray"] addObject:selectModel];
        }
    }
   
    [self checkData];
}



#pragma mark - get
- (UIButton *)comfirmBt{
    if (!_comfirmBt) {
        _comfirmBt = [UIButton buttonWithType:UIButtonTypeCustom];
        [_comfirmBt setTitle:@"确定" forState:UIControlStateNormal];
        [_comfirmBt addTarget:self action:@selector(comfirmBtClicked) forControlEvents:UIControlEventTouchUpInside];
        _comfirmBt.backgroundColor = UIColor.whiteColor;
        [_comfirmBt setTitleColor:[UIColor jpl_colorWithHexString:@"#0091FF"] forState:UIControlStateNormal];
        _comfirmBt.titleLabel.font = [UIFont systemFontOfSize:12];
        _comfirmBt.layer.masksToBounds = YES;
        _comfirmBt.layer.cornerRadius = 15;
    }
    return _comfirmBt;
}

- (UILabel *)remindLb{
    if (!_remindLb) {
        _remindLb = [[UILabel alloc]init];
        _remindLb.text = @"请选择需要添加的商品";
        _remindLb.textColor = UIColor.whiteColor;
        _remindLb.font = [UIFont systemFontOfSize:15];
    }
    return _remindLb;
}

- (UISearchBar *)searchBar{
    if (!_searchBar) {
        _searchBar = [[UISearchBar alloc]init];
        _searchBar.searchBarStyle = UISearchBarStyleMinimal;
        _searchBar.tintColor = [UIColor jpl_colorWithHexString:@"#ADADAD"];
        _searchBar.placeholder = @"搜索商品ID或名称";
        _searchBar.layer.cornerRadius = 15;
        _searchBar.layer.masksToBounds = YES;
        _searchBar.backgroundImage = [UIImage new];
        _searchBar.backgroundColor = [UIColor colorWithWhite:1 alpha:0.24];
        UITextField * textField;
        if (@available(iOS 13, *)) {
            textField = _searchBar.searchTextField;
        }else {
            textField = [_searchBar valueForKey:@"_searchField"];
        }
        if (textField) {
            textField.textColor = UIColor.whiteColor;
            textField.font = [UIFont jpl_pingFangWithSize:14];
            textField.backgroundColor = [UIColor clearColor];
        }
        _searchBar.delegate = self;
    }
    return _searchBar;
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.backgroundColor = UIColor.clearColor;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[JPLLiveAddGoodsCell class] forCellReuseIdentifier:@"JPLLiveAddGoodsCell"];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (NSMutableArray<JPLLiveGoodsModel *> *)addArray{
    if (!_addArray) {
        _addArray = @[].mutableCopy;
    }
    return _addArray;
}

- (NSMutableArray<JPLLiveGoodsModel *> *)dataArray{
    if (!_dataArray) {
        _dataArray = @[].mutableCopy;
    }
    return _dataArray;
}

- (NSMutableArray<JPLLiveGoodsModel *> *)searchArray{
    if (!_searchArray) {
        _searchArray = @[].mutableCopy;
    }
    return _searchArray;
}

@end
