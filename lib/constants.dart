import 'dart:core';

final EMAIL_REGEX = RegExp(r'^[^@]+@[^@]+\.[^@]+');

final PHONE_REGEX = RegExp(r'^\d+$');

const String USER_PLACEHOLDER_IMG = 'https://upload.wikimedia.org/wikipedia/commons/8/89/Portrait_Placeholder.png';
// final String USER_PLACEHOLDER_IMG = 'https://i.pravatar.cc/150?img=10';

const List<String> personalityTags = [
  'Playful',
  'Cuddly',
  'Independent',
  'Intelligent',
  'Curious',
  'Energetic',
  'Calm',
  'Gentle',
  'Affectionate',
  'Vocal',
  'Loyal',
  'Mischievous',
  'Shy',
  'Social',
  'Nocturnal',
  'Crepuscular',
  'Solitary',
  'Drama Queen',
  'Clown',
  'Klutz',
  'Grumpy',
  'Foodie',
];

const List<String> animalTypes = [
  'Cat',
  'Dog',
  'Bird',
  'Turtle',
  'Fish',
  'Rabbit',
  'Salamander',
  'Hamster',
];

const List<String> genders = [
  'Male',
  'Female',
];

const List<String> ageOptions = [
  'Less than 3',
  'Equal or greater than 3',
];