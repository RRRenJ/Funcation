//
//  JPLPickerView.m
//  JPLSDK
//
//  Created by 任敬 on 2021/10/28.
//

#import "JPLPickerView.h"




@interface JPLPickerView ()<UIPickerViewDelegate,UIPickerViewDataSource>

@property (nonatomic, strong) UIView * grayView;

@property (nonatomic, strong) UIView * contentView;

@property (nonatomic, strong) UIPickerView * pickerView;

@property (nonatomic, strong) UIDatePicker * datePickerView;

@property (nonatomic, strong) UIButton * confirmBt;

@property (nonatomic, strong) UIButton  * cancelBt;

@property (nonatomic, copy) NSString * selectStr;

@property (nonatomic, assign) JPLPickerType  type;


@end


@implementation JPLPickerView



- (instancetype)initWithType:(JPLPickerType)type{
    self = [super initWithFrame:CGRectMake(0, 0, JPL_SCR_WIDTH, JPL_SCR_HEIGHT)];
    if (self) {
        self.type = type;
        [self setupViews];
        [self addAction];
    }
    return self;
}

#pragma - mark init view
- (void)setupViews{
    self.backgroundColor = UIColor.clearColor;
    self.frame = CGRectMake(0, 0, JPL_SCR_WIDTH, JPL_SCR_HEIGHT);
    [self addSubview:self.grayView];
    [self addSubview:self.contentView];
    [self.contentView addSubview:self.cancelBt];
    [self.contentView addSubview:self.confirmBt];
    if (self.type == JPLPickerTypeDate) {
        [self.contentView addSubview:self.datePickerView];
    }else{
        [self.contentView addSubview:self.pickerView];
    }

    [self.grayView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    [self.cancelBt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.contentView.mas_centerX).mas_offset(-10);
        make.bottom.mas_equalTo(-8 - JPL_BOTTOM_HEIGHT);
        make.size.mas_equalTo(CGSizeMake(140, 40));
    }];
    [self.confirmBt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_centerX).mas_offset(10);
        make.bottom.mas_equalTo(-8 - JPL_BOTTOM_HEIGHT);
        make.size.mas_equalTo(CGSizeMake(140, 40));
    }];
    
    if (self.type == JPLPickerTypeDate) {
        [self.datePickerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(20);
            make.left.right.mas_equalTo(0);
            make.bottom.mas_equalTo(self.cancelBt.mas_top).mas_offset(-10);
        }];
    }else{
        [self.pickerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(20);
            make.left.right.mas_equalTo(0);
            make.bottom.mas_equalTo(self.cancelBt.mas_top).mas_offset(-10);
        }];
    }
    
    
}

- (void)addAction{
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hide)];
    [self.grayView addGestureRecognizer:tap];
}

- (void)confirmAction{
    if (self.selectBlock) {
        self.selectBlock(self.selectStr);
        [self hide];
    }
    
}

- (void)cancelAction{
    [self hide];
}

- (void)pickerValueChange:(UIDatePicker*)sender{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    //设置时间格式
    formatter.dateFormat = @"yyyy-MM-dd HH:mm";
    self.selectStr = [NSString stringWithFormat:@"%@:00",[formatter  stringFromDate:sender.date]];
}


- (void)show{
    
    if (self.selectStr.length > 0){
        if (self.type == JPLPickerTypeString) {
            if ( [self.dataSource containsObject:self.selectStr]){
                NSInteger index = [self.dataSource indexOfObject:self.selectStr];
                [self.pickerView selectRow:index inComponent:0 animated:NO];
            };
        }else{
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            //设置时间格式
            formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
            NSDate * selectDate = [formatter  dateFromString:self.selectStr];
            if ([selectDate timeIntervalSinceDate:self.datePickerView.minimumDate] >= 0) {
                [self.datePickerView setDate:selectDate];
            }else{
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                //设置时间格式
                formatter.dateFormat = @"yyyy-MM-dd HH:mm";
                self.selectStr = [NSString stringWithFormat:@"%@:00",[formatter  stringFromDate:self.datePickerView.minimumDate]];
                [self.datePickerView setDate:self.datePickerView.minimumDate];
            }
        }
        
    }else{
        if (self.type == JPLPickerTypeString) {
            self.selectStr = self.dataSource.firstObject;
        }else{
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            //设置时间格式
            formatter.dateFormat = @"yyyy-MM-dd HH:mm";
            self.selectStr = [NSString stringWithFormat:@"%@:00",[formatter  stringFromDate:[NSDate date]]];
        }
        
    }
    UIWindow * window = [UIApplication sharedApplication].keyWindow;
    if (!window) {
        window = [UIApplication sharedApplication].windows.lastObject;
    }
    [window addSubview:self];
    self.contentView.frame = CGRectMake(0, JPL_SCR_HEIGHT, JPL_SCR_WIDTH, 240 + JPL_BOTTOM_HEIGHT);
    self.grayView.alpha = 0;
    [UIView animateWithDuration:0.3 animations:^{
        self.contentView.frame = CGRectMake(0, JPL_SCR_HEIGHT - 240 - JPL_BOTTOM_HEIGHT, JPL_SCR_WIDTH, 240 + JPL_BOTTOM_HEIGHT);
        self.grayView.alpha = 1;
    } completion:^(BOOL finished) {
            
    }];
}

