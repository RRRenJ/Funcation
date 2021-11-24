//
//  JPLLiveListViewController.m
//  JPLSDK
//
//  Created by 任敬 on 2021/11/1.
//

#import "JPLLiveListViewController.h"
#import "JPLLiveListCell.h"
#import "JPLLiveViewController.h"
#import "JPLAMViewController.h"

#import "JPLLiveSettingModel.h"

@interface JPLLiveListViewController ()<UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>

@property (nonatomic, strong) UITableView * tableView;

@property (nonatomic, strong) UIButton * backBt;

@property (nonatomic, strong) UIView * naviBar;

@property (nonatomic, strong) UIButton * amBt;

@property (nonatomic, strong) UILabel * titleLb;


@property (nonatomic, strong) NSMutableArray <JPLLiveAMModel *>* dataArray;
///正在直播的直播
@property (nonatomic, strong) NSMutableArray <JPLLiveAMModel *>* currentArray;
///预约的直播
@property (nonatomic, strong) NSMutableArray <JPLLiveAMModel *>* waitArray;
///结束的直播
@property (nonatomic, strong) NSMutableArray <JPLLiveAMModel *>* pastArray;

@property (nonatomic, assign) NSInteger  page;

@end

@implementation JPLLiveListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupViews];
  
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.page = 1;
    [self requestData:self.page];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
   
}

- (void)popToLastVC{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma - mark init view
- (void)setupViews{
    self.titleLb.text = @"我的直播";
    self.view.backgroundColor = [UIColor jpl_colorWithHexString:@"f8f8f8"];
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.naviBar];
    [self.naviBar addSubview:self.titleLb];
    [self.naviBar addSubview:self.backBt];
    [self.naviBar addSubview:self.amBt];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(JPL_NAVIGATION_HEIGHT, 0, 0, 0));
    }];
    [self.naviBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(0);
        make.height.mas_equalTo(JPL_NAVIGATION_HEIGHT);
    }];
    
    [self.titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.top.mas_equalTo(JPL_STATUS_HEIGHT);
        make.height.mas_equalTo(44);
    }];
    [self.backBt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.centerY.mas_equalTo(self.titleLb.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(44, 44));
    }];
    [self.amBt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.centerY.mas_equalTo(self.titleLb.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(75, 30));
    }];
    
    [self.tableView jpl_addRefreshHeaderWithRefreshingBlock:^{
        
        if ([JPLServiceInfo share].token.length == 0) {
            [MBProgressHUD jpl_showMessage:@"没有身份信息"];
            [self.tableView reloadData];
            return;
        }
        
        self.page = 1;
        [self requestData:self.page];
    }];
    
    [self.tableView jpl_addRefreshFooterWithRefreshingBlock:^{
        if ([JPLServiceInfo share].token.length == 0) {
            [MBProgressHUD jpl_showMessage:@"没有身份信息"];
            [self.tableView reloadData];
            return;
        }
        self.page++;
        [self requestData:self.page];
    }];

}

