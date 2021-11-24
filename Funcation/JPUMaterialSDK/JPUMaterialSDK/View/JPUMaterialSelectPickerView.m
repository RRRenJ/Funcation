//
//  JPUMaterialSelectPickerView.m
//  EditVideoText
//
//  Created by foundao on 2021/10/29.
//

#import "JPUMaterialSelectPickerView.h"
@interface JPUMaterialSelectPickerView()<UIPickerViewDelegate,UIPickerViewDataSource>

@property (weak, nonatomic) IBOutlet UIView *viewContent;
@property (weak, nonatomic) IBOutlet UIPickerView *pickView;
@property (nonatomic, assign) NSInteger classSelect;
@property (nonatomic, assign) NSInteger classSubSelect;
@property (nonatomic, assign) NSInteger screenSelect;
@property (nonatomic, assign) BOOL isClass;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layoutViewContentHeight;



@end
@implementation JPUMaterialSelectPickerView
+ (instancetype)viewFromXib
{
    return [[[JPUMaterialSingleton singleton].bundle loadNibNamed:@"JPUMaterialSelectPickerView" owner:nil options:nil]firstObject];

}
- (void)show:(BOOL)isVideoClass;
{
    
    self.isClass = isVideoClass;
    [JPUKeyWindow addSubview:self];
    [self.pickView reloadAllComponents];

    if (isVideoClass) {
        [self.pickView selectRow:self.classSelect inComponent:0 animated:NO];
        [self.pickView selectRow:self.classSubSelect inComponent:1 animated:NO];
        
    }else{
        [self.pickView selectRow:self.screenSelect inComponent:0 animated:NO];
    }
    

}
- (void)awakeFromNib
{
    [super awakeFromNib];
    self.pickView.dataSource = self;
    self.pickView.delegate = self;
    self.layoutViewContentHeight.constant =   300 + ( JPU_IPHONEX ? JPU_SafeBottomMargin : 0 );
    self.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    [self setNeedsLayout];
    [self layoutIfNeeded];
  
}
- (void)setVideoClassArr:(NSArray *)videoClassArr
{
    _videoClassArr = videoClassArr;
    
}
- (void)setVideoScreenArr:(NSArray *)videoScreenArr
{
    _videoScreenArr = videoScreenArr;
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    [[JPUMaterialSingleton singleton]makeLayer:self.viewContent byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(15, 15)];
    
}
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    
    if (self.isClass) {
        return 2;
    }else{
        return 1;
    }
}

//设置指定列包含的项数
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
  
    if (self.isClass) {
        if (component == 0) {
            return self.videoClassArr.count;
        }else{
            JPUMaterialVideoClass *model = self.videoClassArr[self.classSelect];
            return model.labels.count;
        }
    }else{
        return self.videoScreenArr.count;
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if (self.isClass) {
        if (component == 0) {
            JPUMaterialVideoClass *model = self.videoClassArr[row];
            return model.cateName;
        }else{
            JPUMaterialVideoClass *model = self.videoClassArr[self.classSelect];
            JPUMaterialVideoClassSub *subModel = model.labels[row];
            return subModel.labelName;
        }
    }else {
        JPUMaterialVideoClass *model = self.videoScreenArr[row];
        return model.cateName;
    }
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 40;
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (self.isClass) {
        if (component == 0) {
            self.classSelect = row;
            self.classSubSelect = 0;
            [self.pickView reloadAllComponents];
        }else{
            NSLog(@"row-%zd",row);
            self.classSubSelect = row;
        }
    }else{
        self.screenSelect = row;
    }    
}

- (IBAction)sureClick {
    
    if (self.isClass) {
        JPUMaterialVideoClass *model = self.videoClassArr[self.classSelect];
        JPUMaterialVideoClassSub *subModel = model.labels[self.classSubSelect];
        !self.selectClassBlock?:self.selectClassBlock(model,subModel);
    }else{
        JPUMaterialVideoClass *model = self.videoScreenArr[self.screenSelect];
        !self.selectScreenBlock?:self.selectScreenBlock(model);
    }
    
    [self removeFromSuperview];
}

- (IBAction)cancelClick {
    [self removeFromSuperview];
}

@end
