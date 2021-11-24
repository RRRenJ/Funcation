//
//  JPUMaterialEditController.m
//  EditVideoText
//
//  Created by foundao on 2021/10/18.
//

#import "JPUMaterialEditController.h"
#import "JPUMaterialEditContentCell.h"
#import "JPUMaterialPhotoAlbumController.h"
#import "JPUMaterialSelectAlbumsView.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "JPUMaterialVideoPlayViewController.h"
#import "JPUMaterialUploadTipsView.h"
#import "JPUMaterialSelectPickerView.h"
#import "JPUMaterialTagsController.h"

@interface JPUMaterialEditController ()<UITableViewDelegate,UITableViewDataSource,UINavigationControllerDelegate, UIImagePickerControllerDelegate>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layoutNavHeight;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *imageArr;
@property (nonatomic, strong) JPUMaterialEditAssetModel *videoModel;
@property (nonatomic, strong) JPUMaterialSelectAlbumsView *selectView;;
@property (nonatomic, strong) JPUMaterialEditContentCell *cell;
@property (nonatomic, strong) NSString *tcVideoUrlStr;
@property (nonatomic, strong) NSString *editTitleStr;
@property (nonatomic, strong) NSString *editContentStr;
@property (nonatomic, strong) JPUMaterialUploadTipsView *uploadHintView;
@property (weak, nonatomic) IBOutlet UILabel *labelTitle;
@property (nonatomic, strong) JPUMaterialSelectPickerView *pickerView;
@property (nonatomic, strong) JPUMaterialVideoClass *videoClassModel;
@property (nonatomic, strong) JPUMaterialVideoClassSub *videoClassSubModel;

@property (nonatomic, strong) JPUMaterialVideoClass *videoScreenModel;
@property (nonatomic, strong) UIImage *imageCover;
@property (nonatomic, assign) BOOL isUpladVideo;;
@property (nonatomic, strong) NSMutableArray *tagsArr;


@end


