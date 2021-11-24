//
//  JPLAMViewController.m
//  JPLSDK
//
//  Created by 任敬 on 2021/10/26.
//

#import "JPLAMViewController.h"
#import "JPLAMInfoCell.h"
#import "JPLAMCoverCell.h"
#import "JPLAMIntroCell.h"
#import "JPLAMSelectCell.h"
#import "JPLPickerView.h"
#import "JPLPickerView.h"
#import "JPLAMSuccessViewController.h"

@interface JPLAMViewController ()<UITableViewDelegate,UITableViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (nonatomic, strong) UITableView * tableView;

@property (nonatomic, strong) UIButton * submitBt;

@property (nonatomic, strong) NSArray <NSString *> * liveCategoryArray;

@property (nonatomic, strong) NSDateFormatter * dateFormatter;

@property (nonatomic, copy) NSString * city;



@end

@implementation JPLAMViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupViews];
    [self addAction];
}

#pragma - mark init view
- (void)setupViews{
    
    
    self.navigationItem.leftBarButtonItem = [self customLeftBarButtonItem];
    self.view.backgroundColor = [UIColor jpl_colorWithHexString:@"f8f8f8"];
    [self.view addSubview:self.tableView];
    [self.view addSubview: self.submitBt];
    
    [self.submitBt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(18);
        make.right.mas_equalTo(-18);
        make.height.mas_equalTo(50);
        make.bottom.mas_equalTo(-5 - JPL_BOTTOM_HEIGHT);
    }];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(0);
        make.bottom.mas_equalTo(self.submitBt.mas_top).mas_offset(-10);
    }];
    if (self.model) {
        self.title = @"修改预约";
        [self.submitBt setTitle:@" 修改预约" forState:UIControlStateNormal];
    }else{
        self.title = @"预约直播";
        self.model = [[JPLLiveAMModel alloc]init];
        [self.submitBt setTitle:@" 立即预约" forState:UIControlStateNormal];
    }
    
}

