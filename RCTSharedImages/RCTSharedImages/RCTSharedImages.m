//
//  RCTSharedImages.m
//  RCTSharedImages
//
//  Created by 晁荣 on 16/12/23.
//  Copyright © 2016年 maichong. All rights reserved.
//

#import "RCTSharedImages.h"
#import "RCTConvert.h"
#import "RCTLog.h"
#import "RCTUtils.h"
#import "RCTBridge.h"
#import "RCTUIManager.h"
#import "SharedItem.h"

@interface RCTSharedImages () <UIActionSheetDelegate>
@end

@implementation RCTSharedImages
{
    // Use NSMapTable, as UIAlertViews do not implement <NSCopying>
    // which is required for NSDictionary keys
    NSMapTable *_callbacks;
}

RCT_EXPORT_MODULE();

@synthesize bridge = _bridge;

- (dispatch_queue_t)methodQueue
{
    return dispatch_get_main_queue();
}

/*
 * The`anchor` option takes a view to set as the anchor for the share
 * popup to point to, on iPads running iOS 8. If it is not passed, it
 * defaults to centering the share popup on screen without any arrows.
 */
- (CGRect)sourceRectInView:(UIView *)sourceView
             anchorViewTag:(NSNumber *)anchorViewTag
{
    if (anchorViewTag) {
        UIView *anchorView = [self.bridge.uiManager viewForReactTag:anchorViewTag];
        return [anchorView convertRect:anchorView.bounds toView:sourceView];
    } else {
        return (CGRect){sourceView.center, {1, 1}};
    }
}
//测试方法导出
RCT_EXPORT_METHOD(testPrint:(NSString *)text
                  callback:(RCTResponseSenderBlock)callback)
{
    NSString *testStr = [NSString stringWithFormat:@"%@",text];
    NSLog(@"testStr is :%@",testStr);
    //NSString *message = @"callback message!!!";
    callback(@[[NSNull null], testStr]);
}

//分享多张图片
RCT_EXPORT_METHOD(shareImages:(NSDictionary *)options
                  callback:(RCTResponseSenderBlock)callback)
{
    if (RCTRunningInAppExtension()) {
        RCTLogError(@"Unable to show action sheet from app extension");
        return;
    }
    
    NSMutableArray<id> *items = [NSMutableArray array];
    NSString *message = [RCTConvert NSString:options[@"message"]];
    if (message) {
        [items addObject:message];
    }
//    NSString *URL = [NSString stringWithFormat:@"%@",options[@"url"]];
    /** 图片数组*/
    NSMutableArray * photos = [NSArray arrayWithArray:options[@"imagePaths"]];;
    NSLog(@"photos is :%@", photos);
    for (int i = 0; i <9 && i<photos.count; i++) {
        NSURL *URL = [RCTConvert NSURL:photos[i]];
        NSLog(@"photos is url= :%@", URL);
        NSError *error;
        NSData *data = [NSData dataWithContentsOfURL:URL
                                             options:(NSDataReadingOptions)0
                                               error:&error];
        UIImage *imagerang = [UIImage imageWithData:data];
        
        NSString *path_sandox = NSHomeDirectory();
        NSString *imagePath = [path_sandox stringByAppendingString:[NSString stringWithFormat:@"/Documents/ShareWX%d.jpg",i]];
        [UIImagePNGRepresentation(imagerang) writeToFile:imagePath atomically:YES];
        
        NSURL *shareobj = [NSURL fileURLWithPath:imagePath];
        
        /** 这里做个解释 imagerang : UIimage 对象  shareobj:NSURL 对象 这个方法的实际作用就是 在调起微信的分享的时候 传递给他 UIimage对象,在分享的时候 实际传递的是 NSURL对象 达到我们分享九宫格的目的 */
        
        SharedItem *item = [[SharedItem alloc] initWithData:imagerang andFile:shareobj];
        
        [items addObject:item];
    }
    if (items.count == 0) {
        RCTLogError(@"No `url` or `message` to share");
        return;
    }
    
    
    UIActivityViewController *shareController = [[UIActivityViewController alloc] initWithActivityItems:items applicationActivities:nil];
    
    NSString *subject = [RCTConvert NSString:options[@"subject"]];
    if (subject) {
        [shareController setValue:subject forKey:@"subject"];
    }
    
    NSArray *excludedActivityTypes = [RCTConvert NSStringArray:options[@"excludedActivityTypes"]];
    if (excludedActivityTypes) {
        shareController.excludedActivityTypes = excludedActivityTypes;
    }
    
    UIViewController *controller = RCTPresentedViewController();
    shareController.completionWithItemsHandler = ^(NSString *activityType, BOOL completed, __unused NSArray *returnedItems, NSError *activityError) {
    };
    
    shareController.modalPresentationStyle = UIModalPresentationPopover;
    NSNumber *anchorViewTag = [RCTConvert NSNumber:options[@"anchor"]];
    if (!anchorViewTag) {
        shareController.popoverPresentationController.permittedArrowDirections = 0;
    }
    shareController.popoverPresentationController.sourceView = controller.view;
    shareController.popoverPresentationController.sourceRect = [self sourceRectInView:controller.view anchorViewTag:anchorViewTag];
    
    [controller presentViewController:shareController animated:YES completion:nil];
    
    shareController.view.tintColor = [RCTConvert UIColor:options[@"tintColor"]];
}

