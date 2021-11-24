//
//  JPLAMInfoCell.m
//  JPLSDK
//
//  Created by 任敬 on 2021/10/28.
//

#import "JPLAMInfoCell.h"

@interface JPLAMInfoCell ()<UITextFieldDelegate>

@property (nonatomic, strong) UIView * backView;

@property (nonatomic, strong) UILabel * titleLb;

@property (nonatomic, strong) UILabel * startTimeLb;

@property (nonatomic, strong) UILabel * endTimeLb;

@property (nonatomic, strong) UITextField * titleTF;

@property (nonatomic, strong) UITextField * startTimeTF;

@property (nonatomic, strong) UITextField * endTimeTF;

@property (nonatomic, strong) UIImageView * arrow1IV;

@property (nonatomic, strong) UIImageView * arrow2IV;


@end

@implementation JPLAMInfoCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupViews];
    }
    return  self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    
}



#pragma - mark init view
- (void)setupViews{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.contentView.backgroundColor = [UIColor jpl_colorWithHexString:@"f8f8f8"];
    [self.contentView addSubview:self.backView];
    [self.backView addSubview:self.titleLb];
    [self.backView addSubview:self.startTimeLb];
    [self.backView addSubview:self.endTimeLb];
    [self.backView addSubview:self.titleTF];
    [self.backView addSubview:self.startTimeTF];
    [self.backView addSubview:self.endTimeTF];
    [self.backView addSubview:self.arrow1IV];
    [self.backView addSubview:self.arrow2IV];
    
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(10, 18, 0, 18));
    }];
    [self.titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(120, 47));
    }];
    
    [self.startTimeLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(self.titleLb.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(120, 47));
    }];
    
    [self.endTimeLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(self.startTimeLb.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(120, 47));
    }];
    
    [self.titleTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.centerY.mas_equalTo(self.titleLb.mas_centerY);
        make.left.mas_equalTo(self.titleLb.mas_right).mas_offset(10);
        make.height.mas_equalTo(47);
    }];
    
    [self.arrow1IV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.size.mas_equalTo(CGSizeMake(13, 13));
        make.centerY.mas_equalTo(self.startTimeLb.mas_centerY);
    }];
    
    [self.arrow2IV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.size.mas_equalTo(CGSizeMake(13, 13));
        make.centerY.mas_equalTo(self.endTimeLb.mas_centerY);
    }];
    
    
    [self.startTimeTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.arrow1IV.mas_left).mas_offset(-5);
        make.centerY.mas_equalTo(self.startTimeLb.mas_centerY);
        make.left.mas_equalTo(self.startTimeLb.mas_right).mas_offset(10);
        make.height.mas_equalTo(47);
    }];
    
    [self.endTimeTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.arrow2IV.mas_left).mas_offset(-5);
        make.centerY.mas_equalTo(self.endTimeLb.mas_centerY);
        make.left.mas_equalTo(self.endTimeLb.mas_right).mas_offset(10);
        make.height.mas_equalTo(47);
    }];
     
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (textField == self.startTimeTF) {
        if (self.startTimeBlock) {
            self.startTimeBlock(self.startTime);
        }
        return  NO;
    }else if (textField == self.endTimeTF){
        if (self.endTimeBlock) {
            self.endTimeBlock(self.endTime);
        }
        return  NO;
    }else{
        return  YES;
    }
}

- (void)liveNameEdit{
    if (self.liveNameBlock) {
        self.liveNameBlock(self.titleTF.text);
    }
}

#pragma - mark set
- (void)setTitle:(NSString *)title{
    self.titleTF.text = title;
}

- (void)setStartTime:(NSString *)startTime{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSDate * date = [formatter  dateFromString:startTime];
    if (date) {
        self.startTimeTF.text = startTime;
    }else{
        self.startTimeTF.text = nil;
    }
    
}

- (void)setEndTime:(NSString *)endTime{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSDate * date = [formatter  dateFromString:endTime];
    if (date) {
        self.endTimeTF.text = endTime;
    }else{
        self.endTimeTF.text = nil;
    }
}

#pragma - mark get

- (NSString *)title{
    return self.titleTF.text;
}

- (NSString *)startTime{
    return self.startTimeTF.text;
}

- (NSString *)endTime{
    return  self.endTimeTF.text;
}



- (UIView *)backView{
    if (!_backView) {
        _backView = [[UIView alloc]init];
        _backView.backgroundColor = UIColor.whiteColor;
        _backView.layer.cornerRadius = 6;
        _backView.layer.masksToBounds = YES;
    }
    return _backView;
}