- (void)amLiveAction{
    JPLAMViewController * vc = [[JPLAMViewController alloc]init];
    JPLBaseNavigationViewController * navi = [[JPLBaseNavigationViewController alloc]initWithRootViewController:vc];
    navi.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:navi animated:YES completion:nil];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return self.currentArray.count;
    }else if (section == 1){
        return  self.waitArray.count;
    }else{
        return self.pastArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    JPLLiveListCell * cell = [tableView dequeueReusableCellWithIdentifier:@"JPLLiveListCell" forIndexPath:indexPath];

    if (indexPath.section == 0) {
        JPLLiveAMModel * model = self.currentArray[indexPath.row];
        cell.model = model;
        cell.enterLiveBlock = ^{
           
            JPLLiveViewController *vc = [[JPLLiveViewController alloc] init];
            vc.ammodel = self.currentArray[indexPath.row];
            vc.ammodel.live_direction = [JPLLiveSettingModel shareInstance].isPortrait ? @"竖屏" : @"横屏";
            vc.modalPresentationStyle = UIModalPresentationFullScreen;
            [self presentViewController:vc animated:YES completion:nil];

        };
    }else if(indexPath.section == 1){
        JPLLiveAMModel * model = self.waitArray[indexPath.row];
        cell.model = model;
        cell.modifyLiveBlock = ^{
            JPLAMViewController * vc = [[JPLAMViewController alloc]init];
            vc.model = model;
            JPLBaseNavigationViewController * navi = [[JPLBaseNavigationViewController alloc]initWithRootViewController:vc];
            navi.modalPresentationStyle = UIModalPresentationFullScreen;
            [self presentViewController:navi animated:YES completion:nil];
        };
    }else{
        JPLLiveAMModel * model = self.pastArray[indexPath.row];
        cell.model = model;
        cell.modifyLiveBlock = ^{
            JPLAMViewController * vc = [[JPLAMViewController alloc]init];
            vc.model = model;
            JPLBaseNavigationViewController * navi = [[JPLBaseNavigationViewController alloc]initWithRootViewController:vc];
            navi.modalPresentationStyle = UIModalPresentationFullScreen;
            [self presentViewController:navi animated:YES completion:nil];
        };
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    JPLLiveAMModel * model;
    if (indexPath.section == 0) {
       model = self.currentArray[indexPath.row];
    }else if (indexPath.section == 1){
        model = self.waitArray[indexPath.row];
    }else if (indexPath.section == 2){
        model = self.pastArray[indexPath.row];
    }
    return model.liveListCellOfHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return  0.1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}

#pragma - mark EmptyView

- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView {
    if (self.dataArray.count > 0) {
        return NO;
    }else {
        return YES;
    }
}

// 返回图片
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView{
    return JPLImageWithName(@"am_empty");
}

- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *text = @"您暂时没有预约记录哦，快去预约直播吧";
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

- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView {
    return -200.0f;
}


- (void)emptyDataSet:(UIScrollView *)scrollView didTapView:(UIView *)view {
    self.page = 1;
    [self.tableView reloadData];
}


- (void)analysisLiveModelStatus{

    [self.currentArray removeAllObjects];
    [self.waitArray removeAllObjects];
    [self.pastArray removeAllObjects];
    for (int i = 0; i < self.dataArray.count; i++) {
        JPLLiveAMModel * model = self.dataArray[i];
        if ([model.live_status isEqualToString:@"1"]) {
            [self.currentArray addObject:model];
        }else if ([model.live_status isEqualToString:@"2"]){
            [self.waitArray addObject:model];
        }else{
            [self.pastArray addObject: model];
        }
    }
    
}

#pragma - mark request
- (void)requestData:(NSInteger)page{
   
    NSMutableDictionary *dic = @{@"service":@"V220.Live_Stream.Lists",
                                 @"token":[JPLServiceInfo share].token,
                                 @"limit" : @20,
                                 @"page":@(page),
                                 @"status":@(0)
                                }.mutableCopy;
    [JPLService requestWithURLString:API_HOST parameters:dic type:JPLHttpRequestTypePost success:^(JPLResultBase *response) {
        if ([response.ret integerValue] == 200) {
            NSMutableArray * array = [NSMutableArray array];
            array = [JPLLiveAMModel mj_objectArrayWithKeyValuesArray:response.data];
            if (page == 1) {
                [self.dataArray removeAllObjects];
            }
            [self.dataArray addObjectsFromArray:array];
            [self analysisLiveModelStatus];
        }else {
            if (self.page > 1) {
                self.page--;
            }
            [MBProgressHUD jpl_showMessage:response.msg];
        }
        [self.tableView jpl_endHeaderAndFooterRefreshing];
        self.tableView.emptyDataSetSource = self;
        self.tableView.emptyDataSetDelegate = self;
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        if (self.page > 1) {
            self.page--;
        }
        self.tableView.emptyDataSetSource = self;
        self.tableView.emptyDataSetDelegate = self;
        [self.tableView jpl_endHeaderAndFooterRefreshing];
    } withErrorMsg:@"网络出错，请稍后重试"];
}


#pragma - mark set


#pragma - mark get
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        if (@available(iOS 15.0, *)) {
            _tableView.sectionHeaderTopPadding = 0;
        }
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor jpl_colorWithHexString:@"f8f8f8"];
        [_tableView registerClass:[JPLLiveListCell class] forCellReuseIdentifier:@"JPLLiveListCell"];

    }
    return _tableView;
}

- (UIButton *)backBt{
    if (!_backBt) {
        _backBt = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backBt setImage:JPLImageWithName(@"1_more") forState:UIControlStateNormal];
        [_backBt addTarget:self action:@selector(popToLastVC) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backBt;
}

- (UILabel *)titleLb{
    if (!_titleLb) {
        _titleLb = [[UILabel alloc]init];
        _titleLb.font = [UIFont jpl_pingFangWithSize:17 weight:UIFontWeightMedium];
        _titleLb.textColor = [UIColor jpl_colorWithHexString:@"333333"];
        _titleLb.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLb;
}

- (UIView *)naviBar{
    if (!_naviBar) {
        _naviBar = [[UIView alloc]init];
        _naviBar.backgroundColor = UIColor.whiteColor;
    }
    return _naviBar;
}

- (UIButton *)amBt{
    if (!_amBt) {
        _amBt = [UIButton buttonWithType:UIButtonTypeCustom];
        _amBt.bounds = CGRectMake(0, 0, 75, 30);
        [_amBt setTitle:@"预约直播" forState:UIControlStateNormal];
        _amBt.backgroundColor = [UIColor jpl_colorWithHexString:@"#1D6CFD"];
        _amBt.layer.cornerRadius = 15;
        _amBt.layer.masksToBounds = YES;
        [_amBt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _amBt.titleLabel.font = [UIFont jpl_pingFangWithSize:13 weight:UIFontWeightSemibold];
        [_amBt addTarget:self action:@selector(amLiveAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _amBt;
}


- (NSMutableArray<JPLLiveAMModel *> *)dataArray{
    if (!_dataArray) {
        _dataArray = @[].mutableCopy;
    }
    return _dataArray;
}

- (NSMutableArray<JPLLiveAMModel *> *)currentArray{
    if (!_currentArray) {
        _currentArray = @[].mutableCopy;
    }
    return _currentArray;
}

- (NSMutableArray<JPLLiveAMModel *> *)waitArray{
    if (!_waitArray) {
        _waitArray = @[].mutableCopy;
    }
    return _waitArray;
}

- (NSMutableArray<JPLLiveAMModel *> *)pastArray{
    if (!_pastArray) {
        _pastArray = @[].mutableCopy;
    }
    return _pastArray;
}

@end
