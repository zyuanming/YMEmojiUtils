//
//  ViewController.m
//  EmojiCreator
//
//  Created by Zhang Yuanming on 15/10/9.
//  Copyright © 2015年 Baidu. All rights reserved.
//

#import "ViewController.h"
#import <mach-o/dyld.h>
#import <objc/runtime.h>
#import <CoreText/CoreText.h>

@interface EmojiModel : NSObject

@property (nonatomic, strong) NSString *imageName;
@property (nonatomic, strong) NSString *symbol;
@property (nonatomic, assign) long offset;
@property (nonatomic, assign) long fileLength;

@end

@implementation EmojiModel

@end


@interface NSObject (UIKeyboardEmojiCategory)
+ (NSInteger) numberOfCategories;
+ (id) categoryForType:(NSInteger)type;
+ (unsigned long long)hasVariantsForEmoji:(id)arg1;
+ (id)localizedStringForKey:(id)arg1;
+ (id)categories;
+ (id)stringToRegionalIndicatorString:(id)arg1;
@end


@interface NSObject (UIKeyboardEmojiImageView)
- (id) initWithFrame:(CGRect)frame emojiString:(NSString *)emojiString;
@end

@interface NSObject (UIKeyboardEmoji)
+ (id)emojiWithString:(id)arg1 withVariantMask:(unsigned long long)arg2;
- (void)setVariantMask:(unsigned int)arg1;
- (id)key;
@end

@interface ViewController ()

