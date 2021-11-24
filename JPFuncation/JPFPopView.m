//
//  JPFPopView.m
//  JPFuncationSDK
//
//  Created by 任敬 on 2021/11/3.
//

#import "JPFPopView.h"
#import "JPFUtil.h"
#import "JPFConfige.h"
#import <JPVideoEdit/JPVideoEdit.h>
#import <JPLManager.h>
#import <JPUMaterialSingleton.h>

@interface JPFPopView ()

@property (nonatomic, strong) UIImageView * backIV;

@property (nonatomic, strong) UILabel * remindLb;

@property (nonatomic, strong) UILabel * subRemindLb;
@property (nonatomic, strong) UILabel * subRemind2Lb;

@property (nonatomic, strong) UIButton * videoBt;

@property (nonatomic, strong) UIButton * infoBt;

@property (nonatomic, strong) UIButton * uploadBt;

@property (nonatomic, strong) UIButton * videoEditBt;

@property (nonatomic, strong) UIButton * liveBt;

@property (nonatomic, strong) UIButton * closeBt;

@property (nonatomic, strong) UIViewController * presentVC;

@end

@implementation JPFPopView


- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViews];
    }
    return self;
}



#pragma - mark init view
- (void)setupViews{
    self.frame = CGRectMake(0, 0, JPF_SCR_WIDTH, JPF_SCR_HEIGHT);
    self.backgroundColor = UIColor.clearColor;
    [self addSubview:self.backIV];
    [self addSubview:self.remindLb];
    [self addSubview:self.subRemindLb];
    [self addSubview:self.subRemind2Lb];
    [self addSubview:self.videoBt];
    [self addSubview:self.infoBt];
    [self addSubview:self.uploadBt];
    [self addSubview:self.videoEditBt];
    [self addSubview:self.liveBt];
    [self addSubview:self.closeBt];
    self.backIV.frame = self.bounds;
    self.remindLb.frame = CGRectMake(20, 26 + JPF_NAVIGATION_HEIGHT, 0, 0);
    [self.remindLb sizeToFit];
    self.subRemindLb.frame = CGRectMake(20, CGRectGetMaxY(self.remindLb.frame) + 10, 0, 0);
    [self.subRemindLb sizeToFit];
    self.subRemind2Lb.frame = CGRectMake(20, CGRectGetMaxY(self.subRemindLb.frame) + 20, 0, 0);
    [self.subRemind2Lb sizeToFit];
    
    self.closeBt.frame = CGRectMake(JPF_SCR_WIDTH / 2.0f - 40, JPF_SCR_HEIGHT - JPF_BOTTOM_HEIGHT - 66, 80, 40);
    
    CGFloat width1 = (JPF_SCR_WIDTH - 50) / 2.0;
    CGFloat height1 = 106 / 164.f * width1;
    
    CGFloat width2 = (JPF_SCR_WIDTH - 60) / 3.0;
    CGFloat height2 = width2;
    
    self.videoEditBt.frame = CGRectMake(20, CGRectGetMinY(self.closeBt.frame) - 26 - height1, width1, height1);
    self.liveBt.frame = CGRectMake(30 + width1, CGRectGetMinY(self.closeBt.frame) - 26 - height1, width1, height1);
    
    self.videoBt.frame = CGRectMake(30 + width2, CGRectGetMinY(self.videoEditBt.frame) - 10 - height2, width2, height2);
    self.infoBt.frame = CGRectMake(40 + width2 * 2, CGRectGetMinY(self.videoEditBt.frame) - 10 - height2, width2, height2);
    self.uploadBt.frame = CGRectMake(20, CGRectGetMinY(self.videoEditBt.frame) - 10 - height2, width2, height2);
    
}


- (void)show:(UIViewController *)vc{
    self.presentVC = vc;
    UIWindow * window = [UIApplication sharedApplication].keyWindow;
    if (!window) {
        window = [UIApplication sharedApplication].windows.firstObject;
    }
    [window addSubview:self];
    self.frame = CGRectMake(0, JPF_SCR_HEIGHT, JPF_SCR_WIDTH, JPF_SCR_HEIGHT);
    [UIView animateWithDuration:0.3 animations:^{
        self.frame = CGRectMake(0, 0, JPF_SCR_WIDTH, JPF_SCR_HEIGHT);
    }];
}

- (void)hide{
    [UIView animateWithDuration:0.3 animations:^{
        self.frame = CGRectMake(0, JPF_SCR_HEIGHT, JPF_SCR_WIDTH, JPF_SCR_HEIGHT);
    } completion:^(BOOL finished) {
        if (finished) {
            [self removeFromSuperview];
        }
    }];
}

#pragma - mark action

- (void)videoBtClick{
//    [[JPUMaterialSingleton singleton] jpu_material_EditVideo];
    [[JPUMaterialSingleton singleton] jpu_material_EditVideoUid:@"91578989" verifycode:@"token-a554bac0-fbb2-420f-98c7-68f38c9e9bb4-90AD42A51621A5EEB3F027AD1C5F0B7D-58799446-35eb-45dd-87e1-a3b1c9a1d3d5" cityCode:@"110100" source:@"ysyy" phone:@"18111177127" third_id:@"8208aea025f04c9081771461c448d375"];
    [self hide];
}