//- (UIView *)startTimeView{
//    if (!_startTimeView) {
//        _startTimeView = [[UIView alloc]init];
//        _startTimeView.backgroundColor = UIColor.whiteColor;
//        _startTimeView.userInteractionEnabled = YES;
//    }
//    return _startTimeView;
//}
//
//- (UIView *)endTimeView{
//    if (!_endTimeView) {
//        _endTimeView = [[UIView alloc]init];
//        _endTimeView.backgroundColor = UIColor.whiteColor;
//        _endTimeView.userInteractionEnabled = YES;
//    }
//    return _endTimeView;
//}

- (UILabel *)titleLb{
    if (!_titleLb) {
        _titleLb  = [[UILabel alloc]init];
        _titleLb.text = @"直播标题：";
        _titleLb.font = [UIFont jpl_pingFangWithSize:16 weight:UIFontWeightMedium];
        _titleLb.textColor = [UIColor jpl_colorWithHexString:@"333333"];
        _titleLb.textAlignment = NSTextAlignmentLeft;
    }
    return _titleLb;
}

- (UILabel *)startTimeLb{
    if (!_startTimeLb) {
        _startTimeLb  = [[UILabel alloc]init];
        _startTimeLb.text = @"直播开始时间：";
        _startTimeLb.font = [UIFont jpl_pingFangWithSize:16 weight:UIFontWeightMedium];
        _startTimeLb.textColor = [UIColor jpl_colorWithHexString:@"333333"];
        _startTimeLb.textAlignment = NSTextAlignmentLeft;
    }
    return _startTimeLb;
}

- (UILabel *)endTimeLb{
    if (!_endTimeLb) {
        _endTimeLb  = [[UILabel alloc]init];
        _endTimeLb.text = @"直播结束时间：";
        _endTimeLb.font = [UIFont jpl_pingFangWithSize:16 weight:UIFontWeightMedium];
        _endTimeLb.textColor = [UIColor jpl_colorWithHexString:@"333333"];
        _endTimeLb.textAlignment = NSTextAlignmentLeft;
    }
    return _endTimeLb;
}

- (UITextField *)titleTF{
    if (!_titleTF) {
        _titleTF = [[UITextField alloc]init];
        _titleTF.textColor = [UIColor jpl_colorWithHexString:@"333333"];
        _titleTF.font = [UIFont jpl_pingFangWithSize:16 weight:UIFontWeightMedium];
        _titleTF.placeholder = @"请输入直播标题";
        _titleTF.textAlignment = NSTextAlignmentRight;
        _titleTF.delegate = self;
        [_titleTF addTarget:self action:@selector(liveNameEdit) forControlEvents:UIControlEventEditingChanged];
    }
    return _titleTF;
}

- (UITextField *)startTimeTF{
    if (!_startTimeTF) {
        _startTimeTF = [[UITextField alloc]init];
        _startTimeTF.textColor = [UIColor jpl_colorWithHexString:@"333333"];
        _startTimeTF.font = [UIFont jpl_pingFangWithSize:16 weight:UIFontWeightMedium];
        _startTimeTF.placeholder = @"未选择";
        _startTimeTF.textAlignment = NSTextAlignmentRight;
        _startTimeTF.delegate = self;
    }
    return _startTimeTF;
}

- (UITextField *)endTimeTF{
    if (!_endTimeTF) {
        _endTimeTF = [[UITextField alloc]init];
        _endTimeTF.textColor = [UIColor jpl_colorWithHexString:@"333333"];
        _endTimeTF.font = [UIFont jpl_pingFangWithSize:16 weight:UIFontWeightMedium];
        _endTimeTF.placeholder = @"未选择";
        _endTimeTF.textAlignment = NSTextAlignmentRight;
        _endTimeTF.delegate = self;
    }
    return _endTimeTF;
}

- (UIImageView *)arrow1IV{
    if (!_arrow1IV) {
        _arrow1IV = [[UIImageView alloc]initWithImage:JPLImageWithName(@"jpl_am_arrow")];
    }
    return _arrow1IV;
}

- (UIImageView *)arrow2IV{
    if (!_arrow2IV) {
        _arrow2IV = [[UIImageView alloc]initWithImage:JPLImageWithName(@"jpl_am_arrow")];
    }
    return _arrow2IV;
}

@end
