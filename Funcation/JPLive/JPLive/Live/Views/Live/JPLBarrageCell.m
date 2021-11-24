//
//  JPLBarrageCell.m
//  jper
//
//  Created by RRRenJ on 2020/5/28.
//  Copyright © 2020 MuXiao. All rights reserved.
//

#import "JPLBarrageCell.h"


@interface JPLBarrageCell ()

@property (nonatomic, strong) UILabel * messageLb;

@end

@implementation JPLBarrageCell

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

- (instancetype)reloadCustomCell{
    return [[JPLBarrageCell alloc]init];
}

+ (instancetype)cellWithBarrageView:(BarrageView *)barrageView
{
    static NSString *reuseIdentifier = @"JPLBarrageCell";
    JPLBarrageCell *cell = [barrageView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (!cell) {
        cell = [[JPLBarrageCell alloc] initWithIdentifier:reuseIdentifier];
    }
    return cell;
}

- (void)setupViews{
    self.backgroundColor = UIColor.clearColor;
    [self addSubview:self.messageLb];
    [self.messageLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
}

- (void)addActions{
    
}


#pragma mark - set
- (void)setModel:(JPLBarrageModel *)model{
    _model = model;
    NSMutableAttributedString * name = [[NSMutableAttributedString alloc]initWithString:_model.name attributes:@{NSFontAttributeName:self.messageLb.font,NSForegroundColorAttributeName:[UIColor jpl_colorWithHexString:@"#39AAFF"]}];
    NSAttributedString * message = [[NSAttributedString alloc]initWithString:_model.message attributes:@{NSFontAttributeName:self.messageLb.font,NSForegroundColorAttributeName:[UIColor whiteColor]}];
    [name appendAttributedString:message];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setAlignment:NSTextAlignmentCenter];
    [name addAttributes:@{NSParagraphStyleAttributeName : paragraphStyle} range:NSMakeRange(0, [name length])];
    self.messageLb.attributedText = name;
}

#pragma mark - get
- (UILabel *)messageLb{
    if (!_messageLb) {
        _messageLb = [[UILabel alloc]init];
        _messageLb.backgroundColor = [UIColor jpl_colorWithHexString:@"000000" alpha:0.51];
        _messageLb.layer.masksToBounds = YES;
        _messageLb.layer.cornerRadius = 16;
        _messageLb.font = [UIFont systemFontOfSize:14 weight:UIFontWeightSemibold];
    }
    return _messageLb;
}

@end
