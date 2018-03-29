//
//  BadWord.m
//  OTAtest
//
//  Created by admin on 2018/2/6.
//  Copyright © 2018年 test1. All rights reserved.
//

#import "BadWord.h"
@interface BadWord ()

@property (strong,nonatomic) NSMutableDictionary* ALLDict;
@property (strong,nonatomic) NSMutableDictionary* ALLSepDict;
@property (strong,nonatomic) NSArray* ALLSepArray;

@end

@implementation BadWord

+(instancetype) getInstance{
    static BadWord * instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[BadWord alloc] init];
        instance.ALLDict = [[NSMutableDictionary alloc] init];
        instance.ALLSepDict = [[NSMutableDictionary alloc] init];
        instance.ALLSepArray = @[@"*",@"-",@"+",@" ",@"=",@"."];
        [instance initwithWord];
    });
    return instance;
}

-(NSMutableDictionary*)checkadd:(NSMutableDictionary*)dict key:(NSString*)key isend:(bool)isend{
    NSMutableDictionary* tmp = [dict objectForKey:key];
    if (tmp == nil) {
        tmp = [[NSMutableDictionary alloc] init];
        [dict setObject:tmp forKey:key];
    }
    if (isend) {
        [tmp setObject:[NSNumber numberWithInt:1] forKey:@"end"];
    }
    return tmp;
}

-(void)initwithWord{
    for (NSString* key in self.ALLSepArray) {
        [self.ALLSepDict setObject:@1 forKey:key];
    }
    NSString* fileRoot = [[NSBundle mainBundle] pathForResource:@"test" ofType:@"txt"];
    
    //read everything from text
    NSString* fileContents = [NSString stringWithContentsOfFile:fileRoot encoding:NSUTF8StringEncoding error:nil];
    //first, separate by new line
    NSArray* allLinedStrings = [fileContents componentsSeparatedByCharactersInSet: [NSCharacterSet newlineCharacterSet]];
    //then break down even further
    for (NSString* word in allLinedStrings) {
        if (word.length > 0) {
            NSMutableDictionary* nextdict = self.ALLDict;
            for (int i=0; i<[word length]; i++) {
                NSString* key = [word substringWithRange:NSMakeRange(i, 1)];
                nextdict = [self checkadd: nextdict key:key isend:(i == [word length] - 1)];
            }
        }
    }
    NSLog(@"dict = %@",self.ALLDict);
}

-(NSMutableDictionary*)checkexist:(NSMutableDictionary*)dict key:(NSString*) key{
    NSMutableDictionary* tmp = [dict objectForKey:key];
    if (tmp == nil) {
        return dict;
    }
    return tmp;
}
//ggf没有走私走私aaa杀a人dddd强奸ddg强奸411犯罪ddsfe
- (NSString*)check:(NSString*)str{
    if (str == nil || [str length] == 0) {
        return str;
    }
    NSMutableArray* realword = [[NSMutableArray alloc] init];
    NSMutableArray* septable = [[NSMutableArray alloc] init];
    for (int i = 0; i<[str length]; i++) {
        NSString* key = [str substringWithRange:NSMakeRange(i, 1)];
        NSString* v = [self.ALLSepDict objectForKey:key];
        if(v == nil){
            [realword addObject:key];
        }
        else{
            NSDictionary* tmp = @{@"index":@(i),@"seq":key};
            [septable addObject:tmp];
        }
    }
    NSMutableArray* allindexarray = [[NSMutableArray alloc] init];
    NSMutableDictionary* nextdict = self.ALLDict;
    NSMutableArray* oneword = [[NSMutableArray alloc] init];
    NSMutableArray* tmpfound = [[NSMutableArray alloc] init];
    
    bool found = false;
    for (int i = 0; i<realword.count; i++) {
        NSString* key = realword[i];
        NSMutableDictionary* before = nextdict;
        nextdict = [self checkexist:nextdict key:key];
        //没有找到key，下一个字又从头开始
        if (nextdict == before) {
            if (tmpfound.count>0) {
                [allindexarray addObject:[tmpfound copy]];
                [tmpfound removeAllObjects];
            }
            nextdict = self.ALLDict;
            [oneword removeAllObjects];
            if (found) {
                i--;
                found = false;
            }
        }
        else{
            found = true;
            NSNumber* indexn = [NSNumber numberWithInt:i];
            [oneword addObject:indexn];
            //已经到该词语的结尾
            NSNumber* en = [nextdict objectForKey:@"end"];
            if (en != nil && [en isKindOfClass:[NSNumber class]]) {
                if (i == realword.count - 1) {
                    nextdict = self.ALLDict;
                    NSMutableArray* willadd = [[NSMutableArray alloc] init];
                    [willadd addObjectsFromArray:oneword];
                    [tmpfound addObjectsFromArray:willadd];
                    [allindexarray addObject:[tmpfound copy]];
                    [tmpfound removeAllObjects];
                }
                else{
                    NSMutableArray* willadd = [[NSMutableArray alloc] init];
                    [willadd addObjectsFromArray:oneword];
                    [tmpfound addObjectsFromArray:willadd];
                }
                [oneword removeAllObjects];
            }
        }
    }
    for (NSMutableArray* indexarray in allindexarray) {
        for (NSNumber* index in indexarray) {
            realword[index.intValue] = @"*";
        }
    }
    for (NSDictionary* dict in septable) {
        NSNumber* index = [dict objectForKey:@"index"];
        NSString* seq = [dict objectForKey:@"seq"];
        [realword insertObject:seq atIndex:index.intValue];
    }
    NSString* ret = [realword componentsJoinedByString:@""];
    NSLog(@"ret = %@",ret);
    return ret;
}

@end
