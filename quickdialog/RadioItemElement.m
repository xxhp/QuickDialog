//
//  Created by escoz on 7/8/11.
//

#import "Element.h"
#import "LabelElement.h"
#import "RadioItemElement.h"
#import "RootElement.h"
#import "RadioElement.h"
#import "QuickDialogController.h"
#import "QuickDialogTableView.h"
#import "Section.h"
#import "RadioSection.h"


@implementation RadioItemElement

- (RadioItemElement *)initWithIndex:(NSUInteger)index RadioElement:(RadioElement *)radioElement {
    self = [super init];
    _radioElement = radioElement;
    _index = index;
    _title = [[radioElement.items objectAtIndex:_index] description];
    return self;
}

- (RadioItemElement *)initWithIndex:(NSUInteger)index RadioSection:(RadioSection *)section {
    self = [super init];
    _radioSection = section;
    _index = index;
    _title = [[_radioSection.items objectAtIndex:_index] description];
    return self;
}

- (UITableViewCell *)getCellForTableView:(QuickDialogTableView *)tableView controller:(QuickDialogController *)controller {
    UITableViewCell *cell = [super getCellForTableView:tableView controller:controller];
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    cell.accessoryType = _radioElement.selected == _index ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
    return cell;
}

- (void)selected:(QuickDialogTableView *)tableView controller:(QuickDialogController *)controller indexPath:(NSIndexPath *)indexPath {
    [super selected:tableView controller:controller indexPath:indexPath];

    NSUInteger selectedIndex = _radioElement==nil? _radioSection.selected : _radioElement.selected;

    if (_index != selectedIndex) {
        UITableViewCell *oldCell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:selectedIndex inSection:indexPath.section]];
        oldCell.accessoryType = UITableViewCellAccessoryNone;
        [oldCell setNeedsDisplay];

        UITableViewCell *selectedCell = [tableView cellForRowAtIndexPath:indexPath];
        selectedCell.accessoryType = UITableViewCellAccessoryCheckmark;
    }

    if (_radioElement!= nil){
        _radioElement.selected = _index;
        tableView.userInteractionEnabled = NO;

        [NSTimer scheduledTimerWithTimeInterval:0.3
            target:controller
            selector:@selector(popToPreviousRootElement)
            userInfo:nil
            repeats:NO];

    } else if (_radioSection!=nil){
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        _radioSection.selected = _index;
    }
}


@end