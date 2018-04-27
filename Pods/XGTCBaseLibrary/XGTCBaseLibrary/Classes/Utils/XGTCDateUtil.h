//
//  XGTCDateUtil.h
//  aidaojia
//
//  Created by yufan on 15/10/10.
//  Copyright © 2015年 Yi Dao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XGTCDateUtil : NSObject

/**
 * yyyy
 */
+ (NSString *)dateStringYearWithSeconds:(int64_t)seconds;
/**
 *  yy年MM月dd日
 *
 *  @param seconds <#seconds description#>
 *
 *  @return <#return value description#>
 */
+ (NSString *)dateStringYMDWithSeconds:(int64_t)seconds;

/**
 *  MM月dd日
 *
 *  @param seconds <#seconds description#>
 *
 *  @return <#return value description#>
 */
+ (NSString *)dateStringMDWithSeconds:(int64_t)seconds;


/**
 *  MM月dd日(今天、明天、后天)
 *
 *  @param seconds <#seconds description#>
 *
 *  @return <#return value description#>
 */
+ (NSString *)dateStringMDWeekWithSeconds:(int64_t)seconds;

/**
 *  yyyy-MM-dd HH:mm:ss
 *
 *  @param seconds <#seconds description#>
 *
 *  @return <#return value description#>
 */
+ (NSString *)dateStringYMDHMSWithSeconds:(int64_t)seconds;

/**
 *  yyyy-MM-dd HH:mm
 *
 *  @param seconds <#seconds description#>
 *
 *  @return <#return value description#>
 */
+ (NSString *)dataStringYMDHMWithSeconds:(int64_t)seconds;
/**
 *  yyyy-MM-dd
 *
 *  @param seconds <#seconds description#>
 *
 *  @return <#return value description#>
 */
+ (NSString *)dateStringYMDLineWithSeconds:(int64_t)seconds;

/**
 *  yyyy.MM.dd
 *
 *  @param seconds <#seconds description#>
 *
 *  @return <#return value description#>
 */
+ (NSString *)dateStringYMDPointWithSeconds:(int64_t)seconds;

/**
 *  MM-dd HH:mm
 *
 *  @param seconds <#seconds description#>
 *
 *  @return <#return value description#>
 */
+ (NSString *)dateStringMDHMWithSeconds:(int64_t)seconds;

/**
 *  HH:mm
 *
 *  @param seconds <#seconds description#>
 *
 *  @return <#return value description#>
 */
+ (NSString *)dateStringHMWithSeconds:(int64_t)seconds;

/**
 *  HH:mm:ss
 *
 *  @param seconds <#seconds description#>
 *
 *  @return <#return value description#>
 */
+ (NSString *)dateStringHMSWithSeconds:(int64_t)seconds;


/**
 *  今天显示 HH:mm  否则显示 MM月dd日
 *
 *  @param seconds <#seconds description#>
 *
 *  @return <#return value description#>
 */
+ (NSString *)dateStringKaiQiangWithSeconds:(int64_t)seconds;

/**
 *  根据format格式化秒数
 *
 *  @param seconds <#seconds description#>
 *  @param format  <#format description#>
 *
 *  @return <#return value description#>
 */
+ (NSString *)dateStringWithSeconds:(int64_t)seconds format:(NSString *)format;

/**
 *  根据字符串，转化为日期
 *
 *  @param dateStr <#dateStr description#>
 *  @param format  <#format description#>
 *
 *  @return <#return value description#>
 */
+ (NSDate *)dateWithString:(NSString *)dateStr format:(NSString *)format;

/**
 *   根据format格式化Date
 *
 *  @param format <#format description#>
 *  @param date   <#date description#>
 *
 *  @return <#return value description#>
 */
+ (NSString *)formattedDateWithFormat:(NSString *)format date:(NSDate *)date;

+ (NSString *)cAPIDateToStringWithMSeconds:(int64_t)mSeconds;

/**
 *  根据当前时间显示不同的
 *
 *  @param seconds <#seconds description#>
 *
 *  @return <#return value description#>
 */
+ (NSString *)cAPIDateToStringWithSeconds:(int64_t)seconds;

/**
 * 获取当前时间的毫秒数
 */
+ (int64_t)getCurrentTimestamp;

/**
 * 获取当前时间的毫秒数
 */
+ (NSString *)getCurrentTimestampString;


/**
 *  根据时间获取小时、日、月、年
 */
+ (NSInteger)getHourWithDate:(NSDate *)date;
+ (NSInteger)getMonthWithDate:(NSDate *)date;
+ (NSInteger)getYearWithDate:(NSDate *)date;
+ (NSInteger)getDayWithDate:(NSDate *)date;

//获取之前一个小时的时间戳
+ (int64_t)getLastHourWithTime:(int64_t)time;
//获取今天的时间戳
+ (int64_t)getTodayWithTime:(int64_t)time;
@end
