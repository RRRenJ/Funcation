//
//  JPLWatermarkCell.m
//  jper
//
//  Created by RRRenJ on 2020/5/27.
//  Copyright © 2020 MuXiao. All rights reserved.
//

#import "JPLWatermarkCell.h"
#import "JPLWatermarkCollectionCell.h"

@interface JPLWatermarkCell ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong) UILabel * titleLb;

@property (nonatomic, strong) UICollectionView * collectionView;



@end

@implementation JPLWatermarkCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupViews];
        [self addActions];
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

   
}

- (void)setupViews{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.contentView addSubview:self.titleLb];
    [self.contentView addSubview:self.collectionView];
    [self.titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(16);
    }];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleLb.mas_bottom).mas_offset(12);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo((JPL_SCR_WIDTH - 60) / 3.f);
    }];
}

- (void)addActions{
   
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArray.count + 1;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    JPLWatermarkCollectionCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"JPLWatermarkCollectionCell" forIndexPath:indexPath];
    JPLLiveWatermarkModel * model;
    if (self.dataArray.count == indexPath.row) {
        cell.content = @"无水印";
        cell.isSelect = self.selectModel.ID.length == 0;
    }else{
        model = self.dataArray[indexPath.row];
        cell.imageURL = model.icon;
        cell.content = @"";
        cell.isSelect = [self.selectModel.ID isEqualToString:model.ID];
    }
    cell.selectBlock = ^{
        self.selectModel = model;
        if (self.selectBlock) {
            self.selectBlock(self.selectModel);
        }
        [self.collectionView reloadData];
    };
    return  cell;
}


#pragma mark - set
- (void)setDataArray:(NSArray<JPLLiveWatermarkModel *> *)dataArray{
    _dataArray = dataArray;
    [self.collectionView reloadData];
}


#pragma mark - get
- (UILabel *)titleLb{
    if (!_titleLb) {
        _titleLb = [[UILabel alloc]init];
        _titleLb.text = @"直播水印";
        _titleLb.font = [UIFont systemFontOfSize:16];
        _titleLb.textColor = [UIColor jpl_colorWithHexString:@"353535"];
    }
    return _titleLb;
}

- (UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
        layout.minimumLineSpacing = 15;
        layout.minimumInteritemSpacing = 0;
        layout.itemSize = CGSizeMake((JPL_SCR_WIDTH - 60) / 3.f, (JPL_SCR_WIDTH - 60) / 3.f);
        layout.sectionInset = UIEdgeInsetsMake(0, 15, 0, 15);
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        [_collectionView registerClass:[JPLWatermarkCollectionCell class] forCellWithReuseIdentifier:@"JPLWatermarkCollectionCell"];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
    }
    return _collectionView;
}


@end





