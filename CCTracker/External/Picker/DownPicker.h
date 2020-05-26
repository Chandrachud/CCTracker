//
//   DownPicker.h
// --------------------------------------------------------
//      Lightweight DropDownList/ComboBox control for iOS
//
// by Darkseal, 2013-2015 - MIT License
//
// Website: http://www.ryadel.com/
// GitHub:  http://www.ryadel.com/
//

@protocol DownPickerDelegate;

#import <UIKit/UIKit.h>

@interface DownPicker : UIControl<UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate>
{
    UIPickerView* pickerView;
    IBOutlet UITextField* textField;
    NSString* placeholder;
    NSString* placeholderWhileSelecting;
	NSString* toolbarDoneButtonText;
    NSString* toolbarCancelButtonText;
	UIBarStyle toolbarStyle;
    NSArray* dataArray;
}

@property (nonatomic) NSString* text;
@property (nonatomic) NSInteger selectedIndex;
@property(nonatomic, assign) id<DownPickerDelegate>customDelegate;

-(id)initWithTextField:(UITextField *)tf;
-(id)initWithTextField:(UITextField *)tf withData:(NSArray*) data;

@property (nonatomic) BOOL shouldDisplayCancelButton;

/**
 Sets an alternative image to be show to the right part of the textbox (assuming that showArrowImage is set to TRUE).
 @param image
 A valid UIImage
 */
-(void) setArrowImage:(UIImage*)image;
- (IBAction)showPicker:(id)sender;
- (BOOL)textFieldShouldBeginEditing:(UITextField *)aTextField;

-(void) setData:(NSArray*) data;
-(void) setPlaceholder:(NSString*)str;
-(void) setPlaceholderWhileSelecting:(NSString*)str;
-(void) setAttributedPlaceholder:(NSAttributedString *)attributedString;
-(void) setToolbarDoneButtonText:(NSString*)str;
-(void) setToolbarCancelButtonText:(NSString*)str;
-(void) setToolbarStyle:(UIBarStyle)style;

/**
 TRUE to show the rightmost arrow image, FALSE to hide it.
 @param b
 TRUE to show the rightmost arrow image, FALSE to hide it.
 */
-(void) showArrowImage:(BOOL)b;

-(UIPickerView*) getPickerView;
-(UITextField*) getTextField;

/**
 Retrieves the string value at the specified index.
 @return
 The value at the given index or NIL if nothing has been selected yet.
 */
-(NSString*) getValueAtIndex:(NSInteger)index;

/**
 Sets the zero-based index of the selected item: -1 can be used to clear selection.
 @return
 The value at the given index or NIL if nothing has been selected yet.
 */
-(void) setValueAtIndex:(NSInteger)index;
@end

@protocol DownPickerDelegate <NSObject>

-(void)downPickerDidSelectRowAtIndexPath:(NSInteger)row withPicker:(DownPicker *)downPicker;

@end
