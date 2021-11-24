//
//  JPUMaterialTagsController.m
//  EditVideoText
//
//  Created by foundao on 2021/11/4.
//

#import "JPUMaterialTagsController.h"
#import "JPUMaterialSingleton.h"
#import "JPUMaterialTagsCell.h"

@interface JPUMaterialTagsController ()<UICollectionViewDataSource,UICollectionViewDelegate,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionViewSelectTags;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *layoutFlowSelectTags;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionViewHot;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *layoutFlowHot;
@property (weak, nonatomic) IBOutlet UILabel *labelSelectTagsHint;
@property (weak, nonatomic) IBOutlet UILabel *labelSelectNumber;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layoutCollectionViewSelectTagsHeight;
@property (nonatomic, strong) NSArray *hotArr;
@property (weak, nonatomic) IBOutlet UITextField *textFieldTags;
@property (weak, nonatomic) IBOutlet UIButton *btnSure;

@end

@implementation JPUMaterialTagsController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.layoutFlowSelectTags.itemSize = CGSizeMake(JPU_WIDTH/2, 50);
    self.layoutFlowSelectTags.minimumLineSpacing = 0;
    self.layoutFlowSelectTags.minimumInteritemSpacing = 0;

    self.layoutFlowHot.itemSize =  CGSizeMake(JPU_WIDTH/2, 50);
    self.layoutFlowHot.minimumLineSpacing = 0;
    self.layoutFlowHot.minimumInteritemSpacing = 0;
    
        
    [self.collectionViewSelectTags registerNib:[UINib nibWithNibName:@"JPUMaterialTagsCell" bundle:[JPUMaterialSingleton singleton].bundle] forCellWithReuseIdentifier:@"selectTagsCell"];
    [self.collectionViewHot registerNib:[UINib nibWithNibName:@"JPUMaterialTagsCell" bundle:[JPUMaterialSingleton singleton].bundle] forCellWithReuseIdentifier:@"hotTagsCell"];

    
    [self.textFieldTags addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    
    [self getSelectTagsNumber];

    
}

- (void)getHotTags
{
    [self getSelectTagsNumber];
    [[JPUMaterialSingleton singleton]jpu_material_getHotTagsSuccess:^(NSArray * _Nonnull tagsArr) {
        self.hotArr = tagsArr;
        for (JPUMaterialTagsModel *model in self.hotArr) {
            for (JPUMaterialTagsModel *selectModel in self.selectTagsArr) {//
                if ([model.name isEqualToString:selectModel.name]) {
                    model.isSelect = YES;
                }
            }
        }
        [self.collectionViewHot reloadData];
    } failBlock:^(NSString * _Nonnull errorStr) {
        
    }];
    
}
- (void)setUpSureBtnisEdit:(BOOL)isEdit
{
    self.textFieldTags.text = @"";
    
    if (isEdit) {
        self.btnSure.backgroundColor = [UIColor whiteColor];
        [self.btnSure setTitle:@"添加" forState:UIControlStateNormal];
        [self.btnSure setTitleColor:[[JPUMaterialSingleton singleton]jpu_material_colorWithHex:0x1D6CFD alpha:1 ] forState:UIControlStateNormal];
    }else{
        self.btnSure.backgroundColor = [[JPUMaterialSingleton singleton]jpu_material_colorWithHex:0x1D6CFD alpha:1 ];
        [self.btnSure setTitle:@"确认" forState:UIControlStateNormal];
        [self.btnSure setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
}
- (void)getSelectTagsNumber
{
    if (!self.selectTagsArr.count) {
        self.labelSelectTagsHint.hidden = NO;
        self.collectionViewSelectTags.hidden = YES;
        self.labelSelectNumber.text = @"(0/3)";
        self.layoutCollectionViewSelectTagsHeight.constant = 50;
        
    }else{
        self.labelSelectTagsHint.hidden = YES;
        self.collectionViewSelectTags.hidden = NO;
        self.labelSelectNumber.text = [NSString stringWithFormat:@"(%zd/3)",self.selectTagsArr.count];
        NSInteger row =  (self.selectTagsArr.count + 2 -1)/2;
        self.layoutCollectionViewSelectTagsHeight.constant  = row * 50;
            
    }
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (collectionView == self.collectionViewSelectTags) {
        return  self.selectTagsArr.count  ;
    }else{
        return self.hotArr.count;
    }
    
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView == self.collectionViewSelectTags) {
        JPUMaterialTagsCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"selectTagsCell" forIndexPath:indexPath];
        JPUMaterialTagsModel *model = self.selectTagsArr[indexPath.item];
        cell.labelContent.text = model.name;
        cell.viewContent.backgroundColor = [[JPUMaterialSingleton singleton]jpu_material_colorWithHex:0x1D6CFD alpha:1 ];
        cell.labelContent.textColor  = [UIColor whiteColor];
        cell.btnDel.hidden = NO;
        cell.delTagsBlock = ^{//删除
            for (JPUMaterialTagsModel *hotModel in self.hotArr) {
                if ([hotModel.name isEqualToString:model.name]) {
                    hotModel.isSelect = NO;
                }
            }
            [self.selectTagsArr removeObject:model];
            [self getSelectTagsNumber];
            [self.collectionViewHot reloadData];
            [self.collectionViewSelectTags reloadData];
        };

        return cell;
    }else{
        JPUMaterialTagsCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"hotTagsCell" forIndexPath:indexPath];
        JPUMaterialTagsModel *model = self.hotArr[indexPath.item];
        cell.labelContent.text = model.name;
        if (!model.isSelect) {
            cell.viewContent.backgroundColor = [[JPUMaterialSingleton singleton]jpu_material_colorWithHex:0xF0F0F0 alpha:1 ];
            cell.labelContent.textColor  = [UIColor blackColor];
        }else{
            cell.viewContent.backgroundColor = [[JPUMaterialSingleton singleton]jpu_material_colorWithHex:0xF9F9F9  alpha:1 ];
            cell.labelContent.textColor  = [[JPUMaterialSingleton singleton]jpu_material_colorWithHex:0xDADADA alpha:1];
        }

        return cell;
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ( collectionView == self.collectionViewHot ) {
        JPUMaterialTagsModel *model = self.hotArr[indexPath.item];
        if (!model.isSelect) { // 未选中
            if (self.selectTagsArr.count < 3) {//小于5
                model.isSelect = YES;
                [self.selectTagsArr addObject:model];
                [self getSelectTagsNumber];
                [self.collectionViewHot reloadData];
                [self.collectionViewSelectTags reloadData];
            }
           
        }else{//选中 去掉
            model.isSelect = NO;
            for (JPUMaterialTagsModel *selectModel in self.selectTagsArr) {
                if ([selectModel.name isEqualToString:model.name]) {
                    [self.selectTagsArr removeObject:selectModel];
                    break;
                }
            }
            [self getSelectTagsNumber];
            [self.collectionViewHot reloadData];
            [self.collectionViewSelectTags reloadData];
            
        }
    }
}


