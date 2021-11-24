//
//  JPLRecordScreenManager.h
//  JPLSDK
//
//  Created by 任敬 on 2021/11/10.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JPLRecordScreenManager : NSObject
+ (JPLRecordScreenManager *)manager;

- (void)startRecord;
- (void)stopRecord;

@end

NS_ASSUME_NONNULL_END
