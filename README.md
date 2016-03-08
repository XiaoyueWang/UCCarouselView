# UCCarouselView
UICollectionView 实现无线轮播组件

## 这么用
两种模式，一种带定时器的，一种不带定时器的

	// 不使用定时器初始化
	- (instancetype)initWithFrame:(CGRect)frame
                    dataArray:(NSArray *)dataArray
           didSelectItemBlock:(void (^)(NSInteger didSelectItem))block;
	
	// 使用定时器初始化
	- (instancetype)initWithFrame:(CGRect)frame
                    dataArray:(NSArray *)dataArray
                 timeInterval:(CGFloat)timeInterval
           didSelectItemBlock:(void (^)(NSInteger didSelectItem))block;
	
## 数据
dataArray为 UIImage数据

例如：

	#define __LOADIMAGE(file, type) [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:file ofType:type]]
	
	// Demo 数据
	- (NSArray *)loadData {
	    NSArray *array = @[__LOADIMAGE(@"dota2_0", @"jpg"),
	                       __LOADIMAGE(@"dota2_1", @"jpg"),
	                       __LOADIMAGE(@"dota2_2", @"jpg"),
	                       __LOADIMAGE(@"dota2_3", @"jpg")];
	    return array;
	}
