import 'role_repository.dart';
import 'models/role_model.dart';

class RoleService {
  final RoleRepository _roleRepository = RoleRepository();

  // Récupérer les détails d'un rôle par son nom
  Future<Role?> getRoleByName(String roleName) async {
    return await _roleRepository.getRoleByName(roleName);
  }

  // Attribuer un rôle à un utilisateur
  Future<void> assignRoleToUser(String userId, String roleName) async {
    Role? role = await _roleRepository.getRoleByName(roleName);
    if (role != null) {
      await _roleRepository.assignRoleToUser(userId, role.roleId);
    }
  }

  // Vérifier si un utilisateur a un rôle spécifique
  Future<bool> userHasRole(String userId, String roleName) async {
    Role? role = await _roleRepository.getRoleByName(roleName);
    if (role != null) {
      return await _roleRepository.userHasRole(userId, role.roleId);
    }
    return false;
  }
}
