//
//  JPUMaterialEditContentCell.h
//  EditVideoText
//
//  Created by foundao on 2021/10/18.
//

#import <UIKit/UIKit.h>
#import "JPUMaterialSingleton.h"
#import "JPUMaterialTextView.h"

NS_ASSUME_NONNULL_BEGIN

@interface JPUMaterialEditContentCell : UITableViewCell

@property (nonatomic, assign)JPUMaterialEditType  type;



@property (nonatomic, copy) void(^addPhotoBlock)(void);
@property (nonatomic, copy) void(^addVideoBlock)(void);
@property (nonatomic, copy) void(^playVideoBlock)(void);
@property (nonatomic, copy) void(^delPhotoBlock)(NSInteger index);
@property (nonatomic, copy) void(^delVideoBlock)(void);
@property (nonatomic, copy) void(^editTitleBlock)(NSString *titleStr);
@property (nonatomic, copy) void(^editContentBlock)(NSString *contentStr);
@property (nonatomic, copy) void(^selectVideoClassBlock)(void);
@property (nonatomic, copy) void(^selectVideoScreenBlock)(void);
@property (nonatomic, copy) void(^addVideoCoverBlock)(void);
@property (nonatomic, copy) void(^delVideoCoverBlock)(void);
@property (nonatomic, copy) void(^SelectTagsBlock)(void);


@property (nonatomic, strong) NSMutableArray *imageArr;
@property (nonatomic, strong) JPUMaterialEditAssetModel *videoModel;
@property (nonatomic, assign) NSNumber *videoProgress;
@property (nonatomic, strong) JPUMaterialVideoClassSub *videoClassSubModel;
@property (nonatomic, strong) JPUMaterialVideoClass *videoScreenModel;
@property (nonatomic, strong) UIImage *imageCover;

//@property (nonatomic, strong) NSMutableArray *videoClassArray;


@property (weak, nonatomic) IBOutlet JPUMaterialTextView *textViewContent;
@property (weak, nonatomic) IBOutlet UITextField *textFieldTitle;

@property (nonatomic, strong) NSMutableArray *tagsArr;


@end

NS_ASSUME_NONNULL_END
