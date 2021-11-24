//
//  UILabel+JPL.m
//  JPLSDK
//
//  Created by 任敬 on 2021/10/26.
//

#import "UILabel+JPL.h"

@implementation UILabel (JPL)

- (void)changeLineSpace:(float)space {

    NSString *labelText = self.text;
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:labelText];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:space];
    [paragraphStyle setAlignment:self.textAlignment];
    [attributedString addAttributes:@{NSParagraphStyleAttributeName : paragraphStyle, NSForegroundColorAttributeName : self.textColor, NSFontAttributeName : self.font} range:NSMakeRange(0, [labelText length])];
    self.attributedText = attributedString;
    [self sizeToFit];

}

@end
