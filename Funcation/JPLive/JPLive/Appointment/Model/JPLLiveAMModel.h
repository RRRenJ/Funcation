//
//  JPLLiveAMModel.h
//  jper
//
//  Created by RRRenJ on 2020/6/8.
//  Copyright © 2020 MuXiao. All rights reserved.
//

#import <Foundation/Foundation.h>


NS_ASSUME_NONNULL_BEGIN

@interface JPLLiveAMModel : NSObject

@property (nonatomic, copy) NSString *  live_id;

@property (nonatomic, copy) NSString *  live_name;

@property (nonatomic, copy) NSString *  live_status;

@property (nonatomic, copy) NSString *  live_reserve_startime;

@property (nonatomic, copy) NSString *  live_reserve_endtime;

@property (nonatomic, copy) NSString *  live_cover;

@property (nonatomic, copy) NSString *  live_intro;

@property (nonatomic, copy) NSString *  live_direction;

@property (nonatomic, copy) NSString *  live_ratio;

@property (nonatomic, assign) BOOL  live_record;

@property (nonatomic, copy) NSString *  live_category;

@property (nonatomic, copy) NSString *  live_location;

@property (nonatomic, copy) NSString *  live_reason;

@property (nonatomic, assign, readonly) BOOL  isPortrait;


- (CGFloat)liveListCellTitleOfHeight;

- (CGFloat)liveListCellFailOfHeight;

- (CGFloat)liveListCellOfHeight;

@end




NS_ASSUME_NONNULL_END
