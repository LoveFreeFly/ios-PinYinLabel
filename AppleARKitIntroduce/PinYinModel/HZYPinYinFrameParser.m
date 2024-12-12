//
//  HZYPinYinFrameParser.m
//  AppleARKitIntroduce
//
//  Created by huangbaoxian on 2024/12/12.
//

#import "HZYPinYinFrameParser.h"
#import <CoreText/CoreText.h>

@implementation HZYPinYinTextConfig

+ (HZYPinYinTextConfig *)defaultConfig {
    HZYPinYinTextConfig *config = [HZYPinYinTextConfig new];
    config.pinYinToTextSpace = 5;
    config.lineSpacing = 15;
    config.textSpace = 6;
    config.textAlignment = NSTextAlignmentCenter;
    config.textColor = UIColor.redColor;
    config.pinYinColor = UIColor.blueColor;
    config.textFont = [UIFont systemFontOfSize:18];
    config.pinYinFont = [UIFont systemFontOfSize:13];
    config.topOffsetY = 0;
    config.bottomOffsetY = 0;
    return config;
}


@end

@interface HZYPinYinFrameParser ()

@property (nonatomic, strong) HZYPinYinTextConfig *config;

@end

@implementation HZYPinYinFrameParser

- (instancetype)initWithConfig:(HZYPinYinTextConfig *)confg {
    if(self = [super init]) {
        _config = confg;
    }
    return self;
}

- (void)updateConfig:(HZYPinYinTextConfig *)confg {
    _config = nil;
    _config = confg;
}


- (HZYPinYinTextData *)parserDataWithContent:(NSString *)contentString textWidth:(CGFloat)textWidth {
    NSArray *textArray = [self.class parserDataWithJsonString:contentString];
    return [self parserDataWithJsonArray:textArray textWidth:textWidth];
}

- (HZYPinYinTextData *)parserDataWithJsonArray:(NSArray *)jsonArray textWidth:(CGFloat)textWidth {
    NSMutableArray *tempArray = [NSMutableArray array];
    for (NSDictionary *pItem in jsonArray) {
        NSArray *rubyArray = pItem[@"children"];
        for (NSDictionary *rubyDict in rubyArray) {
            NSArray *children = rubyDict[@"children"];
            NSString *chineseText = nil;
            NSString *pinyinText = nil;
            
            for (NSDictionary *child in children) {
                if ([child[@"name"] isEqualToString:@"rb"]) {
                    chineseText = child[@"children"][0][@"value"];
                }
                if ([child[@"name"] isEqualToString:@"rt"]) {
                    pinyinText = child[@"children"][0][@"value"];
                }
            }
            
            if (chineseText && pinyinText) {
                [tempArray addObject:@{@"pinyin": pinyinText,@"chinese": chineseText}];
            }
        }
    }
    if(tempArray.count > 0) {
        return [self parserTextArrayToApePinYinTextDataWithTextArray:tempArray textWidth:textWidth];
    }
    return nil;
}

- (HZYPinYinTextData *)parserTextArrayToApePinYinTextDataWithTextArray:(NSArray *)textArray textWidth:(CGFloat)textWidth{
    CGFloat offSetX = 0;
    CGFloat lineHeight = 0;
    CGFloat calculateY = self.config.topOffsetY;
    
    NSMutableArray *pinYinDataArray = [NSMutableArray array];
    HZYPinYinTextData *pinYinData = [HZYPinYinTextData new];
    pinYinData.dataArray = pinYinDataArray;
    for (NSDictionary *entry in textArray) {
        NSString *pinyin = entry[@"pinyin"];
        NSString *chinese = entry[@"chinese"];
        HZYChineseTextData *data = [[HZYChineseTextData alloc] init];
        [pinYinDataArray addObject:data];
        
        NSAttributedString *chineseAttributedString = [[NSAttributedString alloc] initWithString:chinese attributes:[self getTextAttribute]];

        NSAttributedString *pinyinAttributedString = [[NSAttributedString alloc] initWithString:pinyin attributes:[self getPinYinAttribute]];
        
        data.textAttributedString = chineseAttributedString;
        data.pinYinAttributedString = pinyinAttributedString;
        
        CGSize chinesSize = CalculateTextSize(chineseAttributedString, textWidth);
        CGSize pinYinSize = CalculateTextSize(pinyinAttributedString, textWidth);
        
        CGFloat maxTextWidth = MAX(chinesSize.width, pinYinSize.width);
                        
        if(lineHeight == 0) {
            lineHeight = chinesSize.height + pinYinSize.height + self.config.pinYinToTextSpace;
            data.lineHeight = lineHeight;
        }
        
        if(offSetX + maxTextWidth > textWidth) {
            calculateY += lineHeight;
            calculateY += self.config.lineSpacing;
            offSetX = 0;
        }
        data.pinYinRect = CGRectMake(offSetX, calculateY , maxTextWidth, pinYinSize.height);
        data.textRect = CGRectMake(offSetX, calculateY + self.config.pinYinToTextSpace + pinYinSize.height , maxTextWidth, chinesSize.height);
    
        
        
        offSetX += maxTextWidth + self.config.textSpace;
    }
    pinYinData.cellHeight = (calculateY + lineHeight + self.config.bottomOffsetY);
    return pinYinData;
}

