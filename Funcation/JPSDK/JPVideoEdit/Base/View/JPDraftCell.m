//
//  JPDraftCell.m
//  JPSDK
//
//  Created by 任敬 on 2021/10/25.
//

#import "JPDraftCell.h"


@interface JPDraftCell ()

@property (nonatomic, strong) UIImageView * videoIV;

@property (nonatomic, strong) UILabel * titleLb;

@property (nonatomic, strong) UILabel * timeLb;

@property (nonatomic, strong) UIButton * editBt;

@property (nonatomic, strong) UIButton * deleteBt;

@end

@implementation JPDraftCell

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViews];
        
    }
    return self;
}


#pragma - mark init view
- (void)setupViews{
    self.contentView.backgroundColor = UIColor.whiteColor;
    self.contentView.layer.cornerRadius = 6;
    self.contentView.layer.masksToBounds = YES;
    [self.contentView addSubview:self.videoIV];
    [self.videoIV addSubview:self.timeLb];
    [self.contentView addSubview:self.titleLb];
    [self.contentView addSubview:self.editBt];
    [self.contentView addSubview:self.deleteBt];
    
    [self.videoIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(5);
        make.right.mas_equalTo(-5);
        make.height.mas_equalTo(self.videoIV.mas_width).multipliedBy(85 / 155.0f);
    }];
    
    [self.timeLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(0);
    }];
    
    [self.deleteBt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(self.videoIV.mas_bottom).mas_offset(5);
        make.bottom.mas_equalTo(-5);
        make.width.mas_equalTo(30);
    }];
    [self.editBt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.deleteBt.mas_left).mas_offset(-5);
        make.top.mas_equalTo(self.videoIV.mas_bottom).mas_offset(5);
        make.bottom.mas_equalTo(-5);
        make.width.mas_equalTo(30);
    }];
    
    [self.titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(5);
        make.top.mas_equalTo(self.videoIV.mas_bottom).mas_offset(5);
        make.bottom.mas_equalTo(-5);
        make.right.mas_equalTo(self.editBt.mas_right).mas_equalTo(-5);
    }];
}



- (void)editBtClicked{
    if (self.editBlock) {
        self.editBlock(self.videoInfo);
    }
}

- (void)deleteBtClicked{
    if (self.deleteBlock) {
        self.deleteBlock(self.videoInfo);
    }
}


#pragma - mark set
- (void)setVideoInfo:(JPVideoRecordInfo *)videoInfo{
    _videoInfo = videoInfo;
    self.videoIV.image = _videoInfo.videoSource.firstObject.originThumbImage;
    self.timeLb.text = [JPUtil getDurationWithSecond:CMTimeGetSeconds(_videoInfo.currentTotalTime)];
    self.titleLb.text = [JPUtil stringFromDate:_videoInfo.saveDate];
}



#pragma - mark get

- (UIImageView *)videoIV{
    if (!_videoIV) {
        _videoIV = [[UIImageView alloc]init];
        _videoIV.contentMode = UIViewContentModeScaleAspectFill;
        _videoIV.layer.cornerRadius = 3;
        _videoIV.layer.masksToBounds = YES;
    }
    return _videoIV;
}
- (UILabel *)titleLb{
    if (!_titleLb) {
        _titleLb = [[UILabel alloc]init];
        _titleLb.textColor = [UIColor jp_colorWithHexString:@"353535"];
        _titleLb.font = [UIFont jp_pingFangWithSize:12 weight:UIFontWeightMedium];
    }
    return _titleLb;
}

- (UILabel *)timeLb{
    if (!_timeLb) {
        _timeLb = [[UILabel alloc]init];
        _timeLb.textColor = [UIColor whiteColor];
        _timeLb.font = [UIFont jp_pingFangWithSize:12 weight:UIFontWeightSemibold];
        _timeLb.textAlignment = NSTextAlignmentCenter;
    }
    return _timeLb;
}

- (UIButton *)editBt{
    if (!_editBt) {
        _editBt = [UIButton buttonWithType:UIButtonTypeCustom];
        [_editBt setImage:JPImageWithName(@"draft_edit") forState:UIControlStateNormal];
        [_editBt addTarget:self action:@selector(editBtClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _editBt;
}

- (UIButton *)deleteBt{
    if (!_deleteBt) {
        _deleteBt = [UIButton buttonWithType:UIButtonTypeCustom];
        [_deleteBt setImage:JPImageWithName(@"draft_delete") forState:UIControlStateNormal];
        [_deleteBt addTarget:self action:@selector(deleteBtClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _deleteBt;
}


@end
