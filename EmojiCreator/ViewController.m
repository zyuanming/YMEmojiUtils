//
//  ViewController.m
//  EmojiCreator
//
//  Created by Zhang Yuanming on 15/10/9.
//  Copyright © 2015年 ZhangYuanming. All rights reserved.
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

+ (id)ActivityEmoji;
+ (id)CelebrationEmoji;
+ (id)DingbatVariantsEmoji;
+ (id)FoodAndDrinkEmoji;
+ (id)GenderEmoji;
+ (id)NatureEmoji;
+ (id)NoneVariantEmoji;
+ (id)ObjectsAndSymbolsEmoji;
+ (id)ObjectsEmoji;
+ (id)PeopleEmoji;
+ (id)PrepopulatedEmoji;
+ (id)SkinToneEmoji;
+ (id)SymbolsEmoji;
+ (id)TravelAndPlacesEmoji;
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

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.compressedImagePath = [NSHomeDirectory() stringByAppendingString:[NSString stringWithFormat:@"/Documents/emojis/"]];


//    NSArray *temp = [self getAllEmojiInSimulator];

    [self step2];
//
//
//    ////////////////// 导出data里面的图片，重新压缩后再拼接
//
//    // 1.
//    NSString *dataPath = [[NSBundle mainBundle] pathForResource:@"emojisex" ofType:@"data"];
//
//    NSString *emoji91PlistPath = [[NSBundle mainBundle] pathForResource:@"emojis91" ofType:@"plist"];
//    NSString *data91PlistPath = [[NSBundle mainBundle] pathForResource:@"emojis91data" ofType:@"plist"];
//
//    NSString *emojiexPlistPath = [[NSBundle mainBundle] pathForResource:@"emojisex" ofType:@"plist"];
//    NSString *dataexPlistPath = [[NSBundle mainBundle] pathForResource:@"emojisexdata" ofType:@"plist"];
//
//    NSString *outputhPath = [NSHomeDirectory() stringByAppendingString:@"/Documents/output/"];
//    [self exportImageFromDataPath:dataPath byDataPlist:data91PlistPath byEmojiPlist:emoji91PlistPath saveTo:outputhPath];
//    [self exportImageFromDataPath:dataPath byDataPlist:dataexPlistPath byEmojiPlist:emojiexPlistPath saveTo:outputhPath];
//
//    // 用ImageOptim无损压缩
//
//    // 2.
//    NSString *imagePath = [NSHomeDirectory() stringByAppendingString:@"/Documents/output/"];
//    [self updateDataPlist:data91PlistPath byImagePath:imagePath withEmojiPlist:emoji91PlistPath];
//
//
//    NSString *newDataPath = [NSHomeDirectory() stringByAppendingString:@"/Documents/UpdatedPlist/emojis91data.plist.data"];
//    NSString *newData91PlistPath = [NSHomeDirectory() stringByAppendingString:@"/Documents/UpdatedPlist/emojis91data.plist"];
//    [self updateEmojiDataPlistWithDataPath:newDataPath
//                             dataPlistPath:dataexPlistPath
//                                imagesPath:outputhPath
//                            emojiPlistPath:emojiexPlistPath
//                        baseEmojiPlistPath:emoji91PlistPath
//                    baseEmojiDataPlistPath:newData91PlistPath];
//
//
//
//    ////////////////// iOS 10 更新步骤
//    // 1.
//    [self exportAllEmojiImages];
//    // 用pngquant 命令行执行有损压缩
//
//    // 2.
//    NSString *emojis91Path = [[NSBundle mainBundle] pathForResource:@"emojis91" ofType:@"plist"];
//    NSString *jsonPath = [[NSBundle mainBundle] pathForResource:@"Category-Emoji" ofType:@"json"];
//    NSArray *newAddEmojiList = [self exportNewEmojisListInJsonPath:jsonPath fromEmojiListPath:emojis91Path];
//    // 具体新增的Emoji，可以查看： http://emojipedia.org/apple/ios-10.0/new+changed/
//    NSString *newDesignEmojis = @"🔫,😀,😬,😁,😂,😃,😄,😅,😆,😇,😉,😊,🙂,🙃,☺️,😋,😌,😍,😘,😗,😙,😚,😜,😝,😛,🤑,🤓,😎,🤗,😏,😶,😐,😑,😒,🙄,🤔,😳,😞,😟,😠,😡,😔,😕,🙁,☹️,😣,😖,😫,😩,😤,😮,😱,😨,😰,😯,😦,😧,😢,😥,😪,😓,😭,😵,😲,🤐,😷,🤒,🤕,😴,🙌,👏,👍,👎,👊,✊,👋,👈,👉,👆,👇,👌,☝️,✌️,✋,🖐,👐,💪,🙏,🖖,🤘,🖕,✍️,💅,👄,👅,👂,👃,👶,👦,👧,👨,👩,👱‍♀️,👱,👴,👵,👲,👳‍♀️,👳,👮‍♀️,👮,👷‍♀️,👷,💂‍♀️,💂,🕵️‍♀️,🕵️,🎅,👸,👰,👼,🙇‍♀️,🙇,💁,💁‍♂️,🙅,🙅‍♂️,🙆,🙆‍♂️,🙋,🙋‍♂️,🙎,🙎‍♂️,🙍,🙍‍♂️,💇,💇‍♂️,💆,💆‍♂️,💃,👯,👯‍♂️,🚶‍♀️,🚶,🏃‍♀️,🏃,👫,👭,👬,💑,👩‍❤️‍👩,👨‍❤️‍👨,💏,👩‍❤️‍💋‍👩,👨‍❤️‍💋‍👨,👪,👨‍👩‍👧,👨‍👩‍👧‍👦,👨‍👩‍👦‍👦,👨‍👩‍👧‍👧,👩‍👩‍👦,👩‍👩‍👧,👩‍👩‍👧‍👦,👩‍👩‍👦‍👦,👩‍👩‍👧‍👧,👨‍👨‍👦,👨‍👨‍👧,👨‍👨‍👧‍👦,👨‍👨‍👦‍👦,👨‍👨‍👧‍👧,👩‍👦,👩‍👧,👩‍👧‍👦,👩‍👦‍👦,👩‍👧‍👧,👨‍👦,👨‍👧,👨‍👧‍👦,👨‍👦‍👦,👨‍👧‍👧,🚵,🏊,🚣,🏄，🇷🇴，😈，👿，💀，👽，😾，🛁";
//
//    NSArray *newDesignEmojisList = [newDesignEmojis componentsSeparatedByString:@","];
//    NSMutableArray *newEmojis = [NSMutableArray arrayWithArray:newAddEmojiList];
//    [newEmojis addObjectsFromArray:newDesignEmojisList];
//
//    // 3.
//    NSString *path = [NSHomeDirectory() stringByAppendingString:@"/Documents/UpdatedPlist/emojisexdata.plist.data"];
//    NSData *data = [NSData dataWithContentsOfFile:path];
//    [self updateNewEmoji:newEmojis iniOS10WithUpdateData:data];