//分享链接
RCT_EXPORT_METHOD(shareUrl:(NSDictionary *)options
                  callback:(RCTResponseSenderBlock)callback)
{
    if (RCTRunningInAppExtension()) {
        RCTLogError(@"Unable to show action sheet from app extension");
        return;
    }
    
    NSMutableArray<id> *items = [NSMutableArray array];
    NSString *message = [RCTConvert NSString:options[@"message"]];
    if (message) {
        [items addObject:message];
    }
    NSURL *URL = [RCTConvert NSURL:options[@"url"]];
    if (URL) {
        [items addObject:URL];
    }
    if (items.count == 0) {
        RCTLogError(@"No `url` or `message` to share");
        return;
    }
    
    
    UIActivityViewController *shareController = [[UIActivityViewController alloc] initWithActivityItems:items applicationActivities:nil];
    
    NSString *subject = [RCTConvert NSString:options[@"subject"]];
    if (subject) {
        [shareController setValue:subject forKey:@"subject"];
    }
    
    NSArray *excludedActivityTypes = [RCTConvert NSStringArray:options[@"excludedActivityTypes"]];
    if (excludedActivityTypes) {
        shareController.excludedActivityTypes = excludedActivityTypes;
    }
    
    UIViewController *controller = RCTPresentedViewController();
    shareController.completionWithItemsHandler = ^(NSString *activityType, BOOL completed, __unused NSArray *returnedItems, NSError *activityError) {
    };
    
    shareController.modalPresentationStyle = UIModalPresentationPopover;
    NSNumber *anchorViewTag = [RCTConvert NSNumber:options[@"anchor"]];
    if (!anchorViewTag) {
        shareController.popoverPresentationController.permittedArrowDirections = 0;
    }
    shareController.popoverPresentationController.sourceView = controller.view;
    shareController.popoverPresentationController.sourceRect = [self sourceRectInView:controller.view anchorViewTag:anchorViewTag];
    
    [controller presentViewController:shareController animated:YES completion:nil];
    
    shareController.view.tintColor = [RCTConvert UIColor:options[@"tintColor"]];
}

#pragma mark UIActionSheetDelegate Methods

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    RCTResponseSenderBlock callback = [_callbacks objectForKey:actionSheet];
    if (callback) {
        callback(@[@(buttonIndex)]);
        [_callbacks removeObjectForKey:actionSheet];
    } else {
        RCTLogWarn(@"No callback registered for action sheet: %@", actionSheet.title);
    }
}

@end
