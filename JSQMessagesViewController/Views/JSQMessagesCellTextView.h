//
//  Created by Jesse Squires
//  http://www.jessesquires.com
//
//
//  Documentation
//  http://cocoadocs.org/docsets/JSQMessagesViewController
//
//
//  GitHub
//  https://github.com/jessesquires/JSQMessagesViewController
//
//
//  License
//  Copyright (c) 2014 Jesse Squires
//  Released under an MIT license: http://opensource.org/licenses/MIT
//

#import <UIKit/UIKit.h>

@class JSQMessagesCellTextView;

@protocol JSQMessagesCellTextViewDelegate<NSObject>

-(NSArray<NSRegularExpression*>*)textViewCustomLinkRegularExpressions:(JSQMessagesCellTextView *)textView;

@end

/**
 *  `JSQMessagesCellTextView` is a subclass of `UITextView` that is used to display text
 *  in a `JSQMessagesCollectionViewCell`.
 */
@interface JSQMessagesCellTextView : UITextView

@property (weak) id<JSQMessagesCellTextViewDelegate> messagesCellTextViewDelegate;

@end
