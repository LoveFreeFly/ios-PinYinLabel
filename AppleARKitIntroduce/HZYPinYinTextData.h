//
//  HZYPinYinTextData.h
//  AppleARKitIntroduce
//
//  Created by huangbaoxian on 2024/12/12.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


@interface HZYChineseTextData : NSObject

@property (nonatomic, strong) NSAttributedString *pinYinAttributedString;
@property (nonatomic, strong) NSAttributedString *textAttributedString;

@property (nonatomic, assign) CGRect textRect;
@property (nonatomic, assign) CGRect pinYinRect;

@property (nonatomic, assign) CGFloat lineHeight;

@end


@interface HZYPinYinTextData : NSObject

@property (nonatomic, strong) NSArray<HZYChineseTextData *> *dataArray;

@property (nonatomic, assign) CGFloat cellHeight;

@end

NS_ASSUME_NONNULL_END
