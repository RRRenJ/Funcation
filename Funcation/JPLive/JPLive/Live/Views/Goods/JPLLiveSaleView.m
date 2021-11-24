//
//  JPLLiveSaleView.m
//  jper
//
//  Created by RRRenJ on 2020/5/29.
//  Copyright © 2020 MuXiao. All rights reserved.
//

#import "JPLLiveSaleView.h"
#import "JPLLiveSaleGoodsCell.h"

@interface JPLLiveSaleView ()<UICollectionViewDelegate,UICollectionViewDataSource,DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@property (nonatomic, strong) UICollectionViewFlowLayout * flowLayout;

@property (nonatomic, strong) UICollectionView * collectionView;

@property (nonatomic, strong) UILabel * remindLb;

@property (nonatomic, strong) UIButton * comfirmBt;

@property (nonatomic, strong) JPLLiveGoodsModel * selectModel;
//上次选中的商品
@property (nonatomic, strong) JPLLiveGoodsModel * prSLModel;

@property (nonatomic, strong) NSMutableArray <JPLLiveGoodsModel *>* dataArray;


@end

@implementation JPLLiveSaleView

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

- (void)dealloc{
    [self removeObserver:self forKeyPath:@"selectModel" context:nil];
}

- (void)updateLayoutWithOrientation:(BOOL)isPortrait{
    if (isPortrait) {
        [self layoutWithPortrait];
    }else{
        [self layoutWithLandscape];
    }
}


- (void)setupViews{
    
    [self addSubview:self.remindLb];
    [self addSubview:self.comfirmBt];
    [self addSubview:self.collectionView];
    
    __weak typeof(self) weakself  = self;
    [self.collectionView jpl_addRefreshHeaderWithRefreshingBlock:^{
        [weakself requestSaleGoods];
    }];
  
    [self saleViewMoveTopAnimation:NO];
}

- (void)layoutWithLandscape{
    
    CGFloat left = 0;
    if ((int)(JPL_SCR_WIDTH / JPL_SCR_HEIGHT * 100) == 216) {
         left = 34;
    }
    self.bounds = CGRectMake(0, 0, 0.62 * JPL_SCR_WIDTH - left, JPL_SCR_HEIGHT - 73);
    
    CGFloat width = (self.frame.size.width - 55) / 3.0f;
    self.flowLayout.itemSize = CGSizeMake(width, width / 3.f * 2.f);
    self.flowLayout.minimumLineSpacing = 12;
    self.flowLayout.minimumInteritemSpacing = 12;
    self.flowLayout.sectionInset = UIEdgeInsetsMake(0, 15, 12, 15);
    
    [self.comfirmBt mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.top.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(88, 30));
    }];
    [self.remindLb mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(self.comfirmBt.mas_left).mas_offset(-10);
        make.centerY.mas_equalTo(self.comfirmBt.mas_centerY);
    }];
    
    [self.collectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.comfirmBt.mas_bottom).mas_offset(15);
        make.left.right.bottom.mas_equalTo(0);
    }];
    [self.collectionView reloadData];
}

- (void)layoutWithPortrait{
    self.bounds = CGRectMake(0, 0, JPL_SCR_WIDTH, 472 - 68);
    
    CGFloat width = (self.frame.size.width - 45) / 2.0f;
    self.flowLayout.itemSize = CGSizeMake(width, width / 3.f * 2.f);
    self.flowLayout.minimumLineSpacing = 15;
    self.flowLayout.minimumInteritemSpacing = 15;
    self.flowLayout.sectionInset = UIEdgeInsetsMake(0, 15, 20, 15);
    
    [self.comfirmBt mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.top.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(88, 30));
    }];
    [self.remindLb mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(self.comfirmBt.mas_left).mas_offset(-10);
        make.centerY.mas_equalTo(self.comfirmBt.mas_centerY);
    }];
    
    [self.collectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.comfirmBt.mas_bottom).mas_offset(15);
        make.left.right.bottom.mas_equalTo(0);
    }];
    
    [self.collectionView reloadData];
}

- (void)addActions{
    [self addObserver:self forKeyPath:@"selectModel" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)saleViewMoveTopAnimation:(BOOL)animation{
    self.remindLb.hidden = YES;
    self.comfirmBt.hidden = YES;
    [UIView animateWithDuration:animation ? 0.3 : 0 animations:^{
        [self.collectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(0);
            make.left.right.bottom.mas_equalTo(0);
        }];
        [self layoutIfNeeded];
    }];
    
}

