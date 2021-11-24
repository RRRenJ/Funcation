//
//  JPUMaterialEditContentCell.m
//  EditVideoText
//
//  Created by foundao on 2021/10/18.
//

#import "JPUMaterialEditContentCell.h"
#import "JPUMaterialPhotoCollectionCell.h"
#import "PNChart.h"
#import "JPUMaterialTagsCell.h"
@interface JPUMaterialEditContentCell()<UICollectionViewDataSource,UICollectionViewDelegate,UITextFieldDelegate,UITextViewDelegate>
@property (nonatomic, strong) PNCircleChart *circleChart;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layoutTextViewHeight;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionViewPhoto;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *layoutFlowPhoto;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionViewVideo;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *layoutFlowVideo;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layoutLabelPhotoHeight;//20
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layoutLabelVideoHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layoutLabelPhotoTop;//20
@property (weak, nonatomic) IBOutlet UILabel *labelImageShuxian;
@property (weak, nonatomic) IBOutlet UILabel *labelImage;
@property (weak, nonatomic) IBOutlet UILabel *labelVideo;
@property (weak, nonatomic) IBOutlet UILabel *labelVideoHint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layoutCollectionViewPhotoHeight;
@property (weak, nonatomic) IBOutlet UILabel *labelImageNumber;
@property (weak, nonatomic) IBOutlet UILabel *labelImageTotal;
@property (weak, nonatomic) IBOutlet UILabel *labelImageHint;
@property (nonatomic, assign) BOOL isUpload;//正在上传
@property (weak, nonatomic) IBOutlet UILabel *labelVideoClass;
@property (weak, nonatomic) IBOutlet UILabel *labelVideoScreen;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionViewTags;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *layoutFlowTags;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layoutCollectionTagsHeight;
@property (weak, nonatomic) IBOutlet UIView *viewVideoClass;


@end
@implementation JPUMaterialEditContentCell

- (void)awakeFromNib {
    [super awakeFromNib];

    self.autoresizingMask = 0 ;
    
    self.isUpload = YES;
    
    self.collectionViewPhoto.dataSource = self;
    self.collectionViewPhoto.delegate = self;
    self.collectionViewVideo.dataSource = self;
    self.collectionViewVideo.delegate = self;
    self.collectionViewTags.dataSource = self;
    self.collectionViewTags.delegate = self;
    
    self.textFieldTitle.delegate = self;
    self.textViewContent.delegate  = self;
    
    self.layoutFlowVideo.itemSize = self.layoutFlowPhoto.itemSize = CGSizeMake((JPU_WIDTH-60)/3, (JPU_WIDTH-60)/3);
    self.layoutFlowVideo.sectionInset =  self.layoutFlowPhoto.sectionInset = UIEdgeInsetsMake(10, 20, 10, 20);
    self.layoutFlowVideo.minimumInteritemSpacing =  self.layoutFlowPhoto.minimumInteritemSpacing = 10;
    self.layoutFlowVideo.minimumLineSpacing =  self.layoutFlowPhoto.minimumLineSpacing = 10;

    self.layoutFlowTags.itemSize = CGSizeMake(JPU_WIDTH/2, 50);
    self.layoutFlowTags.minimumLineSpacing = 0;
    self.layoutFlowTags.minimumInteritemSpacing = 0;
    
    [self.collectionViewPhoto registerNib:[UINib nibWithNibName:@"JPUMaterialPhotoCollectionCell" bundle:[JPUMaterialSingleton singleton].bundle] forCellWithReuseIdentifier:@"photo"];
    [self.collectionViewVideo registerNib:[UINib nibWithNibName:@"JPUMaterialPhotoCollectionCell" bundle:[JPUMaterialSingleton singleton].bundle] forCellWithReuseIdentifier:@"video"];
    
    [self.collectionViewTags registerNib:[UINib nibWithNibName:@"JPUMaterialTagsCell" bundle:[JPUMaterialSingleton singleton].bundle] forCellWithReuseIdentifier:@"tags"];

    

 
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.textViewContent.placehoder = @"请输入简介内容，最多300个字。选填";
    self.textViewContent.placehoderColor = [[JPUMaterialSingleton singleton] jpu_material_colorWithHex:0xBEBEBE alpha:1];
    
    [self layoutIfNeeded];
    [self setNeedsDisplay];
    
    if (!self.circleChart) {
        CGFloat width = (JPU_WIDTH-70)/3/2;
        self.circleChart = [[PNCircleChart alloc] initWithFrame:CGRectMake(25+((JPU_WIDTH-70)/3 - width)/2, CGRectGetMinY(self.collectionViewVideo.frame)+((JPU_WIDTH-70)/3 - width)/2 + 10,width,width)
                                                          total:@1
                                                        current:@0
                                                      clockwise:YES];
        
        self.circleChart.backgroundColor = [UIColor clearColor];
        [self.circleChart setStrokeColor:[[JPUMaterialSingleton singleton] jpu_material_colorWithHex:0x0F5CFF alpha:1]];
        self.circleChart.displayAnimated = NO;
        self.circleChart.lineWidth = @3;
        self.circleChart.countingLabel.textColor = [UIColor whiteColor];
        self.circleChart.countingLabel.font = [UIFont systemFontOfSize:12];
        [self.circleChart strokeChart];
        [self addSubview:self.circleChart];
        self.circleChart.hidden = YES;
    }
    
}
- (void)setImageCover:(UIImage *)imageCover
{
    _imageCover = imageCover;
  


    [self.collectionViewPhoto reloadData];
}