@property (nonatomic, strong) NSString *compressedImagePath;
@property (nonatomic, strong) NSDictionary *test;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // iOS10 beta版有些多肤色的Emoji无法通过简单的字符拼接来实现，因为iOS10添加支持了一种全新的emoji构造方式：
    // 例如，通过一个基本的emoji 加上一个 “♀” 女生标记来构造一个全新的对应的女生版的emoji
    _test = @{@"👱‍♀️": @"👱🏻‍♀️,👱‍♀️,👱🏼‍♀️,👱🏽‍♀️,👱🏾‍♀️,👱🏿‍♀️",
               @"👳‍♀️": @"👳🏻‍♀️,👳‍♀️,👳🏼‍♀️,👳🏽‍♀️,👳🏾‍♀️,👳🏿‍♀️",
               @"👮‍♀️": @"👮🏻‍♀️,👮‍♀️,👮🏼‍♀️,👮🏽‍♀️,👮🏾‍♀️,👮🏿‍♀️",
               @"👷‍♀️": @"👷🏻‍♀️,👷‍♀️,👷🏼‍♀️,👷🏽‍♀️,👷🏾‍♀️,👷🏿‍♀️",
               @"💂‍♀️": @"💂🏻‍♀️,💂‍♀️,💂🏼‍♀️,💂🏽‍♀️,💂🏾‍♀️,💂🏿‍♀️",
               @"🕵️‍♀️": @"🕵🏻‍♀️,🕵️‍♀️,🕵🏼‍♀️,🕵🏽‍♀️,🕵🏾‍♀️,🕵🏿‍♀️",
               @"🙇‍♀️": @"🙇🏻‍♀️,🙇‍♀️,🙇🏼‍♀️,🙇🏽‍♀️,🙇🏾‍♀️,🙇🏿‍♀️",
               @"💁‍♂️": @"💁🏻‍♂️,💁‍♂️,💁🏼‍♂️,💁🏽‍♂️,💁🏾‍♂️,💁🏿‍♂️",
               @"🙅‍♂️": @"🙅🏻‍♂️,🙅‍♂️,🙅🏼‍♂️,🙅🏽‍♂️,🙅🏾‍♂️,🙅🏿‍♂️",
               @"🙆‍♂️": @"🙆🏻‍♂️,🙆‍♂️,🙆🏼‍♂️,🙆🏽‍♂️,🙆🏾‍♂️,🙆🏿‍♂️",
               @"🙋‍♂️": @"🙋🏻‍♂️,🙋‍♂️,🙋🏼‍♂️,🙋🏽‍♂️,🙋🏾‍♂️,🙋🏿‍♂️",
               @"🙎‍♂️": @"🙎🏻‍♂️,🙎‍♂️,🙎🏼‍♂️,🙎🏽‍♂️,🙎🏾‍♂️,🙎🏿‍♂️",
               @"🙍‍♂️": @"🙍🏻‍♂️,🙍‍♂️,🙍🏼‍♂️,🙍🏽‍♂️,🙍🏾‍♂️,🙍🏿‍♂️",
               @"💇‍♂️": @"💇🏻‍♂️,💇‍♂️,💇🏼‍♂️,💇🏽‍♂️,💇🏾‍♂️,💇🏿‍♂️",
               @"💆‍♂️": @"💆🏻‍♂️,💆‍♂️,💆🏼‍♂️,💆🏽‍♂️,💆🏾‍♂️,💆🏿‍♂️",
               @"🚶‍♀️": @"🚶🏻‍♀️,🚶‍♀️,🚶🏼‍♀️,🚶🏽‍♀️,🚶🏾‍♀️,🚶🏿‍♀️",
               @"🏃‍♀️": @"🏃🏻‍♀️,🏃‍♀️,🏃🏼‍♀️,🏃🏽‍♀️,🏃🏾‍♀️,🏃🏿‍♀️",
               @"🏋️‍♀️": @"🏋🏻‍♀️,🏋️‍♀️,🏋🏼‍♀️,🏋🏽‍♀️,🏋🏾‍♀️,🏋🏿‍♀️",
               @"⛹️‍♀️": @"⛹🏻‍♀️,⛹️‍♀️,⛹🏼‍♀️,⛹🏽‍♀️,⛹🏾‍♀️,⛹🏿‍♀️",
               @"🏄‍♀️": @"🏄🏻‍♀️,🏄‍♀️,🏄🏼‍♀️,🏄🏽‍♀️,🏄🏾‍♀️,🏄🏿‍♀️",
               @"🏊‍♀️": @"🏊🏻‍♀️,🏊‍♀️,🏊🏼‍♀️,🏊🏽‍♀️,🏊🏾‍♀️,🏊🏿‍♀️",
               @"🚣‍♀️": @"🚣🏻‍♀️,🚣‍♀️,🚣🏼‍♀️,🚣🏽‍♀️,🚣🏾‍♀️,🚣🏿‍♀️",
               @"🚴‍♀️": @"🚴🏻‍♀️,🚴‍♀️,🚴🏼‍♀️,🚴🏽‍♀️,🚴🏾‍♀️,🚴🏿‍♀️",
               @"🚵‍♀️": @"🚵🏻‍♀️,🚵‍♀️,🚵🏼‍♀️,🚵🏽‍♀️,🚵🏾‍♀️,🚵🏿‍♀️",
               @"🕵️": @"🕵🏻,🕵️,🕵🏼,🕵🏽,🕵🏾,🕵🏿",
               @"🏋️": @"🏋🏻,🏋️,🏋🏼,🏋🏽,🏋🏾,🏋🏿",
               @"⛹️": @"⛹🏻,⛹️,⛹🏼,⛹🏽,⛹🏾,⛹🏿",
               @"🚣": @"🚣🏻,🚣,🚣🏼,🚣🏽,🚣🏾,🚣🏿",
               @"🏊": @"🏊🏻,🏊,🏊🏼,🏊🏽,🏊🏾,🏊🏿",
               @"🏄": @"🏄🏻,🏄,🏄🏼,🏄🏽,🏄🏾,🏄🏿"};
    self.compressedImagePath = [NSHomeDirectory() stringByAppendingString:[NSString stringWithFormat:@"/Documents/emojis/"]];


    ////////////////// 导出data里面的图片，重新压缩后再拼接

    // 1.
    NSString *dataPath = [[NSBundle mainBundle] pathForResource:@"emojisex" ofType:@"data"];

    NSString *emoji91PlistPath = [[NSBundle mainBundle] pathForResource:@"emojis91" ofType:@"plist"];
    NSString *data91PlistPath = [[NSBundle mainBundle] pathForResource:@"emojis91data" ofType:@"plist"];

    NSString *emojiexPlistPath = [[NSBundle mainBundle] pathForResource:@"emojisex" ofType:@"plist"];
    NSString *dataexPlistPath = [[NSBundle mainBundle] pathForResource:@"emojisexdata" ofType:@"plist"];

    NSString *outputhPath = [NSHomeDirectory() stringByAppendingString:@"/Documents/output/"];
    [self exportImageFromDataPath:dataPath byDataPlist:data91PlistPath byEmojiPlist:emoji91PlistPath saveTo:outputhPath];
    [self exportImageFromDataPath:dataPath byDataPlist:dataexPlistPath byEmojiPlist:emojiexPlistPath saveTo:outputhPath];

    // 用ImageOptim无损压缩

    // 2.
    NSString *imagePath = [NSHomeDirectory() stringByAppendingString:@"/Documents/output/"];
    [self updateDataPlist:data91PlistPath byImagePath:imagePath withEmojiPlist:emoji91PlistPath];


    NSString *newDataPath = [NSHomeDirectory() stringByAppendingString:@"/Documents/UpdatedPlist/emojis91data.plist.data"];
    NSString *newData91PlistPath = [NSHomeDirectory() stringByAppendingString:@"/Documents/UpdatedPlist/emojis91data.plist"];
    [self updateEmojiDataPlistWithDataPath:newDataPath
                             dataPlistPath:dataexPlistPath
                                imagesPath:outputhPath
                            emojiPlistPath:emojiexPlistPath
                        baseEmojiPlistPath:emoji91PlistPath
                    baseEmojiDataPlistPath:newData91PlistPath];



    ////////////////// iOS 10 更新步骤
    // 1.
    [self exportAllEmojiImages];
    // 用pngquant 命令行执行有损压缩

    // 2.
    NSString *emojis91Path = [[NSBundle mainBundle] pathForResource:@"emojis91" ofType:@"plist"];
    NSString *jsonPath = [[NSBundle mainBundle] pathForResource:@"Category-Emoji" ofType:@"json"];
    NSArray *newAddEmojiList = [self exportNewEmojisListInJsonPath:jsonPath fromEmojiListPath:emojis91Path];
    // 具体新增的Emoji，可以查看： http://emojipedia.org/apple/ios-10.0/new+changed/
    NSString *newDesignEmojis = @"🔫,😀,😬,😁,😂,😃,😄,😅,😆,😇,😉,😊,🙂,🙃,☺️,😋,😌,😍,😘,😗,😙,😚,😜,😝,😛,🤑,🤓,😎,🤗,😏,😶,😐,😑,😒,🙄,🤔,😳,😞,😟,😠,😡,😔,😕,🙁,☹️,😣,😖,😫,😩,😤,😮,😱,😨,😰,😯,😦,😧,😢,😥,😪,😓,😭,😵,😲,🤐,😷,🤒,🤕,😴,🙌,👏,👍,👎,👊,✊,👋,👈,👉,👆,👇,👌,☝️,✌️,✋,🖐,👐,💪,🙏,🖖,🤘,🖕,✍️,💅,👄,👅,👂,👃,👶,👦,👧,👨,👩,👱‍♀️,👱,👴,👵,👲,👳‍♀️,👳,👮‍♀️,👮,👷‍♀️,👷,💂‍♀️,💂,🕵️‍♀️,🕵️,🎅,👸,👰,👼,🙇‍♀️,🙇,💁,💁‍♂️,🙅,🙅‍♂️,🙆,🙆‍♂️,🙋,🙋‍♂️,🙎,🙎‍♂️,🙍,🙍‍♂️,💇,💇‍♂️,💆,💆‍♂️,💃,👯,👯‍♂️,🚶‍♀️,🚶,🏃‍♀️,🏃,👫,👭,👬,💑,👩‍❤️‍👩,👨‍❤️‍👨,💏,👩‍❤️‍💋‍👩,👨‍❤️‍💋‍👨,👪,👨‍👩‍👧,👨‍👩‍👧‍👦,👨‍👩‍👦‍👦,👨‍👩‍👧‍👧,👩‍👩‍👦,👩‍👩‍👧,👩‍👩‍👧‍👦,👩‍👩‍👦‍👦,👩‍👩‍👧‍👧,👨‍👨‍👦,👨‍👨‍👧,👨‍👨‍👧‍👦,👨‍👨‍👦‍👦,👨‍👨‍👧‍👧,👩‍👦,👩‍👧,👩‍👧‍👦,👩‍👦‍👦,👩‍👧‍👧,👨‍👦,👨‍👧,👨‍👧‍👦,👨‍👦‍👦,👨‍👧‍👧,🚵,🏊,🚣,🏄，🇷🇴，😈，👿，💀，👽，😾，🛁";

    NSArray *newDesignEmojisList = [newDesignEmojis componentsSeparatedByString:@","];
    NSMutableArray *newEmojis = [NSMutableArray arrayWithArray:newAddEmojiList];
    [newEmojis addObjectsFromArray:newDesignEmojisList];

    // 3.
    NSString *path = [NSHomeDirectory() stringByAppendingString:@"/Documents/UpdatedPlist/emojisexdata.plist.data"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    [self updateNewEmoji:newEmojis iniOS10WithUpdateData:data];


}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void) getJSONContent {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Category-Emoji" ofType:@"json"];
    NSData *jsonData = [[NSData alloc]initWithContentsOfFile:path];
    NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
    NSArray *emojiCategoryArray = jsonDic[@"EmojiDataArray"];
    NSArray *skinsTemp = @[@"🏻",@"",@"🏼",@"🏽",@"🏾",@"🏿"];
    NSArray *hasSkinEmojiArray = [self getHasDifferentSkinsEmojiList];
    
    NSMutableArray *emojiExPlistArray = [NSMutableArray array];
    NSMutableArray *emojiExDataPlistArray = [NSMutableArray array];
    NSMutableData  *emojiExData = [[NSMutableData alloc]init];
    
    NSMutableString *tmpString = [NSMutableString string];
    
    int offset = 0;
    
    for (int i = 0; i < [emojiCategoryArray count]; i++) {
        NSMutableArray *emojiExCategoryArray = [NSMutableArray array];
        NSMutableDictionary *emojiExDataDic = [NSMutableDictionary dictionary];
        
        NSDictionary *category = emojiCategoryArray[i];
        NSDictionary *categoryDataDic = category[@"CVCategoryData"];
        NSString *dataString = categoryDataDic[@"Data"];
        NSArray *emojis = [dataString componentsSeparatedByString:@","];
        
        
        for (int j = 0; j < [emojis count]; j++) {
            NSString *currEmoji = emojis[j];
            
            NSMutableDictionary *mutDic = [NSMutableDictionary dictionary];
            mutDic[@"symbol"] = currEmoji;
            mutDic[@"imageName"] = [NSString stringWithFormat:@"emoji91_%i_%i_1.png", i, j];
            [emojiExCategoryArray addObject:mutDic];
            
            if ([self isHasEmoji:currEmoji inEmojis:hasSkinEmojiArray]) {
                NSMutableArray *subEmojiArray = [NSMutableArray array];
                for (int k = 0; k < 6; k++) {
                    NSMutableDictionary *mutSubDic = [NSMutableDictionary dictionary];
                    mutSubDic[@"symbol"] = [NSString stringWithFormat:@"%@%@", currEmoji, skinsTemp[k]];
                    mutSubDic[@"imageName"] = [NSString stringWithFormat:@"emoji91_%i_%i_%i.png", i, j, k];
                    [subEmojiArray addObject:mutSubDic];

                    [tmpString appendFormat:@"%@-----%@\n", mutSubDic[@"symbol"], @[mutSubDic[@"symbol"]]];

                    NSString *imagePath = [NSString stringWithFormat:@"%@%@", _compressedImagePath, mutSubDic[@"imageName"]];
                    NSData *data = [NSData dataWithContentsOfFile:imagePath];
                    [emojiExData appendData:data];
                    
                    NSMutableDictionary *mutDataDic = [NSMutableDictionary dictionary];
                    mutDataDic[@"length"] = @(data.length);
                    mutDataDic[@"offset"] = @(offset);
                    emojiExDataDic[mutSubDic[@"imageName"]] = mutDataDic;
                    offset += data.length;
                }
                mutDic[@"subemojis"] = subEmojiArray;
            } else {
                NSString *imagePath = [NSString stringWithFormat:@"%@%@", _compressedImagePath, mutDic[@"imageName"]];
                NSData *data = [NSData dataWithContentsOfFile:imagePath];
                [emojiExData appendData:data];
                
                NSMutableDictionary *mutDataDic = [NSMutableDictionary dictionary];
                mutDataDic[@"length"] = @(data.length);
                mutDataDic[@"offset"] = @(offset);
                emojiExDataDic[mutDic[@"imageName"]] = mutDataDic;
                offset += data.length;

                [tmpString appendFormat:@"%@-----%@\n", currEmoji, @[currEmoji]];
            }

        }
        [emojiExDataPlistArray addObject:emojiExDataDic];
        [emojiExPlistArray addObject:@{@"emojis": emojiExCategoryArray}];
    }
    
    NSString *plistPath = [NSHomeDirectory() stringByAppendingString:[NSString stringWithFormat:@"/Documents/emojis91.plist"]];
    [emojiExPlistArray writeToFile:plistPath atomically:true];
    plistPath = [NSHomeDirectory() stringByAppendingString:[NSString stringWithFormat:@"/Documents/emojis91data.plist"]];
    [emojiExDataPlistArray writeToFile:plistPath atomically:true];
    
    NSString *dataPath = [NSHomeDirectory() stringByAppendingString:[NSString stringWithFormat:@"/Documents/emojis91.data"]];
    [emojiExData writeToFile:dataPath atomically:true];
    
//    NSLog(@"%@", tmpString);
}