- (void)saleViewMoveBottomAnimation:(BOOL)animation{
    self.remindLb.hidden = NO;
    self.comfirmBt.hidden = NO;
    [UIView animateWithDuration:animation ? 0.3 : 0 animations:^{
        [self.collectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.comfirmBt.mas_bottom).mas_offset(15);
            make.left.right.bottom.mas_equalTo(0);
        }];
        [self layoutIfNeeded];
    }];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:@"selectModel"]) {
        
        if (!self.selectModel && !self.prSLModel) {
  
            [self saleViewMoveTopAnimation:YES];
        }else{
            if ([self.selectModel.goods_id isEqualToString:self.prSLModel.goods_id]) {

                [self saleViewMoveTopAnimation:YES];
            }else{

                [self saleViewMoveBottomAnimation:YES];
                if (self.selectModel) {
                    self.remindLb.text = [NSString stringWithFormat:@"确认展示商品%@?",self.selectModel.goods_name];
                }else{
                    self.remindLb.text = @"暂不展示商品";
                }
            }
        }
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    JPLLiveSaleGoodsCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"JPLLiveSaleGoodsCell" forIndexPath:indexPath];
    JPLLiveGoodsModel * model = self.dataArray[indexPath.row];
    model.isSelect = [model.goods_id isEqualToString: self.selectModel.goods_id];
    cell.model = model;
    cell.selectBlock = ^(BOOL isSelect) {
        if (isSelect) {
            self.selectModel = model;
        }else{
            self.selectModel = nil;
        }
        [self.collectionView reloadData];
    };
    
    
    return  cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    JPLLiveGoodsModel * model = self.dataArray[indexPath.row];
    model.isSelect = !model.isSelect;
    if (model.isSelect) {
        self.selectModel = model;
    }else{
        self.selectModel = nil;
    }
    [self.collectionView reloadData];
}

#pragma mark - <DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>
- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView {
    return self.dataArray.count == 0;
    
}

// 返回图片
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView{
    return nil;
}

- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView {
    NSString * text = @"暂无售卖商品内容";
    NSMutableParagraphStyle *paragraph = [NSMutableParagraphStyle new];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    paragraph.alignment = NSTextAlignmentCenter;
    NSDictionary *attribute = @{NSFontAttributeName:[UIFont jpl_pingFangWithSize:14], NSForegroundColorAttributeName: [UIColor jpl_colorWithHexString:@"#666666"], NSParagraphStyleAttributeName: paragraph};
    return [[NSAttributedString alloc] initWithString:text attributes:attribute];
}

- (nullable UIColor *)backgroundColorForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIColor clearColor];
}

// 是否允许点击，默认NO
- (BOOL)emptyDataSetShouldAllowTouch:(UIScrollView *)scrollView {
    return YES;
}

- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView {
    return YES;
}

- (void)emptyDataSet:(UIScrollView *)scrollView didTapView:(UIView *)view {
    [self.collectionView jpl_startHeaderRefreshing];
}


- (void)comfirmBtClicked{
    if (self.selectModel) {
        [self requestSale];
    }else{
        if (self.selectBlock){
            [MBProgressHUD jpl_showMessage:@"暂不展示商品"];
            self.prSLModel = nil;
            self.selectBlock(nil);
            [self saleViewMoveTopAnimation:YES];
        }
    }
    
}
- (void)refreshRequestData{
    [self.collectionView jpl_startHeaderRefreshing];
    
    [self saleViewMoveTopAnimation:NO];
}



#pragma mark - request
- (void)requestSaleGoods{
//    NSMutableDictionary *dic = @{@"service":@"App.Live_Goods.Ready",
//                                 @"token":[JPUserInfo shareInstance].token,
//                                 @"live_id":@([self.live_id integerValue]),
//                                }.mutableCopy;
//    [JPService requestWithURLString:API_HOST parameters:dic type:JPHttpRequestTypePost success:^(JPResultBase *response) {
//        if ([response.ret integerValue] == 200) {
//            [self.dataArray removeAllObjects];
//            self.dataArray = [JPLLiveGoodsModel mj_objectArrayWithKeyValuesArray:response.data];
//            if (self.saleGoodsBlock) {
//                self.saleGoodsBlock(self.dataArray);
//            }
//        }else{
//            [MBProgressHUD jpl_showMessage:response.msg];
//        }
//        self.collectionView.emptyDataSetDelegate = self;
//        self.collectionView.emptyDataSetSource = self;
//        [self.collectionView reloadData];
//        [self.collectionView endHeaderRefreshing];
//    } failure:^(NSError *error) {
//        self.collectionView.emptyDataSetDelegate = self;
//        self.collectionView.emptyDataSetSource = self;
//        [self.collectionView endHeaderRefreshing];
//    } withErrorMsg:@"网络出错，请稍后重试"];
}