@implementation JPUMaterialEditController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.layoutNavHeight.constant = JPU_NavHeight;
    

    self.labelTitle.text = self.type == JPUMaterialEditAll ? @"上传素材" : self.type == JPUMaterialEditVideo ?  @"发布视频" : @"发布动态";
    [self.tableView registerNib:[UINib nibWithNibName:@"JPUMaterialEditContentCell" bundle:[[JPUMaterialSingleton singleton] bundle]] forCellReuseIdentifier:@"cell"];

    if (self.type == JPUMaterialEditVideo) {
        [[JPUMaterialSingleton singleton]jpu_material_getVideoSourceInfoSuccess:^(NSArray * _Nonnull videoClassArr, NSArray * _Nonnull videoScreenArr) {
            self.videoClassModel = videoClassArr.firstObject;
            self.videoClassSubModel = self.videoClassModel.labels.firstObject;
            self.videoScreenModel = videoScreenArr.firstObject;
            self.pickerView.videoScreenArr = videoScreenArr;
            self.pickerView.videoClassArr = videoClassArr;
            [self.tableView reloadData];
        } fail:^{
            
        }];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    self.cell.type = self.type;
    self.cell.imageArr = self.imageArr;
    self.cell.videoModel = self.videoModel;
    self.cell.videoClassSubModel = self.videoClassSubModel;
    self.cell.videoScreenModel = self.videoScreenModel;
    self.cell.imageCover = self.imageCover;
    self.cell.tagsArr = self.tagsArr;
    CFYWeak(self, weakSelf);
    self.cell.addPhotoBlock = ^{
        [weakSelf.view endEditing:YES];
        [weakSelf.selectView show:QMUIAlbumContentTypeOnlyPhoto];
        
    };
    self.cell.addVideoBlock = ^{
        [weakSelf.view endEditing:YES];
        [weakSelf.selectView show:QMUIAlbumContentTypeOnlyVideo];

    };
    self.cell.playVideoBlock = ^{
        [weakSelf.view endEditing:YES];
        JPUMaterialVideoPlayViewController *Vc = [[JPUMaterialVideoPlayViewController alloc]initWithNibName:@"JPUMaterialVideoPlayViewController" bundle:[JPUMaterialSingleton singleton].bundle];
        Vc.model = weakSelf.videoModel;
        Vc.isPlay = YES;
        [weakSelf.navigationController pushViewController:Vc animated:YES];
    };
    self.cell.delPhotoBlock = ^(NSInteger index) {//删除图片
        [weakSelf.view endEditing:YES];
        [weakSelf.imageArr removeObjectAtIndex:index];
        [weakSelf.tableView reloadData];
    };
    self.cell.delVideoBlock = ^{//删除视频
        [weakSelf.view endEditing:YES];
        weakSelf.tcVideoUrlStr = @"";
        weakSelf.videoModel = [[JPUMaterialEditAssetModel alloc]init];
        [weakSelf.tableView reloadData];
    };
    
    self.cell.editTitleBlock = ^(NSString * _Nonnull titleStr) {//编辑标题
        weakSelf.editTitleStr = titleStr;
    };
    self.cell.editContentBlock = ^(NSString * _Nonnull contentStr) {//编辑内容
        weakSelf.editContentStr = contentStr;
    };
    self.cell.selectVideoClassBlock = ^{//选择分类
        [weakSelf.view endEditing:YES];
        [weakSelf.pickerView show:YES];
    };
    self.cell.selectVideoScreenBlock = ^{//选择横屏竖屏
        [weakSelf.view endEditing:YES];
        [weakSelf.pickerView show:NO];
    };
    self.cell.addVideoCoverBlock = ^{//新增视频封面
        [weakSelf.view endEditing:YES];
        [weakSelf goPhotoAlum:QMUIAlbumContentTypeOnlyPhoto isCover:YES];
    };
    self.cell.delVideoCoverBlock = ^{//删除视频封面
        weakSelf.imageCover = nil;
        [weakSelf.tableView reloadData];
    };
    self.cell.SelectTagsBlock = ^{//选择标签
        JPUMaterialTagsController *Vc = [[JPUMaterialTagsController alloc]initWithNibName:@"JPUMaterialTagsController" bundle:[JPUMaterialSingleton singleton].bundle];
        Vc.selectTagsArr = weakSelf.tagsArr;
        Vc.selectTagsBlock = ^(NSMutableArray * _Nonnull selectTagsArr) {
            weakSelf.tagsArr = selectTagsArr;
            [weakSelf.tableView reloadData];
        };
        [weakSelf presentViewController:Vc animated:YES completion:nil];
    };
    return self.cell;
}
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
      [self.view endEditing:YES];
}
- (void)goPhotoAlum:(QMUIAlbumContentType)type isCover:(BOOL)isCover
{
    JPUMaterialPhotoAlbumController *Vc = [[JPUMaterialPhotoAlbumController alloc]initWithNibName:@"JPUMaterialPhotoAlbumController" bundle:[[JPUMaterialSingleton singleton] bundle]];
    Vc.maxNumber = isCover ? 1 : 18 - self.imageArr.count;
    Vc.contentType = type;
    Vc.isEditSelectVideo = YES;
    Vc.selectPhotoBlock = ^(NSMutableArray * _Nonnull imgArr) {
        if (!isCover) {//图册
            [self.imageArr addObjectsFromArray:imgArr];
            [self.tableView reloadData];
        }else{//封面
            self.imageCover = imgArr[0];
            [self.tableView reloadData];
        }
       
    };
    Vc.selectVideoBlock = ^(JPUMaterialEditAssetModel * _Nonnull model) {
        self.videoModel = model;
        [self.tableView reloadData];
        [self uploadVideo];
    };
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:Vc];
    nav.modalPresentationStyle = 0;
    [self presentViewController:nav animated:YES completion:nil];
}