- (NSArray<EmojiModel *> *)getAllEmojiInPlistFile {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"emojis91" ofType:@"plist"];
    NSArray *emojisArray = [NSArray arrayWithContentsOfFile:path];
    path = [[NSBundle mainBundle] pathForResource:@"emojis91data" ofType:@"plist"];
    NSArray *emojisDataArray = [NSArray arrayWithContentsOfFile:path];
    
    NSMutableArray *tmpArray = [NSMutableArray array];
    
    for (int i = 0; i < emojisArray.count; i++) {
        NSArray *emojisInfoArray = emojisArray[i][@"emojis"];
        NSDictionary *emojisDataInfo = emojisDataArray[i];
        
        for (int k = 0; k < emojisInfoArray.count; k++) {
            NSDictionary *emojiInfo = emojisInfoArray[k];
            NSDictionary *emojiDataInfoDic = emojisDataInfo[emojiInfo[@"imageName"]];
            EmojiModel *emojiModel = [[EmojiModel alloc]init];
            emojiModel.symbol = emojiInfo[@"symbol"];
            emojiModel.imageName = emojiInfo[@"imageName"];
            emojiModel.fileLength = [emojiDataInfoDic[@"length"] integerValue];
            emojiModel.offset = [emojiDataInfoDic[@"offset"] integerValue];
            
            [tmpArray addObject:emojiModel];
            
            
            NSArray *subEmojis = emojiInfo[@"subemojis"];
            for (int j = 0; j < subEmojis.count; j++) {
                NSDictionary *subemojiInfo = subEmojis[j];
                NSDictionary *subemojiDataInfoDic = emojisDataInfo[subemojiInfo[@"imageName"]];
                EmojiModel *subemojiModel = [[EmojiModel alloc]init];
                subemojiModel.symbol = subemojiInfo[@"symbol"];
                subemojiModel.imageName = subemojiInfo[@"imageName"];
                subemojiModel.fileLength = [subemojiDataInfoDic[@"length"] integerValue];
                subemojiModel.offset = [subemojiDataInfoDic[@"offset"] integerValue];
                
                [tmpArray addObject:subemojiModel];
            }
        }
    }
    
    return tmpArray;
}


- (NSArray *)getAllEmojiInJsonFile {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Category-Emoji" ofType:@"json"];
    NSData *jsonData = [[NSData alloc]initWithContentsOfFile:path];
    NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
    NSArray *emojiCategoryArray = jsonDic[@"EmojiDataArray"];
    NSArray *skinsTemp = @[@"🏻",@"",@"🏼",@"🏽",@"🏾",@"🏿"];
    
    NSMutableArray *emojiExPlistArray = [NSMutableArray array];
    
    int offset = 0;
    
    for (int i = 0; i < [emojiCategoryArray count]; i++) {
        
        NSDictionary *category = emojiCategoryArray[i];
        NSDictionary *categoryDataDic = category[@"CVCategoryData"];
        NSString *dataString = categoryDataDic[@"Data"];
        NSArray *emojis = [dataString componentsSeparatedByString:@","];
        NSArray *hasSkinEmojiArray = [self getHasDifferentSkinsEmojiList];
        
        for (int j = 0; j < [emojis count]; j++) {
            NSString *currEmoji = emojis[j];
            
            if ([self isHasEmoji:currEmoji inEmojis:hasSkinEmojiArray]) {
                for (int k = 0; k < 6; k++) {
                    NSString *imageName = [NSString stringWithFormat:@"emoji91_%i_%i_%i.png", i, j, k];
                    NSString *imagePath = [NSString stringWithFormat:@"%@%@", _compressedImagePath, imageName];
                    NSData *data = [NSData dataWithContentsOfFile:imagePath];
                    
                    EmojiModel *subEmojiModel = [[EmojiModel alloc]init];
                    subEmojiModel.symbol = [NSString stringWithFormat:@"%@%@", currEmoji, skinsTemp[k]];
                    subEmojiModel.imageName = imageName;
                    subEmojiModel.fileLength = data.length;
                    subEmojiModel.offset = offset;
                    
                    offset += data.length;
                    
                    [emojiExPlistArray addObject:subEmojiModel];
                }

            } else {
                
                NSString *imageName = [NSString stringWithFormat:@"emoji91_%i_%i_0.png", i, j];
                NSString *imagePath = [NSString stringWithFormat:@"%@%@", _compressedImagePath, imageName];
                NSData *data = [NSData dataWithContentsOfFile:imagePath];
                
                EmojiModel *emojiModel = [[EmojiModel alloc]init];
                emojiModel.symbol = currEmoji;
                emojiModel.imageName = [NSString stringWithFormat:@"emoji91_%i_%i_0.png", i, j];
                emojiModel.fileLength = data.length;
                emojiModel.offset = offset;
                
                offset += data.length;
                
                [emojiExPlistArray addObject:emojiModel];
            }
            
        }
    }
    
    return emojiExPlistArray;
}

- (NSArray *)getAllEmojiInSimulator {
    NSMutableArray *emojiArray = [NSMutableArray array];

    Class UIKeyboardEmojiCategory = NSClassFromString(@"UIKeyboardEmojiCategory");
    NSMutableArray *categories = [NSMutableArray array];
    // UIKeyboardEmojiCategory has a +categories method, but it does not fill emoji. Calling categoryForType: does fill emoji
    if ([UIKeyboardEmojiCategory respondsToSelector:@selector(numberOfCategories)])
    {
        NSInteger numberOfCategories = [UIKeyboardEmojiCategory numberOfCategories];
        for (NSUInteger i = 0; i < numberOfCategories; i++)
            [categories addObject:[UIKeyboardEmojiCategory categoryForType:i]];
    }
    
    for (id /* UIKeyboardEmojiCategory */ category in categories)
    {
        NSString *categoryName = [category performSelector:@selector(name)];
        if ([categoryName hasSuffix:@"Recent"])
            continue;
        
        NSString *displayName = [category respondsToSelector:@selector(displayName)] ? [category performSelector:@selector(displayName)] : categoryName;
        if ([displayName hasPrefix:@"UIKeyboardEmojiCategory"])
            displayName = [displayName substringFromIndex:23];
        
        id emojis = [category valueForKey:@"emoji"];
        if ([emojis count] > 0 ) {
//            NSLog(@"--------%@-------", displayName);
        }
        NSArray *skinsTemp = @[@"🏻",@"",@"🏼",@"🏽",@"🏾",@"🏿"];

        NSMutableString *mutableString = [[NSMutableString alloc] init];
        
        for (id /* UIKeyboardEmoji */ emoji in [category valueForKey:@"emoji"])
        {
            NSNumber *mask = [emoji valueForKey:@"variantMask"];
            id emojiString = (NSString *)[emoji valueForKey:@"emojiString"];
            if ([mask integerValue] > 1 ) {
                for (int i = 0; i < 6; i++) {
                    [mutableString appendFormat:@"%@%@, ",emojiString, skinsTemp[i]];
                    [emojiArray addObject:[NSString stringWithFormat:@"%@%@", emojiString, skinsTemp[i]]];
                }
            } else {
                [mutableString appendFormat:@"%@, ",emojiString];
                [emojiArray addObject:emojiString];
            }
        }

        NSLog(@"%@: \n%@", displayName, mutableString);
    }

    return emojiArray;
}