- (void)requestSale{
//    [[JPLUtil currentViewController] jpl_showHUD];
//    NSMutableDictionary *dic = @{@"service":@"App.Live_Goods.Sale",
//                                 @"token":[JPUserInfo shareInstance].token,
//                                 @"live_id":@([self.live_id integerValue]),
//                                 @"goods_id":@([self.selectModel.goods_id integerValue])
//                                }.mutableCopy;
//    [JPService requestWithURLString:API_HOST parameters:dic type:JPHttpRequestTypePost success:^(JPResultBase *response) {
//        if ([response.ret integerValue] == 200) {
//
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                [[JPLUtil currentViewController] hidHUD];
//                if (self.selectBlock){
//                    self.prSLModel = self.selectModel;
//                    self.selectBlock(self.selectModel);
//                }
//                [self saleViewMoveTopAnimation:YES];
//                [MBProgressHUD jpl_showMessage:@"商品开始展示"];
//            });
//
//
//        }else{
//            [[JPLUtil currentViewController] hidHUD];
//            [MBProgressHUD jpl_showMessage:response.msg];
//        }
//        [self.collectionView reloadData];
//    } failure:^(NSError *error) {
//        [[JPLUtil currentViewController] hidHUD];
//    } withErrorMsg:@"网络出错，请稍后重试"];
}


#pragma mark - set


#pragma mark - get
- (UIButton *)comfirmBt{
    if (!_comfirmBt) {
        _comfirmBt = [UIButton buttonWithType:UIButtonTypeCustom];
        [_comfirmBt setTitle:@"确定" forState:UIControlStateNormal];
        [_comfirmBt addTarget:self action:@selector(comfirmBtClicked) forControlEvents:UIControlEventTouchUpInside];

        _comfirmBt.backgroundColor = UIColor.whiteColor;
        [_comfirmBt setTitleColor:[UIColor jpl_colorWithHexString:@"#0091FF"] forState:UIControlStateNormal];
        _comfirmBt.titleLabel.font = [UIFont jpl_pingFangWithSize:12];
        _comfirmBt.layer.masksToBounds = YES;
        _comfirmBt.layer.cornerRadius = 15;
    }
    return _comfirmBt;
}

- (UILabel *)remindLb{
    if (!_remindLb) {
        _remindLb = [[UILabel alloc]init];
        _remindLb.textColor = UIColor.whiteColor;
        _remindLb.text = @"请选择需要展示的商品";
        _remindLb.font = [UIFont jpl_pingFangWithSize:15];
    }
    return _remindLb;
}


- (UICollectionViewFlowLayout *)flowLayout{
    if (!_flowLayout) {
        CGFloat width = (self.width - 55) / 3.0f;
        _flowLayout = [[UICollectionViewFlowLayout alloc]init];
        _flowLayout.itemSize = CGSizeMake(width, width / 3.f * 2.f);
        _flowLayout.minimumLineSpacing = 12;
        _flowLayout.minimumInteritemSpacing = 12;
        _flowLayout.sectionInset = UIEdgeInsetsMake(0, 15, 12, 15);
    }
    return _flowLayout;
}

- (UICollectionView *)collectionView{
    if (!_collectionView) {
    
        
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:self.flowLayout];
        _collectionView.backgroundColor = UIColor.clearColor;
        [_collectionView registerClass:[JPLLiveSaleGoodsCell class] forCellWithReuseIdentifier:@"JPLLiveSaleGoodsCell"];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        
    }
    return _collectionView;
}

- (NSMutableArray<JPLLiveGoodsModel *> *)dataArray{
    if (!_dataArray) {
        _dataArray = @[].mutableCopy;
    }
    return _dataArray;
}

@end
