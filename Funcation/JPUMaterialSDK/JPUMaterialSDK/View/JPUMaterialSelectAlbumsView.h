//
//  JPUMaterialSelectAlbumsView.h
//  EditVideoText
//
//  Created by foundao on 2021/10/19.
//

#import <UIKit/UIKit.h>
#import "JPUMaterialSingleton.h"
NS_ASSUME_NONNULL_BEGIN

@interface JPUMaterialSelectAlbumsView : UIView

+ (instancetype)viewFromXib;
- (void)show:(QMUIAlbumContentType)contentType;

@property (weak, nonatomic) IBOutlet UIButton *btnShoot;
@property (weak, nonatomic) IBOutlet UIButton *btnPhotoAlbum;

@property (nonatomic, copy) void(^addPhotoBlock)(void);
@property (nonatomic, copy) void(^addVideoBlock)(void);

@property (nonatomic, copy) void(^takePhotoBlock)(void);
@property (nonatomic, copy) void(^takeVideoBlock)(void);

@end




NS_ASSUME_NONNULL_END
