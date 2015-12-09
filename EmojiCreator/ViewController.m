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

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.compressedImagePath = [NSHomeDirectory() stringByAppendingString:[NSString stringWithFormat:@"/Documents/emojis/new/"]];
    
    NSArray *targetEmojis = @[@"👑",
    @"🎵",@"🎄",
    @"🌟",@"🎄",@"🎵",
    @"🎄",@"🎄",@"🔴",
    @"🔵",@"🎄",@"🎄",@"🎄",
    @"🎄",@"🎄",@"🎄",@"🌟",@"🎄",
    @"👫",@"👬",@"👭",@"👫",@"👯",@"👭"];
    [self exportEmojiImage:targetEmojis];
    
//    [self exportAllEmojiToPlist];
//    [self getAllEmojiInSimulator];
    
//    [self exportOldEmojiImageBefore8_3];
//    [self updateOldPlistFileBefore8_3];
    
//    [self updateOldPlistFile];
    
//    [self exportNewEmojiImageOnlyInNewSystem];
//    [self getJSONContent];
//    [self exportNewEmojiImage];
    [self getJSONContent];
//    [self exportOldEmojiImageInDifferent];
//
//    // 更新旧版本的 data plist 文件
//    NSString *path = [NSHomeDirectory() stringByAppendingString:[NSString stringWithFormat:@"/Documents/emojis91.data"]];
//    NSData *data = [[NSData alloc]initWithContentsOfFile:path];
//    NSData *tmpData = [self updateOldPlistFileWithUpdateData:data];
//    path = [NSHomeDirectory() stringByAppendingString:[NSString stringWithFormat:@"/Documents/emojis91_new.data"]];
//    [tmpData writeToFile:path atomically:true];
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
    
    NSMutableArray *emojiExPlistArray = [NSMutableArray array];
    NSMutableArray *emojiExDataPlistArray = [NSMutableArray array];
    NSMutableData  *emojiExData = [[NSMutableData alloc]init];
    
    NSMutableString *tmpString = [NSMutableString string];
    
    int offset = 0;
    
    NSArray *hasSkinEmojiArray = [self getHasSkinEmoji];
    
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
                    
