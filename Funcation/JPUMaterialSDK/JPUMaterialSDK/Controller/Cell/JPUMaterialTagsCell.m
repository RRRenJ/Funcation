//
//  JPUMaterialTagsCell.m
//  EditVideoText
//
//  Created by foundao on 2021/11/4.
//

#import "JPUMaterialTagsCell.h"

@implementation JPUMaterialTagsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.layer.masksToBounds = NO;
}
- (IBAction)delClick {
    !self.delTagsBlock?:self.delTagsBlock();
}

@end
