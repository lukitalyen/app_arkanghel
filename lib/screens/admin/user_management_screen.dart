import 'package:app_arkanghel/models/user.dart';
import 'package:app_arkanghel/services/auth_service.dart';
import 'package:app_arkanghel/services/content_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserManagementScreen extends StatelessWidget {
  const UserManagementScreen({super.key});

  void _showConfigureWorkstreamsDialog(BuildContext context, User user) {
    final contentProvider = Provider.of<ContentService>(context, listen: false);
    final authProvider = Provider.of<AuthService>(context, listen: false);
    final allWorkstreams = contentProvider.workstreams;
    final assignedIds = List<String>.from(user.assignedWorkstreamIds);
    // Ensure all employees have at least 5 published workstreams assigned by default
    if (user.role == UserRole.employee && assignedIds.length < 5) {
      final publishedIds = allWorkstreams
          .where((w) => w.isPublished)
          .map((w) => w.id)
          .take(5)
          .toList();
      for (final id in publishedIds) {
        if (!assignedIds.contains(id)) {
          assignedIds.add(id);
        }
      }
    }

    showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text('Configure Workstreams for ${user.fullName}'),
              content: SizedBox(
                width: double.maxFinite,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: allWorkstreams.length,
                  itemBuilder: (context, index) {
                    final workstream = allWorkstreams[index];
                    return CheckboxListTile(
                      title: Text(workstream.title),
                      value: assignedIds.contains(workstream.id),
                      onChanged: (bool? value) {
                        setDialogState(() {
                          if (value == true) {
                            assignedIds.add(workstream.id);
                          } else {
                            assignedIds.remove(workstream.id);
                          }
                        });
                      },
                    );
                  },
                ),
              ),
              actions: [
                TextButton(
                  child: const Text('Cancel'),
                  onPressed: () => Navigator.of(ctx).pop(),
                ),
                TextButton(
                  child: const Text('Save'),
                  onPressed: () {
                    final updatedUser = user.copyWith(assignedWorkstreamIds: assignedIds);
                    authProvider.updateUser(updatedUser);
                    Navigator.of(ctx).pop();
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        toolbarHeight: 0,
      ),
      body: Consumer<AuthService>(
        builder: (context, authService, child) {
          if (authService.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (authService.users.isEmpty) {
            return const Center(child: Text('No users found.'));
          }
          return Column(
            children: [
              _buildHeader(),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  itemCount: authService.users.length,
                  itemBuilder: (context, index) {
                    final user = authService.users[index];
                    return Dismissible(
                      key: Key(user.id),
                      direction: DismissDirection.endToStart,
                      background: Container(
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        decoration: BoxDecoration(
                          color: Colors.red.shade400,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Icon(Icons.delete, color: Colors.white, size: 28),
                      ),
                      confirmDismiss: (direction) async {
                        bool? shouldDelete = await showDialog(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            title: const Text('Are you sure?'),
                            content: const Text('Do you want to remove this user?'),
                            actions: <Widget>[
                              TextButton(
                                child: const Text('No'),
                                onPressed: () => Navigator.of(ctx).pop(false),
                              ),
                              TextButton(
                                child: const Text('Yes'),
                                onPressed: () => Navigator.of(ctx).pop(true),
                              ),
                            ],
                          ),
                        );
                        return shouldDelete == true;
                      },
                      onDismissed: (direction) {
                        Provider.of<AuthService>(context, listen: false).deleteUser(user.id);
                      },
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            _buildUserInfoCell(user, 5),
                            _buildRoleCell(context, authService, user, 4),
                            _buildAccessCell(context, user, 3),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0),
      child: Row(
        children: [
          _buildHeaderCell('Name', 6),
          _buildHeaderCell('Role', 4, alignment: TextAlign.center),
          _buildHeaderCell('Access', 3, alignment: TextAlign.right),
        ],
      ),
    );
  }

  Widget _buildHeaderCell(String text, int flex, {TextAlign alignment = TextAlign.start}) {
    return Expanded(
      flex: flex,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0),
        child: Text(
          text.toUpperCase(),
          textAlign: alignment,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 12,
            color: Color(0xFF6B7280),
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }

  Widget _buildUserInfoCell(User user, int flex) {
    return Expanded(
      flex: flex,
      child: Row(
        children: [
          CircleAvatar(
            radius: 22,
            backgroundColor: const Color(0xFFD1D5DB),
            child: CircleAvatar(
              radius: 20,
              backgroundImage: user.avatarUrl != null ? NetworkImage(user.avatarUrl!) : null,
              child: user.avatarUrl == null ? const Icon(Icons.person, size: 20) : null,
            ),
          ),
          const SizedBox(width: 12),
          Flexible(
            child: Text(
              user.fullName,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRoleCell(BuildContext context, AuthService authService, User user, int flex) {
    final isAdmin = user.role == UserRole.admin;
    final color = isAdmin ? const Color(0xFFDBEAFE) : const Color(0xFFFEF3C7);
    final textColor = isAdmin ? const Color(0xFF1E40AF) : const Color(0xFF92400E);

    return Expanded(
      flex: flex,
      child: Container(
        height: 36,
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(18.0),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<UserRole>(
            value: user.role,
            isExpanded: true,
            icon: Icon(Icons.unfold_more_rounded, color: textColor, size: 20),
            items: UserRole.values.map((role) {
              return DropdownMenuItem(
                value: role,
                child: Center(
                  child: Text(
                    role.name,
                    style: TextStyle(color: textColor, fontWeight: FontWeight.w500, fontSize: 13),
                    textAlign: TextAlign.center,
                  ),
                ),
              );
            }).toList(),
            onChanged: (newRole) {
              if (newRole != null) {
                final updatedUser = user.copyWith(role: newRole);
                authService.updateUser(updatedUser);
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _buildAccessCell(BuildContext context, User user, int flex) {
    return Expanded(
      flex: flex,
      child: Center(
        child: IconButton(
          icon: const Icon(Icons.settings_outlined, color: Color(0xFF4B5563), size: 20),
          onPressed: () => _showConfigureWorkstreamsDialog(context, user),
          tooltip: 'Configure Workstreams',
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(minWidth: 24, minHeight: 24),
        ),
      ),
    );
  }
}