//                    NSLog(@"%@-----%@", mutSubDic[@"symbol"], @[mutSubDic[@"symbol"]]);
                    [tmpString appendFormat:@"%@-----%@\n", mutSubDic[@"symbol"], @[mutSubDic[@"symbol"]]];
                    
                    UIImage *image = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@%@", _compressedImagePath, mutSubDic[@"imageName"]]];
                    NSData *data = UIImagePNGRepresentation(image);
                    [emojiExData appendData:data];
                    
                    NSMutableDictionary *mutDataDic = [NSMutableDictionary dictionary];
                    mutDataDic[@"length"] = @(data.length);
                    mutDataDic[@"offset"] = @(offset);
                    emojiExDataDic[mutSubDic[@"imageName"]] = mutDataDic;
                    offset += data.length;
                }
                mutDic[@"subemojis"] = subEmojiArray;
            } else {
                
                UIImage *image = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@%@", _compressedImagePath, mutDic[@"imageName"]]];
                NSData *data = UIImagePNGRepresentation(image);
                [emojiExData appendData:data];
                
                NSMutableDictionary *mutDataDic = [NSMutableDictionary dictionary];
                mutDataDic[@"length"] = @(data.length);
                mutDataDic[@"offset"] = @(offset);
                emojiExDataDic[mutDic[@"imageName"]] = mutDataDic;
                offset += data.length;
                
//                NSLog(@"%@-----%@", currEmoji, @[currEmoji]);
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


- (NSArray *)getAllEmojiInPlistFile {
    NSString *path = [NSHomeDirectory() stringByAppendingString:[NSString stringWithFormat:@"/Documents/emojis91.plist"]];
    NSArray *emojisArray = [NSArray arrayWithContentsOfFile:path];
    path = [NSHomeDirectory() stringByAppendingString:[NSString stringWithFormat:@"/Documents/emojis91data.plist"]];
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
        NSArray *hasSkinEmojiArray = [self getHasSkinEmoji];
        
        for (int j = 0; j < [emojis count]; j++) {
            NSString *currEmoji = emojis[j];
            
            if ([self isHasEmoji:currEmoji inEmojis:hasSkinEmojiArray]) {
                for (int k = 0; k < 6; k++) {
                    NSString *imageName = [NSString stringWithFormat:@"emoji91_%i_%i_%i.png", i, j, k];
                    UIImage *image = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@%@", _compressedImagePath, imageName]];
                    NSData *data = UIImagePNGRepresentation(image);
                    
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
                UIImage *image = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@%@", _compressedImagePath, imageName]];
                NSData *data = UIImagePNGRepresentation(image);
                
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
    NSArray *notSureArray = @[@"🕴", @"🕵"];
    
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
        
        for (id /* UIKeyboardEmoji */ emoji in [category valueForKey:@"emoji"])
        {
            NSNumber *mask = [emoji valueForKey:@"variantMask"];
            id emojiString = (NSString *)[emoji valueForKey:@"emojiString"];
            id testString = [UIKeyboardEmojiCategory stringToRegionalIndicatorString:emojiString];
            if ([emojiString isEqualToString:@"🕵"]) {
                
            }
            if ([mask integerValue] > 1 ) {
                for (int i = 0; i < 6; i++) {
                    [emojiArray addObject:[NSString stringWithFormat:@"%@%@", emojiString, skinsTemp[i]]];
                }
            } else {
                [emojiArray addObject:emojiString];
            }
        }
    }

    return emojiArray;
}

- (NSArray *) getHasSkinEmoji {
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
        NSString *categoryName = [category performSelector:@selector(name)];
        if ([categoryName hasSuffix:@"Recent"])
            continue;
        
        NSString *displayName = [category respondsToSelector:@selector(displayName)] ? [category performSelector:@selector(displayName)] : categoryName;
        if ([displayName hasPrefix:@"UIKeyboardEmojiCategory"]) {
            displayName = [displayName substringFromIndex:23];
        }

        NSArray *skinsTemp = @[@"🏻",@"",@"🏼",@"🏽",@"🏾",@"🏿"];
        
        for (id /* UIKeyboardEmoji */ emoji in [category valueForKey:@"emoji"])
        {
            NSNumber *mask = [emoji valueForKey:@"variantMask"];
            
            if ([mask integerValue] > 1 ) {
                if ([mask integerValue] == 3) {
                    id emojiString = (NSString *)[emoji valueForKey:@"emojiString"];
                    NSLog(@"%@^^^^^^^^", emojiString);
                } else if ([mask integerValue] == 2) {
                    id emojiString = (NSString *)[emoji valueForKey:@"emojiString"];
                    [hasSkinEmojiArray addObject:emojiString];
                }
            }
        }
    }
    
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
    label.font = [UIFont systemFontOfSize:150.0];
    [label sizeToFit];
    
    return [self imageWithView:label];
}

- (void)updateOldPlistFileBefore8_3 {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"emojisdata" ofType:@"plist"];
    NSMutableArray *emojisDataPlist = [NSMutableArray arrayWithContentsOfFile:path];
    path = [[NSBundle mainBundle] pathForResource:@"emojis" ofType:@"plist"];
    NSArray *emojisPlist = [NSArray arrayWithContentsOfFile:path];
    
    NSMutableData *mutData = [NSMutableData data];
    long offset = 0;
    for (int i = 0; i < emojisPlist.count; i++) {
        NSDictionary *emojisInfo = emojisPlist[i];
        NSMutableDictionary *emojiInfo = emojisDataPlist[i];
        NSArray *emojisArray = emojisInfo[@"emojis"];
        
        for (int j = 0; j < emojisArray.count; j++) {
            NSDictionary *dic = emojisArray[j];
            NSString *imageName = dic[@"imageName"];
            path = [NSHomeDirectory() stringByAppendingString:[NSString stringWithFormat:@"/Documents/oldEmojis_8_1_compressed/%@", imageName]];
            NSData *imageData = [[NSData alloc] initWithContentsOfFile:path];
            if (imageData.length == 0) {
                NSLog(@"error");
            }
            [mutData appendData:imageData];
            NSMutableDictionary *dataDic = emojiInfo[imageName];
            if (dataDic != nil && [dataDic isKindOfClass:[NSDictionary class]]) {
                
                dataDic[@"offset"] = @(offset);
                dataDic[@"length"] = @(imageData.length);
                offset += imageData.length;
            }
        }
        [emojiInfo removeObjectForKey:@"offset"];
    }
    
    path = [NSHomeDirectory() stringByAppendingString:[NSString stringWithFormat:@"/Documents/emojisdata.plist"]];
    [emojisDataPlist writeToFile:path atomically:true];
    path = [NSHomeDirectory() stringByAppendingString:[NSString stringWithFormat:@"/Documents/emojis.data"]];
    [mutData writeToFile:path atomically:true];
}

- (NSData *)updateOldPlistFileWithUpdateData: (NSData *)data {
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

                if ([key isEqualToString:@"emojiex_0_121.png"]) {
                    
                }
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
                    UIImage *image = [UIImage imageWithData:imageData];
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

- (void)exportNewEmojiImage {
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
        NSArray *hasSkinEmojiArray = [self getHasSkinEmoji];
        
        for (int j = 0; j < [emojis count]; j++) {
            NSString *currEmoji = emojis[j];
            NSString *imageName = [NSString stringWithFormat:@"emoji91_%i_%i_1.png", i, j];
            
            if ([self isHasEmoji:currEmoji inEmojis:hasSkinEmojiArray]) {
                for (int k = 0; k < 6; k++) {
                    NSString *subSymbol = [NSString stringWithFormat:@"%@%@", currEmoji, skinsTemp[k]];
                    NSString *subImageName = [NSString stringWithFormat:@"emoji91_%i_%i_%i.png", i, j, k];
                    NSData *imageData = UIImagePNGRepresentation([self toImage:subSymbol]);
                    
                    path = [NSHomeDirectory() stringByAppendingString:[NSString stringWithFormat:@"/Documents/emojis/%@", subImageName]];
                    [imageData writeToFile:path atomically:true];
                }

            } else {
//                NSData *imageData = UIImagePNGRepresentation([self toImage:currEmoji]);
//                
//                path = [NSHomeDirectory() stringByAppendingString:[NSString stringWithFormat:@"/Documents/emojis/%@", imageName]];
//                [imageData writeToFile:path atomically:true];
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

- (void)exportNewEmojiImageOnlyInNewSystem {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"emojisex" ofType:@"plist"];
    NSArray *oldEmojis = [self getAllEmojiInPlistFile: path];
    
    path = [[NSBundle mainBundle] pathForResource:@"Category-Emoji" ofType:@"json"];
    NSData *jsonData = [[NSData alloc]initWithContentsOfFile:path];
    NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
    NSArray *emojiCategoryArray = jsonDic[@"EmojiDataArray"];
    NSArray *skinsTemp = @[@"🏻",@"",@"🏼",@"🏽",@"🏾",@"🏿"];
    
    
    for (int i = 0; i < [emojiCategoryArray count]; i++) {
        
        NSDictionary *category = emojiCategoryArray[i];
        NSDictionary *categoryDataDic = category[@"CVCategoryData"];
        NSString *dataString = categoryDataDic[@"Data"];
        NSArray *emojis = [dataString componentsSeparatedByString:@","];
        NSArray *hasSkinEmojiArray = [self getHasSkinEmoji];
        
        for (int j = 0; j < [emojis count]; j++) {
            NSString *currEmoji = emojis[j];
            NSString *imageName = [NSString stringWithFormat:@"emoji91_%i_%i_1.png", i, j];
            
            if (![self isHasEmoji:currEmoji inEmojis:oldEmojis]) {
                NSLog(@"new emoji is %@", currEmoji);
            }
        }
    }
}


- (NSArray *)getAllEmojiInPlistFile: (NSString *)filePath {
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
        NSArray *hasSkinEmojiArray = [self getHasSkinEmoji];
        
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
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Category-Emoji" ofType:@"json"];
    NSData *jsonData = [[NSData alloc]initWithContentsOfFile:path];
    NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
    NSArray *emojiCategoryArray = jsonDic[@"EmojiDataArray"];
    NSArray *skinsTemp = @[@"🏻",@"",@"🏼",@"🏽",@"🏾",@"🏿"];
    
    NSMutableArray *tmpTargetEmojis = [targetEmojis mutableCopy];
    
    for (int i = 0; i < [emojiCategoryArray count]; i++) {
        
        NSDictionary *category = emojiCategoryArray[i];
        NSDictionary *categoryDataDic = category[@"CVCategoryData"];
        NSString *dataString = categoryDataDic[@"Data"];
        NSArray *emojis = [dataString componentsSeparatedByString:@","];
        NSArray *hasSkinEmojiArray = [self getHasSkinEmoji];
        
        for (int j = 0; j < [emojis count]; j++) {
            NSString *currEmoji = emojis[j];
            NSString *imageName = [NSString stringWithFormat:@"emoji91_%i_%i_1.png", i, j];
            
            if ([self isHasEmoji:currEmoji inEmojis:hasSkinEmojiArray]) {
                for (int k = 0; k < 6; k++) {
                    NSString *subSymbol = [NSString stringWithFormat:@"%@%@", currEmoji, skinsTemp[k]];

                    NSArray *tmpTargets = [tmpTargetEmojis copy];
                    for (int m = 0; m < tmpTargets.count; m++) {
                        NSString *targetEmoji = tmpTargets[m];
                        if ([targetEmoji isEqualToString:subSymbol]) {
                            [tmpTargetEmojis removeObject:targetEmoji];
                            NSString *subImageName = [NSString stringWithFormat:@"emoji91_%i_%i_%i.png", i, j, k];
                            NSData *imageData = UIImagePNGRepresentation([self toImage:subSymbol]);
                            
                            path = [NSHomeDirectory() stringByAppendingString:[NSString stringWithFormat:@"/Documents/%@", subImageName]];
                            [imageData writeToFile:path atomically:true];
                        }
                    }
                }

            } else {
                NSArray *tmpTargets = [tmpTargetEmojis copy];
                for (int m = 0; m < tmpTargets.count; m++) {
                    NSString *targetEmoji = tmpTargets[m];
                    if ([targetEmoji isEqualToString:currEmoji]) {
                        [tmpTargetEmojis removeObject:targetEmoji];
                        NSData *imageData = UIImagePNGRepresentation([self toImage:currEmoji]);
                        
                        path = [NSHomeDirectory() stringByAppendingString:[NSString stringWithFormat:@"/Documents/%@", imageName]];
                        [imageData writeToFile:path atomically:true];
                    }
                }
            }
        }
    }
    
    for (int n = 0; n < tmpTargetEmojis.count; n++) {
        NSLog(@"can not export the emoji to image: %@", tmpTargetEmojis[n]);
    }
}


@end