- (void)addAction{
    __weak typeof(self) weakself = self;
    self.locationBlock = ^(NSString * _Nonnull city) {
        weakself.city = city;
        [weakself.tableView reloadData];
    };
    [self getLocationCity];
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 3;
    }else{
        return 5;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            JPLAMInfoCell * cell = [tableView dequeueReusableCellWithIdentifier:@"JPLAMInfoCell" forIndexPath:indexPath];
            cell.title = self.model.live_name;
            cell.startTime = self.model.live_reserve_startime;
            cell.endTime = self.model.live_reserve_endtime;
            __weak typeof(cell) weakcell = cell;
            cell.liveNameBlock = ^(NSString * _Nonnull name) {
                self.model.live_name = name;
            };
            cell.startTimeBlock = ^(NSString * _Nonnull startTime) {
                [tableView endEditing:YES];
                JPLPickerView * view = [[JPLPickerView alloc]initWithType:JPLPickerTypeDate];
                view.content = self.model.live_reserve_startime;
                NSDate * now = [NSDate date];
                NSDate * minDate = [now dateByAddingTimeInterval:30 * 60];
                NSDate * maxDate = [now dateByAddingTimeInterval:24 * 3600 * 30];
                view.minTime = [self.dateFormatter stringFromDate:minDate];
                view.maxTime = [self.dateFormatter stringFromDate:maxDate];
                view.selectBlock = ^(NSString * _Nonnull content) {
                    weakcell.startTime = content;
                    self.model.live_reserve_startime = content;
                };
                [view show];
            };
            cell.endTimeBlock = ^(NSString * _Nonnull endTime) {
                [tableView endEditing:YES];
                JPLPickerView * view = [[JPLPickerView alloc]initWithType:JPLPickerTypeDate];
                NSDate * start = [self.dateFormatter dateFromString:self.model.live_reserve_startime];
                if (!start) {
                    start = [NSDate date];
                }
                NSDate * minDate = [start dateByAddingTimeInterval:3600 * 2];
                NSDate * maxDate = [start dateByAddingTimeInterval:24 * 3600 * 5];
                view.minTime = [self.dateFormatter stringFromDate:minDate];
                view.maxTime = [self.dateFormatter stringFromDate:maxDate];
                if (self.model.live_reserve_endtime.length == 0) {
                    self.model.live_reserve_endtime = view.minTime;
                }
                view.content = self.model.live_reserve_endtime;
                view.selectBlock = ^(NSString * _Nonnull content) {
                    weakcell.endTime = content;
                    self.model.live_reserve_endtime = content;
                };
                [view show];
            };
            return  cell;
        }else if (indexPath.row == 1){
            JPLAMCoverCell * cell = [tableView dequeueReusableCellWithIdentifier:@"JPLAMCoverCell" forIndexPath:indexPath];
            cell.selectBlock = ^{
                [tableView endEditing:YES];
                [self getPhotoLibrary:^(BOOL successful) {
                    [self presentPhotoLibrary];
                }];
            };
            return cell;
        }else{
            JPLAMIntroCell * cell = [tableView dequeueReusableCellWithIdentifier:@"JPLAMIntroCell" forIndexPath:indexPath];
            cell.intro = self.model.live_intro;
            return  cell;
        }
    }else{
        JPLAMSelectCell * cell = [tableView dequeueReusableCellWithIdentifier:@"JPLAMSelectCell" forIndexPath:indexPath];
        cell.haveArrow = indexPath.row < 4;
        if (indexPath.row == 0) {
            cell.title = @"画面";
            cell.isDefault = [self.model.live_direction isEqualToString:@"竖屏"];
            cell.content = self.model.live_direction;
        }else if (indexPath.row == 1){
            cell.title = @"分辨率";
            cell.content = self.model.live_ratio;
            cell.isDefault = [self.model.live_ratio isEqualToString:@"720p"];
        }else if (indexPath.row == 2){
            cell.title = @"边播边录";
            cell.content = self.model.live_record ? @"开启" : @"关闭";
            cell.isDefault = !self.model.live_record;
        }else if (indexPath.row == 3){
            cell.title = @"所属分类";
            cell.content = self.model.live_category;
            cell.isDefault = [self.model.live_category isEqualToString:@"生活"];
        }else{
            cell.isDefault = NO;
            cell.title = @"直播地区";
            if (!self.city) {
                cell.content = @"获取位置信息";
            }else{
                cell.content = self.city;
            }
        }
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            return 151;
        }else if (indexPath.row == 1){
            return 99;
        }else{
            return 145;
        }
    }else{
        return 46;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [tableView endEditing:YES];
    if (indexPath.section == 1) {
        NSArray <NSString *> * array;
        NSString * current;
        if (indexPath.row == 0) {
            array = @[@"竖屏",@"横屏"];
            current = self.model.live_direction;
        }else if (indexPath.row == 1){
            array = @[@"480p",@"720p",@"1080p"];
            current = self.model.live_ratio;
        }else if (indexPath.row == 2){
            array = @[@"关闭",@"开启"];
            current = self.model.live_record ? @"开启" : @"关闭";
        }else if (indexPath.row == 3){
            array = self.liveCategoryArray;
            current = self.model.live_category;
        }
        if (indexPath.row < 4) {
            JPLPickerView * pickView = [[JPLPickerView alloc]initWithType:JPLPickerTypeString];
            pickView.dataSource = array;
            pickView.content = current;
            __weak typeof(self) weakself = self;
            pickView.selectBlock = ^(NSString * _Nonnull content) {
                if (indexPath.row == 0) {
                    weakself.model.live_direction = content;
                }else if (indexPath.row == 1){
                    weakself.model.live_ratio = content;
                }else if (indexPath.row == 2){
                    weakself.model.live_record = [content isEqualToString:@"开启"];
                }else if (indexPath.row == 3){
                    weakself.model.live_category = content;
                }
                [weakself.tableView reloadData];
            };
            [pickView show];
        }else{
            [self getLocationCity];
        }
    }
}


