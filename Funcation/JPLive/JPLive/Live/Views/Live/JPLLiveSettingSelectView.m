//
//  JPLLiveSettingSelectView.m
//  jper
//
//  Created by RRRenj on 2021/6/25.
//  Copyright © 2021 MuXiao. All rights reserved.
//

#import "JPLLiveSettingSelectView.h"
#import "LewPopupViewController.h"

@interface JPLLiveSettingSelectView ()<UIPickerViewDelegate,UIPickerViewDataSource>

@property (nonatomic, strong) UIPickerView * pickerView;

@property (nonatomic, strong) UIButton * cancelBt;

@property (nonatomic, strong) UIButton * comfirmBt;

@property (nonatomic, strong) UIView * lineView;

@property (nonatomic, strong) NSMutableArray * dataArray;

@end


@implementation JPLLiveSettingSelectView

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

- (void)setupViews{
    self.bounds = CGRectMake(0, 0, JPL_SCR_WIDTH, 218 + JPL_BOTTOM_HEIGHT);
    self.backgroundColor = UIColor.whiteColor;
    [self addSubview:self.cancelBt];
    [self addSubview:self.comfirmBt];
    [self addSubview:self.lineView];
    [self addSubview:self.pickerView];
    
    [self.cancelBt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(5);
        make.top.mas_equalTo(5);
        make.size.mas_equalTo(CGSizeMake(50, 45));
    }];
    
    [self.comfirmBt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-5);
        make.top.mas_equalTo(5);
        make.size.mas_equalTo(CGSizeMake(50, 45));
    }];
    
    [self.pickerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.lineView.mas_bottom);
        make.bottom.mas_equalTo(-JPL_BOTTOM_HEIGHT);
        make.left.and.right.mas_equalTo(0);
    }];
    
   
    
}

- (void)addActions{
    
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return  1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return self.dataArray.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return self.dataArray[row];
}


- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel * label;
    if (![view isKindOfClass:[UILabel class]]){
        label = [[UILabel alloc]init];
    }
    label.textColor = [UIColor jpl_colorWithHexString:@"#353535"];
    label.font = [UIFont systemFontOfSize:16];
    label.text = self.dataArray[row];
    label.textAlignment = NSTextAlignmentCenter;
    for (UIView * line in pickerView.subviews) {
        if (line.height < 1) {
            line.backgroundColor = UIColor.clearColor;
        }
    }
    return  label;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return 54;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    self.selectTitle = self.dataArray[row];
}



- (void)cancelBtClicked{
    [self hide];
}

- (void)comfirmBtClicked{
    if (self.selectBlock) {
        self.selectBlock(self.selectTitle);
        [self hide];
    }
}

- (void)show{
    if (self.selectTitle){
        if ( [self.dataArray containsObject:self.selectTitle]){
            NSInteger index = [self.dataArray indexOfObject:self.selectTitle];
            [self.pickerView selectRow:index inComponent:0 animated:NO];
        };
    }
    LewPopupViewAnimationSlide * animation = [[LewPopupViewAnimationSlide alloc]init];
    animation.type = LewPopupViewAnimationSlideTypeBottomBottom;
    animation.popViewPoint_y = JPL_SCR_HEIGHT - self.height;
    [JPLUtil.currentViewController lew_presentPopupView:self animation:animation backgroundClickable:YES];
}

- (void)hide{
    [JPLUtil.currentViewController lew_dismissPopupView];
}

#pragma mark - set
- (void)setDataSource:(NSArray<NSString *> *)dataSource{
    _dataSource = dataSource;
    [self.dataArray removeAllObjects];
    [self.dataArray addObjectsFromArray:_dataSource];
}


#pragma mark - get
- (UIButton *)cancelBt{
    if (!_cancelBt) {
        _cancelBt = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancelBt setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelBt addTarget:self action:@selector(cancelBtClicked) forControlEvents:UIControlEventTouchUpInside];
        _cancelBt.titleLabel.font = [UIFont systemFontOfSize:14];
        [_cancelBt setTitleColor:[UIColor jpl_colorWithHexString:@"ADADAD"] forState:UIControlStateNormal];
    }
    return _cancelBt;
}
- (UIButton *)comfirmBt{
    if (!_comfirmBt) {
        _comfirmBt = [UIButton buttonWithType:UIButtonTypeCustom];
        [_comfirmBt setTitle:@"确定" forState:UIControlStateNormal];
        [_comfirmBt addTarget:self action:@selector(comfirmBtClicked) forControlEvents:UIControlEventTouchUpInside];
        _comfirmBt.titleLabel.font = [UIFont systemFontOfSize:14];
        [_comfirmBt setTitleColor:[UIColor jpl_colorWithHexString:@"0091FF"] forState:UIControlStateNormal];
    }
    return _comfirmBt;
}

- (UIPickerView *)pickerView{
    if (!_pickerView) {
        _pickerView = [[UIPickerView alloc]init];
        _pickerView.delegate = self;
        _pickerView.dataSource = self;
    }
    return _pickerView;
}

- (UIView *)lineView{
    if (!_lineView) {
        _lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 55, JPL_SCR_WIDTH, 1)];
        _lineView.backgroundColor = [UIColor jpl_colorWithHexString:@"000000" alpha:0.13];
    }
    return _lineView;
}


- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = @[].mutableCopy;
    }
    return _dataArray;
}

@end
