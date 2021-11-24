//
//  JPUMaterialPhotoCollectionCell.m
//  EditVideoText
//
//  Created by foundao on 2021/9/14.
//

#import "JPUMaterialPhotoCollectionCell.h"
#import "JPUMaterialSingleton.h"

@implementation JPUMaterialPhotoCollectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.viewSelectHint.layer.cornerRadius = 10;
    self.viewSelectHint.layer.borderWidth = 1;

    self.imageViewContent.layer.cornerRadius = 10;
        

}

- (void)setModel:(JPUMaterialEditAssetModel *)model
{

    
    
    _model = model;
    
    self.imageViewTags.hidden =  model.contentType == QMUIAlbumContentTypeOnlyVideo? NO : YES;
    self.labelTime.text =  model.contentType == QMUIAlbumContentTypeOnlyVideo ? [[JPUMaterialSingleton singleton] jpu_material_getVideoTime:model.asset.duration] : @"";

    self.labelTime.hidden =  model.contentType == QMUIAlbumContentTypeOnlyVideo ? NO : YES;

    self.viewSelectHint.hidden = model.contentType ==QMUIAlbumContentTypeOnlyVideo?YES:NO;
    
    if (self.model.isSelect) {
        self.viewSelectHint.layer.borderColor = UIColor.clearColor.CGColor;
        self.viewSelectHint.backgroundColor = [UIColor colorWithRed:12/255.0 green:122/255.0 blue:254/255.0 alpha:1];
        self.labelNumber.hidden = NO;
        self.labelNumber.text = [NSString stringWithFormat:@"%zd",model.selectindex];

    }else{
        self.viewSelectHint.layer.borderColor = UIColor.whiteColor.CGColor;
        self.viewSelectHint.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.29];
        self.labelNumber.hidden = YES;
    }
    
   
    NSLog(@"??????????");
    [model.asset  requestThumbnailImageWithSize:CGSizeMake(JPU_WIDTH/4,JPU_WIDTH/4) completion:^(UIImage *result, NSDictionary<NSString *,id> *info) {
        self.imageViewContent.image = result;
    }];

}
- (IBAction)delClick {
    
    !self.delBlock?:self.delBlock();
}

@end
