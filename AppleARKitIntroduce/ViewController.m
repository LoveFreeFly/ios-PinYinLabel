//
//  ViewController.m
//  AppleARKitIntroduce
//
//  Created by huangbaoxian on 2024/12/12.
//

#import "ViewController.h"
#import "HZYPinYinTextView.h"
#import "HZYPinYinFrameParser.h"
#import "HZYPinYinTextData.h"


@interface ViewController ()

@property (nonatomic, strong) HZYPinYinTextView *label;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    HZYPinYinTextView *label = [[HZYPinYinTextView alloc] initWithFrame:CGRectMake(30, 100, 300, 120)];
    label.enableTapped = YES;
    label.backgroundColor = UIColor.grayColor;
    [self.view addSubview:label];
    self.label = label;
    
    // Do any additional setup after loading the view.
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self loadData];
}

- (void )loadData {
    NSArray *englishData = @[
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
                   @{
                       @"name": @"ruby",
                       @"value": @"",
                       @"children": @[
                           @{
                               @"name": @"rb",
                               @"value": @"",
                               @"children": @[
                                   @{@"name": @"txt", @"value": @"汉字", @"children": @[]}
                               ]
                           },
                           @{
                               @"name": @"rt",
                               @"value": @"",
                               @"children": @[
                                   @{@"name": @"txt", @"value": @"hàn zì", @"children": @[]}
                               ]
                        }
                    ]
                },
                   @{
                       @"name": @"ruby",
                       @"value": @"",
                       @"children": @[
                           @{
                               @"name": @"rb",
                               @"value": @"",
                               @"children": @[
                                   @{@"name": @"txt", @"value": @" 成 吉 思 汗 ", @"children": @[]}
                               ]
                           },
                           @{
                               @"name": @"rt",
                               @"value": @"",
                               @"children": @[
                                   @{@"name": @"txt", @"value": @"chéng jí sī hán", @"children": @[]}
                               ]
                        }
                    ]
                },
                   
                   @{
                       @"name": @"ruby",
                       @"value": @"",
                       @"children": @[
                           @{
                               @"name": @"rb",
                               @"value": @"",
                               @"children": @[
                                   @{@"name": @"txt", @"value": @" 追 星 赶 月 ", @"children": @[]}
                               ]
                           },
                           @{
                               @"name": @"rt",
                               @"value": @"",
                               @"children": @[
                                   @{@"name": @"txt", @"value": @"zhuī xīng gǎn yuè", @"children": @[]}
                               ]
                        }
                    ]
                },
                   
                   @{
                       @"name": @"ruby",
                       @"value": @"",
                       @"children": @[
                           @{
                               @"name": @"rb",
                               @"value": @"",
                               @"children": @[
                                   @{@"name": @"txt", @"value": @"热 爱 祖 国", @"children": @[]}
                               ]
                           },
                           @{
                               @"name": @"rt",
                               @"value": @"",
                               @"children": @[
                                   @{@"name": @"txt", @"value": @"rè ài zǔ guó", @"children": @[]}
                               ]
                        }
                    ]
                },
            ]
        }
    ];
    HZYPinYinFrameParser *pinYinParser = [[HZYPinYinFrameParser alloc] initWithConfig:[HZYPinYinTextConfig defaultConfig]];
    HZYPinYinTextData *data = [pinYinParser parserDataWithJsonArray:englishData textWidth:300];
    self.label.frame = CGRectMake(self.label.frame.origin.x, self.label.frame.origin.y, self.label.frame.size.width, data.cellHeight);
    [self.label setTextData:data];

}



@end
