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

#import "JSQMessagesCellTextView.h"

@implementation JSQMessagesCellTextView

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.textColor = [UIColor whiteColor];
    self.editable = NO;
    // HACK: Tap gestures don't over the text view get swallowed on iOS 11. This is a quick and dirty fix.
    self.selectable = NO; // YES;
    self.userInteractionEnabled = YES;
    self.dataDetectorTypes = UIDataDetectorTypeNone;
    self.showsHorizontalScrollIndicator = NO;
    self.showsVerticalScrollIndicator = NO;
    self.scrollEnabled = NO;
    self.backgroundColor = [UIColor clearColor];
    self.contentInset = UIEdgeInsetsZero;
    self.scrollIndicatorInsets = UIEdgeInsetsZero;
    self.contentOffset = CGPointZero;
    self.textContainerInset = UIEdgeInsetsZero;
    self.textContainer.lineFragmentPadding = 0;
    self.linkTextAttributes = @{ NSForegroundColorAttributeName : [UIColor whiteColor],
                                 NSUnderlineStyleAttributeName : @(NSUnderlineStyleSingle | NSUnderlinePatternSolid) };
}

- (void)setSelectedRange:(NSRange)selectedRange
{
    //  attempt to prevent selecting text
    [super setSelectedRange:NSMakeRange(NSNotFound, 0)];
}

- (NSRange)selectedRange
{
    //  attempt to prevent selecting text
    return NSMakeRange(NSNotFound, NSNotFound);
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    //  ignore double-tap to prevent copy/define/etc. menu from showing
    if ([gestureRecognizer isKindOfClass:[UITapGestureRecognizer class]]) {
        UITapGestureRecognizer *tap = (UITapGestureRecognizer *)gestureRecognizer;
        if (tap.numberOfTapsRequired == 2) {
            return NO;
        }
    }
    
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    //  ignore double-tap to prevent copy/define/etc. menu from showing
    if ([gestureRecognizer isKindOfClass:[UITapGestureRecognizer class]]) {
        UITapGestureRecognizer *tap = (UITapGestureRecognizer *)gestureRecognizer;
        if (tap.numberOfTapsRequired == 2) {
            return NO;
        }
    }
    
    return YES;
}

- (void)layoutSubviews
{
    [self detectCustomLinks];
    [super layoutSubviews];
}

- (void)detectCustomLinks
{
    NSMutableArray<NSTextCheckingResult*>  *textCheckingResults = [NSMutableArray<NSTextCheckingResult*> array];

    for (NSRegularExpression *exp in [self.messagesCellTextViewDelegate textViewCustomLinkRegularExpressions:self]) {
        NSArray<NSTextCheckingResult*> *matches = [exp matchesInString:self.text options:NSMatchingWithoutAnchoringBounds range:NSMakeRange(0, self.text.length)];
        [textCheckingResults addObjectsFromArray:matches];
    }

    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithAttributedString:self.attributedText];

    [attributedText removeAttribute:NSLinkAttributeName range:NSMakeRange(0, attributedText.string.length)];
    for (NSTextCheckingResult *match in textCheckingResults) {
        [attributedText addAttribute: NSLinkAttributeName value:[attributedText attributedSubstringFromRange:match.range].string range:match.range];
    }

    self.attributedText = attributedText;
}

@end
