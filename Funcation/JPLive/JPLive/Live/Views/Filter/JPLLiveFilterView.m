//
//  JPLLiveFilterView.m
//  jper
//
//  Created by RRRenJ on 2020/5/29.
//  Copyright © 2020 MuXiao. All rights reserved.
//

#import "JPLLiveFilterView.h"
#import "JPLLiveFilterCell.h"

@interface JPLLiveFilterView ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong) UIView * tapView;

@property (nonatomic, strong) UIView * contentView;

@property (nonatomic, strong) UILabel * titleLb;

@property (nonatomic, strong) UIView * lineView;

@property (nonatomic, strong) UICollectionView * collectionView;

@property (nonatomic, strong) NSMutableArray <JPLLiveFilterModel *> *dataArray;

@property (nonatomic, strong) JPLLiveFilterModel * selectModel;

@property (nonatomic, assign) BOOL isShow;

@property (nonatomic, strong) UIButton * hideBt;

@end

@implementation JPLLiveFilterView

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

- (void)updateLayoutWithOrientation:(BOOL)isPortrait{
    self.frame = CGRectMake(0, JPL_SCR_HEIGHT, JPL_SCR_WIDTH, JPL_SCR_HEIGHT);
    if (isPortrait) {
        [self layoutWithPortrait];
    }else{
        [self layoutWithLandscape];
    }
}

- (void)setupViews{
    self.frame = CGRectMake(0, JPL_SCR_HEIGHT, JPL_SCR_WIDTH, JPL_SCR_HEIGHT);
    self.backgroundColor = [UIColor clearColor];
    self.userInteractionEnabled = YES;
    [self addSubview:self.tapView];
    [self addSubview:self.contentView];
    [self.contentView addSubview:self.titleLb];
    [self.contentView addSubview:self.lineView];
    [self.contentView addSubview:self.collectionView];
    [self.contentView addSubview:self.hideBt];
    
    
}

- (void)layoutWithLandscape{
    
    self.contentView.frame = CGRectMake(0, JPL_SCR_HEIGHT - 165, JPL_SCR_WIDTH, 165);
    self.tapView.frame = CGRectMake(0, 0, JPL_SCR_WIDTH, JPL_SCR_HEIGHT - 165);
    
    self.hideBt.hidden = YES;
    
    CGFloat left = 30;
    if ((int)(JPL_SCR_WIDTH / JPL_SCR_HEIGHT * 100) == 216) {
         left = 40;
    }
    [self.titleLb mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(left);
        make.top.mas_equalTo(12);
    }];
    [self.lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(30);
        make.right.mas_equalTo(-30);
        make.height.mas_equalTo(1);
        make.top.mas_equalTo(self.titleLb.mas_bottom).mas_offset(11);
    }];
    
    [self.collectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.lineView.mas_bottom).mas_offset(25);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(75);
    }];
}

- (void)layoutWithPortrait{
    self.contentView.frame = CGRectMake(0, JPL_SCR_HEIGHT - 200, JPL_SCR_WIDTH, 200);
    self.tapView.frame = CGRectMake(0, 0, JPL_SCR_WIDTH, JPL_SCR_HEIGHT - 200);
    
    self.hideBt.hidden = NO;
    
    [self.titleLb mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(30);
        make.top.mas_equalTo(12);
    }];
    
    [self.hideBt mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-10);
        make.centerY.mas_equalTo(self.titleLb.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
    
    [self.lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(30);
        make.right.mas_equalTo(-30);
        make.height.mas_equalTo(1);
        make.top.mas_equalTo(self.titleLb.mas_bottom).mas_offset(11);
    }];
    
    [self.collectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.lineView.mas_bottom).mas_offset(25);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(75);
    }];
}

- (void)addActions{
    self.selectModel = self.dataArray.firstObject;
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGestureClikced)];
    [self.tapView addGestureRecognizer:tap];
    
}

- (void)tapGestureClikced{
    [self hide];
    if(self.tapHideBlock){
        self.tapHideBlock();
    }
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    JPLLiveFilterCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"JPLLiveFilterCell" forIndexPath:indexPath];
    JPLLiveFilterModel * model = self.dataArray[indexPath.row];
    model.isSelect = model == self.selectModel;
    cell.model = model;
    return  cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    JPLLiveFilterModel * model = self.dataArray[indexPath.row];
    if(self.selectModel != model){
        self.selectModel = model;
        if (self.filterBlock) {
            self.filterBlock(model);
        }
        [self.collectionView reloadData];
    }
    
}

