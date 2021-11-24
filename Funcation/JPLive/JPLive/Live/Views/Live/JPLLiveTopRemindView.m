//
//  JPLLiveTopRemindView.m
//  jper
//
//  Created by RRRenJ on 2020/6/24.
//  Copyright © 2020 MuXiao. All rights reserved.
//

#import "JPLLiveTopRemindView.h"


@interface JPLLiveTopRemindView ()

@property (nonatomic, strong) UILabel * contentLb;

@property (nonatomic, assign) BOOL isShow;

@end

@implementation JPLLiveTopRemindView

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
    self.frame = CGRectMake(0, -40, JPL_SCR_WIDTH, 40);
    self.backgroundColor = UIColor.redColor;
    [self addSubview:self.contentLb];
    [self.contentLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    self.isShow = NO;
}

- (void)addActions{
    
}

- (void)show{
    if (self.isShow) {
        return;
    }
    self.isShow = YES;
    [[JPLUtil currentViewController].view addSubview:self];
    [UIView animateWithDuration:0.3 animations:^{
        self.transform = CGAffineTransformMakeTranslation(0, self.frame.size.height);
    } completion:^(BOOL finished) {
        if (finished) {
            [self performSelector:@selector(hide) withObject:nil afterDelay:3];
        }
    }];
}

- (void)hide{
    [UIView animateWithDuration:0.3 animations:^{
        self.transform = CGAffineTransformMakeTranslation(0, 0);
    } completion:^(BOOL finished) {
        if (finished) {
            [self removeFromSuperview];
            self.isShow = NO;
        }
    }];
}

#pragma mark - set
- (void)setContent:(NSString *)content{
    if (self.isShow) {
        return;
    }
    _content = content;
    self.contentLb.text = _content;
}


#pragma mark - get
- (UILabel *)contentLb{
    if (!_contentLb) {
        _contentLb = [[UILabel alloc]init];
        _contentLb.textColor = UIColor.whiteColor;
        _contentLb.font = [UIFont systemFontOfSize:14];
        _contentLb.textAlignment = NSTextAlignmentCenter;
    }
    return _contentLb;
    
}

@end
