//
//  Created by escoz on 7/15/11.
//
//  To change this template use File | Settings | File Templates.
//


#import <UIKit/UIKit.h>
#import "EntryTableViewCell.h"
#import "DateEntryTableViewCell.h"
#import "Element.h"
#import "LabelElement.h"
#import "EntryElement.h"
#import "DateTimeInlineElement.h"


@interface DateEntryTableViewCell ()
- (void)createSubviews;

@end

@implementation DateEntryTableViewCell

@synthesize pickerView = _pickerView;
@synthesize centeredLabel = _centeredLabel;


- (DateEntryTableViewCell *)init {
    self = [self initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"QuickformDateTimeInlineElement"];
    if (self!=nil){
        [self createSubviews];
		self.selectionStyle = UITableViewCellSelectionStyleGray;
    }
    return self;
}

- (void)createSubviews {
    [super createSubviews];
    _textField.hidden = YES;

    _pickerView = [[UIDatePicker alloc] init];
    [_pickerView sizeToFit];
    _pickerView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
    [_pickerView addTarget:self action:@selector(dateChanged:)
              forControlEvents:UIControlEventValueChanged];

    _textField.inputView = _pickerView;

    self.centeredLabel = [[UILabel alloc] init];
    self.centeredLabel.textColor = [UIColor colorWithRed:0.243 green:0.306 blue:0.435 alpha:1.0];
    self.centeredLabel.highlightedTextColor = [UIColor whiteColor];
    self.centeredLabel.font = [UIFont systemFontOfSize:17];
    self.centeredLabel.textAlignment = UITextAlignmentCenter;
	self.centeredLabel.backgroundColor = [UIColor clearColor];
    self.centeredLabel.frame = CGRectMake(10, 10, self.contentView.frame.size.width-20, self.contentView.frame.size.height-20);
    [self.contentView addSubview:self.centeredLabel];
}

- (void) dateChanged:(id)sender{
    ((DateTimeInlineElement *)  _entryElement).dateValue = _pickerView.date;
    [self prepareForElement:_entryElement inTableView:_quickformTableView];
}

- (void)prepareForElement:(EntryElement *)element inTableView:(QuickDialogTableView *)tableView {
    DateTimeInlineElement *entry = (DateTimeInlineElement *)element;
    [super prepareForElement:element inTableView:tableView];

    DateTimeInlineElement *dateElement = ((DateTimeInlineElement *) element);

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    switch (dateElement.mode) {
        case UIDatePickerModeDate:
            [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
            [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
            break;
        case UIDatePickerModeTime:
            [dateFormatter setDateStyle:NSDateFormatterNoStyle];
            [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
            break;
        case UIDatePickerModeDateAndTime:
            [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
            [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
            break;
		case UIDatePickerModeCountDownTimer:
            [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
            [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
			break;
    }
	
    if (!entry.centerLabel){
		self.textLabel.text = element.title;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.centeredLabel.text = nil;
		self.detailTextLabel.text = [dateFormatter stringFromDate:dateElement.dateValue];
		
    } else {
        self.selectionStyle = UITableViewCellSelectionStyleBlue;
        self.textLabel.text = nil;
		self.centeredLabel.text = [dateFormatter stringFromDate:dateElement.dateValue];
    }
	
	_textField.text = [dateFormatter stringFromDate:dateElement.dateValue];
    _pickerView.datePickerMode = dateElement.mode;
    _textField.placeholder = dateElement.placeholder;

    _textField.inputAccessoryView.hidden = entry.hiddenToolbar;
}


@end