- (NSArray *) getHasDifferentSkinsEmojiList {
    NSMutableArray *hasSkinEmojiArray = [NSMutableArray array];
    
    Class UIKeyboardEmojiCategory = NSClassFromString(@"UIKeyboardEmojiCategory");
    NSMutableArray *categories = [NSMutableArray array];
    // UIKeyboardEmojiCategory has a +categories method, but it does not fill emoji. Calling categoryForType: does fill emoji
    if ([UIKeyboardEmojiCategory respondsToSelector:@selector(numberOfCategories)])
    {
        NSInteger numberOfCategories = [UIKeyboardEmojiCategory numberOfCategories];
        for (NSUInteger i = 0; i < numberOfCategories; i++)
            [categories addObject:[UIKeyboardEmojiCategory categoryForType:i]];
    }
    
    for (id /* UIKeyboardEmojiCategory */ category in categories)
    {
        for (id /* UIKeyboardEmoji */ emoji in [category valueForKey:@"emoji"])
        {
            NSNumber *mask = [emoji valueForKey:@"variantMask"];
            id emojiString = (NSString *)[emoji valueForKey:@"emojiString"];

            if ([mask integerValue] == 2) {
                [hasSkinEmojiArray addObject:emojiString];
            }
            if ([mask integerValue] == 6) {
                [hasSkinEmojiArray addObject:emojiString];
            }
            if ([mask integerValue] == 3) {
                [hasSkinEmojiArray addObject:emojiString];
            }
        }
    }

    [hasSkinEmojiArray addObject:@"🕵️"];
    [hasSkinEmojiArray addObject:@"🏋️"];
    [hasSkinEmojiArray addObject:@"⛹️"];
    [hasSkinEmojiArray addObject:@"🏊"];
    [hasSkinEmojiArray addObject:@"🏄🏼"];
    [hasSkinEmojiArray addObject:@"🚣"];
    [hasSkinEmojiArray addObject:@"☝️"];
    [hasSkinEmojiArray addObject:@"✌️"];
    [hasSkinEmojiArray addObject:@"✍️"];
    return hasSkinEmojiArray;
}

- (BOOL)isHasEmoji: (NSString *)emoji inEmojis:(NSArray *)emojis {
    for (int i = 0; i < emojis.count; i++) {
        NSString *tmpEmoji = emojis[i];
        if ([emoji isEqualToString:tmpEmoji]) {
            return true;
        }
    }
    return false;
}


- (BOOL)isHasEmoji: (NSString *)emoji inEmojisModel:(NSArray *)emojisModel {
    for (int i = 0; i < emojisModel.count; i++) {
        EmojiModel *tmpEmoji = emojisModel[i];
        NSString *tmpUnicodeEmoji = [NSString stringWithFormat:@"%@", @[tmpEmoji.symbol]];
        NSString *unicodeEmoji = [NSString stringWithFormat:@"%@", @[emoji]];
        if ([emoji isEqualToString:tmpEmoji.symbol]) {
            return true;
        } else if ([tmpUnicodeEmoji containsString:unicodeEmoji]) {
            NSLog(@"contains emoji is%@", emoji);
        }
    }
    return false;
}

- (EmojiModel *)getEmojiModelWithSymbol: (NSString *)symbol inEmojisModel: (NSArray *)emojisModel {
    for (int i = 0; i < emojisModel.count; i++) {
        EmojiModel *tmpEmoji = emojisModel[i];
        if ([symbol isEqualToString:tmpEmoji.symbol]) {
            return tmpEmoji;
        }
    }
    return nil;
}

- (UIImage *)imageWithView: (UILabel *)label {
    UIGraphicsBeginImageContext(label.bounds.size);
    [[label layer] renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (UIImage *)toImage: (NSString *)emoji {
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectZero];
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = [UIColor clearColor];
    label.text = emoji;
    UIFont *font = [UIFont fontWithName:@"AppleColorEmoji" size:90.0];
    label.font = font;
    [label sizeToFit];
//    CGSize needSize = [label sizeThatFits:CGSizeMake(1000, 1000)];
//    CGFloat height = [self heightStringWithEmojis:emoji fontType:font ForWidth:needSize.width];
//    label.frame = CGRectMake(0, 0, needSize.width, height);

    return [self imageWithView:label];
}

- (CGFloat)heightStringWithEmojis:(NSString*)str fontType:(UIFont *)uiFont ForWidth:(CGFloat)width {

    // Get text
    CFMutableAttributedStringRef attrString = CFAttributedStringCreateMutable(kCFAllocatorDefault, 0);
    CFAttributedStringReplaceString (attrString, CFRangeMake(0, 0), (CFStringRef) str );
    CFIndex stringLength = CFStringGetLength((CFStringRef) attrString);

    // Change font
    CTFontRef ctFont = CTFontCreateWithName((__bridge CFStringRef) uiFont.fontName, uiFont.pointSize, NULL);
    CFAttributedStringSetAttribute(attrString, CFRangeMake(0, stringLength), kCTFontAttributeName, ctFont);

    // Calc the size
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString(attrString);
    CFRange fitRange;
    CGSize frameSize = CTFramesetterSuggestFrameSizeWithConstraints(framesetter, CFRangeMake(0, 0), NULL, CGSizeMake(width, CGFLOAT_MAX), &fitRange);

    CFRelease(ctFont);
    CFRelease(framesetter);
    CFRelease(attrString);
    
    return frameSize.height + 10;
    
}

- (NSData *)updateOldPlistFileWithAppendingData: (NSData *)data {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"emojisexdata" ofType:@"plist"];
    NSMutableArray *emojisDataPlist = [NSMutableArray arrayWithContentsOfFile:path];
    
    NSMutableData *tmpData = [NSMutableData dataWithData:data];
    NSArray<EmojiModel *> *allEmojis = [self getAllEmojiInPlistFile];
    int count = 0;
    
    for (int i = 0; i < emojisDataPlist.count; i++) {
        NSMutableDictionary *emojiInfo = emojisDataPlist[i];
        NSArray *allImageNameArray = [emojiInfo allKeys];
        
        for (int j = 0; j < allImageNameArray.count; j++) {
            NSString *key = allImageNameArray[j];
            NSMutableDictionary *dic = emojiInfo[key];
            if (dic != nil && [dic isKindOfClass:[NSDictionary class]]) {
                count++;

                NSString *symbol = [self getSymbolWithImageName:key];

                if ([self isHasEmoji:symbol inEmojisModel:allEmojis]) {
                    EmojiModel *model = [self getEmojiModelWithSymbol:symbol inEmojisModel:allEmojis];
                    dic[@"offset"] = @(model.offset);
                    dic[@"length"] = @(model.fileLength);
                } else {
                    NSData *imageData = [NSData dataWithContentsOfFile:[NSString stringWithFormat:@"%@%@", _compressedImagePath, key]];
                    dic[@"offset"] = @(tmpData.length);
                    dic[@"length"] = @(imageData.length);
                    [tmpData appendData:imageData];
                    count++;
                }
            }
        }
        
        [emojiInfo removeObjectForKey:@"offset"];
    }
    
    path = [NSHomeDirectory() stringByAppendingString:[NSString stringWithFormat:@"/Documents/emojisexdata.plist"]];
    [emojisDataPlist writeToFile:path atomically:true];
    NSLog(@"all count is%i", count);
    return tmpData;
}

