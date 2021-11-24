//
//  JPUMaterialPhotoAlbumController.m
//  EditVideoText
//
//  Created by foundao on 2021/9/14.
//

#import "JPUMaterialPhotoAlbumController.h"
#import "JPUMaterialPhotoCollectionCell.h"
#import "JPUMaterialVideoPlayViewController.h"
#import "JPUMaterialSingleton.h"
#import <Photos/Photos.h>



@interface JPUMaterialPhotoAlbumController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *layoutFlow;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layoutNavHeight;
@property (weak, nonatomic) IBOutlet UIButton *btnBack;
@property (weak, nonatomic) IBOutlet UILabel *labelTitle;
@property (weak, nonatomic) IBOutlet UIButton *btnFinish;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layoutCollectionBottom;
@property (nonatomic, strong) NSMutableArray* dataSource;
@property (nonatomic, strong) NSMutableArray* selectArr;
@property (nonatomic, strong) NSMutableArray *indexArr;


@end

@implementation JPUMaterialPhotoAlbumController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpUI];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self getAlbum];
    });
}
- (void)setUpUI
{
    self.layoutNavHeight.constant = JPU_NavHeight;
    self.labelTitle.text = self.contentType == QMUIAlbumContentTypeOnlyVideo ? @"全部视频" : @"最近图片";
    self.btnFinish.hidden = self.contentType == QMUIAlbumContentTypeOnlyVideo ? YES :NO;
    self.layoutCollectionBottom.constant = self.contentType == QMUIAlbumContentTypeOnlyVideo ? 0 : -75;
    self.layoutFlow.itemSize = CGSizeMake(JPU_WIDTH/4,JPU_WIDTH/4);
    self.layoutFlow.minimumLineSpacing = 0;
    self.layoutFlow.minimumInteritemSpacing = 0;
    self.layoutFlow.sectionInset = UIEdgeInsetsMake(5, 0, 0, 0);
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
        [self.collectionView registerNib:[UINib nibWithNibName:@"JPUMaterialPhotoCollectionCell" bundle:[JPUMaterialSingleton singleton].bundle] forCellWithReuseIdentifier:@"cell"];

    self.btnFinish.layer.masksToBounds = YES;
    self.btnFinish.layer.cornerRadius = 20;

    
}
- (void)getAlbum{
    if ([PHPhotoLibrary authorizationStatus] == PHAuthorizationStatusNotDetermined) {
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            if (status == PHAuthorizationStatusAuthorized) {
                [self loadDataSource];
            }else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[JPUMaterialProgressHUD sharedHUD]showHint:@"没有相册权限"];
                });
            }
        }];
    }else if ([PHPhotoLibrary authorizationStatus] == PHAuthorizationStatusAuthorized) {
        [self loadDataSource];
    }else if ([PHPhotoLibrary authorizationStatus] == PHAuthorizationStatusDenied || [PHPhotoLibrary authorizationStatus] == PHAuthorizationStatusRestricted) {
        [[JPUMaterialProgressHUD sharedHUD]showHint:@"您还未开启相册权限"];
    }
}