- (void)setVideoClassSubModel:(JPUMaterialVideoClassSub *)videoClassSubModel
{
    _videoClassSubModel = videoClassSubModel;
    self.labelVideoClass.text = videoClassSubModel.labelName ? : @"";

}

- (void)setVideoScreenModel:(JPUMaterialVideoClass *)videoScreenModel
{
    _videoScreenModel = videoScreenModel;
    self.labelVideoScreen.text = videoScreenModel.cateName ? : @"竖屏";
    
}
- (void)setType:(JPUMaterialEditType)type
{
    _type = type;
    if (type == JPUMaterialEditImage) {
        self.collectionViewPhoto.hidden = NO;
        self.layoutLabelPhotoTop.constant = 20;
        self.layoutLabelPhotoHeight.constant = 20;
        //视频
        self.labelVideo.hidden = self.labelVideoHint.hidden = YES;
        self.layoutLabelVideoHeight.constant = 0;
        self.collectionViewVideo.hidden = YES;

        //封面
    }else if (type == JPUMaterialEditVideo){
        
        self.viewVideoClass.hidden = NO;
        
        //视频
        self.collectionViewVideo.hidden = NO;
        self.layoutLabelVideoHeight.constant = 20;
        self.labelVideoHint.text = @"丨支持MP4和MOV，最大1GB，最长30分钟";
    
        
        //图片
        self.labelImage.text = @"封面图";
        self.labelImageHint.text = @"图片大小不超过5M";
        
        


    }
}

- (void)setVideoProgress:(NSNumber *)videoProgress
{
    _videoProgress = videoProgress;
    
    if ([_videoProgress floatValue] > 0 && [_videoProgress floatValue] < 1) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.isUpload = YES;
            [self.collectionViewVideo reloadData];
            self.circleChart.hidden = NO;
            [self.circleChart updateChartByCurrent: videoProgress ];
        });
    }else{
        dispatch_async(dispatch_get_main_queue(), ^{
            self.circleChart.hidden = YES;
            [self.circleChart updateChartByCurrent:@0];
            self.isUpload = NO;
            
            [self.collectionViewVideo reloadData];
        });
    }
}