- (void)updateNewEmoji: (NSArray *)newEmojis iniOS10WithUpdateData: (NSData *)updatingData {
    NSArray<EmojiModel *> *oldAllEmojis = [self getAllEmojiInPlistFile];

    NSString *path = [[NSBundle mainBundle] pathForResource:@"Category-Emoji" ofType:@"json"];
    NSData *jsonData = [[NSData alloc]initWithContentsOfFile:path];
    NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
    NSArray *emojiCategoryArray = jsonDic[@"EmojiDataArray"];
    NSArray *skinsTemp = @[@"🏻",@"",@"🏼",@"🏽",@"🏾",@"🏿"];
    NSArray *hasSkinEmojiArray = [self getHasDifferentSkinsEmojiList];

    NSMutableArray *emojiExPlistArray = [NSMutableArray array];
    NSMutableArray *emojiExDataPlistArray = [NSMutableArray array];
    NSMutableData  *emojiExData = [NSMutableData dataWithData:updatingData];
    long offset = emojiExData.length;
    int appendCount = 0;

    for (int i = 0; i < [emojiCategoryArray count]; i++) {
        NSMutableArray *emojiExCategoryArray = [NSMutableArray array];
        NSMutableDictionary *emojiExDataDic = [NSMutableDictionary dictionary];

        NSDictionary *category = emojiCategoryArray[i];
        NSDictionary *categoryDataDic = category[@"CVCategoryData"];
        NSString *dataString = categoryDataDic[@"Data"];
        NSArray *emojis = [dataString componentsSeparatedByString:@","];

        for (int j = 0; j < [emojis count]; j++) {
            NSString *currEmoji = emojis[j];

            NSMutableDictionary *mutDic = [NSMutableDictionary dictionary];
            mutDic[@"symbol"] = currEmoji;

            if (![self isHasEmoji:currEmoji inEmojis:newEmojis]) {
                EmojiModel *oldModel = [self getEmojiModelWithSymbol:currEmoji inEmojisModel:oldAllEmojis];
                mutDic[@"imageName"] = oldModel.imageName;
            } else {
                mutDic[@"imageName"] = [NSString stringWithFormat:@"emoji10_%i_%i_1.png", i, j];
            }
            [emojiExCategoryArray addObject:mutDic];


            if ([self isHasEmoji:currEmoji inEmojis:newEmojis]) {
                if ([self isHasEmoji:currEmoji inEmojis:hasSkinEmojiArray]) {
                    NSMutableArray *subEmojiArray = [NSMutableArray array];

                    NSArray *skinArray = [_test[currEmoji] componentsSeparatedByString:@","];
                    if (skinArray.count > 0) {
                        for (int k = 0; k < 6; k++) {
                            NSMutableDictionary *mutSubDic = [NSMutableDictionary dictionary];
                            mutSubDic[@"symbol"] = skinArray[k];
                            mutSubDic[@"imageName"] = [NSString stringWithFormat:@"emoji10_%i_%i_%i.png", i, j, k];
                            [subEmojiArray addObject:mutSubDic];

                            NSData *data = [NSData dataWithContentsOfFile:[NSString stringWithFormat:@"%@%@", _compressedImagePath, mutSubDic[@"imageName"]]];
                            [emojiExData appendData:data];
                            NSLog(@"append the %i emoji %@, length is : %@", appendCount++, mutSubDic[@"symbol"], @(data.length));

                            NSMutableDictionary *mutDataDic = [NSMutableDictionary dictionary];
                            mutDataDic[@"length"] = @(data.length);
                            mutDataDic[@"offset"] = @(offset);
                            emojiExDataDic[mutSubDic[@"imageName"]] = mutDataDic;
                            offset += data.length;
                        }
                    } else {
                        for (int k = 0; k < 6; k++) {
                            NSMutableDictionary *mutSubDic = [NSMutableDictionary dictionary];
                            mutSubDic[@"symbol"] = [NSString stringWithFormat:@"%@%@", currEmoji, skinsTemp[k]];
                            mutSubDic[@"imageName"] = [NSString stringWithFormat:@"emoji10_%i_%i_%i.png", i, j, k];
                            [subEmojiArray addObject:mutSubDic];

                            NSData *data = [NSData dataWithContentsOfFile:[NSString stringWithFormat:@"%@%@", _compressedImagePath, mutSubDic[@"imageName"]]];
                            [emojiExData appendData:data];
                            NSLog(@"append the %i emoji %@, length is : %@", appendCount++, mutSubDic[@"symbol"], @(data.length));

                            NSMutableDictionary *mutDataDic = [NSMutableDictionary dictionary];
                            mutDataDic[@"length"] = @(data.length);
                            mutDataDic[@"offset"] = @(offset);
                            emojiExDataDic[mutSubDic[@"imageName"]] = mutDataDic;
                            offset += data.length;
                        }
                    }


                    mutDic[@"subemojis"] = subEmojiArray;
                } else {
                    NSData *data = [NSData dataWithContentsOfFile:[NSString stringWithFormat:@"%@%@", _compressedImagePath, mutDic[@"imageName"]]];
                    [emojiExData appendData:data];
                    NSLog(@"append the %i emoji %@, length is : %@", appendCount++, currEmoji, @(data.length));

                    NSMutableDictionary *mutDataDic = [NSMutableDictionary dictionary];
                    mutDataDic[@"length"] = @(data.length);
                    mutDataDic[@"offset"] = @(offset);
                    emojiExDataDic[mutDic[@"imageName"]] = mutDataDic;
                    offset += data.length;
                }
            } else { // 没变的Emoji
                EmojiModel *oldModel = [self getEmojiModelWithSymbol:currEmoji inEmojisModel:oldAllEmojis];
                if ([self isHasEmoji:currEmoji inEmojis:hasSkinEmojiArray]) {
                    NSMutableArray *subEmojiArray = [NSMutableArray array];
                    for (int k = 0; k < 6; k++) {
                        NSString *subSymbol = [NSString stringWithFormat:@"%@%@", currEmoji, skinsTemp[k]];
                        EmojiModel *subOldModel = [self getEmojiModelWithSymbol:subSymbol inEmojisModel:oldAllEmojis];

                        NSMutableDictionary *mutSubDic = [NSMutableDictionary dictionary];
                        mutSubDic[@"symbol"] = subSymbol;
                        mutSubDic[@"imageName"] = subOldModel.imageName;
                        [subEmojiArray addObject:mutSubDic];

                        NSMutableDictionary *mutDataDic = [NSMutableDictionary dictionary];
                        mutDataDic[@"length"] = @(subOldModel.fileLength);
                        mutDataDic[@"offset"] = @(subOldModel.offset);
                        emojiExDataDic[mutSubDic[@"imageName"]] = mutDataDic;
                    }
                    mutDic[@"subemojis"] = subEmojiArray;
                } else {
                    NSMutableDictionary *mutDataDic = [NSMutableDictionary dictionary];
                    mutDataDic[@"length"] = @(oldModel.fileLength);
                    mutDataDic[@"offset"] = @(oldModel.offset);
                    emojiExDataDic[mutDic[@"imageName"]] = mutDataDic;
                }
            }




        }
        [emojiExDataPlistArray addObject:emojiExDataDic];
        [emojiExPlistArray addObject:@{@"emojis": emojiExCategoryArray}];
    }

    NSString *plistPath = [NSHomeDirectory() stringByAppendingString:[NSString stringWithFormat:@"/Documents/emojis10.plist"]];
    [emojiExPlistArray writeToFile:plistPath atomically:true];
    plistPath = [NSHomeDirectory() stringByAppendingString:[NSString stringWithFormat:@"/Documents/emojis10data.plist"]];
    [emojiExDataPlistArray writeToFile:plistPath atomically:true];

    NSString *dataPath = [NSHomeDirectory() stringByAppendingString:[NSString stringWithFormat:@"/Documents/emojisex.data"]];
    [emojiExData writeToFile:dataPath atomically:true];
}

- (void)exportOldEmojiImageBefore8_3 {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"emojisdata" ofType:@"plist"];
    NSMutableArray *emojisDataPlist = [NSMutableArray arrayWithContentsOfFile:path];
    path = [[NSBundle mainBundle] pathForResource:@"emojis" ofType:@"data"];
    NSFileHandle *fileHandle = [NSFileHandle fileHandleForReadingAtPath:path];
    
    for (int i = 0; i < emojisDataPlist.count; i++) {
        NSMutableDictionary *emojiInfo = emojisDataPlist[i];
        NSNumber *offset = emojiInfo[@"offset"];
        
        NSArray *allImageNameArray = [emojiInfo allKeys];
        
        for (int j = 0; j < allImageNameArray.count; j++) {
            NSString *key = allImageNameArray[j];
            NSMutableDictionary *dic = emojiInfo[key];
            if (dic != nil && [dic isKindOfClass:[NSDictionary class]]) {
                NSNumber *dicOffset = dic[@"offset"];
                
                [fileHandle seekToFileOffset:([offset longLongValue] + [dicOffset longLongValue])];
                NSData *imageData = [fileHandle readDataOfLength:[dic[@"length"] longLongValue]];
                path = [NSHomeDirectory() stringByAppendingString:[NSString stringWithFormat:@"/Documents/oldEmojis_8_1/%@", key]];
                [imageData writeToFile:path atomically:true];
            }
        }
    }
}