- (void)show{
    if (self.selectModel){
        NSInteger index = [self.dataArray indexOfObject:self.selectModel];
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
    }
    [[JPLUtil currentViewController].view addSubview:self];
    [UIView animateWithDuration:0.3 animations:^{
        self.transform = CGAffineTransformMakeTranslation(0, -JPL_SCR_HEIGHT);
    } completion:^(BOOL finished) {
        if (finished) {
           
        }
    }];
}

- (void)hide{
    [UIView animateWithDuration:0.3 animations:^{
        self.transform = CGAffineTransformMakeTranslation(0, 0);
    } completion:^(BOOL finished) {
        if (finished) {
          
            [self removeFromSuperview];
        }
        
    }];
}


#pragma mark - set


#pragma mark - get
- (UILabel *)titleLb{
    if (!_titleLb) {
        _titleLb = [[UILabel alloc]init];
        _titleLb.textColor = [UIColor colorWithWhite:1 alpha:0.81];
        _titleLb.text = @"选择滤镜";
        _titleLb.font = [UIFont systemFontOfSize:15];
    }
    return _titleLb;
}

- (UIView *)lineView{
    if (!_lineView) {
        _lineView = [[UIView alloc]init];
        _lineView.backgroundColor = [UIColor jpl_colorWithHexString:@"#383838"];
    }
    return _lineView;
}

- (UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
        layout.itemSize = CGSizeMake(45, 75);
        layout.minimumLineSpacing = 23;
        layout.minimumInteritemSpacing = 0;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.sectionInset = UIEdgeInsetsMake(0, 30, 0, 30);
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.backgroundColor = UIColor.clearColor;
        [_collectionView registerClass:[JPLLiveFilterCell class] forCellWithReuseIdentifier:@"JPLLiveFilterCell"];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        
    }
    return _collectionView;
}


- (UIView *)tapView{
    if (!_tapView) {
        _tapView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, JPL_SCR_WIDTH, JPL_SCR_HEIGHT - 165)];
        _tapView.userInteractionEnabled = YES;
        _tapView.backgroundColor = UIColor.clearColor;
    }
    return _tapView;;
}

- (UIView *)contentView{
    if (!_contentView) {
        _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, JPL_SCR_HEIGHT - 165, JPL_SCR_WIDTH, 165)];
        _contentView.userInteractionEnabled = YES;
        _contentView.backgroundColor = [UIColor jpl_colorWithHexString:@"#262626" alpha:0.8];
    }
    return _contentView;
}

- (UIButton *)hideBt{
    if (!_hideBt) {
        _hideBt = [UIButton buttonWithType:UIButtonTypeCustom];
        [_hideBt setImage:JPLImageWithName(@"live_pop_hide") forState:UIControlStateNormal];
        [_hideBt addTarget:self action:@selector(tapGestureClikced) forControlEvents:UIControlEventTouchUpInside];
    }
    return _hideBt;
}


- (NSMutableArray<JPLLiveFilterModel *> *)dataArray{
    if (!_dataArray) {
        _dataArray = @[].mutableCopy;
        NSArray * names = @[@"原画",@"标准",@"樱红",@"云裳",@"纯真",@"白兰",@"元气",@"超脱",@"香氛",@"美白",@"浪漫",@"清新",@"唯美",@"粉嫩",@"怀旧",@"蓝调",@"清凉",@"日系"];
        NSArray * images = @[@"orginal",@"biaozhun",@"yinghong",@"yunshang",@"chunzhen",@"bailan",@"yuanqi",@"chaotuo",@"xiangfen",@"white",@"langman",@"qingxin",@"weimei",@"fennen",@"huaijiu",@"landiao",@"qingliang",@"rixi"];
        for (int index = 0; index < names.count; index++) {
            JPLLiveFilterModel * model = [[JPLLiveFilterModel alloc]init];
            model.name = names[index];
            model.imageName = images[index];
            model.filterName = [NSString stringWithFormat:@"%@-1",model.imageName];
            model.isSelect = NO;
            if (index == 0){
                model.filterName = @"";
                model.isSelect = YES;
            }
            [_dataArray addObject:model];
        }
    }
    return _dataArray;
}





@end
