library globals;
import 'package:Florish/helpers/database_helpers.dart';

Day today;
double bac = 0.00;
String imageName = 'assets/images/plants/drink0water0.png';

String selectedSex = 'Other';
int selectedHeight = 0;
int selectedFeet = 0;
int selectedInches = 0;
int selectedWeight = 180;

double weightGrams = selectedWeight * 453.592;
int heightInches = 0;

bool dayEnded = false;
int yesterDrink = 0;
int yesterWater = 0;

var weights = [
  '100', '105', '110', '115', '120', '125', '130', '135', '140', '145',
  '150', '155', '160', '165', '170', '175','180', '185', '190', '195',
  '200','205', '210', '215', '220', '225', '230', '235', '240', '245',
  '250', '255', '260', '265', '270', '275','280', '285', '290', '295',
  '300', '305', '310', '315', '320', '325', '330', '335', '340', '345',
  '350', '355', '360', '365', '370', '375','380', '385', '390', '395',
  '400'
];

var sexes = [
  "Female", "Male", "Other"
];


