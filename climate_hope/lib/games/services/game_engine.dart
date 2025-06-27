import '../models/game_item.dart';
import '../data/items.dart';

class GameEngine {
  List<GameItem> getRandomItems() {
    final randomItems = [...items];
    randomItems.shuffle();
    return randomItems;
  }
}