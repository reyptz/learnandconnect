import '../../data/repositories/user_repository.dart';
import '../../data/repositories/ticket_repository.dart';
import '../../data/repositories/category_repository.dart';
import '../../data/models/user_model.dart';
import '../../data/models/ticket_model.dart';
import '../../data/models/category_model.dart';

class FirestoreService {
  final UserRepository _userRepository = UserRepository();
  final TicketRepository _ticketRepository = TicketRepository();
  final CategoryRepository _categoryRepository = CategoryRepository();

  // Récupérer un utilisateur par ID
  Future<User?> getUserById(String userId) async {
    return await _userRepository.getUserById(userId);
  }

  // Créer un nouvel utilisateur
  Future<void> createUser(User user) async {
    await _userRepository.createUser(user);
  }

  // Mettre à jour un utilisateur
  Future<void> updateUser(User user) async {
    await _userRepository.updateUser(user);
  }

  // Récupérer un ticket par ID
  Future<Ticket?> getTicketById(String ticketId) async {
    return await _ticketRepository.getTicketById(ticketId);
  }

  // Créer un nouveau ticket
  Future<void> createTicket(Ticket ticket) async {
    await _ticketRepository.createTicket(ticket);
  }

  // Récupérer une catégorie par ID
  Future<Category?> getCategoryById(String categoryId) async {
    return await _categoryRepository.getCategoryById(categoryId);
  }

  // Créer une nouvelle catégorie
  Future<void> createCategory(Category category) async {
    await _categoryRepository.createCategory(category);
  }
}