- (void)exportOldEmojiImageInDifferent {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"emojisexdata" ofType:@"plist"];
    NSMutableArray *emojisDataPlist = [NSMutableArray arrayWithContentsOfFile:path];
    path = [[NSBundle mainBundle] pathForResource:@"emojisex" ofType:@"data"];
    NSFileHandle *fileHandle = [NSFileHandle fileHandleForReadingAtPath:path];
    
    NSArray<EmojiModel *> *allEmojis = [self getAllEmojiInPlistFile];

    for (int i = 0; i < emojisDataPlist.count; i++) {
        NSMutableDictionary *emojiInfo = emojisDataPlist[i];
        NSNumber *offset = emojiInfo[@"offset"];
        
        NSArray *allImageNameArray = [emojiInfo allKeys];
        
        for (int j = 0; j < allImageNameArray.count; j++) {
            NSString *key = allImageNameArray[j];
            NSMutableDictionary *dic = emojiInfo[key];
            if (dic != nil && [dic isKindOfClass:[NSDictionary class]]) {
                NSNumber *dicOffset = dic[@"offset"];

                NSString *symbol = [self getSymbolWithImageName:key];
                if ([self isHasEmoji:symbol inEmojisModel:allEmojis]) {

                } else {
                    [fileHandle seekToFileOffset:([offset longLongValue] + [dicOffset longLongValue])];
                    NSData *imageData = [fileHandle readDataOfLength:[dic[@"length"] longLongValue]];
                    path = [NSHomeDirectory() stringByAppendingString:[NSString stringWithFormat:@"/Documents/emojis/%@", key]];
                    [imageData writeToFile:path atomically:true];
                }
            }
        }
    }
}


// 导出所有emoji 为 图片
- (void)exportAllEmojiImages {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Category-Emoji" ofType:@"json"];
    NSData *jsonData = [[NSData alloc]initWithContentsOfFile:path];
    NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
    NSArray *emojiCategoryArray = jsonDic[@"EmojiDataArray"];
    NSArray *skinsTemp = @[@"🏻",@"",@"🏼",@"🏽",@"🏾",@"🏿"];
    

    for (int i = 0; i < [emojiCategoryArray count]; i++) {

        NSDictionary *category = emojiCategoryArray[i];
        NSDictionary *categoryDataDic = category[@"CVCategoryData"];
        NSString *dataString = categoryDataDic[@"Data"];
        NSArray *emojis = [dataString componentsSeparatedByString:@","];
        NSArray *hasSkinEmojiArray = [self getHasDifferentSkinsEmojiList];
        
        for (int j = 0; j < [emojis count]; j++) {
            NSString *currEmoji = emojis[j];
            NSString *imageName = [NSString stringWithFormat:@"emoji10_%i_%i_1.png", i, j];

            NSString *emojiPath = [NSHomeDirectory() stringByAppendingString:@"/Documents/emojis/"];
            [[NSFileManager defaultManager] createDirectoryAtPath:emojiPath withIntermediateDirectories:YES attributes:nil error:nil];

            if ([self isHasEmoji:currEmoji inEmojis:hasSkinEmojiArray]) {

                NSArray *skinArray = [_test[currEmoji] componentsSeparatedByString:@","];
                if (skinArray.count > 0) {
                    for (int k = 0; k < 6; k++) {
                        NSString *subSymbol = skinArray[k];
                        NSString *subImageName = [NSString stringWithFormat:@"emoji10_%i_%i_%i.png", i, j, k];
                        NSData *imageData = UIImagePNGRepresentation([self toImage:subSymbol]);

                        path = [NSHomeDirectory() stringByAppendingString:[NSString stringWithFormat:@"/Documents/emojis/%@", subImageName]];
                        [imageData writeToFile:path atomically:true];
                    }
                } else {
                    for (int k = 0; k < 6; k++) {
                        NSString *subSymbol = [NSString stringWithFormat:@"%@%@", currEmoji, skinsTemp[k]];
                        NSString *subImageName = [NSString stringWithFormat:@"emoji10_%i_%i_%i.png", i, j, k];
                        NSData *imageData = UIImagePNGRepresentation([self toImage:subSymbol]);

                        path = [NSHomeDirectory() stringByAppendingString:[NSString stringWithFormat:@"/Documents/emojis/%@", subImageName]];
                        [imageData writeToFile:path atomically:true];
                    }
                }

            } else {
                NSData *imageData = UIImagePNGRepresentation([self toImage:currEmoji]);
                
                path = [NSHomeDirectory() stringByAppendingString:[NSString stringWithFormat:@"/Documents/emojis/%@", imageName]];
                [imageData writeToFile:path atomically:true];
            }
            
        }
    }
}


- (NSString *)getSymbolWithImageName:(NSString *)imageName {
    NSString *path2 = [[NSBundle mainBundle] pathForResource:@"emojisex" ofType:@"plist"];
    NSArray *emojisPlist = [NSArray arrayWithContentsOfFile:path2];
    for (int i = 0; i < emojisPlist.count; i++) {
        NSDictionary *emojiDic = emojisPlist[i];
        NSArray *emojis = emojiDic[@"emojis"];
        
        for (int j = 0; j < emojis.count; j++) {
            NSDictionary *dic = emojis[j];
            NSString *name = dic[@"imageName"];
            if ([name isEqualToString:imageName]) {
                return dic[@"symbol"];
            }
            
            NSArray *subEmojis = dic[@"subemojis"];
            for (int k = 0; k < subEmojis.count; k++) {
                NSDictionary *subDic = subEmojis[k];
                NSString *subName = subDic[@"imageName"];
                if ([subName isEqualToString:imageName]) {
                    return subDic[@"symbol"];
                }
            }
        }
    }
    return @"";
}


// 导出系统新添加的emoji
- (NSArray *)exportNewEmojisListInJsonPath: (NSString *)jsonPath fromEmojiListPath: (NSString *)emojisPlistFilePath {
    NSArray *oldEmojis = [self getAllEmojiInPlistFile: emojisPlistFilePath];
    NSData *jsonData = [[NSData alloc]initWithContentsOfFile:jsonPath];
    NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
    NSArray *emojiCategoryArray = jsonDic[@"EmojiDataArray"];
    
    NSMutableArray *result = [NSMutableArray array];
    NSMutableString *newEmojis = [NSMutableString string];

    for (int i = 0; i < [emojiCategoryArray count]; i++) {
        
        NSDictionary *category = emojiCategoryArray[i];
        NSDictionary *categoryDataDic = category[@"CVCategoryData"];
        NSString *dataString = categoryDataDic[@"Data"];
        NSArray *emojis = [dataString componentsSeparatedByString:@","];
        
        for (int j = 0; j < [emojis count]; j++) {
            NSString *currEmoji = emojis[j];
            if (![self isHasEmoji:currEmoji inEmojisModel:oldEmojis]) {
                [newEmojis appendFormat:@"%@,", currEmoji];
                [result addObject:currEmoji];
            }
        }
    }

    NSLog(@"new emojis is %@", newEmojis);
    return result;
}


- (NSArray<EmojiModel *> *)getAllEmojiInPlistFile: (NSString *)filePath {
    NSArray *emojisArray = [NSArray arrayWithContentsOfFile:filePath];
    
    NSMutableArray *tmpArray = [NSMutableArray array];
    
    for (int i = 0; i < emojisArray.count; i++) {
        NSArray *emojisInfoArray = emojisArray[i][@"emojis"];
        
        for (int k = 0; k < emojisInfoArray.count; k++) {
            NSDictionary *emojiInfo = emojisInfoArray[k];
            EmojiModel *emojiModel = [[EmojiModel alloc]init];
            emojiModel.symbol = emojiInfo[@"symbol"];
            emojiModel.imageName = emojiInfo[@"imageName"];

            
            [tmpArray addObject:emojiModel];
            
            
            NSArray *subEmojis = emojiInfo[@"subemojis"];
            for (int j = 0; j < subEmojis.count; j++) {
                NSDictionary *subemojiInfo = subEmojis[j];
                EmojiModel *subemojiModel = [[EmojiModel alloc]init];
                subemojiModel.symbol = subemojiInfo[@"symbol"];
                subemojiModel.imageName = subemojiInfo[@"imageName"];
                
                [tmpArray addObject:subemojiModel];
            }
        }
    }
    
    return tmpArray;
}

