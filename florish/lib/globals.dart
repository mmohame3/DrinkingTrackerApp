library globals;
import 'package:Florish/models/day_model.dart';
/// Global variables used across the app


Day today;
double bac = 0.00;
String imageName = 'assets/plants/drink0water0.png';

final int resetTime = 6;
final double maxBAC = 0.15;
final int numberOfDrinkPlants = 9;
final int numberOfWaterPlants = 9;
final double bacDropPerHour = .015;

String selectedSex = 'Other';
int selectedFeet = 0;
int selectedInches = 0;
int selectedWeight = 180;

double weightGrams = selectedWeight * 453.592;
int heightInches = 0;

bool dayEnded = false;
int yesterDrink = 0;
int yesterWater = 0;
double yesterLastBAC = 0.0;
int yesterLastDrinkToResetMinutes = 0;
double yesterHydratio = 0.0;

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
  "Other", "Female", "Male"
];


