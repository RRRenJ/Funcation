//
//  JPLAMSuccessViewController.m
//  JPLSDK
//
//  Created by 任敬 on 2021/10/29.
//

#import "JPLAMSuccessViewController.h"
#import "JPLLiveListViewController.h"

@interface JPLAMSuccessViewController ()

@property (nonatomic, strong) UIImageView * successIV;

@property (nonatomic, strong) UILabel * remindLb;

@property (nonatomic, strong) UIButton * allBt;

@end

@implementation JPLAMSuccessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupViews];
    
    
}

#pragma - mark init view
- (void)setupViews{
    self.title = @"预约中";
    self.navigationItem.backBarButtonItem = nil;
    self.view.backgroundColor = [UIColor jpl_colorWithHexString:@"f8f8f8"];
    [self.view addSubview:self.successIV];
    [self.view addSubview:self.remindLb];
    [self.view addSubview:self.allBt];
    [self.successIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.top.mas_equalTo(100);
        make.size.mas_equalTo(CGSizeMake(94, 88));
    }];
    [self.remindLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.top.mas_equalTo(self.successIV.mas_bottom).mas_offset(10);
    }];
    [self.allBt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(243, 50));
    }];
    
}

- (void)popToLastVC{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)allAction{
    JPLLiveListViewController * vc = [[JPLLiveListViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.navigationController.viewControllers = @[vc];
    });
}

#pragma - mark request


#pragma - mark set


#pragma - mark get
- (UIImageView *)successIV{
    if (!_successIV) {
        _successIV = [[UIImageView alloc]initWithImage:JPLImageWithName(@"jp_am_wait")];
    }
    return _successIV;
}

- (UILabel *)remindLb{
    if (!_remindLb) {
        _remindLb = [[UILabel alloc]init];
        _remindLb.text = @"预约提交成功，请等待审核！";
        _remindLb.font = [UIFont jpl_pingFangWithSize:16];
        _remindLb.textColor = [UIColor jpl_colorWithHexString:@"666666"];
        _remindLb.textAlignment = NSTextAlignmentCenter;
    }
    return _remindLb;
}


- (UIButton *)allBt{
    if (!_allBt) {
        _allBt = [UIButton buttonWithType:UIButtonTypeCustom];
        [_allBt setTitle:@"查看我的预约" forState:UIControlStateNormal];
        [_allBt setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        _allBt.titleLabel.font = [UIFont jpl_pingFangWithSize:18 weight:UIFontWeightSemibold];
        _allBt.backgroundColor = [UIColor jpl_colorWithHexString:@"#1D6CFD"];
        _allBt.layer.cornerRadius = 6;
        _allBt.layer.masksToBounds = YES;
        [_allBt addTarget:self action:@selector(allAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _allBt;
}


@end
