//
//  JPLConfige.h
//  JPLSDK
//
//  Created by 任敬 on 2021/10/22.
//

#ifndef JPLConfige_h
#define JPLConfige_h


#define JPL_SCR_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define JPL_SCR_HEIGHT ([UIScreen mainScreen].bounds.size.height)

//状态栏高度
#define JPL_STATUS_HEIGHT  [UIApplication sharedApplication].statusBarFrame.size.height
//是否是刘海屏
#define JPL_IS_BANGSCREEN  JPL_STATUS_HEIGHT > 20.0f

#define JPL_NAVIGATION_HEIGHT  (JPL_STATUS_HEIGHT + 44.0f)

#define JPL_BOTTOM_HEIGHT (JPL_IS_BANGSCREEN ? 34.0f : 0.0f)

#define JPL_TABBAR_HEIGHT (JPL_BOTTOM_HEIGHT + 49.0f)


#define JPScreenFitFloat6(ip6s) (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? ip6s*1024/667: (ip6s/375.f*JPL_SCR_WIDTH))



#define JPL_MATERIAL_FILES_FOLDER [NSString stringWithFormat:@"%@/%@/%@", NSHomeDirectory(), @"Documents", @"JPLSDK"]


#endif /* JPLConfige_h */