- (void)takePhoto:(NSString *)typeStr
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = NO; //可编辑
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    picker.mediaTypes = @[typeStr];
    picker.videoQuality = UIImagePickerControllerQualityTypeMedium;
    picker.cameraFlashMode = UIImagePickerControllerCameraFlashModeAuto;
    picker.videoMaximumDuration = 1800;
    [self presentViewController:picker animated:YES completion:nil];
    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey,id> *)info
{
    
    NSString* mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    if ([mediaType isEqualToString:(NSString *)kUTTypeMovie]) {
        NSURL* url = [info objectForKey:UIImagePickerControllerMediaURL];
        [[JPUMaterialSingleton singleton] jpu_material_getTakeVideoImageAndTimeForm:url block:^(NSString * _Nonnull timeStr, UIImage * _Nonnull image,NSInteger fileSize,NSString *seconds) {
            self.videoModel.videoTime = timeStr;
            self.videoModel.videoImage = image;
            self.videoModel.filesize = fileSize;
            self.videoModel.seconds = seconds;
            self.videoModel.filePath = [NSString stringWithFormat:@"%@",url];
            [self.tableView reloadData];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self uploadVideo];
            });
        }];
    }else{
        UIImage * image = [info valueForKey:UIImagePickerControllerOriginalImage];
        [self.imageArr addObject:image];
        [self.tableView reloadData];
    }
    [self dismissViewControllerAnimated:YES completion:nil];

}

- (void)uploadVideo
{
    self.isUpladVideo = YES;
    [[JPUMaterialSingleton singleton] jpu_material_uploadVideo:self.videoModel  progressBlock:^(CGFloat progress) {
        self.cell.videoProgress =  [NSNumber numberWithFloat:progress];
    }success:^(NSString * _Nonnull url) {
        self.tcVideoUrlStr = url;
        self.isUpladVideo = NO;
    }failBlock:^(NSString * _Nonnull errorStr) {
        self.isUpladVideo = NO;
        [[JPUMaterialProgressHUD sharedHUD]showHint:errorStr];
    }];
}


#pragma mark - action

- (IBAction)backClick {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)uploadClick {
    [self.view endEditing:YES];
    
    if (self.isUpladVideo) {
        [[JPUMaterialProgressHUD sharedHUD]showHint:@"正在上传视频,请稍后"];
        return;
    }
    
    if (!self.editTitleStr.length) {
        [[JPUMaterialProgressHUD sharedHUD]showHint:@"请输入标题!"];
        return;
    }
    
    if(self.type == JPUMaterialEditVideo) {
        
        if (!self.imageCover) {
            [[JPUMaterialProgressHUD sharedHUD]showHint:@"请选择封面!"];
            return;
        }
       
        if (!self.tcVideoUrlStr.length) {
            [[JPUMaterialProgressHUD sharedHUD]showHint:@"请上传一个视频!"];
            return;
        }
        
    
        
    }else{
        if (!self.imageArr.count) {
            [[JPUMaterialProgressHUD sharedHUD]showHint:@"请选择图片!"];
            return;
        }
    }
    
    
    [[JPUMaterialProgressHUD sharedHUD]showProgress:@"正在上传中,请不要关闭央视影音软件"];
    NSMutableArray *urlArr = [NSMutableArray array];
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(1);
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    if (self.imageArr.count>0) {
        for (int i = 0; i < self.imageArr.count; i++){
            dispatch_group_enter(group);//使分组里正要执行的任务数递增
            dispatch_async(queue, ^{
                dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
                UIImage *image = self.imageArr[i];
                [[JPUMaterialSingleton singleton] jpu_material_uploadPhoto:image  success:^(NSString * _Nonnull url) {
                    [urlArr addObject:url];
                    dispatch_semaphore_signal(semaphore);
                    dispatch_group_leave(group);
                } failBlock:^(NSString * _Nonnull errorStr) {
                }];
            });
            
            dispatch_group_notify(group, dispatch_get_main_queue(), ^{
                if (self.type == JPUMaterialEditAll) {//发布素材
                    NSArray *videoArr  = [NSArray array];
                    if (self.tcVideoUrlStr.length) {
                        videoArr = @[self.tcVideoUrlStr];
                    }
                    
                    [[JPUMaterialSingleton singleton]jpu_material_pushMaterialTitle:self.editTitleStr content:self.editContentStr photoArr:urlArr videoArr:videoArr success:^{
                        [self.uploadHintView show:YES];
                    } failBlock:^{
                        [self.uploadHintView show:NO];
                    }];
                }else{//发布动态
                    [[JPUMaterialSingleton singleton]jpu_material_pushDynamicTitle:self.editTitleStr content:self.editContentStr photoArr:urlArr success:^{
                        [self.uploadHintView show:YES];
                    } failBlock:^{
                        [self.uploadHintView show:NO];
                    }];
                }
            });
        }
    }else{
                
        [[JPUMaterialSingleton singleton] jpu_material_uploadPhoto:self.imageCover  success:^(NSString * _Nonnull url) {
            
            [[JPUMaterialSingleton singleton]jpu_material_pushVideolTitle:self.editTitleStr content:self.editContentStr video_cover:url video_tagsArr:self.tagsArr video_url:self.tcVideoUrlStr video_type:self.videoScreenModel.cateId video_category:self.videoClassModel.cateId video_label:self.videoClassSubModel.labelId videoModel:self.videoModel success:^{
                
                [self.uploadHintView show:YES];
                
            } failBlock:^{
                
                [self.uploadHintView show:NO];
                
            }];
            
            
        }failBlock:^(NSString * _Nonnull errorStr) {
            
        }];
        
        
        
    }
}


