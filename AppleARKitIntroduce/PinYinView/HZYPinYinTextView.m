//
//  HZYPinYinTextView.m
//  AppleARKitIntroduce
//
//  Created by huangbaoxian on 2024/12/12.
//

#import "HZYPinYinTextView.h"
#import <CoreText/CoreText.h>

@interface HZYPinYinTextView ()

@property (nonatomic, strong) UITapGestureRecognizer *tapRecognizer;

@end

@implementation HZYPinYinTextView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (void)setEnableTapped:(BOOL)enableTapped {
    _enableTapped = enableTapped;
    self.userInteractionEnabled = enableTapped;
    if(enableTapped) {
        if(!_tapRecognizer) {
            _tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userTapGestureDetected:)];
        }
        [self addGestureRecognizer:_tapRecognizer];
    }else {
        if(_tapRecognizer && _tapRecognizer.view) {
            [self removeGestureRecognizer:_tapRecognizer];
        }
    }
}

- (void)userTapGestureDetected:(UITapGestureRecognizer *)sender {
    CGPoint point = [sender locationInView:self];
    
    for (HZYChineseTextData *subTextData in self.textData.dataArray) {
        if(CGRectContainsPoint(subTextData.textRect, point)) {
            if(self.delegate && [self.delegate respondsToSelector:@selector(pinYinTextView:textData:touchPinYin:didSelectionTouchPoint:)]) {
                [self.delegate pinYinTextView:self textData:subTextData touchPinYin:NO didSelectionTouchPoint:point];
            }
        }else if(CGRectContainsPoint(subTextData.pinYinRect, point)) {
            if(self.delegate && [self.delegate respondsToSelector:@selector(pinYinTextView:textData:touchPinYin:didSelectionTouchPoint:)]) {
                [self.delegate pinYinTextView:self textData:subTextData touchPinYin:YES didSelectionTouchPoint:point];
            }
        }
    }
   
}

- (void)setTextData:(HZYPinYinTextData *)textData {
    _textData = textData;
    [self setNeedsDisplay];
}


- (void)drawRect:(CGRect)rect {
    if(self.textData.dataArray > 0) {
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSaveGState(context);
        CGContextSetTextMatrix(context, CGAffineTransformIdentity);
        CGContextTranslateCTM(context, 0.0, rect.size.height);
        CGContextScaleCTM(context, 1.0, -1.0);
        for (HZYChineseTextData *chineseData in self.textData.dataArray) {
            NSAttributedString *chineseAttributedString = chineseData.textAttributedString;
            NSAttributedString *pinyinAttributedString = chineseData.pinYinAttributedString;
            [self drawCoreTextString:chineseAttributedString
                           inContext:context
                                rect:chineseData.textRect
                          viewHeight:rect.size.height];
            
            [self drawCoreTextString:pinyinAttributedString
                           inContext:context
                                rect:chineseData.pinYinRect
                          viewHeight:rect.size.height];
        }
        CGContextRestoreGState(context);
    }else {
        [super drawRect:rect];
    }
}

- (void)drawCoreTextString:(NSAttributedString *)string
                 inContext:(CGContextRef)context
                      rect:(CGRect)rect  viewHeight:(CGFloat)viewHeight {
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)string);
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, CGRectMake(rect.origin.x, viewHeight -  CGRectGetMaxY(rect), rect.size.width, rect.size.height));
    CTFrameRef frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, 0), path, NULL);
    CTFrameDraw(frame, context);
    
    CFRelease(framesetter);
    CFRelease(path);
    CFRelease(frame);
}

@end
