//
//  JPLAlertView.m
//  jper
//
//  Created by 藩 亜玲 on 2017/5/25.
//  Copyright © 2017年 MuXiao. All rights reserved.
//

#import "JPLAlertView.h"

@implementation JPLAlertView

- (id)initWithTitle:(NSString *)title andFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        
        UILabel *lable = [[UILabel alloc] init];
        lable.numberOfLines = 0;
        lable.textAlignment = NSTextAlignmentCenter;
        lable.font = [UIFont jpl_pingFangWithSize:17];
        lable.textColor = [UIColor whiteColor];
        lable.backgroundColor = [UIColor clearColor];
        lable.text = title;
        
        
        NSStringDrawingOptions opts = NSStringDrawingUsesLineFragmentOrigin |
        NSStringDrawingUsesFontLeading;
        
        NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
        [style setLineBreakMode:NSLineBreakByCharWrapping];
        
        NSDictionary *attributes = @{NSFontAttributeName:lable.font, NSParagraphStyleAttributeName:style};
        
        CGRect rect = [title boundingRectWithSize:CGSizeMake(280, 1000)
                                          options:opts
                                       attributes:attributes
                                          context:nil];
        lable.frame = CGRectMake((self.frame.size.width - rect.size.width)/2, (self.frame.size.height - rect.size.height)/2, rect.size.width, rect.size.height);
        
        UIView *bkView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, lable.frame.size.width + 20, lable.frame.size.height + 20)];
        bkView.backgroundColor = [UIColor blackColor];
        bkView.alpha = 0.7f;
        bkView.center = lable.center;
        bkView.layer.cornerRadius = 4;
        bkView.layer.masksToBounds = YES;
       
        
        [self addSubview:bkView];
        [self addSubview:lable];
        self.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    }
    return self;
}

@end
