//
//  LineChartView.h
//  
//
//  Created by Marcel Ruegenberg on 02.08.13.
//
//

#import <UIKit/UIKit.h>

@class LineChartDataItem;

typedef LineChartDataItem *(^LineChartDataGetter)(NSUInteger item);



@interface LineChartDataItem : NSObject

@property (readonly) float x; // should be within the x range
@property (readonly) float y; // should be within the y range
@property (readonly) NSString *xLabel; // label to be shown on the x axis
@property (readonly) NSString *dataLabel; // label to be shown directly at the data item

+ (LineChartDataItem *)dataItemWithX:(float)x y:(float)y xLabel:(NSString *)xLabel dataLabel:(NSString *)dataLabel;

@end



@interface LineChartData : NSObject

@property (strong) UIColor *color;
@property (copy) NSString *title;
@property NSUInteger itemCount;

@property float xMin;
@property float xMax;

@property (copy) LineChartDataGetter getData;

@end



@interface LineChartView : UIView

@property (nonatomic, strong) NSArray *data; // Array of `LineChartData` objects, one for each line.

@property float yMin;
@property float yMax;
@property (strong) NSArray *ySteps; // Array of step names (NSString). At each step, a scale line is shown.
@property BOOL drawsDataPoints; // Switch to turn off circles on data points. On by default.
@property BOOL drawsDataLines; // Switch to turn off lines connecting data points. On by default.

- (void)showLegend:(BOOL)show animated:(BOOL)animated;

@end
