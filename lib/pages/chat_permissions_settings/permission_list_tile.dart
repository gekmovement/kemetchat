import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:matrix/matrix.dart';

import 'package:fluffychat/config/app_config.dart';

class PermissionsListTile extends StatelessWidget {
  final String permissionKey;
  final int permission;
  final String? category;
  final void Function(int? level)? onChanged;
  final bool canEdit;

  const PermissionsListTile({
    super.key,
    required this.permissionKey,
    required this.permission,
    this.category,
    required this.onChanged,
    required this.canEdit,
  });

  String getLocalizedPowerLevelString(BuildContext context) {
    if (category == null) {
      switch (permissionKey) {
        case 'users_default':
          return L10n.of(context)!.defaultPermissionLevel;
        case 'events_default':
          return L10n.of(context)!.sendMessages;
        case 'state_default':
          return L10n.of(context)!.changeGeneralChatSettings;
        case 'ban':
          return L10n.of(context)!.banFromChat;
        case 'kick':
          return L10n.of(context)!.kickFromChat;
        case 'redact':
          return L10n.of(context)!.deleteMessage;
        case 'invite':
          return L10n.of(context)!.inviteOtherUsers;
      }
    } else if (category == 'notifications') {
      switch (permissionKey) {
        case 'rooms':
          return L10n.of(context)!.sendRoomNotifications;
      }
    } else if (category == 'events') {
      switch (permissionKey) {
        case EventTypes.RoomName:
          return L10n.of(context)!.changeTheNameOfTheGroup;
        case EventTypes.RoomTopic:
          return L10n.of(context)!.changeTheDescriptionOfTheGroup;
        case EventTypes.RoomPowerLevels:
          return L10n.of(context)!.changeTheChatPermissions;
        case EventTypes.HistoryVisibility:
          return L10n.of(context)!.changeTheVisibilityOfChatHistory;
        case EventTypes.RoomCanonicalAlias:
          return L10n.of(context)!.changeTheCanonicalRoomAlias;
        case EventTypes.RoomAvatar:
          return L10n.of(context)!.editRoomAvatar;
        case EventTypes.RoomTombstone:
          return L10n.of(context)!.replaceRoomWithNewerVersion;
        case EventTypes.Encryption:
          return L10n.of(context)!.enableEncryption;
        case 'm.room.server_acl':
          return L10n.of(context)!.editBlockedServers;
      }
    }
    return permissionKey;
  }

  @override
  Widget build(BuildContext context) {
    final color = permission >= 100
        ? Colors.orangeAccent
        : permission >= 50
            ? Colors.blueAccent
            : Colors.greenAccent;
    return ListTile(
      title: Text(
        getLocalizedPowerLevelString(context),
        style: Theme.of(context).textTheme.titleSmall,
      ),
      trailing: Material(
        color: color.withAlpha(64),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConfig.borderRadius / 2),
          side: BorderSide(color: color),
        ),
        child: DropdownButton<int>(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          borderRadius: BorderRadius.circular(AppConfig.borderRadius / 2),
          underline: const SizedBox.shrink(),
          onChanged: canEdit ? onChanged : null,
          value: permission,
          items: [
            DropdownMenuItem(
              value: permission < 50 ? permission : 0,
              child: Text(L10n.of(context)!.userLevel(permission)),
            ),
            DropdownMenuItem(
              value: permission < 100 && permission >= 50 ? permission : 50,
              child: Text(L10n.of(context)!.moderatorLevel(permission)),
            ),
            DropdownMenuItem(
              value: permission >= 100 ? permission : 100,
              child: Text(L10n.of(context)!.adminLevel(permission)),
            ),
            DropdownMenuItem(
              value: null,
              child: Text(L10n.of(context)!.custom),
            ),
          ],
        ),
      ),
    );
  }
}
