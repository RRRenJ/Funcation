//
//  JPLLiveVideoFooterView.m
//  jper
//
//  Created by RRRenJ on 2020/9/27.
//  Copyright © 2020 MuXiao. All rights reserved.
//

#import "JPLLiveVideoFooterView.h"

@interface JPLLiveVideoFooterView ()

@property (nonatomic, strong) UIImageView * backView;

@end

@implementation JPLLiveVideoFooterView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupViews];
        [self addActions];
    }
    return self;
}



- (void)setupViews{
    self.frame = CGRectMake(0, 0, JPL_SCR_WIDTH, 18);
    self.contentView.backgroundColor = UIColor.whiteColor;
    [self.contentView addSubview:self.backView];
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];

}

- (void)addActions{
    
}


#pragma mark - set


#pragma mark - get
- (UIImageView *)backView{
    if (!_backView) {
        _backView = [[UIImageView alloc]init];
        _backView.image = [JPLImageWithName(@"liveVideoBottom") resizableImageWithCapInsets:UIEdgeInsetsMake(0, 20, 0, 20) resizingMode:UIImageResizingModeStretch];
    }
    return _backView;
}

@end
