//
//  Student.m
//  L31-32_tableViewEditing
//
//  Created by Artsiom Dolia on 1/4/15.
//  Copyright (c) 2015 Artsiom Dolia. All rights reserved.
//

#import "Student.h"

@implementation Student

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.averageGrade = ((float)(arc4random()%201)/100)+2;
        self.studentName = [self getRandomName];
    }
    return self;
}

#pragma mark - Private methods

-(NSString *) getRandomName {
    
    NSArray *namesList = [NSArray arrayWithObjects:@"Leslee Hollister",@"Nannie Sepulveda", @"Richelle Furr", @"Simonne Gouin", @"Taina Detweiler", @"Aja Recalde", @"Joie Stabile", @"Ron Taff", @"Addie Reynold", @"Cathrine Crosley", @"Kristy Levens",@"Cruz Vanbeek",@"Reatha Deslauriers",@"Marcelene Trundy",@"Annmarie Sprung",@"Bernetta Arora",@"Cristie Geraghty",@"Oren Lefebure",@"Shirleen Odle",@"Caryn Doom",@"Marcos Oswald",@"Wayne Taillon",@"Joni Ort",@"Raisa Nickle",@"Jeannine Goode",@"Richard Schneller",@"Loni Renteria",@"Barbara Propp",@"Gayla Calabria",@"Jon Dittrich",@"Milo Keenum",@"Mirtha Hepner",@"Marci Mestayer",@"Latonya Darner",@"Abby Gravelle",@"Shelba Duke",@"Luciana Branam",@"Rima Breunig",@"Carlena Wyble",@"Claudio Madril",@"Juliana Bergdoll",@"Cleora Knudsen",@"Velia Winslett",@"Eden Blasingame",@"Loyd Wolff",@"Lorraine Verge",@"Delorse Zeck", nil];
    
    return [namesList objectAtIndex:arc4random()%(namesList.count)];
}

@end
