//
//  JPUMaterialTextView.h
//  EditVideoText
//
//  Created by foundao on 2021/10/20.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JPUMaterialTextView : UITextView
@property (nonatomic,copy)NSString *placehoder;
@property (nonatomic,strong)UIColor *placehoderColor;
@property (nonatomic,assign)BOOL isAutoHeight;

@end

NS_ASSUME_NONNULL_END