- (void)exportAllEmojiToPlist {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Category-Emoji" ofType:@"json"];
    NSData *jsonData = [[NSData alloc]initWithContentsOfFile:path];
    NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
    NSArray *emojiCategoryArray = jsonDic[@"EmojiDataArray"];
    NSArray *skinsTemp = @[@"🏻",@"",@"🏼",@"🏽",@"🏾",@"🏿"];
    
    NSMutableArray *emojiExPlistArray = [NSMutableArray array];
    
    for (int i = 0; i < [emojiCategoryArray count]; i++) {
        
        NSDictionary *category = emojiCategoryArray[i];
        NSDictionary *categoryDataDic = category[@"CVCategoryData"];
        NSString *dataString = categoryDataDic[@"Data"];
        NSArray *emojis = [dataString componentsSeparatedByString:@","];
        NSArray *hasSkinEmojiArray = [self getHasDifferentSkinsEmojiList];
        
        for (int j = 0; j < [emojis count]; j++) {
            NSString *currEmoji = emojis[j];
            
            if ([self isHasEmoji:currEmoji inEmojis:hasSkinEmojiArray]) {
                for (int k = 0; k < 6; k++) {
                    NSMutableDictionary *subEmojiDic = [NSMutableDictionary dictionary];
                    NSString *symbol = [NSString stringWithFormat:@"%@%@", currEmoji, skinsTemp[k]];
                    subEmojiDic[@"symbol"] = symbol;
                    subEmojiDic[@"unicode"] = [NSString stringWithFormat:@"%@", @[symbol]];
                    NSLog(@"%@ ------------> %@", symbol, @[symbol]);
                    [emojiExPlistArray addObject:subEmojiDic];
                }
                
            } else {

                NSMutableDictionary *emojiDic = [NSMutableDictionary dictionary];
                emojiDic[@"symbol"] = currEmoji;
//                emojiDic[@"unicode"] = [NSString stringWithFormat:@"%@", @[currEmoji]];

                NSLog(@"%@ ------> %@", currEmoji, @[currEmoji]);
                [emojiExPlistArray addObject:emojiDic];
            }
        }
    }
    
//    NSLog(@"%@", emojiExPlistArray);
}

// 导出特定Emoji 的图片

- (void)exportEmojiImage:(NSArray *)targetEmojis {
    
    
    for (int i = 0; i < targetEmojis.count; i++) {
        NSString *emoji = targetEmojis[i];
        NSData *imageData = UIImagePNGRepresentation([self toImage:emoji]);
        NSString *imageName = [NSString stringWithFormat:@"%i.png", i];
        NSString *path = [NSHomeDirectory() stringByAppendingString:[NSString stringWithFormat:@"/Documents/%@", imageName]];
        [imageData writeToFile:path atomically:true];
    }
    
    NSLog(@"Save To %@", NSHomeDirectory());
}


- (NSDictionary *)findEmojiDataInfoIn:(NSArray *)emojisDataPlist byImageName:(NSString *)imageName {
    for (int i = 0; i < emojisDataPlist.count; i++) {
        NSMutableDictionary *emojiInfo = emojisDataPlist[i];
        NSArray *allImageNameArray = [emojiInfo allKeys];

        for (int j = 0; j < allImageNameArray.count; j++) {
            NSString *key = allImageNameArray[j];
            NSMutableDictionary *dic = emojiInfo[key];

            if ([key isEqualToString:imageName]) {
                return dic;
            }
        }
    }

    return nil;
}

- (NSString *)findEmojiImageNameIn:(NSArray *)emojisPlist byEmojiSymbol:(NSString *)symbol {
    for (int i = 0; i < emojisPlist.count; i++) {
        NSDictionary *emojisInfo = emojisPlist[i];
        NSArray *emojisArray = emojisInfo[@"emojis"];

        for (int j = 0; j < emojisArray.count; j++) {
            NSDictionary *dic = emojisArray[j];
            NSArray *subEmojis = dic[@"subemojis"];
            NSString *currSymbol = dic[@"symbol"];

            if (subEmojis.count > 0) {
                for (int j = 0; j < subEmojis.count; j++) {
                    NSString *subSymbol = subEmojis[j][@"symbol"];
                    if ([symbol isEqualToString:subSymbol]) {
                        return subEmojis[j][@"imageName"];
                    }
                }
            } else if ([symbol isEqualToString:currSymbol]) {
                return dic[@"imageName"];
            }
        }
    }

    return nil;
}

- (void)exportImageFromDataPath:(NSString *)dataPath byDataPlist:(NSString *)dataPlistPath byEmojiPlist:(NSString *)emojiPlistPath saveTo:(NSString *)savePath {
    NSMutableArray *emojisDataPlist = [NSMutableArray arrayWithContentsOfFile:dataPlistPath];
    NSArray *emojisPlist = [NSArray arrayWithContentsOfFile:emojiPlistPath];
    NSFileHandle *dataHandle = [NSFileHandle fileHandleForReadingAtPath:dataPath];

    NSMutableData *mutData = [NSMutableData data];
    for (int i = 0; i < emojisPlist.count; i++) {
        NSDictionary *emojisInfo = emojisPlist[i];
        NSArray *emojisArray = emojisInfo[@"emojis"];

        for (int j = 0; j < emojisArray.count; j++) {
            NSDictionary *dic = emojisArray[j];
            NSArray *subEmojis = dic[@"subemojis"];
            NSString *imageName = dic[@"imageName"];


            if (subEmojis.count > 0) {
                for (int j = 0; j < subEmojis.count; j++) {

                    NSDictionary *subDataInfo = [self findEmojiDataInfoIn:emojisDataPlist byImageName:subEmojis[j][@"imageName"]];
                    long long offset = [subDataInfo[@"offset"] longLongValue];
                    NSUInteger length = [subDataInfo[@"length"] unsignedIntegerValue];
                    [dataHandle seekToFileOffset:offset];
                    NSData *imageData = [dataHandle readDataOfLength:length];

                    NSString *subSymbol = subEmojis[j][@"symbol"];
                    [[NSFileManager defaultManager] createDirectoryAtPath:savePath withIntermediateDirectories:YES attributes:nil error:nil];
                    NSString *imageName = [NSString stringWithFormat:@"%@_%i.png", subSymbol, j];
                    NSString *imagePath = [savePath stringByAppendingString:imageName];
                    [imageData writeToFile:imagePath atomically:true];
                    if (imageData.length == 0) {
                        NSLog(@"export image for symbol %@ fail !!!" , subSymbol);
                    }
                }
            } else {
                NSDictionary *currEmojiDataInfo = [self findEmojiDataInfoIn:emojisDataPlist byImageName:imageName];
                long long offset = [currEmojiDataInfo[@"offset"] longLongValue];
                NSUInteger length = [currEmojiDataInfo[@"length"] unsignedIntegerValue];
                [dataHandle seekToFileOffset:offset];
                NSData *imageData = [dataHandle readDataOfLength:length];

                NSString *currSymbol = dic[@"symbol"];
                [[NSFileManager defaultManager] createDirectoryAtPath:savePath withIntermediateDirectories:YES attributes:nil error:nil];
                NSString *imageName = [NSString stringWithFormat:@"%@_%i.png", currSymbol, 1];
                NSString *imagePath = [savePath stringByAppendingString:imageName];
                [imageData writeToFile:imagePath atomically:true];
                if (imageData.length == 0) {
                    NSLog(@"export image for symbol %@ fail !!!" , currSymbol);
                }
            }
        }
    }

    NSString *outputhPath = [NSHomeDirectory() stringByAppendingString:@"/Documents/UpdatedPlist/"];
    [[NSFileManager defaultManager] createDirectoryAtPath:outputhPath withIntermediateDirectories:YES attributes:nil error:nil];

    NSString *dataPlistFileName = [[NSURL URLWithString:dataPlistPath] lastPathComponent];
    NSString *path = [outputhPath stringByAppendingString:dataPlistFileName];
    [emojisDataPlist writeToFile:path atomically:true];

    path = [outputhPath stringByAppendingString:[NSString stringWithFormat:@"%@.data", dataPlistFileName]];
    [mutData writeToFile:path atomically:true];

    NSLog(@"finished export ...");
}