- (NSMutableArray *)imageArr
{
    if(!_imageArr){
        _imageArr = [NSMutableArray array];
    }
    return _imageArr;
}

- (JPUMaterialEditAssetModel *)videoModel
{
    if(!_videoModel){
        _videoModel = [[JPUMaterialEditAssetModel alloc]init];
    }
    return _videoModel;
}
- (JPUMaterialSelectAlbumsView *)selectView
{
    if(!_selectView){
        _selectView = [JPUMaterialSelectAlbumsView viewFromXib];
        _selectView.frame = self.view.frame;
        CFYWeak(self, weakSelf);
        _selectView.addVideoBlock = ^{
            weakSelf.videoModel.isTakeVideo = NO;
            [weakSelf goPhotoAlum:QMUIAlbumContentTypeOnlyVideo isCover:NO];
            
        };
        _selectView.addPhotoBlock  = ^{
            [weakSelf goPhotoAlum:QMUIAlbumContentTypeOnlyPhoto isCover:NO];
        };
        _selectView.takeVideoBlock = ^{
            weakSelf.videoModel.isTakeVideo = YES;
            [weakSelf takePhoto:(NSString *)kUTTypeMovie];
        };
        _selectView.takePhotoBlock = ^{
            [weakSelf takePhoto:(NSString *)kUTTypeImage];
        };
    }
    return _selectView;
}
- (JPUMaterialUploadTipsView *)uploadHintView
{
    if(!_uploadHintView){
        _uploadHintView = [JPUMaterialUploadTipsView viewFromXib];
        _uploadHintView.type = self.type;
        _uploadHintView.frame = self.view.frame;
        CFYWeak(self, weakSelf);
        _uploadHintView.goHomeBlock = ^{
            [weakSelf dismissViewControllerAnimated:YES completion:nil];
        };
        _uploadHintView.uploadBlock = ^(BOOL isNewly) {
            if (isNewly) {
                weakSelf.imageArr = [NSMutableArray array];
                weakSelf.tcVideoUrlStr =  weakSelf.editTitleStr = weakSelf.editContentStr = @"";
                weakSelf.videoModel = [[JPUMaterialEditAssetModel alloc]init];
                weakSelf.cell.textFieldTitle.text = @"";
                weakSelf.cell.textViewContent.text = @"";
                weakSelf.imageCover = nil;
                [weakSelf.tableView reloadData];
            }
        };
    }
    return _uploadHintView;
}
- (JPUMaterialSelectPickerView *)pickerView
    
{
    if(!_pickerView){
        _pickerView = [JPUMaterialSelectPickerView viewFromXib];
        CFYWeak(self, weakSelf);
        _pickerView.selectClassBlock = ^(JPUMaterialVideoClass * _Nonnull model, JPUMaterialVideoClassSub * _Nonnull subModel) {
            weakSelf.videoClassModel = model;
            weakSelf.videoClassSubModel= subModel;
            [weakSelf.tableView reloadData];
        };
        _pickerView.selectScreenBlock = ^(JPUMaterialVideoClass * _Nonnull model) {
            weakSelf.videoScreenModel = model;
            [weakSelf.tableView reloadData];
        };
    }
    return _pickerView;
}
- (NSMutableArray *)tagsArr
{
    if(!_tagsArr){
        _tagsArr = [NSMutableArray array];
    }
    return _tagsArr;
}

@end
