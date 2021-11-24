//
//  CompositionViewController.m
//  JPSDK
//
//  Created by 任敬 on 2021/10/19.
//

#import "CompositionViewController.h"
#import "ExportViewController.h"

@interface CompositionViewController ()<JPCompositionManagerDelegate>

@property (nonatomic, strong) UILabel * titleLb;

@property (nonatomic, strong) UILabel * progressLb;

@property (nonatomic, strong) UIView * progressBackView;

@property (nonatomic, strong) UIView * progressView;

@property (nonatomic, strong) UILabel * remind1Lb;

@property (nonatomic, strong) UILabel * remind2Lb;

@end

@implementation CompositionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupViews];
    self.manager.delegate = self;
    [self.manager startComposition];
}

#pragma - mark init view
- (void)setupViews{
    self.title = @"导出";
    self.view.backgroundColor = [UIColor blackColor];
    [self.view addSubview:self.titleLb];
    [self.view addSubview:self.progressBackView];
    [self.view addSubview:self.remind2Lb];
    [self.view addSubview:self.remind1Lb];
    [self.progressBackView addSubview:self.progressView];
    [self.progressBackView addSubview:self.progressLb];
    [self.progressBackView bringSubviewToFront:self.progressLb];
    
    
    [self.titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(JP_STATUS_HEIGHT + 9);
        make.centerX.mas_equalTo(0);
    }];
    
    
    [self.progressBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(18);
        make.right.mas_equalTo(-18);
        make.bottom.mas_equalTo(-120);
        make.height.mas_equalTo(55);
    }];
    
    [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.mas_equalTo(0);
        make.width.mas_equalTo(0);
    }];
    
    [self.progressLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(0);
    }];
    
    [self.remind2Lb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(18);
        make.right.mas_equalTo(-18);
        make.bottom.mas_equalTo(self.progressBackView.mas_top).mas_offset(-25);
    }];
    
    [self.remind1Lb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(18);
        make.right.mas_equalTo(-18);
        make.bottom.mas_equalTo(self.remind2Lb.mas_top).mas_offset(-18);
    }];
    
    
    
}

- (void)compositionStatusChangeed:(JPCompositionManager *)compositionManager{
    if (compositionManager.compositinType == JPCompositionTypeCompositioning) {
        self.progressLb.text = [NSString stringWithFormat:@"%.0f%%",compositionManager.compositionProgress * 100];
        [UIView animateWithDuration:0.2 animations:^{
            [self.progressView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.top.bottom.mas_equalTo(0);
                make.width.mas_equalTo((JP_SCREEN_WIDTH - 36) * compositionManager.compositionProgress);
            }];
            [self.progressBackView layoutIfNeeded];
            [self.progressBackView setNeedsLayout];
        }];
        
    }else if(compositionManager.compositinType == JPCompositionTypeCompositioned){
        self.progressLb.text = @"100%";
        [UIView animateWithDuration:0.2 animations:^{
            [self.progressView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.top.bottom.right.mas_equalTo(0);
            }];
            [self.progressBackView layoutIfNeeded];
            [self.progressBackView setNeedsLayout];
        }];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            ExportViewController * vc = [[ExportViewController alloc]init];
            vc.compositionManager = self.manager;
            [self.navigationController pushViewController:vc animated:YES];
        });
        
    }else if (compositionManager.compositinType == JPCompositionTypeCompositionFaild){
        self.progressLb.text = @"失败";
    }
}

- (void)compositionErrorWillBackToPage {
    
}


- (void)compositionErrorWillEndEdit {
    
}



#pragma - mark request


#pragma - mark set


#pragma - mark get


- (UIView *)progressBackView{
    if (!_progressBackView) {
        _progressBackView = [[UIView alloc]init];
        _progressBackView.backgroundColor = [UIColor jp_colorWithHexString:@"#1D2026"];
        _progressBackView.layer.masksToBounds = YES;
        _progressBackView.layer.cornerRadius = 3;
    }
    return _progressBackView;
}


- (UIView *)progressView{
    if (!_progressView) {
        _progressView = [[UIView alloc]init];
        _progressView.backgroundColor = [UIColor jp_colorWithHexString:@"#1D6CFD"];
        _progressView.layer.masksToBounds = YES;
        _progressView.layer.cornerRadius = 3;
    }
    return _progressView;
}



- (UILabel *)progressLb{
    if (!_progressLb) {
        _progressLb = [[UILabel alloc]init];
        _progressLb.text = @"0%";
        _progressLb.textColor = UIColor.whiteColor;
        _progressLb.font = [UIFont jp_pingFangWithSize:23 weight:UIFontWeightMedium];
    }
    return _progressLb;
}

- (UILabel *)remind1Lb{
    if (!_remind1Lb) {
        _remind1Lb = [[UILabel alloc]init];
        _remind1Lb.text = @"加速导出中…";
        _remind1Lb.font = [UIFont jp_pingFangWithSize:23 weight:UIFontWeightMedium];
        _remind1Lb.textColor = UIColor.whiteColor;
    }
    return _remind1Lb;
}

- (UILabel *)remind2Lb{
    if (!_remind2Lb) {
        _remind2Lb = [[UILabel alloc]init];
        _remind2Lb.text = @"正在加速导出中，请耐心等待！\n请在导出过程中保持设备停留在此页面，不要切换页面，以免导出失败。";
        _remind2Lb.numberOfLines = 0;
        _remind2Lb.font = [UIFont jp_pingFangWithSize:15 weight:UIFontWeightMedium];
        _remind2Lb.textColor = [UIColor jp_colorWithHexString:@"ffffff"alpha:0.7];
    }
    return _remind2Lb;
}


- (UILabel *)titleLb{
    if (!_titleLb) {
        _titleLb = [[UILabel alloc]init];
        _titleLb.text = @"导出";
        _titleLb.font = [UIFont jp_pingFangWithSize:17 weight:UIFontWeightMedium];
        _titleLb.textColor = UIColor.whiteColor;
    }
    return _titleLb;
}








@end