- (void)infoBtClick{
//    [[JPUMaterialSingleton singleton] jpu_material_EditPhoto];
    [[JPUMaterialSingleton singleton] jpu_material_EditPhotoUid:@"91578989" verifycode:@"token-a554bac0-fbb2-420f-98c7-68f38c9e9bb4-90AD42A51621A5EEB3F027AD1C5F0B7D-58799446-35eb-45dd-87e1-a3b1c9a1d3d5" cityCode:@"110100" source:@"ysyy" phone:@"18111177127" third_id:@"8208aea025f04c9081771461c448d375"];
    [self hide];
}

- (void)uploadBtClick{
//    [[JPUMaterialSingleton singleton] jpu_material_EditAll];
    [[JPUMaterialSingleton singleton] jpu_material_EditAllUid:@"91578989" verifycode:@"token-a554bac0-fbb2-420f-98c7-68f38c9e9bb4-90AD42A51621A5EEB3F027AD1C5F0B7D-58799446-35eb-45dd-87e1-a3b1c9a1d3d5" cityCode:@"110100" source:@"ysyy" phone:@"18111177127" third_id:@"8208aea025f04c9081771461c448d375"];
    [self hide];
}

- (void)videoEditBtClick{
    [JPManager showVideoEditAlert:self.presentVC hide:^{
        [self hide];
        
    }];
}

- (void)liveBtClick{
    [JPLManager showAlert:self.presentVC hide:^{
        [self hide];
    }];
}

- (void)closeBtClick{
    [self hide];
}


#pragma - mark set


#pragma - mark get
- (UIImageView *)backIV{
    if (!_backIV ) {
        _backIV = [[UIImageView alloc]init];
        _backIV.image = JPFImageWithName(@"mask_background");
        _backIV.contentMode = UIViewContentModeScaleAspectFill;
        _backIV.clipsToBounds = YES;
    }
    return _backIV;
}


- (UILabel *)remindLb{
    if (!_remindLb) {
        _remindLb = [[UILabel alloc]init];
        _remindLb.text = @"开始创作你的作品吧！";
        _remindLb.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:29];
        _remindLb.textColor = UIColor.blackColor;
    }
    return _remindLb;
}
- (UILabel *)subRemindLb{
    if (!_subRemindLb) {
        _subRemindLb = [[UILabel alloc]init];
        _subRemindLb.text = @"发布素材，\n能在电脑端登录媒体号后台进行编辑和发布。";
        _subRemindLb.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
        _subRemindLb.textColor = [UIColor colorWithWhite:0 alpha:0.5];
        _subRemindLb.numberOfLines = 2;
    }
    return _subRemindLb;
}

- (UILabel *)subRemind2Lb{
    if (!_subRemind2Lb) {
        _subRemind2Lb = [[UILabel alloc]init];
        _subRemind2Lb.text = @"发布视频和图文动态，\n能审核通过后直接在媒体号里观看。";
        _subRemind2Lb.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
        _subRemind2Lb.textColor = [UIColor colorWithWhite:0 alpha:0.5];
        _subRemind2Lb.numberOfLines = 2;
    }
    return _subRemind2Lb;
}


- (UIButton *)videoBt{
    if (!_videoBt) {
        _videoBt = [UIButton buttonWithType:UIButtonTypeCustom];
        [_videoBt setBackgroundImage:JPFImageWithName(@"funcation_submit_video") forState:UIControlStateNormal];
        [_videoBt addTarget:self action:@selector(videoBtClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _videoBt;
}

- (UIButton *)infoBt{
    if (!_infoBt) {
        _infoBt = [UIButton buttonWithType:UIButtonTypeCustom];
        [_infoBt setBackgroundImage:JPFImageWithName(@"funcation_submit_info") forState:UIControlStateNormal];
        [_infoBt addTarget:self action:@selector(infoBtClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _infoBt;
}

- (UIButton *)uploadBt{
    if (!_uploadBt) {
        _uploadBt = [UIButton buttonWithType:UIButtonTypeCustom];
        [_uploadBt setBackgroundImage:JPFImageWithName(@"funcation_upload") forState:UIControlStateNormal];
        [_uploadBt addTarget:self action:@selector(uploadBtClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _uploadBt;
}

- (UIButton *)videoEditBt{
    if (!_videoEditBt) {
        _videoEditBt = [UIButton buttonWithType:UIButtonTypeCustom];
        [_videoEditBt setBackgroundImage:JPFImageWithName(@"funcation_videoEdit") forState:UIControlStateNormal];
        [_videoEditBt addTarget:self action:@selector(videoEditBtClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _videoEditBt;
}

- (UIButton *)liveBt{
    if (!_liveBt) {
        _liveBt = [UIButton buttonWithType:UIButtonTypeCustom];
        [_liveBt setBackgroundImage:JPFImageWithName(@"funcation_live") forState:UIControlStateNormal];
        [_liveBt addTarget:self action:@selector(liveBtClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _liveBt;
}

- (UIButton *)closeBt{
    if (!_closeBt) {
        _closeBt = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeBt setImage:JPFImageWithName(@"funcation_close") forState:UIControlStateNormal];
        [_closeBt setTitle:@" 取消" forState:UIControlStateNormal];
        [_closeBt setTitleColor:[UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0] forState:UIControlStateNormal];
        _closeBt.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:15];
        [_closeBt addTarget:self action:@selector(closeBtClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeBt;
}

@end
