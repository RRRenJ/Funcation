//
//  JPUMaterialUploadTipsView.m
//  EditVideoText
//
//  Created by foundao on 2021/10/20.
//

#import "JPUMaterialUploadTipsView.h"
@interface JPUMaterialUploadTipsView()
@property (weak, nonatomic) IBOutlet UIImageView *imageViewHint;
@property (weak, nonatomic) IBOutlet UILabel *labelContent;
@property (weak, nonatomic) IBOutlet UILabel *labelHint;
@property (weak, nonatomic) IBOutlet UIButton *btnUpload;
@property (weak, nonatomic) IBOutlet UIButton *btnGoHome;

@property (nonatomic, assign) BOOL isSuccess;

@end
@implementation JPUMaterialUploadTipsView

+ (instancetype)viewFromXib
{
    return [[[JPUMaterialSingleton singleton].bundle loadNibNamed:@"JPUMaterialUploadTipsView" owner:nil options:nil]firstObject];

}
- (void)setType:(JPUMaterialEditType)type
{
    _type = type;
}
- (void)show:(BOOL)isSuccess
{
    self.isSuccess = isSuccess;
    
    if (!isSuccess) {
        self.imageViewHint.image = [[JPUMaterialSingleton singleton] jpu_material_imageName:@"JPUUploadFail"];
        self.labelContent.text = @"上传失败!";
        self.labelHint.text = @"网络错误,请稍后再试";
        [self.btnUpload setTitle:@"重新上传" forState:UIControlStateNormal];
        
    }else{
        self.imageViewHint.image =[[JPUMaterialSingleton singleton] jpu_material_imageName:@"JPUUploadSuccess"];
        self.labelContent.text = @"上传成功!";
        self.labelHint.text =self.type == JPUMaterialEditAll ?  @"媒体号后台能编辑素材后发布" :  @"审核通过后可直接发布到媒体号里显示";
        [self.btnUpload setTitle:@"继续上传" forState:UIControlStateNormal];
    }
    
    [JPUKeyWindow addSubview:self];
}
- (IBAction)uploadClick {
    !self.uploadBlock?:self.uploadBlock(self.isSuccess);
    [self removeFromSuperview];
}
- (IBAction)backHomeClick {

    !self.goHomeBlock?:self.goHomeBlock();
    [self removeFromSuperview];

}

@end