- (IBAction)sureClick {
    [self.view endEditing:YES];
    
    if ([self.btnSure.titleLabel.text isEqualToString:@"添加"]) {//添加
        if (self.selectTagsArr.count >= 3) {
            [self setUpSureBtnisEdit:NO];
            return;
        }
        if (self.textFieldTags.text.length>0) {//有字体
            if ([self isEmpty:self.textFieldTags.text]) {
                [[JPUMaterialProgressHUD sharedHUD]showHint:@"标签不能全空格"];
                [self setUpSureBtnisEdit:NO];

                return;
            }
            BOOL isHot = NO; //是否是热门
            for (JPUMaterialTagsModel *model in self.hotArr) {
                if ([model.name isEqualToString:self.textFieldTags.text]) {//名字一样
                    isHot = YES;
                    if (!model.isSelect) {//未被选中
                        model.isSelect = YES;
                        [self.selectTagsArr addObject:model];
                        [self getSelectTagsNumber];
                        [self.collectionViewHot reloadData];
                        [self.collectionViewSelectTags reloadData];
                    }
                }
            }
            if (!isHot) {//不是热门 自定义标签
                BOOL isSelect = NO; //是否被选中
                for (JPUMaterialTagsModel *model in self.selectTagsArr) {//已选标签中 循环
                    if ([model.name isEqualToString:self.textFieldTags.text]) {//名字一样
                        isSelect = YES;
                    }
                }
                if (!isSelect) {//已选标签中 没有一样的
                    JPUMaterialTagsModel *newModel = [[JPUMaterialTagsModel alloc]init];
                    newModel.name = self.textFieldTags.text;
                    [self.selectTagsArr addObject:newModel];
                    [self getSelectTagsNumber];
                    [self.collectionViewHot reloadData];
                    [self.collectionViewSelectTags reloadData];
                }
            }
        }
        [self setUpSureBtnisEdit:NO];
    }else{//确认
        !self.selectTagsBlock?:self.selectTagsBlock(self.selectTagsArr);
        [self dismissViewControllerAnimated:YES completion:nil];
    }

}
- (IBAction)backClick {
    
    [self.view endEditing:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}



- (void)textFieldDidChange:(UITextField *)textField
{
    UITextRange *selectedRange = [textField markedTextRange];
    UITextPosition *pos = [textField positionFromPosition:selectedRange.start offset:0];
    if (selectedRange && pos) {//如果存在高亮部分, 就暂时不统计字数
        return;
    }
    NSInteger realLength = textField.text.length;
    if (realLength > 10) {
        textField.text = [textField.text substringToIndex:10];
    }
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    [self setUpSureBtnisEdit:YES];
    return YES;
}
- (NSArray *)hotArr
{
    if(!_hotArr){
        _hotArr = [NSArray array];
    }
    return _hotArr;
}

//全空格为yes
- (BOOL)isEmpty:(NSString *) str {
    
    if(!str) {
        return true;
    }else {
        NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
        NSString *trimedString = [str stringByTrimmingCharactersInSet:set];
        
        if([trimedString length] == 0) {
            return true;
        }else {
            return false;
        }
    }
}

@end