- (void)loadDataSource
{
    self.dataSource = [NSMutableArray arrayWithArray:[[JPUMaterialSingleton singleton] jpu_material_getAllAlbumsWithAlbum:self.contentType]];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.collectionView reloadData];
    });
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataSource.count;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    JPUMaterialPhotoCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.backgroundColor = UIColor.clearColor;
    JPUMaterialEditAssetModel *model = self.dataSource[indexPath.item];
    cell.model = model;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    JPUMaterialEditAssetModel *model = self.dataSource[indexPath.item];
    if (self.contentType == QMUIAlbumContentTypeOnlyVideo) {
        [[JPUMaterialProgressHUD sharedHUD]show];
        [[JPUMaterialSingleton singleton] jpu_material_downloadiCloudVideo:model.asset.phAsset success:^(NSString * _Nonnull filePath) {
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                
                [model.asset assetSize:^(long long size) {
                    CGFloat mb = size/(1024*1024.0);
                    if (mb > 1024) {
                        [[JPUMaterialProgressHUD sharedHUD]showHint:@"视频过大,请重新选择"];
                        return;
                    }
                    if (model.asset.duration >1800) {
                        [[JPUMaterialProgressHUD sharedHUD]showHint:@"视频时间超过30分钟"];
                        return;
                    }
                    
                    
                    [[JPUMaterialProgressHUD sharedHUD]hide];
                    model.filePath =filePath;
                    model.videoImage = model.asset.originImage;
                    model.filesize = size;
                    model.videoTime =  [[JPUMaterialSingleton singleton] jpu_material_getVideoTime:model.asset.duration];
                    model.seconds =  [[JPUMaterialSingleton singleton] jpu_material_getVideoSeconds:model.asset.duration];

                    JPUMaterialVideoPlayViewController *Vc = [[JPUMaterialVideoPlayViewController alloc]initWithNibName:@"JPUMaterialVideoPlayViewController" bundle:[[JPUMaterialSingleton singleton] bundle]];
                    Vc.model = model;
                    Vc.selectVideoBlock = ^{
                        !self.selectVideoBlock?:self.selectVideoBlock(model);
                        [self dismissViewControllerAnimated:YES completion:nil];
                    };
                    [self.navigationController pushViewController:Vc animated:YES];
                }];
            }];
        }];
    }else{
        if (!model.isSelect) {
            //添加到数组
            if (self.maxNumber -  self.selectArr.count <= 0) {
                [[JPUMaterialProgressHUD sharedHUD]showHint:[NSString stringWithFormat:@"最多只能选择%zd张",self.maxNumber]];
                return;
            }
            
            BOOL   isOnLocal =  [self downloadFromiCloud:model.asset.phAsset];
            if (!isOnLocal && !model.isDownload) {//在icloud上下载
                [[JPUMaterialProgressHUD sharedHUD]show];
                [model.asset requestOriginImageWithCompletion:^(UIImage *result, NSDictionary<NSString *,id> *info) {
                    [model.asset assetSize:^(long long size) {
                        [[JPUMaterialProgressHUD sharedHUD]hide];
                        CGFloat mb = size/(1024*1024.0);
                        if (mb >= 5) {
                            [[JPUMaterialProgressHUD sharedHUD]showHint:@"图片太多,请选择其他图片"];
                            return;
                        }
                        model.isDownload = YES;
                        model.photoImg = result;
                        model.isSelect  = YES;
                        model.selectindex = self.selectArr.count + 1;
                        [self.selectArr addObject:model];
                        [self.indexArr addObject:indexPath];
                        [self.collectionView reloadItemsAtIndexPaths:self.indexArr];
                    }];
                } withProgressHandler:^(double progress, NSError * _Nullable error, BOOL * _Nonnull stop, NSDictionary * _Nullable info) {
                }];
            }else{
                [model.asset assetSize:^(long long size) {
                    CGFloat mb = size/(1024*1024.0);
                    if (mb >= 200) {
                        [[JPUMaterialProgressHUD sharedHUD]showHint:@"图片太多,请选择其他图片"];
                        return;
                    }
                    model.isDownload = YES;
                    model.photoImg = model.asset.originImage;
                    model.isSelect  = YES;
                    model.selectindex = self.selectArr.count + 1;
                    [self.selectArr addObject:model];

                    [self.indexArr addObject:indexPath];
                    [self.collectionView reloadItemsAtIndexPaths:self.indexArr];
                }];
            }
        }else{
            //删除数组
            model.isSelect = NO;
            [self.selectArr enumerateObjectsUsingBlock:^(JPUMaterialEditAssetModel  *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if (obj.selectindex > model.selectindex) {
                    obj.selectindex = obj.selectindex -1 ;
                }
            }];
            [self.selectArr removeObject:model];
            [self.collectionView reloadItemsAtIndexPaths:self.indexArr];
            [self.indexArr removeObject:indexPath];

        }
    }
}
- (BOOL)downloadFromiCloud:(PHAsset *)asset{
    NSArray *resourceArray = [PHAssetResource assetResourcesForAsset:asset];
    
    BOOL isOnLocal =  [[resourceArray.firstObject valueForKey:@"locallyAvailable"] boolValue];
    
  
    
    return isOnLocal;
}
#pragma mark - action
- (IBAction)backClick {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)finishClick {
    
    if (!self.selectArr.count) {
        [[JPUMaterialProgressHUD sharedHUD]showHint:@"请选择图片"];
        return;
    }
    NSMutableArray *array = [NSMutableArray array];
    for ( JPUMaterialEditAssetModel *model in self.selectArr) {
        [array addObject:model.photoImg];
    }
    !self.selectPhotoBlock?:self.selectPhotoBlock(array);
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
#pragma mark - getter
- (NSMutableArray *)dataSource
{
    if(!_dataSource){
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}
- (NSMutableArray *)selectArr
{
    if(!_selectArr){
        _selectArr = [NSMutableArray array];
    }
    return _selectArr;
}
- (NSMutableArray *)indexArr
{
    if(!_indexArr){
        _indexArr = [NSMutableArray array];
    }
    return _indexArr;
}

@end