- (void)presentPhotoLibrary{
    UIImagePickerController * vc = [[UIImagePickerController alloc]init];
    vc.delegate = self;
    vc.allowsEditing = YES;
    vc.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    vc.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey,id> *)info{
    UIImage * image = info[UIImagePickerControllerEditedImage];
    if (!image) {
        image = info[UIImagePickerControllerOriginalImage];
    }
    JPLAMCoverCell * cell = (JPLAMCoverCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    cell.coverImage = image;
    [picker dismissViewControllerAnimated:YES completion:nil];
}





- (void)submitBtAction{
    
    if ([JPLServiceInfo share].token.length == 0) {
        [MBProgressHUD jpl_showMessage:@"没有身份信息"];
        return;
    }
    
    if (self.model.live_id) {
        [self modifyRequest];
    }else{
        [self applyRequest];
    }
}

#pragma - mark request

- (void)applyRequest{
    [self jpl_showHUD];
    NSMutableDictionary *dic = @{@"service":@"App.Live_Stream.Reserve",
                                 @"token":[JPLServiceInfo share].token,
                                 @"live_name":self.model.live_name,
                                 @"live_reserve_startime": self.model.live_reserve_startime,
                                 @"live_reserve_endtime":self.model.live_reserve_endtime,
                                 @"live_goods_ids": @[],
                                }.mutableCopy;
    [JPLService requestWithURLString:API_HOST parameters:dic type:JPLHttpRequestTypePost success:^(JPLResultBase *response) {
        [self jpl_hideHUD];
        if ([response.ret integerValue] == 200) {
            JPLAMSuccessViewController * vc = [[JPLAMSuccessViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
           
        }else {
            [MBProgressHUD jpl_showMessage:response.msg];
        }
    } failure:^(NSError *error) {
        [self jpl_hideHUD];
    } withErrorMsg:@"网络出错，请稍后重试"];
}

- (void)modifyRequest{
    [self jpl_showHUD];
   
    NSMutableDictionary *dic = @{@"service":@"App.Live_Stream.Edit",
                                 @"token":[JPLServiceInfo share].token,
                                 @"live_id":@([self.model.live_id integerValue]),
                                 @"live_name":self.model.live_name,
                                 @"live_reserve_startime": self.model.live_reserve_startime,
                                 @"live_reserve_endtime":self.model.live_reserve_endtime,
                                 @"live_goods_ids": @[],
                                }.mutableCopy;
    [JPLService requestWithURLString:API_HOST parameters:dic type:JPLHttpRequestTypePost success:^(JPLResultBase *response) {
        [self jpl_hideHUD];
        if ([response.ret integerValue] == 200) {
            [MBProgressHUD jpl_showMessage:@"预约修改成功"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
            
        }else {
            [MBProgressHUD jpl_showMessage:response.msg];
        }
    } failure:^(NSError *error) {
        [self jpl_hideHUD];
    } withErrorMsg:@"网络出错，请稍后重试"];
}


#pragma - mark set


#pragma - mark get
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor jpl_colorWithHexString:@"f8f8f8"];
        if (@available(iOS 15.0, *)) {
            _tableView.sectionHeaderTopPadding = 0;
        }
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[JPLAMInfoCell class] forCellReuseIdentifier:@"JPLAMInfoCell"];
        [_tableView registerClass:[JPLAMCoverCell class] forCellReuseIdentifier:@"JPLAMCoverCell"];
        [_tableView registerClass:[JPLAMIntroCell class] forCellReuseIdentifier:@"JPLAMIntroCell"];
        [_tableView registerClass:[JPLAMSelectCell class] forCellReuseIdentifier:@"JPLAMSelectCell"];
        _tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (UIButton *)submitBt{
    if (!_submitBt) {
        _submitBt = [UIButton buttonWithType:UIButtonTypeCustom];
        [_submitBt setTitle:@" 立即预约" forState:UIControlStateNormal];
        [_submitBt setImage:[JPLImageWithName(@"bt_am_live") imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
        [_submitBt setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        _submitBt.backgroundColor = [UIColor jpl_colorWithHexString:@"#1D6CFD"];
        _submitBt.layer.cornerRadius = 6;
        _submitBt.layer.masksToBounds = YES;
        [_submitBt addTarget:self action:@selector(submitBtAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _submitBt;
}

- (NSDateFormatter *)dateFormatter{
    if (!_dateFormatter) {
        _dateFormatter = [[NSDateFormatter alloc]init];
        _dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    }
    return _dateFormatter;
}



- (NSArray<NSString *> *)liveCategoryArray{
    if (!_liveCategoryArray) {
        _liveCategoryArray = @[@"生活",@"运动",@"唱歌",@"舞蹈",@"户外",@"美食",@"亲子",@"宠物",@"知识教学",@"才艺",@"购物"];
    }
    return _liveCategoryArray;
}

@end
