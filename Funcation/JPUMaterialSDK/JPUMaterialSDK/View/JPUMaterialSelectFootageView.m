//
//  JPUMaterialSelectFootageView.m
//  EditVideoText
//
//  Created by foundao on 2021/10/18.
//

#import "JPUMaterialSelectFootageView.h"
@interface JPUMaterialSelectFootageView()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layoutViewContentTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layoutViewContentWidth;
@end
@implementation JPUMaterialSelectFootageView

+ (instancetype)viewFromXib
{
    
    return [[[JPUMaterialSingleton singleton].bundle loadNibNamed:@"JPUMaterialSelectFootageView" owner:nil options:nil]firstObject];
}

- (void)show:(UIView *)view
{
    [view addSubview:self];
    [UIView animateWithDuration:0.25 animations:^{
        self.alpha = 1;
        self.layoutViewContentTop.constant = JPU_HEIGHT- (JPU_IPHONEX ? 415 : 380);
        [self setNeedsLayout];
        [self layoutIfNeeded];
    }];
}
- (void)awakeFromNib
{
    [super awakeFromNib];
    self.autoresizingMask  = 0;
    self.alpha = 0;
    self.layoutContentHeight.constant = JPU_IPHONEX ? 415 : 380;
    self.layoutViewContentTop.constant = JPU_HEIGHT;
    self.layoutViewContentWidth.constant = JPU_WIDTH;
    [self setNeedsLayout];
    [self layoutIfNeeded];
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    [[JPUMaterialSingleton singleton]makeLayer:self.viewContent byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(15, 15)];
}


- (IBAction)btnAllClick {
    
    !self.selectBlock?:self.selectBlock(JPUMaterialEditAll);
    [self removeFromSuperview];

}
- (IBAction)btnVideoClick {
    !self.selectBlock?:self.selectBlock(JPUMaterialEditVideo);
    [self removeFromSuperview];

}

- (IBAction)btnImageClick {
    !self.selectBlock?:self.selectBlock(JPUMaterialEditImage);
    [self removeFromSuperview];


}
- (IBAction)btnCancelClick {
    
    [self removeFromSuperview];
}

@end
