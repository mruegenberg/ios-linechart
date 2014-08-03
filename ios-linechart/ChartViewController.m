//
//  ChartViewController.m
//  ios-linechart
//
//  Created by Marcel Ruegenberg on 02.08.13.
//  Copyright (c) 2013 Marcel Ruegenberg. All rights reserved.
//

#import "ChartViewController.h"
#import "LCLineChartView.h"

@interface ChartViewController ()

@property (strong) NSDateFormatter *formatter;

@end

@implementation ChartViewController

#define SECS_PER_DAY (86400)

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    {
        self.formatter = [[NSDateFormatter alloc] init];
        [self.formatter setDateFormat:[NSDateFormatter dateFormatFromTemplate:@"yyyyMMMd" options:0 locale:[NSLocale currentLocale]]];
    }
    
    // first sample chart view:
    {
        LCLineChartData *d1x = ({
            LCLineChartData *d1 = [LCLineChartData new];
            // el-cheapo next/prev day. Don't use this in your Real Code (use NSDateComponents or objc-utils instead)
            NSDate *date1 = [[NSDate date] dateByAddingTimeInterval:((-3) * SECS_PER_DAY)];
            NSDate *date2 = [[NSDate date] dateByAddingTimeInterval:((2) * SECS_PER_DAY)];
            d1.xMin = [date1 timeIntervalSinceReferenceDate];
            d1.xMax = [date2 timeIntervalSinceReferenceDate];
            d1.title = @"Foobarbang";
            d1.color = [UIColor redColor];
            d1.itemCount = 6;
            NSMutableArray *arr = [NSMutableArray array];
            for(NSUInteger i = 0; i < 4; ++i) {
                [arr addObject:@(d1.xMin + (rand() / (float)RAND_MAX) * (d1.xMax - d1.xMin))];
            }
            [arr addObject:@(d1.xMin)];
            [arr addObject:@(d1.xMax)];
            [arr sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
                return [obj1 compare:obj2];
            }];
            NSMutableArray *arr2 = [NSMutableArray array];
            for(NSUInteger i = 0; i < 6; ++i) {
                [arr2 addObject:@((rand() / (float)RAND_MAX) * 6)];
            }
            d1.getData = ^(NSUInteger item) {
                float x = [arr[item] floatValue];
                float y = [arr2[item] floatValue];
                NSString *label1 = [self.formatter stringFromDate:[date1 dateByAddingTimeInterval:x]];
                NSString *label2 = [NSString stringWithFormat:@"%f", y];
                return [LCLineChartDataItem dataItemWithX:x y:y xLabel:label1 dataLabel:label2];
            };
            
            d1;
        });
        
        LCLineChartData *d2x = ({
            LCLineChartData *d1 = [LCLineChartData new];
            NSDate *date1 = [[NSDate date] dateByAddingTimeInterval:((-3) * SECS_PER_DAY)];
            NSDate *date2 = [[NSDate date] dateByAddingTimeInterval:((2) * SECS_PER_DAY)];
            d1.xMin = [date1 timeIntervalSinceReferenceDate];
            d1.xMax = [date2 timeIntervalSinceReferenceDate];
            d1.title = @"Bar";
            d1.color = [UIColor blueColor];
            d1.itemCount = 8;
            NSMutableArray *arr = [NSMutableArray array];
            for(NSUInteger i = 0; i < d1.itemCount - 2; ++i) {
                [arr addObject:@(d1.xMin + (rand() / (float)RAND_MAX) * (d1.xMax - d1.xMin))];
            }
            [arr addObject:@(d1.xMin)];
            [arr addObject:@(d1.xMax)];
            [arr sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
                return [obj1 compare:obj2];
            }];
            NSMutableArray *arr2 = [NSMutableArray array];
            for(NSUInteger i = 0; i < d1.itemCount; ++i) {
                [arr2 addObject:@((rand() / (float)RAND_MAX) * 6)];
            }
            d1.getData = ^(NSUInteger item) {
                float x = [arr[item] floatValue];
                float y = [arr2[item] floatValue];
                NSString *label1 = [self.formatter stringFromDate:[date1 dateByAddingTimeInterval:x]];
                NSString *label2 = [NSString stringWithFormat:@"%f", y];
                return [LCLineChartDataItem dataItemWithX:x y:y xLabel:label1 dataLabel:label2];
            };
            
            d1;
        });
        
        LCLineChartView *chartView = [[LCLineChartView alloc] initWithFrame:CGRectMake(20, 400, 500, 300)];
        chartView.yMin = 0;
        chartView.yMax = 6;
        chartView.ySteps = @[@"1.0",@"2.0",@"3.0",@"4.0",@"5.0",@"A big label at 6.0"];
        chartView.data = @[d1x,d2x];
        chartView.selectedItemCallback = ^(LCLineChartData *dat, NSUInteger item, CGPoint pos) {
            if(dat == d1x && item == 2) {
                NSLog(@"User selected item 1 in 1st graph at position %@ in the graph view", NSStringFromCGPoint(pos));
            }
        };
        
        //    chartView.drawsDataPoints = NO; // Uncomment to turn off circles at data points.
        //    chartView.drawsDataLines = NO; // Uncomment to turn off lines connecting data points. (=> scatter plot)
        //    chartView.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1.0]; // Uncomment for custom background color.
        
        [self.view addSubview:chartView];
    }
    
    // second sample chart view
    {
        LCLineChartData *d = [LCLineChartData new];
        d.xMin = 1;
        d.xMax = 31;
        d.title = @"The title for the legend";
        d.color = [UIColor redColor];
        d.itemCount = 10;
        
        NSMutableArray *vals = [NSMutableArray new];
        for(NSUInteger i = 0; i < d.itemCount; ++i)
            [vals addObject:@((rand() / (float)RAND_MAX) * (31 - 1) + 1)];
        [vals sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            return [obj1 compare:obj2];
        }];
        d.getData = ^(NSUInteger item) {
            float x = [vals[item] floatValue];
            float y = powf(2, x / 7);
            NSString *label1 = [NSString stringWithFormat:@"%lu", (unsigned long)item];
            NSString *label2 = [NSString stringWithFormat:@"%f", y];
            return [LCLineChartDataItem dataItemWithX:x y:y xLabel:label1 dataLabel:label2];
        };
        
        LCLineChartView *chartView = [[LCLineChartView alloc] initWithFrame:CGRectMake(20, 700, 500, 300)];
        chartView.yMin = 0;
        chartView.yMax = powf(2, 31 / 7) + 0.5;
        chartView.ySteps = @[@"0.0",
                             [NSString stringWithFormat:@"%.02f", chartView.yMax / 2],
                             [NSString stringWithFormat:@"%.02f", chartView.yMax]];
        chartView.xStepsCount = 5;
        chartView.data = @[d];
        
        chartView.axisLabelColor = [UIColor blueColor];
        
        [self.view addSubview:chartView];
    }
}

@end