- (void)hide{
    self.grayView.alpha = 1;
    [UIView animateWithDuration:0.3 animations:^{
        self.contentView.frame = CGRectMake(0, JPL_SCR_HEIGHT, JPL_SCR_WIDTH, 290 + JPL_BOTTOM_HEIGHT);
        self.grayView.alpha = 0;
    } completion:^(BOOL finished) {
        if (finished) {
            [self removeFromSuperview];
        }
    }];
}




- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return  self.dataSource.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return self.dataSource[row];
}


- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel * label;
    if (![view isKindOfClass:[UILabel class]]){
        label = [[UILabel alloc]init];
    }
    label.textColor = [UIColor jpl_colorWithHexString:@"333333"];
    label.font = [UIFont jpl_pingFangWithSize:16 weight:UIFontWeightMedium];
    label.text = self.dataSource[row];
    label.textAlignment = NSTextAlignmentCenter;
    for (UIView * line in pickerView.subviews) {
        if (line.size.height < 1) {
            line.backgroundColor = UIColor.clearColor;
        }
    }
    return  label;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return 54;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    self.selectStr = self.dataSource[row];
}


#pragma - mark set
- (void)setDataSource:(NSArray<NSString *> *)dataSource{
    _dataSource = dataSource;
    [self.pickerView reloadAllComponents];
}

- (void)setMinTime:(NSString *)minTime{
    _minTime = minTime;
    if (_minTime.length > 0) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
        NSDate * date = [formatter  dateFromString:_minTime];
        [self.datePickerView setMinimumDate:date];
    }
}

- (void)setMaxTime:(NSString *)maxTime{
    _maxTime = maxTime;
    if (_maxTime.length > 0) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
        NSDate * date = [formatter  dateFromString:_maxTime];
        [self.datePickerView setMaximumDate:date];
    }
}

- (void)setContent:(NSString *)content{
    _content = content;
    self.selectStr = content;
}


#pragma - mark get
- (UIView *)grayView{
    if (!_grayView) {
        _grayView = [[UIView alloc]init];
        _grayView.backgroundColor = [UIColor jpl_colorWithHexString:@"000000" alpha:0.5];
        _grayView.userInteractionEnabled = YES;
    }
    return _grayView;
}

- (UIView *)contentView{
    if (!_contentView) {
        _contentView = [[UIView alloc]init];
        _contentView.backgroundColor = UIColor.whiteColor;
        _contentView.bounds = CGRectMake(0, 0, JPL_SCR_WIDTH, 240 + JPL_BOTTOM_HEIGHT);
        UIBezierPath * path = [UIBezierPath bezierPathWithRoundedRect:_contentView.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(12, 12)];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = _contentView.bounds;
        maskLayer.path = path.CGPath;
        _contentView.layer.mask = maskLayer;
    }
    return _contentView;
}

- (UIPickerView *)pickerView{
    if (!_pickerView) {
        _pickerView = [[UIPickerView alloc]init];
        _pickerView.delegate = self;
        _pickerView.dataSource = self;
    }
    return _pickerView;
}

- (UIDatePicker *)datePickerView{
    if (!_datePickerView) {
        _datePickerView = [[UIDatePicker alloc]init];
        _datePickerView.locale = [NSLocale localeWithLocaleIdentifier:@"zh"];
        _datePickerView.datePickerMode = UIDatePickerModeDateAndTime;
        if (@available(iOS 13.4, *)) {
            _datePickerView.preferredDatePickerStyle = UIDatePickerStyleWheels;
        }
        [_datePickerView setMinimumDate:[NSDate date]];
        [_datePickerView setDate:[NSDate date]];
        [_datePickerView addTarget:self action:@selector(pickerValueChange:) forControlEvents:UIControlEventValueChanged];
        
    }
    return _datePickerView;
}


- (UIButton *)confirmBt{
    if (!_confirmBt) {
        _confirmBt = [UIButton buttonWithType:UIButtonTypeCustom];
        [_confirmBt setTitle:@"确认" forState:UIControlStateNormal];
        [_confirmBt setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        _confirmBt.backgroundColor = [UIColor jpl_colorWithHexString:@"#1D6CFD"];
        _confirmBt.titleLabel.font = [UIFont jpl_pingFangWithSize:16 weight:UIFontWeightMedium];
        _confirmBt.layer.cornerRadius = 6;
        _confirmBt.layer.masksToBounds = YES;
        [_confirmBt addTarget:self action:@selector(confirmAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _confirmBt;
}

- (UIButton *)cancelBt{
    if (!_cancelBt) {
        _cancelBt = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancelBt setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelBt setTitleColor:[UIColor jpl_colorWithHexString:@"999999"] forState:UIControlStateNormal];
        _cancelBt.backgroundColor = [UIColor jpl_colorWithHexString:@"#ECECEC"];
        _cancelBt.titleLabel.font = [UIFont jpl_pingFangWithSize:16 weight:UIFontWeightMedium];
        _cancelBt.layer.cornerRadius = 6;
        _cancelBt.layer.masksToBounds = YES;
        [_cancelBt addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelBt;
}


@end