- (void)updateDataPlist: (NSString *)dataPlistPath byImagePath:(NSString *)imagePath withEmojiPlist: (NSString *)emojiPlistPath {
    NSMutableArray *emojisDataPlist = [NSMutableArray arrayWithContentsOfFile:dataPlistPath];
    NSArray *emojisPlist = [NSArray arrayWithContentsOfFile:emojiPlistPath];

    NSMutableData *mutData = [NSMutableData data];
    long offset = 0;
    for (int i = 0; i < emojisPlist.count; i++) {
        NSDictionary *emojisInfo = emojisPlist[i];
        NSMutableDictionary *emojiDataInfo = emojisDataPlist[i];
        NSArray *emojisArray = emojisInfo[@"emojis"];

        for (int j = 0; j < emojisArray.count; j++) {
            NSDictionary *dic = emojisArray[j];
            NSArray *subEmojis = dic[@"subemojis"];
            NSString *imageName = dic[@"imageName"];

            BOOL jump = false;
            if ([dic[@"symbol"] isEqualToString:@"🏇"]) {
                jump = true;
            }
            if (subEmojis.count > 0 && !jump) {
                for (int j = 0; j < subEmojis.count; j++) {
                    NSDictionary *subemojiInfo = subEmojis[j];
                    NSString *subEmojiImageName = subemojiInfo[@"imageName"];
                    NSString *filePath = [imagePath stringByAppendingString:[NSString stringWithFormat:@"%@_%i.png", subemojiInfo[@"symbol"], j]];
                    NSData *imageData = [[NSData alloc] initWithContentsOfFile:filePath];
                    if (imageData.length == 0) {
                        NSLog(@"error");
                    }
                    NSMutableDictionary *dataDic = emojiDataInfo[subEmojiImageName];
                    dataDic[@"offset"] = @(offset);
                    dataDic[@"length"] = @(imageData.length);
                    offset += imageData.length;

                    [mutData appendData:imageData];
                }
            } else {
                NSString *filePath = [imagePath stringByAppendingString:[NSString stringWithFormat:@"%@_1.png", dic[@"symbol"]]];
                NSData *imageData = [[NSData alloc] initWithContentsOfFile:filePath];
                if (imageData.length == 0) {
                    NSLog(@"error");
                }

                NSMutableDictionary *dataDic = emojiDataInfo[imageName];
                dataDic[@"offset"] = @(offset);
                dataDic[@"length"] = @(imageData.length);
                offset += imageData.length;

                [mutData appendData:imageData];
            }
        }
    }

    NSString *outputhPath = [NSHomeDirectory() stringByAppendingString:@"/Documents/UpdatedPlist/"];
    [[NSFileManager defaultManager] createDirectoryAtPath:outputhPath withIntermediateDirectories:YES attributes:nil error:nil];

    NSString *dataPlistFileName = [[NSURL URLWithString:dataPlistPath] lastPathComponent];
    NSString *path = [outputhPath stringByAppendingString:dataPlistFileName];
    [emojisDataPlist writeToFile:path atomically:true];

    path = [outputhPath stringByAppendingString:[NSString stringWithFormat:@"%@.data", dataPlistFileName]];
    [mutData writeToFile:path atomically:true];
}

- (void)updateEmojiDataPlistWithDataPath:(NSString *)dataPath
                           dataPlistPath:(NSString *)dataPlistPath
                              imagesPath:(NSString *)imagesPath
                          emojiPlistPath:(NSString *)emojiPlistPath
                      baseEmojiPlistPath:(NSString *)baseEmojiPlistPath
                  baseEmojiDataPlistPath:(NSString *)baseEmojiDataPlistPath {
    NSMutableArray *emojisDataPlist = [NSMutableArray arrayWithContentsOfFile:dataPlistPath];
    NSArray *emojisPlist = [NSArray arrayWithContentsOfFile:emojiPlistPath];
    NSArray *baseEmojisPlist = [NSArray arrayWithContentsOfFile:baseEmojiPlistPath];
    NSArray *baseEmojisDataPlist = [NSArray arrayWithContentsOfFile:baseEmojiDataPlistPath];


    NSMutableData *mutData = [NSMutableData dataWithContentsOfFile:dataPath];
    NSFileHandle *fileHandle = [NSFileHandle fileHandleForReadingAtPath:dataPath];
    long offset = mutData.length;
    int count = 0;
    for (int i = 0; i < emojisPlist.count; i++) {
        NSDictionary *emojisInfo = emojisPlist[i];
        NSMutableDictionary *emojiDataInfo = emojisDataPlist[i];
        NSArray *emojisArray = emojisInfo[@"emojis"];

        for (int j = 0; j < emojisArray.count; j++) {
            NSDictionary *dic = emojisArray[j];
            NSArray *subEmojis = dic[@"subemojis"];
            NSString *imageName = dic[@"imageName"];

            BOOL jump = false;
            if ([dic[@"symbol"] isEqualToString:@"🏇"]) {
                jump = true;
            }

            if (subEmojis.count > 0 && !jump) {
                for (int j = 0; j < subEmojis.count; j++) {
                    NSDictionary *subemojiInfo = subEmojis[j];
                    NSString *subSymbol = subEmojis[j][@"symbol"];
                    NSString *subSymbolImageName = subEmojis[j][@"imageName"];
                    NSString *baseSubEmojiImageName = [self findEmojiImageNameIn:baseEmojisPlist byEmojiSymbol:subSymbol];
                    NSDictionary *imageDataInfoDic = [self findEmojiDataInfoIn:baseEmojisDataPlist byImageName:baseSubEmojiImageName];

                    if (imageDataInfoDic != nil) {
                        long long existOffset = [imageDataInfoDic[@"offset"] longLongValue];
                        NSUInteger length = [imageDataInfoDic[@"length"] unsignedIntegerValue];
                        NSMutableDictionary *dataDic = emojiDataInfo[subSymbolImageName];
                        dataDic[@"offset"] = @(existOffset);
                        dataDic[@"length"] = @(length);
                    } else {
                        NSString *filePath = [imagesPath stringByAppendingString:[NSString stringWithFormat:@"%@_%i.png", subemojiInfo[@"symbol"], j]];
                        NSData *imageData = [[NSData alloc] initWithContentsOfFile:filePath];
                        if (imageData.length == 0) {
                            NSLog(@"error");
                        }
                        NSMutableDictionary *dataDic = emojiDataInfo[subSymbolImageName];
                        dataDic[@"offset"] = @(offset);
                        dataDic[@"length"] = @(imageData.length);
                        offset += imageData.length;
                        
                        [mutData appendData:imageData];
                        count++;
                    }
                }
            } else {

                NSString *subEmojiImageName = [self findEmojiImageNameIn:baseEmojisPlist byEmojiSymbol:dic[@"symbol"]];
                NSDictionary *imageDataInfoDic = [self findEmojiDataInfoIn:baseEmojisDataPlist byImageName:subEmojiImageName];

                if (imageDataInfoDic != nil) {
                    long long existOffset = [imageDataInfoDic[@"offset"] longLongValue];
                    NSUInteger length = [imageDataInfoDic[@"length"] unsignedIntegerValue];
                    NSMutableDictionary *dataDic = emojiDataInfo[imageName];
                    dataDic[@"offset"] = @(existOffset);
                    dataDic[@"length"] = @(length);
                    [fileHandle seekToFileOffset:existOffset];
                    NSData *testData = [fileHandle readDataOfLength:length];
                } else {
                    NSString *filePath = [imagesPath stringByAppendingString:[NSString stringWithFormat:@"%@_1.png", dic[@"symbol"]]];
                    NSData *imageData = [[NSData alloc] initWithContentsOfFile:filePath];
                    if (imageData.length == 0) {
                        NSLog(@"error");
                    }

                    NSMutableDictionary *dataDic = emojiDataInfo[imageName];
                    dataDic[@"offset"] = @(offset);
                    dataDic[@"length"] = @(imageData.length);
                    offset += imageData.length;
                    
                    [mutData appendData:imageData];
                    count++;
                }
            }
        }
    }

    NSLog(@"append %i emojis image", count);

    NSString *outputhPath = [NSHomeDirectory() stringByAppendingString:@"/Documents/UpdatedPlist/"];
    [[NSFileManager defaultManager] createDirectoryAtPath:outputhPath withIntermediateDirectories:YES attributes:nil error:nil];

    NSString *dataPlistFileName = [[NSURL URLWithString:dataPlistPath] lastPathComponent];
    NSString *path = [outputhPath stringByAppendingString:dataPlistFileName];
    [emojisDataPlist writeToFile:path atomically:true];

    path = [outputhPath stringByAppendingString:[NSString stringWithFormat:@"%@.data", dataPlistFileName]];
    [mutData writeToFile:path atomically:true];
}

@end

