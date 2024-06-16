import '../models/animal.dart';
import 'package:uuid/uuid.dart';

final Uuid uuid = Uuid();

List<Animal> animalList = [
  Animal(
    id: uuid.v4(),
    imageUrl: 'assets/images/userImage.jpg',
    name: 'Max',
    gender: 'Male',
    type: 'Dog',
    size: 'Medium',
    age: 3,
    description: 'Max is a friendly and energetic dog who loves to play fetch and go on long walks. He is very loyal to his owners and gets along well with other pets. Max is always ready for an adventure and loves to meet new people.',
    personality: ['Playful'],
  ),
  Animal(
    id: uuid.v4(),
    imageUrl: 'assets/images/userImage.jpg',
    name: 'Bella',
    gender: 'Female',
    type: 'Cat',
    size: 'Small',
    age: 2,
    description: 'Bella is a curious and independent cat who enjoys exploring her surroundings. She is quite the observer and loves to perch herself in high places to watch over everything. Bella is also very affectionate and enjoys quiet moments with her human friends.',
    personality: ['Curious', 'Independent', 'Quiet'],
  ),
  Animal(
    id: uuid.v4(),
    imageUrl: 'assets/images/userImage.jpg',
    name: 'Charlie',
    gender: 'Male',
    type: 'Rabbit',
    size: 'Small',
    age: 1,
    description: 'Charlie is a gentle and cuddly rabbit who loves to be held and petted. He enjoys munching on fresh vegetables and hopping around the garden. Charlie is very calm and quiet, making him a perfect companion for a peaceful home.',
    personality: ['Gentle', 'Cuddly', 'Quiet'],
  ),
  Animal(
    id: uuid.v4(),
    imageUrl: 'assets/images/userImage.jpg',
    name: 'Lucy',
    gender: 'Female',
    type: 'Bird',
    size: 'Small',
    age: 4,
    description: 'Lucy is a vibrant and talkative parrot who loves to interact with people. She enjoys mimicking sounds and having conversations. Lucy is very intelligent and can learn new tricks quickly. She brings a lot of joy and color to her surroundings.',
    personality: ['Talkative', 'Vibrant', 'Intelligent'],
  ),
  Animal(
    id: uuid.v4(),
    imageUrl: 'assets/images/userImage.jpg',
    name: 'Max',
    gender: 'Male',
    type: 'Dog',
    size: 'Medium',
    age: 3,
    description: 'Max is a friendly and energetic dog who loves to play fetch and go on long walks. He is very loyal to his owners and gets along well with other pets. Max is always ready for an adventure and loves to meet new people.',
    personality: ['Playful', 'Loyal', 'Friendly'],
  ),
  Animal(
    id: uuid.v4(),
    imageUrl: 'assets/images/userImage.jpg',
    name: 'Bella',
    gender: 'Female',
    type: 'Cat',
    size: 'Small',
    age: 2,
    description: 'Bella is a curious and independent cat who enjoys exploring her surroundings. She is quite the observer and loves to perch herself in high places to watch over everything. Bella is also very affectionate and enjoys quiet moments with her human friends.',
    personality: ['Curious', 'Independent', 'Quiet'],
  ),
  Animal(
    id: uuid.v4(),
    imageUrl: 'assets/images/userImage.jpg',
    name: 'Max',
    gender: 'Male',
    type: 'Dog',
    size: 'Medium',
    age: 3,
    description: 'Max is a friendly and energetic dog who loves to play fetch and go on long walks. He is very loyal to his owners and gets along well with other pets. Max is always ready for an adventure and loves to meet new people.',
    personality: ['Playful', 'Loyal', 'Friendly'],
  ),
  Animal(
    id: uuid.v4(),
    imageUrl: 'assets/images/userImage.jpg',
    name: 'Bella',
    gender: 'Female',
    type: 'Cat',
    size: 'Small',
    age: 2,
    description: 'Bella is a curious and independent cat who enjoys exploring her surroundings. She is quite the observer and loves to perch herself in high places to watch over everything. Bella is also very affectionate and enjoys quiet moments with her human friends.',
    personality: ['Curious', 'Independent', 'Quiet', 'Lovely', 'Cute'],
  ),
];

Animal getAnimalById(String id) {
  for (Animal animal in animalList) {
    if (animal.id == id) {
      return animal;
    }
  }
  // Return null if no animal with the given id is found
  return animalList[0];
}