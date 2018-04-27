//
//  XGTCDateUtil.m
//  aidaojia
//
//  Created by yufan on 15/10/10.
//  Copyright © 2015年 Yi Dao. All rights reserved.
//

#import "XGTCDateUtil.h"
#include <sys/time.h>

@implementation XGTCDateUtil

+ (NSDateFormatter *)formatter
{
    static NSDateFormatter *formatter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        formatter = [[NSDateFormatter alloc] init];
//        [formatter setTimeZone:[NSTimeZone systemTimeZone]];
        [formatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:8 * 3600]];
        [formatter setLocale:[NSLocale autoupdatingCurrentLocale]];
    });
    return formatter;
}

+ (NSString *)dateStringYearWithSeconds:(int64_t)seconds {
    return [self dateStringWithSeconds:seconds format:@"yyyy年"];
}

+ (NSString *)dateStringYMDWithSeconds:(int64_t)seconds
{
    return [self dateStringWithSeconds:seconds format:@"yy年MM月dd日"];
}

+ (NSString *)dateStringMDWithSeconds:(int64_t)seconds
{
    return [self dateStringWithSeconds:seconds format:@"MM月dd日"];
}

+ (NSString *)dateStringMDWeekWithSeconds:(int64_t)seconds
{
    return [NSString stringWithFormat:@"%@%@", [self dateStringWithSeconds:seconds format:@"MM-dd"], [self compareSeconds:seconds]];
}

+ (NSString *)dateStringYMDHMSWithSeconds:(int64_t)seconds
{
    return [self dateStringWithSeconds:seconds format:@"yyyy-MM-dd HH:mm:ss"];
}
+ (NSString *)dataStringYMDHMWithSeconds:(int64_t)seconds
{
     return [self dateStringWithSeconds:seconds format:@"yyyy-MM-dd HH:mm"];
}

+ (NSString *)dateStringYMDLineWithSeconds:(int64_t)seconds
{
    return [self dateStringWithSeconds:seconds format:@"yyyy-MM-dd"]; // 秒
}

+ (NSString *)dateStringYMDPointWithSeconds:(int64_t)seconds
{
    return [self dateStringWithSeconds:seconds format:@"yyyy.MM.dd"];
}


+ (NSString *)dateStringMDHMWithSeconds:(int64_t)seconds
{
    return [self dateStringWithSeconds:seconds format:@"MM月dd日 HH:mm"];
}

+ (NSString *)dateStringHMWithSeconds:(int64_t)seconds
{
    return [self dateStringWithSeconds:seconds format:@"HH:mm"];
}

+ (NSString *)dateStringHMSWithSeconds:(int64_t)seconds
{
    return [self dateStringWithSeconds:seconds format:@"HH:mm:ss"];
}

+ (NSString *)dateStringKaiQiangWithSeconds:(int64_t)seconds
{
    if ([self secondsIsToday:seconds]) {
        return [self dateStringHMWithSeconds:seconds];
    } else {
        return [self dateStringMDWithSeconds:seconds];
    }
}

+ (BOOL)secondsIsToday:(int64_t)seconds
{
    NSCalendar *calendar = [ NSCalendar currentCalendar ];
    int unit = NSCalendarUnitDay | NSCalendarUnitMonth |  NSCalendarUnitYear ;
    NSDateComponents *nowCmps = [calendar components :unit fromDate:[NSDate date]];
    NSDateComponents *selfCmps = [calendar components :unit fromDate:[NSDate dateWithTimeIntervalSince1970:seconds]];
    return (selfCmps.year == nowCmps.year) && (selfCmps.month == nowCmps.month ) && (selfCmps.day == nowCmps.day);
}

/**
 *  根据指定格式格式化时间
 *
 *  @param seconds <#seconds description#>
 *  @param format  <#format description#>
 *
 *  @return <#return value description#>
 */
+ (NSString *)dateStringWithSeconds:(int64_t)seconds format:(NSString *)format
{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:seconds];
    return [self formattedDateWithFormat:format date:date];
}


+ (NSDate *)dateWithString:(NSString *)dateStr format:(NSString *)format
{
    [self.formatter setDateFormat:format];
    return [self.formatter dateFromString:dateStr];
}

+ (NSString *)formattedDateWithFormat:(NSString *)format date:(NSDate *)date
{
    [self.formatter setDateFormat:format];
    return [self.formatter stringFromDate:date];
}
+ (NSString *)cAPIDateToStringWithMSeconds:(int64_t)mSeconds
{
    return [self cAPIDateToStringWithSeconds:mSeconds / 1000];
}

