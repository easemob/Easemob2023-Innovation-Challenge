// mappings.dart
import 'package:flutter/material.dart';

class UserAvatarMappings {
  static final Map<String, ImageProvider> _userAvatarMap = {
    'clientA': AssetImage('assets/avatars/avatar1.jpg'),
    'clientB': AssetImage('assets/avatars/avatar2.jpg'),
    'clientC': AssetImage('assets/avatars/avatar3.jpg'),
  };

  static ImageProvider getAvatar(String userId) {
    return _userAvatarMap[userId] ?? AssetImage('assets/avatars/agent_avatar.jpg');
  }
}