+ (NSArray *)parserDataWithArray:(NSArray *)jsonArray {
    NSMutableArray *tempArray = [NSMutableArray array];
    for (NSDictionary *pItem in jsonArray) {
        NSArray *rubyArray = pItem[@"children"];
        for (NSDictionary *rubyDict in rubyArray) {
            NSArray *children = rubyDict[@"children"];
            NSString *chineseText = nil;
            NSString *pinyinText = nil;
            
            for (NSDictionary *child in children) {
                if ([child[@"name"] isEqualToString:@"rb"]) {
                    chineseText = child[@"children"][0][@"value"];
                }
                if ([child[@"name"] isEqualToString:@"rt"]) {
                    pinyinText = child[@"children"][0][@"value"];
                }
            }
            
            if (chineseText && pinyinText) {
                [tempArray addObject:@{@"pinyin": pinyinText,@"chinese": chineseText}];
            }
        }
    }
    return tempArray;
}

- (HZYPinYinTextData *)parserDataWithChineseArray:(NSArray *)textArray textWidth:(CGFloat)textWidth {
    return [self parserTextArrayToApePinYinTextDataWithTextArray:textArray textWidth:textWidth];
}

+ (NSArray *)parserDataWithJsonString:(NSString *)json {
    NSData *jsonData = [json dataUsingEncoding:NSUTF8StringEncoding];
    // 将 NSData 转换为 NSDictionary 或 NSArray
    NSError *error = nil;
    NSObject *obj = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&error];
    if(obj && [obj isKindOfClass:NSDictionary.class]) {
        NSDictionary  *json = (NSDictionary *)obj;
        return [self parserDataWithArray:@[json]];
    }
    if(obj && [obj isKindOfClass:NSArray.class]) {
        NSArray *jsonArray = (NSArray *)obj;
        return [self parserDataWithArray:jsonArray];
    }
    return @[];
}

CGSize CalculateTextSize(NSAttributedString *attbuteString, CGFloat maxWidth) {
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)attbuteString);
    CGSize suggestedSize = CTFramesetterSuggestFrameSizeWithConstraints(framesetter, CFRangeMake(0, 0), NULL, CGSizeMake(maxWidth, CGFLOAT_MAX), NULL);
    CFRelease(framesetter);
    suggestedSize.width += 1;
    suggestedSize.height += 1;
    return suggestedSize;
}


- (NSDictionary *)getTextAttribute {
    CGFloat lineSpacing = self.config.lineSpacing;
    CGFloat paragraphSpace = self.config.lineSpacing;
    NSTextAlignment alignment = self.config.textAlignment;
    // set line break mode
    NSLineBreakMode lineBreak = NSLineBreakByWordWrapping;
    NSMutableParagraphStyle *ps = [[NSMutableParagraphStyle alloc] init];
    ps.lineBreakMode = lineBreak;
    ps.lineSpacing = lineSpacing;
    ps.alignment = alignment;
    ps.paragraphSpacing = paragraphSpace;
    
    NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
    attributes[NSFontAttributeName] = self.config.textFont;
    attributes[NSParagraphStyleAttributeName] = ps;//(__bridge id)theParagraphRef;
    attributes[NSForegroundColorAttributeName] = self.config.textColor;

    return attributes;
}

- (NSDictionary *)getPinYinAttribute {
    CGFloat lineSpacing = self.config.lineSpacing;
    CGFloat paragraphSpace = self.config.lineSpacing;
    NSTextAlignment alignment = self.config.textAlignment;
    NSLineBreakMode lineBreak = NSLineBreakByWordWrapping;// lineBreakWithWord ? NSLineBreakByWordWrapping: NSLineBreakByCharWrapping;
    NSMutableParagraphStyle *ps = [[NSMutableParagraphStyle alloc] init];
    ps.lineBreakMode = lineBreak;
    ps.lineSpacing = lineSpacing;
    ps.alignment = alignment;
    ps.paragraphSpacing = paragraphSpace;
    NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
    attributes[NSFontAttributeName] = self.config.pinYinFont;
    attributes[NSParagraphStyleAttributeName] = ps;
    attributes[NSForegroundColorAttributeName] = self.config.pinYinColor;
    return attributes;
}


@end
