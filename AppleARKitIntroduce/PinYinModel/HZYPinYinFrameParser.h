//
//  HZYPinYinFrameParser.h
//  AppleARKitIntroduce
//
//  Created by huangbaoxian on 2024/12/12.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "HZYPinYinTextData.h"


NS_ASSUME_NONNULL_BEGIN


@interface HZYPinYinTextConfig : NSObject
/*
 * 拼音和文字间间距
 */
@property (nonatomic, assign) CGFloat pinYinToTextSpace;
/*
 * 行间距
 */
@property (nonatomic, assign) CGFloat lineSpacing;
/*
 * 每个词组之间的间距
 */
@property (nonatomic, assign) CGFloat textSpace;

@property (nonatomic, assign) NSTextAlignment textAlignment;

/*
 * 文字颜色
 */
@property (nonatomic, strong) UIColor *textColor;
/*
 * 拼音颜色
 */
@property (nonatomic, strong) UIColor *pinYinColor;
/*
 * 拼音字体
 */
@property (nonatomic, strong) UIFont *pinYinFont;
/*
 * 文字字体
 */
@property (nonatomic, strong) UIFont *textFont;

/*
 * 顶部偏移
 */
@property (nonatomic, assign) CGFloat topOffsetY;
/*
 * 底部偏移
 */
@property (nonatomic, assign) CGFloat bottomOffsetY;

+ (HZYPinYinTextConfig *)defaultConfig;

@end

@interface HZYPinYinFrameParser : NSObject

- (instancetype)initWithConfig:(HZYPinYinTextConfig *)confg;
- (void)updateConfig:(HZYPinYinTextConfig *)confg;

/**
 * {"name":"doc","value":"","children":[{"name":"p","value":"","children":[{"name":"ruby","value":"","children":[{"name":"rb","value":"","children":[{"name":"txt","value":"汉","children":[]}]},{"name":"rt","value":"","children":[{"name":"txt","value":"hàn","children":[]}]}]},{"name":"ruby","value":"","children":[{"name":"rb","value":"","children":[{"name":"txt","value":"汉字","children":[]}]},{"name":"rt","value":"","children":[{"name":"txt","value":"hàn zì","children":[]}]}]}]}]}
 */
- (HZYPinYinTextData *)parserDataWithContent:(NSString *)contentString textWidth:(CGFloat)textWidth;
/**
 *@[
 @{
     @"name": @"p",
     @"value": @"",
     @"children": @[
         @{
            @"name": @"ruby",
            @"value": @"",
            @"children": @[
                @{
                     @"name": @"rb",
                     @"value": @"汉",
                     @"children": @[
                         @{@"name": @"txt", @"value": @"汉", @"children": @[]}
                     ]
                 },
                 @{
                     @"name": @"rt",
                     @"value": @"",
                     @"children": @[
                         @{@"name": @"txt", @"value": @"hàn", @"children": @[]}
                     ]
                 }
             ]
          },
        ]
      }
    ];
*/

- (HZYPinYinTextData *)parserDataWithJsonArray:(NSArray *)jsonArray textWidth:(CGFloat)textWidth;
/**
 *   @[@{@"pinyin": pinyinText,@"chinese": chineseText}]
 */
- (HZYPinYinTextData *)parserDataWithChineseArray:(NSArray *)textArray textWidth:(CGFloat)textWidth;


+ (NSArray *)parserDataWithArray:(NSArray *)jsonArray;
+ (NSArray *)parserDataWithJsonString:(NSString *)json;


@end

NS_ASSUME_NONNULL_END
