import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../repository/user_repository.dart';
import '../repository/analytics_repository.dart';
import 'user_cubit.dart';

/// {@template user_page}
/// Page that demonstrates RepositoryProvider usage
/// {@endtemplate}
class UserPage extends StatelessWidget {
  const UserPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      // Access repository from context and inject into cubit
      create: (context) => UserCubit(
        context.read<UserRepository>(),
        analyticsRepository: context.read<AnalyticsRepository>(),
      )..loadUsers(),
      child: const UserView(),
    );
  }
}

/// {@template user_view}
/// View that demonstrates repository usage patterns
/// {@endtemplate}
class UserView extends StatelessWidget {
  const UserView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Users - RepositoryProvider Demo'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () =>
                context.read<UserCubit>().eventSink.add(LoadUsersSinkEvent()),
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showAddUserDialog(context),
          ),
          // New: Sink demo button
          IconButton(
            icon: const Icon(Icons.batch_prediction),
            onPressed: () => _showBatchOperationsDialog(context),
          ),
        ],
      ),
      body: BlocConsumer<UserCubit, UserState>(
        listener: (context, state) {
          if (state.error != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.error!),
                backgroundColor: Colors.red,
                action: SnackBarAction(
                  label: 'Dismiss',
                  onPressed: () => context.read<UserCubit>().clearError(),
                ),
              ),
            );
          }
        },
        builder: (context, state) {
          if (state.isLoading && state.users.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          return Column(
            children: [
              // Repository info panel
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'RepositoryProvider Demo',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Repository: ${context.read<UserRepository>().runtimeType}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    Text(
                      'Users loaded: ${state.users.length}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),

              // User list
              Expanded(
                child: state.users.isEmpty
                    ? const Center(
                        child: Text('No users found. Tap + to add a user.'),
                      )
                    : ListView.builder(
                        itemCount: state.users.length,
                        itemBuilder: (context, index) {
                          final user = state.users[index];
                          return Card(
                            margin: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 4,
                            ),
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor:
                                    user.isActive ? Colors.green : Colors.grey,
                                child: Text(
                                  user.name.substring(0, 1).toUpperCase(),
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ),
                              title: Text(user.name),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(user.email),
                                  Text(
                                    user.isActive ? 'Active' : 'Inactive',
                                    style: TextStyle(
                                      color: user.isActive
                                          ? Colors.green
                                          : Colors.grey,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                              trailing: PopupMenuButton(
                                itemBuilder: (context) => [
                                  PopupMenuItem(
                                    value: 'edit',
                                    child: const Text('Edit'),
                                    onTap: () =>
                                        _showEditUserDialog(context, user),
                                  ),
                                  PopupMenuItem(
                                    value: 'delete',
                                    child: const Text('Delete'),
                                    onTap: () => context
                                        .read<UserCubit>()
                                        .deleteUser(user.id),
                                  ),
                                  PopupMenuItem(
                                    value: 'select',
                                    child: const Text('Select'),
                                    onTap: () => context
                                        .read<UserCubit>()
                                        .selectUser(user.id),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ),

              // Selected user info
              if (state.selectedUser != null)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  color: Theme.of(context).colorScheme.primaryContainer,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Selected User',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      Text('Name: ${state.selectedUser!.name}'),
                      Text('Email: ${state.selectedUser!.email}'),
                      Text(
                          'Status: ${state.selectedUser!.isActive ? 'Active' : 'Inactive'}'),
                    ],
                  ),
                ),

              // Loading indicator
              if (state.isLoading) const LinearProgressIndicator(),
            ],
          );
        },
      ),
    );
  }

  void _showAddUserDialog(BuildContext context) {
    final nameController = TextEditingController();
    final emailController = TextEditingController();

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Add User'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (nameController.text.isNotEmpty &&
                  emailController.text.isNotEmpty) {
                context.read<UserCubit>().createUser(
                      nameController.text,
                      emailController.text,
                    );
                Navigator.of(dialogContext).pop();
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void _showEditUserDialog(BuildContext context, User user) {
    final nameController = TextEditingController(text: user.name);
    final emailController = TextEditingController(text: user.email);

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Edit User'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            SwitchListTile(
              title: const Text('Active'),
              value: user.isActive,
              onChanged: (value) {
                // This would need a more complex state management
                // For now, we'll update when saving
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (nameController.text.isNotEmpty &&
                  emailController.text.isNotEmpty) {
                final updatedUser = user.copyWith(
                  name: nameController.text,
                  email: emailController.text,
                );
                context.read<UserCubit>().updateUser(updatedUser);
                Navigator.of(dialogContext).pop();
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showBatchOperationsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Batch Operations (Sink Demo)'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Demonstrate batch operations using Sink:'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Queue multiple operations via sink
                final cubit = context.read<UserCubit>();
                cubit.processBatchOperations([
                  CreateUserSinkEvent('Batch User 1', 'batch1@example.com'),
                  CreateUserSinkEvent('Batch User 2', 'batch2@example.com'),
                  LoadUsersSinkEvent(),
                ]);
                Navigator.of(dialogContext).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text('Batch operations queued via Sink!')),
                );
              },
              child: const Text('Create 2 Users + Reload'),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () {
                // Single operation via sink
                context
                    .read<UserCubit>()
                    .queueUserOperation(LoadUsersSinkEvent());
                Navigator.of(dialogContext).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Reload queued via Sink!')),
                );
              },
              child: const Text('Queue Reload Only'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }
}