+ (NSString *)cAPIDateToStringWithSeconds:(int64_t)seconds
{
    NSString *ret = nil;
    NSTimeInterval baseTimeInterVal = seconds;
    NSTimeInterval offsetTimeInterval = [[NSDate date] timeIntervalSince1970];
    
    struct tm localNow;
    time_t rawtime = (time_t)offsetTimeInterval;
    localtime_r(&rawtime, &localNow);
    time_t baseTime = (time_t)baseTimeInterVal;
    struct tm baseLocal ;
    localtime_r(&baseTime, &baseLocal);
    NSTimeInterval interval = offsetTimeInterval - baseTimeInterVal;
    
    NSInteger nYear = baseLocal.tm_year + 1900;
    NSInteger nMonth = baseLocal.tm_mon + 1;
    NSInteger nDay = baseLocal.tm_mday;
    NSInteger nHour = baseLocal.tm_hour;
    NSInteger nMin = baseLocal.tm_min;
    NSInteger nSecond = baseLocal.tm_sec;
    
    NSInteger nCurrentYear = localNow.tm_year + 1900;
    NSInteger nCurrentDay = localNow.tm_mday;
    NSInteger nCurrentHour = localNow.tm_hour;
    NSInteger nCurrentMin = localNow.tm_min;
    NSInteger nCurrentSecond = localNow.tm_sec;
    
    char timeBuf[80];
    memset(timeBuf, 0, sizeof(timeBuf) * sizeof(char));
    
    if(interval < 60){
        ret = @"刚刚";
    } else if(interval < 3600){
        snprintf(timeBuf, sizeof(timeBuf), "%d分钟前", (int)(interval/60));
        ret = [NSString stringWithCString:(const char*)timeBuf encoding:NSUTF8StringEncoding];
    } else if(interval < 86400) {
        if (nDay==nCurrentDay) {
            snprintf(timeBuf, sizeof(timeBuf), "今天 %d:%.2d", baseLocal.tm_hour, baseLocal.tm_min);
            ret =  [NSString stringWithCString:(const char*)timeBuf encoding:NSUTF8StringEncoding];
            
        } else {
            snprintf(timeBuf, sizeof(timeBuf), "昨天 %d:%.2d", baseLocal.tm_hour, baseLocal.tm_min);
            ret =  [NSString stringWithCString:(const char*)timeBuf encoding:NSUTF8StringEncoding];
        }
    } else if(interval<86400 *2 && (nHour<nCurrentHour || (nHour==nCurrentHour && nMin<nCurrentMin) || (nHour==nCurrentHour && nMin==nCurrentMin && nSecond<nCurrentSecond))){
        snprintf(timeBuf, sizeof(timeBuf), "昨天 %d:%.2d", baseLocal.tm_hour, baseLocal.tm_min);
        ret =  [NSString stringWithCString:(const char*)timeBuf encoding:NSUTF8StringEncoding];
    } else {
        if(nYear==nCurrentYear){
            snprintf(timeBuf, sizeof(timeBuf), "%ld月%ld日", (long)nMonth,(long)nDay);
            ret =  [NSString stringWithCString:(const char*)timeBuf encoding:NSUTF8StringEncoding];
        } else {
            snprintf(timeBuf, sizeof(timeBuf), "%ld-%02ld-%02ld", (long)nYear,(long)nMonth,(long)nDay);
            ret =  [NSString stringWithCString:(const char*)timeBuf encoding:NSUTF8StringEncoding];
        }
    }
    return ret;
}

+ (NSString *)getCurrentTimestampString
{
    return [NSString stringWithFormat:@"%lld", (long long)[[NSDate date] timeIntervalSince1970] * 1000];
}

+ (int64_t)getCurrentTimestamp
{
    return  [@([[NSDate date] timeIntervalSince1970]) longLongValue];
}


+ (NSString *)compareSeconds:(int64_t)seconds
{
    NSString *dateString = [self dateStringYMDWithSeconds:seconds];
    int64_t todaySeconds = [[NSDate date] timeIntervalSince1970];
    if ([dateString isEqualToString:[self dateStringYMDWithSeconds:todaySeconds]]) {
        return @"(今天)";
    } else if ([dateString isEqualToString:[self dateStringYMDWithSeconds:todaySeconds+86400]]) {
        return @"(明天)";
    } else if ([dateString isEqualToString:[self dateStringYMDWithSeconds:todaySeconds + 86400*2]]) {
        return @"(后天)";
    } else {
        return @"";
    }
}

//获取小时

+ (NSInteger)getHourWithDate:(NSDate *)date
{
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSUInteger unitFlags = NSCalendarUnitYear| NSCalendarUnitMonth | NSCalendarUnitDay |NSCalendarUnitHour |NSCalendarUnitMinute;
    
    NSDateComponents *components = [calendar components:unitFlags fromDate:date];
    
    NSInteger hour = [components hour];
    
    return hour;
    
}


//获取日

+ (NSInteger)getDayWithDate:(NSDate *)date
{
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDateComponents *dayComponents = [calendar components:(NSCalendarUnitDay) fromDate:date];
    
    return [dayComponents day];
    
}

//获取月

+ (NSInteger)getMonthWithDate:(NSDate *)date
{
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDateComponents *dayComponents = [calendar components:(NSCalendarUnitMonth) fromDate:date];
    
    return [dayComponents month];
    
}

//获取年

+ (NSInteger)getYearWithDate:(NSDate *)date
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *dayComponents = [calendar components:(NSCalendarUnitYear) fromDate:date];
    return [dayComponents year];
}


+ (int64_t)getLastHourWithTime:(int64_t)time
{
    NSString *todayStr = [self dateStringWithSeconds:time format:@"yyyy-MM-dd HH"];
    NSDate *currentDate = [self dateWithString:todayStr format:@"yyyy-MM-dd HH"];
    return [currentDate timeIntervalSince1970];
}

+ (int64_t)getTodayWithTime:(int64_t)time
{
    NSString *todayStr = [self dateStringWithSeconds:time format:@"yyyy-MM-dd"];
    NSDate *currentDate = [self dateWithString:todayStr format:@"yyyy-MM-dd"];
    return [currentDate timeIntervalSince1970];
}


@end