//    NSString *emojis10Path = [[NSBundle mainBundle] pathForResource:@"emojis10" ofType:@"plist"];
//    NSString *emojis10DataPath = [[NSBundle mainBundle] pathForResource:@"emojis10data" ofType:@"plist"];
//    NSString *jsonPath = [[NSBundle mainBundle] pathForResource:@"Category-Emoji_10.2" ofType:@"json"];
//    NSArray *newAddEmojiList = [self exportNewEmojisListInJsonPath:jsonPath fromEmojiListPath:emojis10Path];
//
//
//    [self exportAllEmojiImages:jsonPath withImageNamePrefix:@"emojis102"];

//    NSString *path = [[NSBundle mainBundle] pathForResource:@"emojisex_10" ofType:@"data"];
//    NSData *data = [NSData dataWithContentsOfFile:path];
//    [self updateNewEmoji: newAddEmojiList
//   iniOS10WithUpdateData:data
// withOriginPlistFilePath:emojis10Path
//           withJsonFile: jsonPath
//       withDataPlistFile: emojis10DataPath
//         imageNamePrefix:@"emojis102"
//           withMultiSkin: false];
//
//    NSString *dataPath = [NSHomeDirectory() stringByAppendingString:@"/Documents/emojisex.data"];
//    NSString *outputhPath = [NSHomeDirectory() stringByAppendingString:@"/Documents/output/"];
//    NSString *updatedPath = [NSHomeDirectory() stringByAppendingString:@"/Documents/UpdatedPlist/"];
//
//    NSString *data102PlistPath = [NSHomeDirectory() stringByAppendingString:@"/Documents/emojis102data.plist"];
//    NSString *emoji102PlistPath = [NSHomeDirectory() stringByAppendingString:@"/Documents/emojis102.plist"];
//
//    NSString *data10PlistPath = [NSHomeDirectory() stringByAppendingString:@"/Documents/emojis10data.plist"];
//    NSString *emoji10PlistPath = [NSHomeDirectory() stringByAppendingString:@"/Documents/emojis10.plist"];
//
//    NSString *data91PlistPath = [NSHomeDirectory() stringByAppendingString:@"/Documents/emojis91data.plist"];
//    NSString *emoji91PlistPath = [NSHomeDirectory() stringByAppendingString:@"/Documents/emojis91.plist"];
//
//    NSString *dataexPlistPath = [NSHomeDirectory() stringByAppendingString:@"/Documents/emojisexdata.plist"];
//    NSString *emojiexPlistPath = [NSHomeDirectory() stringByAppendingString:@"/Documents/emojisex.plist"];
//
//    [self exportImageFromDataPath:dataPath byDataPlist:data102PlistPath byEmojiPlist:emoji102PlistPath saveTo:outputhPath];
//    [self exportImageFromDataPath:dataPath byDataPlist:data10PlistPath byEmojiPlist:emoji10PlistPath saveTo:outputhPath];
//    [self exportImageFromDataPath:dataPath byDataPlist:data91PlistPath byEmojiPlist:emoji91PlistPath saveTo:outputhPath];
//    [self exportImageFromDataPath:dataPath byDataPlist:dataexPlistPath byEmojiPlist:emojiexPlistPath saveTo:outputhPath];
//
//    [self updateDataPlist:data102PlistPath byImagePath:outputhPath withEmojiPlist:emoji102PlistPath imagePrefix:@"emojis" includeMultiSkins:false];
//
//    [self updateEmojiDataPlistWithDataPath:[updatedPath stringByAppendingString:@"emojis102data.plist.data"]
//                              dataPlistPath:data10PlistPath
//                                 imagesPath:outputhPath
//                             emojiPlistPath:emoji10PlistPath
//                         baseEmojiPlistPath:emoji102PlistPath
//                    baseEmojiDataPlistPath:data102PlistPath
//                 newBaseEmojiDataPlistPath:[updatedPath stringByAppendingString:@"emojis102data.plist"]
//                         includeMultiSkins:false];
//
//    [self updateEmojiDataPlistWithDataPath:[updatedPath stringByAppendingString:@"emojis10data.plist.data"]
//                             dataPlistPath:data91PlistPath
//                                imagesPath:outputhPath
//                            emojiPlistPath:emoji91PlistPath
//                        baseEmojiPlistPath:emoji10PlistPath
//                    baseEmojiDataPlistPath:data10PlistPath
//                 newBaseEmojiDataPlistPath:[updatedPath stringByAppendingString:@"emojis10data.plist"]
//                         includeMultiSkins:false];
//
//    [self updateEmojiDataPlistWithDataPath:[updatedPath stringByAppendingString:@"emojis91data.plist.data"]
//                             dataPlistPath:dataexPlistPath
//                                imagesPath:outputhPath
//                            emojiPlistPath:emojiexPlistPath
//                        baseEmojiPlistPath:emoji91PlistPath
//                    baseEmojiDataPlistPath:data91PlistPath
//                 newBaseEmojiDataPlistPath:[updatedPath stringByAppendingString:@"emojis91data.plist"]
//                         includeMultiSkins:false];
//    [self updateOldDataPlist:[NSHomeDirectory() stringByAppendingString:@"/Documents/emojisdata.plist"]
//              withEmojiPlist:[NSHomeDirectory() stringByAppendingString:@"/Documents/emojis.plist"] includeMultiSkins:false];

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
                NSArray *allSkinedEmojis = [self getSkinedEmojis:currEmoji];
                for (int k = 0; k < allSkinedEmojis.count; k++) {
                    NSMutableDictionary *mutSubDic = [NSMutableDictionary dictionary];
                    mutSubDic[@"symbol"] = allSkinedEmojis[k];
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
                if (subEmojiArray.count > 1) {
                    mutDic[@"subemojis"] = subEmojiArray;
                }
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

}