- (void)setImageArr:(NSMutableArray *)imageArr
{
    _imageArr = imageArr;
    if (self.type == JPUMaterialEditVideo) {
        return;
    }
    
    if (!imageArr.count) {
        self.labelImageHint.hidden = NO;
        self.labelImageNumber.hidden = YES;
        self.labelImageTotal.hidden = YES;
    }else {
        self.labelImageHint.hidden = YES;
        self.labelImageNumber.hidden = NO;
        self.labelImageTotal.hidden = NO;
        self.labelImageNumber.text = [NSString stringWithFormat:@"%zd",imageArr.count];
        if (imageArr.count<18) {
            self.labelImageNumber.textColor = [[JPUMaterialSingleton singleton] jpu_material_colorWithHex:0x000000 alpha:1];
            self.labelImageTotal.textColor = [[JPUMaterialSingleton singleton] jpu_material_colorWithHex:0x999999 alpha:1];
        }else{
            self.labelImageNumber.textColor = [[JPUMaterialSingleton singleton] jpu_material_colorWithHex:0x32D669 alpha:1];
            self.labelImageTotal.textColor = [[JPUMaterialSingleton singleton] jpu_material_colorWithHex:0x32D669 alpha:1];
        }
    }
    
    NSInteger row = 0;
    if (self.imageArr.count == 18) {
        row  =  (18 + 3 -1)/3;
    }else{
        row  =  (imageArr.count + 1  + 3 -1)/3;
    }
    self.layoutCollectionViewPhotoHeight.constant  = row * (JPU_WIDTH-60)/3 + (row - 1) *10 + 20;
    [self.collectionViewPhoto reloadData];
    
    
}
- (void)setVideoModel:(JPUMaterialEditAssetModel *)videoModel
{
    _videoModel = videoModel;
    [self.collectionViewVideo reloadData];
}
- (void)setTagsArr:(NSMutableArray *)tagsArr
{
    _tagsArr = tagsArr;
    
    NSInteger row =  (self.tagsArr.count + 2 -1)/2;
    self.layoutCollectionTagsHeight.constant  = tagsArr.count > 0 ? row * 50 : 20;
    [self.collectionViewTags reloadData];
    
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    
    if (collectionView == self.collectionViewPhoto) {
        return self.type == JPUMaterialEditVideo ? 1 :  self.imageArr.count  == 18 ? 18 : self.imageArr.count + 1 ;
    }else if (collectionView == self.collectionViewVideo){
        return 1;
    }else{
        return self.tagsArr.count;
    }
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView == self.collectionViewPhoto) {//图片
        JPUMaterialPhotoCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"photo" forIndexPath:indexPath];
        if (self.type == JPUMaterialEditVideo) {//封面
            if (!self.imageCover) {//没有封面图
                cell.btnDel.hidden = YES;
                cell.imageViewContent.image = [[JPUMaterialSingleton singleton] jpu_material_imageName:@"JPUAddPhoto"];
            }else{//有封面图
                cell.imageViewContent.image = self.imageCover;
                cell.btnDel.hidden = NO;
                cell.delBlock = ^{
                    !self.delVideoCoverBlock?:self.delVideoCoverBlock();
                };
            }
        }else{//图片
            if (indexPath.row ==  self.imageArr.count ){
                cell.btnDel.hidden = YES;
                cell.imageViewContent.image = [[JPUMaterialSingleton singleton] jpu_material_imageName:@"JPUAddPhoto"];
            }else{
                cell.imageViewContent.image = self.imageArr[indexPath.item ];
                cell.btnDel.hidden = NO;
                cell.delBlock = ^{
                    !self.delPhotoBlock?:self.delPhotoBlock(indexPath.item );
                };
            }
        }
        
       
        return cell;
    }else if (collectionView == self.collectionViewVideo){//视频
        JPUMaterialPhotoCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"video" forIndexPath:indexPath];
        if (self.videoModel.videoTime.length) {
            cell.imageViewPlay.hidden = cell.labelTime.hidden = cell.imageViewTags.hidden = NO;
            cell.imageViewContent.image = self.videoModel.videoImage;
            cell.labelTime.text = self.videoModel.videoTime;
            cell.imageViewPlay.hidden = self.isUpload?YES:NO;
            cell.btnDel.hidden = self.isUpload ?YES:NO;
            cell.delBlock = ^{
                self.isUpload = NO;
                !self.delVideoBlock?:self.delVideoBlock();
            };
        }else{
            cell.btnDel.hidden  = cell.imageViewPlay.hidden = cell.labelTime.hidden =  cell.imageViewTags.hidden = YES;
            cell.imageViewContent.image =[[JPUMaterialSingleton singleton] jpu_material_imageName:@"JPUAddVideo"];
        }
        return cell;
    }else{
        
        JPUMaterialTagsCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"tags" forIndexPath:indexPath];
        JPUMaterialTagsModel *model = self.tagsArr[indexPath.item];
        cell.labelContent.text = model.name;
        return  cell;
        
    }
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (collectionView == self.collectionViewPhoto) {//图片
        if (self.type == JPUMaterialEditVideo) {
            if (!self.imageCover) {
                !self.addVideoCoverBlock?:self.addVideoCoverBlock();
            }
        }else{
            if (indexPath.row ==  self.imageArr.count ) {
                !self.addPhotoBlock?:self.addPhotoBlock();
            }
        }
    }else if (collectionView == self.collectionViewVideo){//视频
        if (self.videoModel.videoTime.length) {
            !self.playVideoBlock?:self.playVideoBlock();
        }else{
            !self.addVideoBlock?:self.addVideoBlock();
        }
    }
}
- (IBAction)selectVideoClassClick {
    !self.selectVideoClassBlock?:self.selectVideoClassBlock();
}


- (IBAction)selectVideoScreenClick {
    !self.selectVideoScreenBlock?:self.selectVideoScreenBlock();
}
- (IBAction)selectVideoTagsClick {
    !self.SelectTagsBlock?:self.SelectTagsBlock();
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    !self.editTitleBlock?:self.editTitleBlock(textField.text);
}
-(void)textViewDidEndEditing:(UITextView *)textView
{
    !self.editContentBlock?:self.editContentBlock(textView.text);
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (string.length == 0) return YES;
    
    NSInteger existedLength = textField.text.length;
    NSInteger selectedLength = range.length;
    NSInteger replaceLength = string.length;
    if (existedLength - selectedLength + replaceLength > 30){
        return NO;
    }
    
    return YES;
}

-(void)textViewDidChange:(UITextView*)textView
{
    UITextRange *selectedRange = [textView markedTextRange];
    UITextPosition *posi = [textView positionFromPosition:selectedRange.start offset:0];
    if (selectedRange && posi) {
        return;
    }
    
    NSInteger realLength = textView.text.length;
    NSRange selection = textView.selectedRange;
    NSString *tailText = [textView.text substringFromIndex:selection.location]; // 光标后的文本
    NSInteger restLength = 300 - tailText.length;                     // 光标前允许输入的最大数量
    if (realLength > 300 ) {
        NSRange range = [textView.text rangeOfComposedCharacterSequenceAtIndex:restLength];
        NSString *subHeadText = [textView.text substringToIndex:range.location];
        textView.text = [subHeadText stringByAppendingString:tailText];
        [textView setSelectedRange:NSMakeRange(restLength, 0)];
        [textView.undoManager removeAllActions];
    }
    
}
@end
