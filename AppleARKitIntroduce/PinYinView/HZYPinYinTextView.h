//
//  HZYPinYinTextView.h
//  AppleARKitIntroduce
//
//  Created by huangbaoxian on 2024/12/12.
//

#import <UIKit/UIKit.h>
#import "HZYPinYinTextData.h"

NS_ASSUME_NONNULL_BEGIN

@class HZYPinYinTextView;

@protocol HZYPinYinTextViewDelegate <NSObject>

- (void)pinYinTextView:(HZYPinYinTextView *)pinYinTextView
              textData:(HZYChineseTextData *)textData
           touchPinYin:(BOOL)isTouchPinYin
didSelectionTouchPoint:(CGPoint)point;

@end


@interface HZYPinYinTextView : UIView

@property (nonatomic, weak) id<HZYPinYinTextViewDelegate> delegate;

@property (nonatomic, strong) HZYPinYinTextData *textData;

@property (nonatomic, assign) BOOL enableTapped;


@end

NS_ASSUME_NONNULL_END