- (NSArray<EmojiModel *> *)getAllEmojiInJsonFile: (NSString *)jsonFileName {
    NSString *fileName = jsonFileName == nil ? @"Category-Emoji" : jsonFileName;
    NSString *path = [[NSBundle mainBundle] pathForResource:fileName ofType:@"json"];
    NSData *jsonData = [[NSData alloc]initWithContentsOfFile:path];
    NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
    NSArray *emojiCategoryArray = jsonDic[@"EmojiDataArray"];

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
                NSArray *allSkinedEmojis = [self getSkinedEmojis:currEmoji];
                for (int k = 0; k < allSkinedEmojis.count; k++) {
                    NSString *imageName = [NSString stringWithFormat:@"emoji91_%i_%i_%i.png", i, j, k];
                    NSString *imagePath = [NSString stringWithFormat:@"%@%@", _compressedImagePath, imageName];
                    NSData *data = [NSData dataWithContentsOfFile:imagePath];
                    
                    EmojiModel *subEmojiModel = [[EmojiModel alloc]init];
                    subEmojiModel.symbol = allSkinedEmojis[k];
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
        for (NSUInteger i = 0; i < numberOfCategories + 1; i++)
            [categories addObject:[UIKeyboardEmojiCategory categoryForType:i]];
    }

    
    for (id /* UIKeyboardEmojiCategory */ category in categories)
    {
        NSString *categoryName = [category performSelector:@selector(name)];
        if ([categoryName hasSuffix:@"Recent"])
            continue;

        if (!categoryName) {
            continue;
        }

        NSString *displayName = [category respondsToSelector:@selector(displayName)] ? [category performSelector:@selector(displayName)] : categoryName;
        if ([displayName hasPrefix:@"UIKeyboardEmojiCategory"])
            displayName = [displayName substringFromIndex:23];
        
        id emojis = [category valueForKey:@"emoji"];
        if ([emojis count] == 0 ) {
            continue;
        }

        NSMutableString *mutableString = [[NSMutableString alloc] init];

        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        
        for (id /* UIKeyboardEmoji */ emoji in [category valueForKey:@"emoji"])
        {
            NSNumber *mask = [emoji valueForKey:@"variantMask"];
            id emojiString = (NSString *)[emoji valueForKey:@"emojiString"];
            if ([mask integerValue] > 1 ) {
                NSArray *allSkinedEmojis = [self getSkinedEmojis: emojiString];
                for (int i = 0; i < allSkinedEmojis.count; i++) {
                    [mutableString appendFormat:@"%@, ", allSkinedEmojis[i]];
                    [emojiArray addObject: allSkinedEmojis[i]];
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

            if ([mask integerValue] == 2 || [mask integerValue] == 6 || [mask integerValue] == 3 || [mask integerValue] == 10) {
                NSArray *skinedArray = [self getSkinedEmojis:emojiString];
                if (skinedArray.count > 1) {
                    [hasSkinEmojiArray addObject:emojiString];
                }
            }
        }
    }

    [hasSkinEmojiArray addObject:@"🏋️"];
    [hasSkinEmojiArray addObject:@"⛹️"];

    return hasSkinEmojiArray;
}

- (BOOL)isHasEmoji: (NSString *)emoji inEmojis:(NSArray *)emojis {
    for (int i = 0; i < emojis.count; i++) {
        NSString *tmpEmoji = emojis[i];
        NSString *displayForImageFlagString = @"\\ufe0f";
        NSString *tmpUnicodeEmoji = [self trimString:emoji byCharacter:displayForImageFlagString];
        NSString *unicodeEmoji = [self trimString:tmpEmoji byCharacter:displayForImageFlagString];
        if ([emoji isEqualToString:tmpEmoji]) {
            return true;
        } else if ([tmpUnicodeEmoji isEqualToString:unicodeEmoji]) {
            return true;
        }
    }
    return false;
}


- (BOOL)isHasEmoji: (NSString *)emoji inEmojisModel:(NSArray *)emojisModel {
    for (int i = 0; i < emojisModel.count; i++) {
        EmojiModel *tmpEmoji = emojisModel[i];
        NSString *displayForImageFlagString = @"\\ufe0f";
        NSString *tmpUnicodeEmoji = [self trimString:emoji byCharacter:displayForImageFlagString];
        NSString *unicodeEmoji = [self trimString:tmpEmoji.symbol byCharacter:displayForImageFlagString];
        if ([emoji isEqualToString:tmpEmoji.symbol]) {
            return true;
        } else if ([tmpUnicodeEmoji isEqualToString:unicodeEmoji]) {
            return true;
        }
    }
    return false;
}

- (EmojiModel *)getEmojiModelWithSymbol: (NSString *)symbol inEmojisModel: (NSArray *)emojisModel {
    for (int i = 0; i < emojisModel.count; i++) {
        EmojiModel *tmpEmoji = emojisModel[i];
        if ([symbol isEqualToString:tmpEmoji.symbol]) {
            return tmpEmoji;
        } else {
            NSString *displayForImageFlagString = @"\\ufe0f";
            NSString *trimUnicode1 = [self trimString:tmpEmoji.symbol byCharacter:displayForImageFlagString];
            NSString *trimUnicode2 = [self trimString:symbol byCharacter:displayForImageFlagString];

            if ([trimUnicode2 isEqualToString:trimUnicode1]) {
                return tmpEmoji;
            }

        }
    }
    return nil;
}

- (NSString *)trimString: (NSString *)text byCharacter: (NSString *)trimCharacter
{
    NSData *tmpData = [text dataUsingEncoding: NSNonLossyASCIIStringEncoding];
    NSString *tmpUnicode = [[NSString alloc] initWithData:tmpData encoding:NSUTF8StringEncoding];

    while ([tmpUnicode containsString:trimCharacter]) {
        NSRange range = [tmpUnicode rangeOfString:trimCharacter];
        NSString *prefixUnicode = [tmpUnicode substringToIndex:range.location];
        NSString *suffixUnicode = [tmpUnicode substringFromIndex:range.location + range.length];
        tmpUnicode = [prefixUnicode stringByAppendingString:suffixUnicode];
    }

    return tmpUnicode;
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
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"emojis91" ofType:@"plist"];
    NSArray<EmojiModel *> *allEmojis = [self getAllEmojiInPlistFile: plistPath dataPlistFile: nil];
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

- (void)updateNewEmoji: (NSArray *)newEmojis
 iniOS10WithUpdateData: (NSData *)updatingData
withOriginPlistFilePath: (NSString *)plistPath
          withJsonFile: (NSString *)jsonFilePath
     withDataPlistFile: (NSString *)dataPlistFile
       imageNamePrefix: (NSString *)imageNamePrefix
         withMultiSkin: (BOOL)withMultiSkin {

    NSArray<EmojiModel *> *oldAllEmojis = [self getAllEmojiInPlistFile: plistPath dataPlistFile: dataPlistFile];
    NSData *jsonData = [[NSData alloc]initWithContentsOfFile: jsonFilePath];
    NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
    NSArray *emojiCategoryArray = jsonDic[@"EmojiDataArray"];
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

            mutDic[@"imageName"] = [NSString stringWithFormat:@"%@_%i_%i_1.png", imageNamePrefix, i, j];
            [emojiExCategoryArray addObject:mutDic];


            if ([self isHasEmoji:currEmoji inEmojis:newEmojis]) {
                if ([self isHasEmoji:currEmoji inEmojis:hasSkinEmojiArray]) {
                    NSMutableArray *subEmojiArray = [NSMutableArray array];

                    NSArray *allSkinedEmojis = [self getSkinedEmojis:currEmoji];
                    for (int k = 0; k < allSkinedEmojis.count; k++) {
                        NSMutableDictionary *mutSubDic = [NSMutableDictionary dictionary];
                        mutSubDic[@"symbol"] = allSkinedEmojis[k];
                        mutSubDic[@"imageName"] = [NSString stringWithFormat:@"%@_%i_%i_%i.png", imageNamePrefix, i, j, k];
                        [subEmojiArray addObject:mutSubDic];

                        if (withMultiSkin || k == 1) {
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
                    if (subEmojiArray.count > 1) {
                        mutDic[@"subemojis"] = subEmojiArray;
                    }
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
                    NSArray *allSkinedEmojis = [self getSkinedEmojis:currEmoji];
                    for (int k = 0; k < allSkinedEmojis.count; k++) {
                        NSString *subSymbol = allSkinedEmojis[k];
                        EmojiModel *subOldModel = [self getEmojiModelWithSymbol:subSymbol inEmojisModel:oldAllEmojis];

                        if (subOldModel) {
                            NSMutableDictionary *mutSubDic = [NSMutableDictionary dictionary];
                            mutSubDic[@"symbol"] = subSymbol;
                            mutSubDic[@"imageName"] = [NSString stringWithFormat:@"%@_%i_%i_%i.png", imageNamePrefix, i, j, k];
                            [subEmojiArray addObject:mutSubDic];

                            if (withMultiSkin || k == 1) {
                                NSMutableDictionary *mutDataDic = [NSMutableDictionary dictionary];
                                mutDataDic[@"length"] = @(subOldModel.fileLength);
                                mutDataDic[@"offset"] = @(subOldModel.offset);
                                emojiExDataDic[mutSubDic[@"imageName"]] = mutDataDic;
                            }
                        } else {
                            NSLog(@"can not find sub emojis in %@", currEmoji);
                        }
                    }
                    if (subEmojiArray.count > 1) {
                        mutDic[@"subemojis"] = subEmojiArray;
                    }
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

    NSString *resultPlistPath = [NSHomeDirectory() stringByAppendingString:[NSString stringWithFormat:@"/Documents/%@.plist", imageNamePrefix]];
    [emojiExPlistArray writeToFile:resultPlistPath atomically:true];
    resultPlistPath = [NSHomeDirectory() stringByAppendingString:[NSString stringWithFormat:@"/Documents/%@data.plist", imageNamePrefix]];
    [emojiExDataPlistArray writeToFile:resultPlistPath atomically:true];

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

    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"emojis91" ofType:@"plist"];
    NSArray<EmojiModel *> *allEmojis = [self getAllEmojiInPlistFile:plistPath dataPlistFile: nil];

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
- (void)exportAllEmojiImages: (NSString *)jsonFilePath withImageNamePrefix: (NSString *)imageNamePrefix {
    NSData *jsonData = [[NSData alloc]initWithContentsOfFile: jsonFilePath];
    NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
    NSArray *emojiCategoryArray = jsonDic[@"EmojiDataArray"];


    for (int i = 0; i < [emojiCategoryArray count]; i++) {

        NSDictionary *category = emojiCategoryArray[i];
        NSDictionary *categoryDataDic = category[@"CVCategoryData"];
        NSString *dataString = categoryDataDic[@"Data"];
        NSArray *emojis = [dataString componentsSeparatedByString:@","];
        NSArray *hasSkinEmojiArray = [self getHasDifferentSkinsEmojiList];
        
        for (int j = 0; j < [emojis count]; j++) {
            NSString *currEmoji = emojis[j];
            NSString *imageName = [NSString stringWithFormat:@"%@_%i_%i_1.png",imageNamePrefix, i, j];

            NSString *emojiPath = [NSHomeDirectory() stringByAppendingString:@"/Documents/emojis/"];
            [[NSFileManager defaultManager] createDirectoryAtPath:emojiPath withIntermediateDirectories:YES attributes:nil error:nil];

            if ([self isHasEmoji:currEmoji inEmojis:hasSkinEmojiArray]) {

                NSArray *allSkinedEmojis = [self getSkinedEmojis:currEmoji];
                for (int k = 0; k < allSkinedEmojis.count; k++) {
                    NSString *subSymbol = allSkinedEmojis[k];
                    NSString *subImageName = [NSString stringWithFormat:@"%@_%i_%i_%i.png",imageNamePrefix, i, j, k];
                    NSData *imageData = UIImagePNGRepresentation([self toImage:subSymbol]);

                    NSString *path = [NSHomeDirectory() stringByAppendingString:[NSString stringWithFormat:@"/Documents/emojis/%@", subImageName]];
                    [imageData writeToFile:path atomically:true];
                }

            } else {
                NSData *imageData = UIImagePNGRepresentation([self toImage:currEmoji]);
                
                NSString *path = [NSHomeDirectory() stringByAppendingString:[NSString stringWithFormat:@"/Documents/emojis/%@", imageName]];
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
    NSArray *oldEmojis = [self getAllEmojiInPlistFile: emojisPlistFilePath dataPlistFile: nil];
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

    NSLog(@"new emoji has %lu: %@",(unsigned long)result.count, newEmojis);
    return result;
}


- (NSArray<EmojiModel *> *)getAllEmojiInPlistFile: (NSString *)filePath dataPlistFile: (NSString *)dataPlistFilePath {
//    NSString *path = [[NSBundle mainBundle] pathForResource:@"emojis91" ofType:@"plist"];
    NSArray *emojisArray = [NSArray arrayWithContentsOfFile:filePath];
//    path = [[NSBundle mainBundle] pathForResource:@"emojis91data" ofType:@"plist"];
    NSArray *emojisDataArray = [NSArray arrayWithContentsOfFile: dataPlistFilePath];

    NSMutableArray *tmpArray = [NSMutableArray array];

    for (int i = 0; i < emojisArray.count; i++) {
        NSArray *emojisInfoArray = emojisArray[i][@"emojis"];
        NSDictionary *emojisDataInfo = emojisDataArray.count > 0 ? emojisDataArray[i] : nil;

        for (int k = 0; k < emojisInfoArray.count; k++) {
            NSDictionary *emojiInfo = emojisInfoArray[k];

            EmojiModel *emojiModel = [[EmojiModel alloc]init];
            emojiModel.symbol = emojiInfo[@"symbol"];
            emojiModel.imageName = emojiInfo[@"imageName"];

            if (emojisDataInfo) {
                NSDictionary *emojiDataInfoDic = emojisDataInfo[emojiInfo[@"imageName"]];
                emojiModel.fileLength = [emojiDataInfoDic[@"length"] integerValue];
                emojiModel.offset = [emojiDataInfoDic[@"offset"] integerValue];
            }

            [tmpArray addObject:emojiModel];


            NSArray *subEmojis = emojiInfo[@"subemojis"];
            for (int j = 0; j < subEmojis.count; j++) {
                NSDictionary *subemojiInfo = subEmojis[j];

                EmojiModel *subemojiModel = [[EmojiModel alloc]init];
                subemojiModel.symbol = subemojiInfo[@"symbol"];
                subemojiModel.imageName = subemojiInfo[@"imageName"];

                if (emojisDataInfo) {
                    NSDictionary *subemojiDataInfoDic = emojisDataInfo[subemojiInfo[@"imageName"]];
                    subemojiModel.fileLength = [subemojiDataInfoDic[@"length"] integerValue];
                    subemojiModel.offset = [subemojiDataInfoDic[@"offset"] integerValue];
                }

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
                NSArray *allSkinedEmojis = [self getSkinedEmojis:currEmoji];
                for (int k = 0; k < allSkinedEmojis.count; k++) {
                    NSMutableDictionary *subEmojiDic = [NSMutableDictionary dictionary];
                    NSString *symbol = allSkinedEmojis[k];
                    subEmojiDic[@"symbol"] = symbol;
                    subEmojiDic[@"unicode"] = [NSString stringWithFormat:@"%@", @[symbol]];
                    NSLog(@"%@ ------------> %@", symbol, @[symbol]);
                    [emojiExPlistArray addObject:subEmojiDic];
                }
                
            } else {

                NSMutableDictionary *emojiDic = [NSMutableDictionary dictionary];
                emojiDic[@"symbol"] = currEmoji;

                NSLog(@"%@ ------> %@", currEmoji, @[currEmoji]);
                [emojiExPlistArray addObject:emojiDic];
            }
        }
    }
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

    NSString *displayForImageFlagString = @"\\ufe0f";
    NSString *tmpUnicodeEmoji = [self trimString:symbol byCharacter:displayForImageFlagString];

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
                    NSString *unicodeEmoji = [self trimString:subSymbol byCharacter:displayForImageFlagString];
                    if ([symbol isEqualToString:subSymbol]) {
                        return subEmojis[j][@"imageName"];
                    } else if ([tmpUnicodeEmoji isEqualToString:unicodeEmoji]) {
                        return subEmojis[j][@"imageName"];
                    }
                }
            } else {
                NSString *unicodeEmoji = [self trimString:currSymbol byCharacter:displayForImageFlagString];
                if ([tmpUnicodeEmoji isEqualToString:unicodeEmoji]) {
                    return dic[@"imageName"];
                }
            }
        }
    }

    return nil;
}

- (void)exportImageFromDataPath:(NSString *)dataPath
                    byDataPlist:(NSString *)dataPlistPath
                   byEmojiPlist:(NSString *)emojiPlistPath
                         saveTo:(NSString *)savePath {
    NSMutableArray *emojisDataPlist = [NSMutableArray arrayWithContentsOfFile:dataPlistPath];
    NSArray *emojisPlist = [NSArray arrayWithContentsOfFile:emojiPlistPath];
    NSFileHandle *dataHandle = [NSFileHandle fileHandleForReadingAtPath:dataPath];
    [[NSFileManager defaultManager] createDirectoryAtPath:savePath withIntermediateDirectories:YES attributes:nil error:nil];
    for (int i = 0; i < emojisPlist.count; i++) {
        NSDictionary *emojisInfo = emojisPlist[i];
        NSArray *emojisArray = emojisInfo[@"emojis"];

        for (int j = 0; j < emojisArray.count; j++) {
            NSDictionary *dic = emojisArray[j];
            NSArray *subEmojis = dic[@"subemojis"];

            if (subEmojis.count > 0) {
                for (int k = 0; k < subEmojis.count; k++) {

                    NSDictionary *subDataInfo = [self findEmojiDataInfoIn:emojisDataPlist byImageName:subEmojis[k][@"imageName"]];
                    long long offset = [subDataInfo[@"offset"] longLongValue];
                    NSUInteger length = [subDataInfo[@"length"] unsignedIntegerValue];
                    [dataHandle seekToFileOffset:offset];
                    NSData *imageData = [dataHandle readDataOfLength:length];

                    NSString *subSymbol = subEmojis[k][@"symbol"];

                    NSString *subImageName = [NSString stringWithFormat:@"%lli-%lu.png", offset, (unsigned long)length];
                    NSString *imagePath = [savePath stringByAppendingString:subImageName];
                    [imageData writeToFile:imagePath atomically:true];
                    if (imageData.length == 0) {
                        NSLog(@"export image for symbol %@ fail !!!" , subSymbol);
                    }
                }
            } else {
                NSDictionary *currEmojiDataInfo = [self findEmojiDataInfoIn:emojisDataPlist byImageName:dic[@"imageName"]];
                long long offset = [currEmojiDataInfo[@"offset"] longLongValue];
                NSUInteger length = [currEmojiDataInfo[@"length"] unsignedIntegerValue];
                NSString *imageName = [NSString stringWithFormat:@"%lli-%lu.png", offset, (unsigned long)length];
                [dataHandle seekToFileOffset:offset];
                NSData *imageData = [dataHandle readDataOfLength:length];

                NSString *currSymbol = dic[@"symbol"];
                NSString *imagePath = [savePath stringByAppendingString:imageName];
                [imageData writeToFile:imagePath atomically:true];
                if (imageData.length == 0) {
                    NSLog(@"export image for symbol %@ fail !!!" , currSymbol);
                }
            }
        }
    }


    NSLog(@"finished export ...");
}

- (void)updateDataPlist: (NSString *)dataPlistPath
            byImagePath:(NSString *)imagePath
         withEmojiPlist: (NSString *)emojiPlistPath
            imagePrefix:(NSString *)imagePrefix
      includeMultiSkins: (BOOL)includeMultiSkins {
    NSMutableArray *emojisDataPlist = [NSMutableArray arrayWithContentsOfFile:dataPlistPath];
    NSMutableArray *emojisPlist = [NSMutableArray arrayWithContentsOfFile:emojiPlistPath];

    NSMutableData *mutData = [NSMutableData data];
    unsigned long long offset = 0;
    for (int i = 0; i < emojisPlist.count; i++) {
        NSMutableDictionary *emojisInfo = emojisPlist[i];
        NSMutableDictionary *emojiDataInfo = emojisDataPlist[i];
        NSMutableArray *emojisArray = emojisInfo[@"emojis"];

        for (int j = 0; j < emojisArray.count; j++) {
            NSMutableDictionary *dic = emojisArray[j];
            NSArray *subEmojis = dic[@"subemojis"];
            NSString *imageName = dic[@"imageName"];


            if (subEmojis.count > 0) {
                for (int k = 0; k < subEmojis.count; k++) {
                    NSMutableDictionary *subemojiInfo = subEmojis[k];
                    NSString *subEmojiImageName = subemojiInfo[@"imageName"];
                    NSMutableDictionary *dataDic = emojiDataInfo[subEmojiImageName];
                    long long subOffset = [dataDic[@"offset"] longLongValue];
                    NSUInteger subLength = [dataDic[@"length"] unsignedIntegerValue];
                    NSString *subImageName = [NSString stringWithFormat:@"%llu-%li.png", subOffset, subLength];

                    NSString *filePath = [imagePath stringByAppendingString:subImageName];
                    NSData *imageData = [[NSData alloc] initWithContentsOfFile:filePath];

                    if (includeMultiSkins || k == 1) {
                        if (imageData.length == 0) {
                            NSLog(@"error");
                        }
                        subemojiInfo[@"imageName"] = [NSString stringWithFormat:@"%llu-%li", offset, imageData.length];
                        dataDic[@"offset"] = @(offset);
                        dataDic[@"length"] = @(imageData.length);

                        if (k == 1) {
                            dic[@"imageName"] = subemojiInfo[@"imageName"];
                        }

                        offset += imageData.length;

                        [mutData appendData:imageData];
                    } else {
                        [emojiDataInfo removeObjectForKey:subEmojiImageName];
                        [subemojiInfo removeObjectForKey:@"imageName"];
                    }
                }
            } else {
                NSMutableDictionary *dataDic = emojiDataInfo[imageName];
                long long subOffset = [dataDic[@"offset"] longLongValue];
                NSUInteger subLength = [dataDic[@"length"] unsignedIntegerValue];
                NSString *subImageName = [NSString stringWithFormat:@"%llu-%li.png", subOffset, subLength];
                NSString *filePath = [imagePath stringByAppendingString: subImageName];
                NSData *imageData = [[NSData alloc] initWithContentsOfFile:filePath];
                if (imageData.length == 0) {
                    NSLog(@"error");
                }
                dic[@"imageName"] = [NSString stringWithFormat:@"%llu-%li", offset, imageData.length];
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

    NSString *emojiPlistFileName = [[NSURL URLWithString:emojiPlistPath] lastPathComponent];
    NSString *emojiPath = [outputhPath stringByAppendingString:emojiPlistFileName];
    [emojisPlist writeToFile:emojiPath atomically:true];

    path = [outputhPath stringByAppendingString:[NSString stringWithFormat:@"%@.data", dataPlistFileName]];
    [mutData writeToFile:path atomically:true];
}

- (void)updateEmojiDataPlistWithDataPath:(NSString *)dataPath
                           dataPlistPath:(NSString *)dataPlistPath
                              imagesPath:(NSString *)imagesPath
                          emojiPlistPath:(NSString *)emojiPlistPath
                      baseEmojiPlistPath:(NSString *)baseEmojiPlistPath
                  baseEmojiDataPlistPath:(NSString *)baseEmojiDataPlistPath
               newBaseEmojiDataPlistPath: (NSString *)newBaseEmojiDataPlistPath
                       includeMultiSkins: (BOOL)includeMultiSkins  {
    NSMutableArray *emojisDataPlist = [NSMutableArray arrayWithContentsOfFile:dataPlistPath];
    NSMutableArray *emojisPlist = [NSMutableArray arrayWithContentsOfFile:emojiPlistPath];
    NSArray *baseEmojisPlist = [NSArray arrayWithContentsOfFile:baseEmojiPlistPath];
    NSArray *baseEmojisDataPlist = [NSArray arrayWithContentsOfFile:baseEmojiDataPlistPath];
    NSArray *newBaseEmojisDataPlist = [NSArray arrayWithContentsOfFile:newBaseEmojiDataPlistPath];


    NSMutableData *mutData = [NSMutableData dataWithContentsOfFile:dataPath];
    NSFileHandle *fileHandle = [NSFileHandle fileHandleForReadingAtPath:dataPath];
    unsigned long long offset = mutData.length;
    int count = 0;
    for (int i = 0; i < emojisPlist.count; i++) {
        NSMutableDictionary *emojisInfo = emojisPlist[i];
        NSMutableDictionary *emojiDataInfo = emojisDataPlist[i];
        NSMutableArray *emojisArray = emojisInfo[@"emojis"];

        for (int j = 0; j < emojisArray.count; j++) {
            NSMutableDictionary *dic = emojisArray[j];
            NSMutableArray *subEmojis = dic[@"subemojis"];
            NSString *imageName = dic[@"imageName"];


            if (subEmojis.count > 0) {
                for (int k = 0; k < subEmojis.count; k++) {
                    NSString *subSymbol = subEmojis[k][@"symbol"];
                    NSString *subSymbolImageName = subEmojis[k][@"imageName"];
                    NSMutableDictionary *dataDic = emojiDataInfo[subSymbolImageName];
                    long long existOffset = [dataDic[@"offset"] longLongValue];
                    NSUInteger length = [dataDic[@"length"] unsignedIntegerValue];
                    NSString *subImageName = [NSString stringWithFormat:@"%llu-%li.png",existOffset, length];

                    NSString *baseSubEmojiImageName = [self findEmojiImageNameIn:baseEmojisPlist byEmojiSymbol:subSymbol];
                    NSDictionary *imageDataInfoDic = [self findEmojiDataInfoIn:baseEmojisDataPlist byImageName:baseSubEmojiImageName];
                    NSDictionary *newImageDataInfoDic = [self findEmojiDataInfoIn:newBaseEmojisDataPlist byImageName:baseSubEmojiImageName];
                    long long existOffset1 = 0;
                    NSUInteger length1 = 0;

                    if (imageDataInfoDic != nil) {
                        existOffset1 = [imageDataInfoDic[@"offset"] longLongValue];
                        length1 = [imageDataInfoDic[@"length"] unsignedIntegerValue];
                    }

                    if (includeMultiSkins || k == 1) {
                        if (existOffset == existOffset1 && length == length1) {
                            dataDic[@"offset"] = @([newImageDataInfoDic[@"offset"] longLongValue]);
                            dataDic[@"length"] = @([newImageDataInfoDic[@"length"] longLongValue]);
                        } else {
                            NSString *filePath = [imagesPath stringByAppendingString: subImageName];
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

                        subEmojis[k][@"imageName"] = [NSString stringWithFormat:@"%@-%@",dataDic[@"offset"], dataDic[@"length"]];
                        if (k == 1) {
                            dic[@"imageName"] = [NSString stringWithFormat:@"%@-%@",dataDic[@"offset"], dataDic[@"length"]];
                        }
                    } else {
                        [emojiDataInfo removeObjectForKey:subSymbolImageName];
                        [subEmojis[k] removeObjectForKey:@"imageName"];
                    }
                }
            } else {

                NSString *subEmojiImageName = [self findEmojiImageNameIn:baseEmojisPlist byEmojiSymbol:dic[@"symbol"]];
                NSDictionary *imageDataInfoDic = [self findEmojiDataInfoIn:baseEmojisDataPlist byImageName:subEmojiImageName];
                NSDictionary *newImageDataInfoDic = [self findEmojiDataInfoIn:newBaseEmojisDataPlist byImageName:subEmojiImageName];
                NSMutableDictionary *dataDic = emojiDataInfo[imageName];
                long long existOffset = [dataDic[@"offset"] longLongValue];
                NSUInteger length = [dataDic[@"length"] unsignedIntegerValue];
                long long existOffset1 = 0;
                NSUInteger length1 = 0;

                if (imageDataInfoDic != nil) {
                    existOffset1 = [imageDataInfoDic[@"offset"] longLongValue];
                    length1 = [imageDataInfoDic[@"length"] unsignedIntegerValue];
                }

                if (existOffset == existOffset1 && length == length1) {
                    dataDic[@"offset"] = @([newImageDataInfoDic[@"offset"] longLongValue]);
                    dataDic[@"length"] = @([newImageDataInfoDic[@"length"] unsignedIntegerValue]);
                    [fileHandle seekToFileOffset:existOffset];
                    dic[@"imageName"] = [NSString stringWithFormat:@"%@-%@",dataDic[@"offset"], dataDic[@"length"]];
                } else {
                    NSString *subImageName = [NSString stringWithFormat:@"%llu-%li.png",existOffset, length];
                    NSString *filePath = [imagesPath stringByAppendingString: subImageName];
                    NSData *imageData = [[NSData alloc] initWithContentsOfFile:filePath];
                    if (imageData.length == 0) {
                        NSLog(@"error");
                    }

                    dic[@"imageName"] = [NSString stringWithFormat:@"%llu-%li",offset, imageData.length];
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

    NSString *emojiPlistFileName = [[NSURL URLWithString:emojiPlistPath] lastPathComponent];
    NSString *emojiPath = [outputhPath stringByAppendingString:emojiPlistFileName];
    [emojisPlist writeToFile:emojiPath atomically:true];

    path = [outputhPath stringByAppendingString:[NSString stringWithFormat:@"%@.data", dataPlistFileName]];
    [mutData writeToFile:path atomically:true];
}

- (void)updateOldDataPlist: (NSString *)dataPlistPath
         withEmojiPlist: (NSString *)emojiPlistPath
      includeMultiSkins: (BOOL)includeMultiSkins {
    NSMutableArray *emojisDataPlist = [NSMutableArray arrayWithContentsOfFile:dataPlistPath];
    NSMutableArray *emojisPlist = [NSMutableArray arrayWithContentsOfFile:emojiPlistPath];


    for (int i = 0; i < emojisPlist.count; i++) {
        NSMutableDictionary *emojisInfo = emojisPlist[i];
        NSMutableDictionary *emojiDataInfo = emojisDataPlist[i];
        NSMutableArray *emojisArray = emojisInfo[@"emojis"];

        for (int j = 0; j < emojisArray.count; j++) {
            NSMutableDictionary *dic = emojisArray[j];
            NSArray *subEmojis = dic[@"subemojis"];
            NSString *imageName = dic[@"imageName"];


            if (subEmojis.count > 0) {
                for (int k = 0; k < subEmojis.count; k++) {
                    NSMutableDictionary *subemojiInfo = subEmojis[k];
                    NSString *subEmojiImageName = subemojiInfo[@"imageName"];
                    NSMutableDictionary *dataDic = emojiDataInfo[subEmojiImageName];
                    long long subOffset = [dataDic[@"offset"] longLongValue];
                    NSUInteger subLength = [dataDic[@"length"] unsignedIntegerValue];

                    if (includeMultiSkins || k == 1) {

                        subemojiInfo[@"imageName"] = [NSString stringWithFormat:@"%llu-%li", subOffset, subLength];

                        if (k == 1) {
                            dic[@"imageName"] = subemojiInfo[@"imageName"];
                        }

                    } else {
                        [emojiDataInfo removeObjectForKey:subEmojiImageName];
                        [subemojiInfo removeObjectForKey:@"imageName"];
                    }
                }
            } else {
                NSMutableDictionary *dataDic = emojiDataInfo[imageName];
                long long subOffset = [dataDic[@"offset"] longLongValue];
                NSUInteger subLength = [dataDic[@"length"] unsignedIntegerValue];
                dic[@"imageName"] = [NSString stringWithFormat:@"%llu-%li", subOffset, subLength];
            }
        }
    }

    NSString *outputhPath = [NSHomeDirectory() stringByAppendingString:@"/Documents/UpdatedPlist/"];
    [[NSFileManager defaultManager] createDirectoryAtPath:outputhPath withIntermediateDirectories:YES attributes:nil error:nil];

    NSString *dataPlistFileName = [[NSURL URLWithString:dataPlistPath] lastPathComponent];
    NSString *path = [outputhPath stringByAppendingString:dataPlistFileName];
    [emojisDataPlist writeToFile:path atomically:true];

    NSString *emojiPlistFileName = [[NSURL URLWithString:emojiPlistPath] lastPathComponent];
    NSString *emojiPath = [outputhPath stringByAppendingString:emojiPlistFileName];
    [emojisPlist writeToFile:emojiPath atomically:true];
}

// iOS10 beta版有些多肤色的Emoji无法通过简单的字符拼接来实现，因为iOS10添加支持了一种全新的emoji构造方式：
// 例如，通过一个基本的emoji 加上一个 “♀” 女生标记来构造一个全新的对应的女生版的emoji
- (NSArray *)getSkinedEmojis: (NSString *)emoji {
    NSArray *skinsMask = @[@"🏻",@"",@"🏼",@"🏽",@"🏾",@"🏿"];
    NSString *joinString = @"\\u200d";
    NSString *displayForImageFlagString = @"\\ufe0f";

    NSData *testdata = [emoji dataUsingEncoding: NSNonLossyASCIIStringEncoding];
    NSString *goodValue = [[NSString alloc] initWithData:testdata encoding:NSUTF8StringEncoding];
    NSMutableArray *result = [NSMutableArray array];

    // 处理多字符连接
    if ([goodValue containsString:joinString]) {
        NSRange range = [goodValue rangeOfString:joinString];
        NSString *prefixUnicode = [goodValue substringToIndex:range.location];
        NSString *suffixUnicode = [goodValue substringFromIndex:range.location + range.length];


        for (int i = 0; i < skinsMask.count; i++) {
            NSString *mask = skinsMask[i];
            NSData *maskData = [mask dataUsingEncoding: NSNonLossyASCIIStringEncoding];
            NSString *maskUnicode = [[NSString alloc] initWithData:maskData encoding:NSUTF8StringEncoding];

            NSString *newSkinUnicode = [[[prefixUnicode stringByAppendingString:maskUnicode] stringByAppendingString: joinString] stringByAppendingString:suffixUnicode];
            NSData *newSkinData = [newSkinUnicode dataUsingEncoding:NSUTF8StringEncoding];
            NSString *newSkin = [[NSString alloc] initWithData:newSkinData encoding:NSNonLossyASCIIStringEncoding];

            [result addObject:newSkin];
        }
    } else if ([goodValue containsString:displayForImageFlagString]) {
        NSRange range = [goodValue rangeOfString:displayForImageFlagString];
        NSString *prefixUnicode = [goodValue substringToIndex:range.location];
        NSString *suffixUnicode = [goodValue substringFromIndex:range.location + range.length];

        for (int i = 0; i < skinsMask.count; i++) {
            NSString *mask = skinsMask[i];
            NSData *maskData = [mask dataUsingEncoding: NSNonLossyASCIIStringEncoding];
            NSString *maskUnicode = [[NSString alloc] initWithData:maskData encoding:NSUTF8StringEncoding];

            NSString *newSkinUnicode = [[[prefixUnicode stringByAppendingString:maskUnicode] stringByAppendingString: displayForImageFlagString] stringByAppendingString:suffixUnicode];
            NSData *newSkinData = [newSkinUnicode dataUsingEncoding:NSUTF8StringEncoding];
            NSString *newSkin = [[NSString alloc] initWithData:newSkinData encoding:NSNonLossyASCIIStringEncoding];

            [result addObject:newSkin];
        }
    } else {
        for (int i = 0; i < skinsMask.count; i++) {
            NSString *newSkin = [NSString stringWithFormat:@"%@%@", emoji, skinsMask[i]];

            [result addObject:newSkin];
        }
    }

    if ([emoji isEqualToString:@"🤝"]) {
        return @[emoji];
    }

    return result;
}






- (NSArray<EmojiModel *> *)step1 {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"emojis102" ofType:@"plist"];
    NSArray *emojisArray = [NSArray arrayWithContentsOfFile: path];
    //    path = [[NSBundle mainBundle] pathForResource:@"emojis91data" ofType:@"plist"];
//    NSArray *emojisDataArray = [NSArray arrayWithContentsOfFile: dataPlistFilePath];

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




- (void)step2 {
    NSArray *models = [self step1];


    NSMutableArray *emojiArray = [NSMutableArray array];
    NSMutableArray *emojiExPlistArray = [NSMutableArray array];

    Class UIKeyboardEmojiCategory = NSClassFromString(@"UIKeyboardEmojiCategory");
    NSMutableArray *categories = [NSMutableArray array];
    // UIKeyboardEmojiCategory has a +categories method, but it does not fill emoji. Calling categoryForType: does fill emoji
    if ([UIKeyboardEmojiCategory respondsToSelector:@selector(numberOfCategories)])
    {
        NSInteger numberOfCategories = [UIKeyboardEmojiCategory numberOfCategories];
        for (NSUInteger i = 0; i < numberOfCategories + 1; i++)
        [categories addObject:[UIKeyboardEmojiCategory categoryForType:i]];
    }


    for (id category in categories)
    {
        NSMutableArray *emojiExCategoryArray = [NSMutableArray array];
        NSString *categoryName = [category performSelector:@selector(name)];
        if ([categoryName hasSuffix:@"Recent"])
        continue;

        if (!categoryName) {
            continue;
        }

        NSString *displayName = [category respondsToSelector:@selector(displayName)] ? [category performSelector:@selector(displayName)] : categoryName;
        if ([displayName hasPrefix:@"UIKeyboardEmojiCategory"])
        displayName = [displayName substringFromIndex:23];

        id emojis = [category valueForKey:@"emoji"];
        if ([emojis count] == 0 ) {
            continue;
        }

        NSMutableString *mutableString = [[NSMutableString alloc] init];

        for (id emoji in [category valueForKey:@"emoji"])
        {
            id emojiString = (NSString *)[emoji valueForKey:@"emojiString"];
            NSMutableDictionary *mutDic = [NSMutableDictionary dictionary];
            mutDic[@"symbol"] = emojiString;
            EmojiModel *model = [self getEmojiModelWithSymbol: emojiString inEmojisModel: models];
            if (model) {
                mutDic[@"imageName"] = model.imageName;
            }

            [emojiExCategoryArray addObject:mutDic];


            NSNumber *mask = [emoji valueForKey:@"variantMask"];

            if ([mask integerValue] > 1 ) {
                NSMutableArray *subEmojiArray = [NSMutableArray array];
                NSArray *allSkinedEmojis = [self getSkinedEmojis: emojiString];
                for (int i = 0; i < allSkinedEmojis.count; i++) {


                    NSMutableDictionary *mutSubDic = [NSMutableDictionary dictionary];
                    mutSubDic[@"symbol"] = allSkinedEmojis[i];
                    EmojiModel *model = [self getEmojiModelWithSymbol: allSkinedEmojis[i] inEmojisModel: models];
                    if (model) {
                        mutSubDic[@"imageName"] = model.imageName;
                    }
                    [subEmojiArray addObject:mutSubDic];



                    [mutableString appendFormat:@"%@, ", allSkinedEmojis[i]];
                    [emojiArray addObject: allSkinedEmojis[i]];
                }

                if (subEmojiArray.count > 1) {
                    mutDic[@"subemojis"] = subEmojiArray;
                }
            } else {
                [mutableString appendFormat:@"%@, ",emojiString];
                [emojiArray addObject:emojiString];
            }
        }

        [emojiExPlistArray addObject:@{@"emojis": emojiExCategoryArray}];

        NSLog(@"%@: \n%@", displayName, mutableString);
    }



    NSString *plistPath = [NSHomeDirectory() stringByAppendingString:[NSString stringWithFormat:@"/Documents/emojis111.plist"]];
    [emojiExPlistArray writeToFile:plistPath atomically:true];





//        NSString *path = [[NSBundle mainBundle] pathForResource:@"emojis102" ofType:@"plist"];
//        NSArray *oldEmojis = [NSArray arrayWithContentsOfFile: path];

        NSArray *newAllEmojis = emojiExPlistArray;

        NSMutableArray *result = [NSMutableArray array];
        NSMutableString *newEmojis = [NSMutableString string];

        for (int i = 0; i < [newAllEmojis count]; i++) {

            NSDictionary *category = newAllEmojis[i];
            NSArray *emojis = category[@"emojis"];

            for (int j = 0; j < [emojis count]; j++) {
                NSDictionary *currEmojiDic = emojis[j];
                NSString *currEmoji = currEmojiDic[@"symbol"];
                if (![self isHasEmoji:currEmoji inEmojisModel:models]) {
                    [newEmojis appendFormat:@"%@,", currEmoji];
                    [result addObject:currEmoji];
                }
            }
        }

        NSLog(@"new emoji has %lu: %@",(unsigned long)result.count, newEmojis);


        NSMutableString *newEmojisListString = [NSMutableString string];
        for (int i = 0; i < [result count]; i++) {
            NSString *emoji = result[i];
            [newEmojisListString appendFormat: @"%@: %@\n", emoji, @[emoji]];

        }

        NSLog(@"%@", newEmojisListString);
}



















@end

