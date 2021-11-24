//
//  JPUMaterialSelectAlbumsView.m
//  EditVideoText
//
//  Created by foundao on 2021/10/19.
//

#import "JPUMaterialSelectAlbumsView.h"
@interface JPUMaterialSelectAlbumsView()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layoutContentHeight;
@property (weak, nonatomic) IBOutlet UIView *viewContent;
@property (nonatomic, assign) QMUIAlbumContentType contentType;

@end
@implementation JPUMaterialSelectAlbumsView
- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.layoutContentHeight.constant = JPU_IPHONEX ? 199 : 165;

}

+ (instancetype)viewFromXib
{
    
    return [[[JPUMaterialSingleton singleton].bundle loadNibNamed:@"JPUMaterialSelectAlbumsView" owner:nil options:nil]firstObject];

}

- (void)show:(QMUIAlbumContentType)contentType
{
    self.contentType = contentType;
    if (self.contentType == QMUIAlbumContentTypeOnlyVideo) {
        [self.btnShoot setTitle:@"拍摄视频" forState:UIControlStateNormal];
        [self.btnPhotoAlbum setTitle:@"从相册导入视频" forState:UIControlStateNormal];
    }else{
        [self.btnShoot setTitle:@"拍摄图片" forState:UIControlStateNormal];
        [self.btnPhotoAlbum setTitle:@"从相册导入图片" forState:UIControlStateNormal];
    }
    
    [JPUKeyWindow addSubview:self];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [[JPUMaterialSingleton singleton]makeLayer:self.viewContent byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(15, 15)];
}

- (IBAction)takeClick {
    
    if (self.contentType == QMUIAlbumContentTypeOnlyVideo) {
        !self.takeVideoBlock?:self.takeVideoBlock();
    }else{
        !self.takePhotoBlock?:self.takePhotoBlock();
    }
    [self removeFromSuperview];

}
- (IBAction)photoAlbumClick:(id)sender {
    

    if (self.contentType == QMUIAlbumContentTypeOnlyVideo) {
        !self.addVideoBlock?:self.addVideoBlock();
    }else{
        !self.addPhotoBlock?:self.addPhotoBlock();
    }
    [self removeFromSuperview];
    
}
- (IBAction)cancelClick {
    [self removeFromSuperview];
}

@end
