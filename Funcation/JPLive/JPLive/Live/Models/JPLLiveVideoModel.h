//
//  JPLLiveVideoModel.h
//  jper
//
//  Created by RRRenJ on 2020/6/10.
//  Copyright © 2020 MuXiao. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JPLLiveVideoModel : NSObject

@property (nonatomic, copy) NSString *  live_id;

@property (nonatomic, copy) NSString *  live_name;

@property (nonatomic, copy) NSString *  live_push_duration;
///0 回放正在生成 1 回放已生成
@property (nonatomic, copy) NSString *  live_record_status;

@property (nonatomic, copy) NSString *  live_reserve_endtime;

@property (nonatomic, copy) NSString *  live_reserve_startime;

@property (nonatomic, copy) NSString * live_record_mp4;

@end

NS_ASSUME_NONNULL_END
