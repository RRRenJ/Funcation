//
//  JPDraftViewController.m
//  JPSDK
//
//  Created by 任敬 on 2021/10/25.
//

#import "JPDraftViewController.h"
#import "JPDraftCell.h"
#import "JPNewPageViewController.h"
#import "JPDraftAlertView.h"

@interface JPDraftViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionViewFlowLayout * flowLayout;

@property (nonatomic, strong) UICollectionView * collectionView;

@property (nonatomic, strong) NSMutableArray<JPVideoRecordInfo *> * dataArray;

@property (nonatomic, strong) UIBarButtonItem * backItem;

@property (nonatomic, strong) UILabel * emptyLb;


@end

@implementation JPDraftViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupViews];
    
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self getData];
    });
   
}

- (void)backAction{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

#pragma - mark init view
- (void)setupViews{
    self.navigationItem.title = @"草稿箱";
    self.navigationController.navigationBar.tintColor = UIColor.whiteColor;
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor jp_colorWithHexString:@"333333"],NSFontAttributeName : [UIFont jp_pingFangWithSize:17 weight:UIFontWeightMedium]};
    self.navigationItem.leftBarButtonItem = self.backItem;
    [self.view addSubview:self.collectionView];
    [self.view addSubview:self.emptyLb];
    [self.emptyLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.centerY.mas_equalTo(-50);
    }];
}




- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    JPDraftCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"JPDraftCell" forIndexPath:indexPath];
    cell.videoInfo = self.dataArray[indexPath.row];
    
    cell.deleteBlock = ^(JPVideoRecordInfo * _Nonnull videoInfo) {
        
        JPDraftAlertView * alert = [[JPDraftAlertView alloc]init];
        alert.confirmBlock = ^{
            [JPUtil removeRecordInfo:videoInfo completion:^{
                [self getData];
            }];
        };
        [alert show:self.navigationController];
        
    };
    
    cell.editBlock = ^(JPVideoRecordInfo * _Nonnull videoInfo) {
        
        for (JPVideoModel *videoModel in videoInfo.videoSource) {
            [videoModel asyncGetAllThumbImages];
        }

        JPNewPageViewController * pageVC = [[JPNewPageViewController alloc]initWithNibName:@"JPNewPageViewController" bundle:JPResourceBundle];
        pageVC.recordInfo = videoInfo;
        pageVC.isDrafts = YES;
        UINavigationController * navi = [[UINavigationController alloc]initWithRootViewController:pageVC];
        navi.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:navi animated:YES completion:nil];
    };
    
    return cell;
}


#pragma - mark request

- (void)getData{
    [JPUtil loadAllRecordInfoCompletion:^(NSArray<JPVideoRecordInfo *> *result) {
        [self.dataArray removeAllObjects];
        [self.dataArray addObjectsFromArray:result];
        [self.collectionView reloadData];
        self.emptyLb.hidden = self.dataArray.count > 0;
    }];
}

#pragma - mark set


#pragma - mark get

- (UICollectionViewFlowLayout *)flowLayout{
    if (!_flowLayout) {
        _flowLayout = [[UICollectionViewFlowLayout alloc]init];
        _flowLayout.sectionInset = UIEdgeInsetsMake(10, 17, 10, 17);
        _flowLayout.minimumLineSpacing = 10;
        _flowLayout.minimumInteritemSpacing = 10;
        CGFloat width = (JP_SCREEN_WIDTH - 44) / 2;
        _flowLayout.itemSize = CGSizeMake(width, width / 165.f * 121.f);
    }
    return _flowLayout;
}

- (UICollectionView *)collectionView{
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, JPGPU_SCREEN_WIDTH, JP_SCREEN_HEIGHT - JP_NAVIGATION_HEIGHT) collectionViewLayout:self.flowLayout];
        _collectionView.backgroundColor = [UIColor jp_colorWithHexString:@"f7f7f7"];
        [_collectionView registerClass:[JPDraftCell class] forCellWithReuseIdentifier:@"JPDraftCell"];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
    }
    return _collectionView;;
}

- (UIBarButtonItem *)backItem{
    if (!_backItem) {
        _backItem = [[UIBarButtonItem alloc]initWithImage:[JPImageWithName(@"draft_back") imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(backAction)];
    }
    return _backItem;
}

- (UILabel *)emptyLb{
    if (!_emptyLb) {
        _emptyLb = [[UILabel alloc]init];
        _emptyLb.text = @"暂无草稿，快去创作吧";
        _emptyLb.textColor = [UIColor jp_colorWithHexString:@"999999"];
        _emptyLb.font = [UIFont jp_pingFangWithSize:15];
    }
    return _emptyLb;
}

- (NSMutableArray<JPVideoRecordInfo *> *)dataArray{
    if (!_dataArray) {
        _dataArray = @[].mutableCopy;
    }
    return _dataArray;
}

@end
