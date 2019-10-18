library globals;

int waterCount = 0;
int drinkCount = 2;

double bac = 0.00;
double maxBAC = 0.00;

int waterAtMaxBAC = 0;

String selectedSex = '';
int selectedHeight = 0;
int selectedFeet = 0;
int selectedInches = 0;
int selectedWeight = 150;

double weightGrams = selectedWeight * 453.592;
int heightInches = 0;

var drinkTimes = new List();

var allDrinkTimes = new List();
var drinkTypes = new List();

var weights = [
  '100', '105', '110', '115', '120', '125', '130', '135', '140', '145',
  '150', '155', '160', '165', '170', '175','180', '185', '190', '195',
  '200','205', '210', '215', '220', '225', '230', '235', '240', '245',
  '250', '255', '260', '265', '270', '275','280', '285', '290', '295',
  '300', '305', '310', '315', '320', '325', '330', '335', '340', '345',
  '350', '355', '360', '365', '370', '375','380', '385', '390', '395',
  '400',
];

var sexes = [
  "Female", "Male", "Other"
];


