//
//  JPLLiveFilterModel.h
//  jper
//
//  Created by RRRenJ on 2020/5/29.
//  Copyright © 2020 MuXiao. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JPLLiveFilterModel : NSObject

@property (nonatomic, copy) NSString *  name;

@property (nonatomic, copy) NSString *  imageName;

@property (nonatomic, copy) NSString *  filterName;

@property (nonatomic, assign) BOOL isSelect;

@end

NS_ASSUME_NONNULL_END
