import 'package:flutter/material.dart';

import 'package:butterflyui_runtime/src/core/control_utils.dart';
import 'package:butterflyui_runtime/src/core/controls/common/color_value.dart';

IconData? parseIconDataLoose(Object? value) {
  if (value == null) return null;
  final raw = value.toString().trim();
  if (raw.isEmpty) return null;
  final key = raw.toLowerCase().replaceAll('-', '_').replaceAll(' ', '_');
  return _iconAliases[key];
}

Widget? buildIconValue(
  Object? value, {
  Object? colorValue,
  Color? color,
  Color? background,
  double? size,
  TextStyle? textStyle,
  bool autoContrast = false,
  double minContrast = 4.5,
  IconData? fallbackIcon,
}) {
  if (value == null) return null;

  final resolvedColor =
      resolveColorValue(
        colorValue ?? color,
        fallback: color,
        background: background,
        autoContrast: autoContrast,
        minContrast: minContrast,
      ) ??
      color;

  if (value is IconData) {
    return Icon(value, size: size, color: resolvedColor);
  }

  if (value is Map) {
    final map = coerceObjectMap(value);

    final typeToken = map['type']?.toString().trim().toLowerCase();
    if (typeToken != null && typeToken.isNotEmpty && map['props'] is Map) {
      final nestedProps = coerceObjectMap(map['props'] as Map);
      if (typeToken == 'icon' ||
          typeToken == 'glyph_button' ||
          typeToken == 'icon_button' ||
          typeToken == 'emoji_icon') {
        final nestedValue =
            nestedProps['icon'] ??
            nestedProps['glyph'] ??
            nestedProps['emoji'] ??
            nestedProps['value'] ??
            nestedProps['name'];
        return buildIconValue(
          nestedValue,
          colorValue: nestedProps['color'] ?? colorValue,
          color: resolvedColor,
          background:
              background ??
              resolveColorValue(
                nestedProps['background'] ?? nestedProps['bgcolor'],
              ),
          size: coerceDouble(nestedProps['size']) ?? size,
          textStyle: textStyle,
          autoContrast:
              coerceBool(nestedProps['auto_contrast']) ?? autoContrast,
          minContrast: coerceDouble(nestedProps['min_contrast']) ?? minContrast,
          fallbackIcon: fallbackIcon,
        );
      }
    }

    final codepoint = _parseIconCodepoint(
      map['codepoint'] ?? map['unicode'] ?? map['code'] ?? map['glyph'],
    );
    if (codepoint != null) {
      final fontFamily = map['font_family']?.toString();
      final fontPackage = map['font_package']?.toString();
      final matchTextDirection =
          coerceBool(map['match_text_direction']) ?? false;
      return _buildIconFromCodepoint(
        codepoint,
        fontFamily: fontFamily,
        fontPackage: fontPackage,
        matchTextDirection: matchTextDirection,
        size: size,
        color: resolvedColor,
        textStyle: textStyle,
        fallbackIcon: fallbackIcon,
      );
    }

    final nested =
        map['icon'] ??
        map['name'] ??
        map['value'] ??
        map['text'] ??
        map['label'];
    if (nested != null) {
      return buildIconValue(
        nested,
        colorValue: map['color'] ?? colorValue,
        color: resolvedColor,
        background:
            background ??
            resolveColorValue(map['background'] ?? map['bgcolor']),
        size: coerceDouble(map['size']) ?? size,
        textStyle: textStyle,
        autoContrast: coerceBool(map['auto_contrast']) ?? autoContrast,
        minContrast: coerceDouble(map['min_contrast']) ?? minContrast,
        fallbackIcon: fallbackIcon,
      );
    }
  } else {
    final codepoint = _parseIconCodepoint(value);
    if (codepoint != null) {
      return _buildIconFromCodepoint(
        codepoint,
        fontFamily: 'MaterialIcons',
        size: size,
        color: resolvedColor,
        textStyle: textStyle,
        fallbackIcon: fallbackIcon,
      );
    }
  }

  final iconData = parseIconDataLoose(value);
  if (iconData != null) {
    return Icon(iconData, size: size, color: resolvedColor);
  }

  final text = value.toString().trim();
  if (text.isEmpty) return null;

  // Keep one/two-char glyph fallback (emoji/symbol) but avoid rendering long
  // icon names as plain text.
  if (text.runes.length <= 2) {
    return Text(
      text,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: (textStyle ?? TextStyle(fontSize: size, color: resolvedColor)),
    );
  }

  final fallback = fallbackIcon ?? Icons.help_outline;
  return Icon(fallback, size: size, color: resolvedColor);
}

int? _parseIconCodepoint(Object? value) {
  if (value == null) return null;
  if (value is int) return value;
  final raw = value.toString().trim();
  if (raw.isEmpty) return null;
  final normalized = raw.toLowerCase();
  if (normalized.startsWith('0x')) {
    return int.tryParse(normalized.substring(2), radix: 16);
  }
  if (normalized.startsWith(r'\u')) {
    return int.tryParse(normalized.substring(2), radix: 16);
  }
  if (normalized.startsWith('u+')) {
    return int.tryParse(normalized.substring(2), radix: 16);
  }
  return int.tryParse(normalized);
}

Widget _buildIconFromCodepoint(
  int codepoint, {
  String? fontFamily,
  String? fontPackage,
  bool matchTextDirection = false,
  double? size,
  Color? color,
  TextStyle? textStyle,
  IconData? fallbackIcon,
}) {
  if (_isMaterialIconFamily(fontFamily)) {
    final iconData = _materialIconsByCodepoint[codepoint];
    if (iconData != null) {
      return Icon(iconData, size: size, color: color);
    }
    return Icon(fallbackIcon ?? Icons.help_outline, size: size, color: color);
  }

  final baseStyle = textStyle ?? TextStyle(fontSize: size, color: color);
  final glyph = String.fromCharCode(codepoint);
  return Text(
    glyph,
    maxLines: 1,
    overflow: TextOverflow.ellipsis,
    style: baseStyle.copyWith(fontFamily: fontFamily, package: fontPackage),
  );
}

bool _isMaterialIconFamily(String? fontFamily) {
  if (fontFamily == null || fontFamily.trim().isEmpty) {
    return true;
  }
  final normalized = fontFamily
      .toLowerCase()
      .replaceAll('_', '')
      .replaceAll('-', '')
      .replaceAll(' ', '');
  return normalized == 'materialicons';
}

const Map<String, IconData> _iconAliases = <String, IconData>{
  'add': Icons.add,
  'add_box': Icons.add_box_outlined,
  'add_circle': Icons.add_circle_outline,
  'add_link': Icons.add_link,
  'add_photo': Icons.add_photo_alternate_outlined,
  'alarm': Icons.alarm_outlined,
  'analytics': Icons.analytics_outlined,
  'anchor': Icons.anchor_outlined,
  'android': Icons.android,
  'apple': Icons.apple,
  'apps': Icons.apps,
  'archive': Icons.archive_outlined,
  'arrow_back': Icons.arrow_back,
  'arrow_drop_down': Icons.arrow_drop_down,
  'arrow_drop_up': Icons.arrow_drop_up,
  'arrow_downward': Icons.arrow_downward,
  'arrow_down': Icons.expand_more,
  'arrow_forward': Icons.arrow_forward,
  'arrow_left': Icons.chevron_left,
  'arrow_right': Icons.chevron_right,
  'arrow_upward': Icons.arrow_upward,
  'arrow_up': Icons.expand_less,
  'assignment': Icons.assignment_outlined,
  'attach_file': Icons.attach_file,
  'attachment': Icons.attachment_outlined,
  'audiotrack': Icons.audiotrack_outlined,
  'auto_awesome': Icons.auto_awesome_outlined,
  'backspace': Icons.backspace_outlined,
  'backup': Icons.backup_outlined,
  'bar_chart': Icons.bar_chart_outlined,
  'battery_charging': Icons.battery_charging_full_outlined,
  'battery_full': Icons.battery_full_outlined,
  'beach': Icons.beach_access_outlined,
  'bed': Icons.bed_outlined,
  'bluetooth': Icons.bluetooth_outlined,
  'bolt': Icons.bolt_outlined,
  'bookmark': Icons.bookmark_outline,
  'bookmark_add': Icons.bookmark_add_outlined,
  'bug': Icons.bug_report_outlined,
  'build': Icons.build_outlined,
  'calendar': Icons.calendar_today_outlined,
  'call': Icons.call_outlined,
  'camera': Icons.camera_alt_outlined,
  'cancel': Icons.cancel_outlined,
  'car': Icons.directions_car_outlined,
  'category': Icons.category_outlined,
  'chat': Icons.chat_bubble_outline,
  'check': Icons.check,
  'check_box': Icons.check_box_outlined,
  'check_box_outline': Icons.check_box_outline_blank_outlined,
  'check_circle': Icons.check_circle_outline,
  'checklist': Icons.checklist_outlined,
  'chevron_down': Icons.expand_more,
  'chevron_left': Icons.chevron_left,
  'chevron_right': Icons.chevron_right,
  'chevron_up': Icons.expand_less,
  'circle': Icons.circle_outlined,
  'close': Icons.close,
  'cloud': Icons.cloud_outlined,
  'cloud_done': Icons.cloud_done_outlined,
  'cloud_download': Icons.cloud_download_outlined,
  'cloud_upload': Icons.cloud_upload_outlined,
  'code': Icons.code_outlined,
  'coffee': Icons.coffee_outlined,
  'color_lens': Icons.color_lens_outlined,
  'comment': Icons.comment_outlined,
  'compass': Icons.explore_outlined,
  'computer': Icons.computer_outlined,
  'construction': Icons.construction_outlined,
  'contact_mail': Icons.contact_mail_outlined,
  'copy': Icons.copy_outlined,
  'copy_all': Icons.copy_all_outlined,
  'dashboard': Icons.dashboard_outlined,
  'data': Icons.storage_outlined,
  'delete': Icons.delete_outline,
  'delete_forever': Icons.delete_forever_outlined,
  'description': Icons.description_outlined,
  'document': Icons.description_outlined,
  'download': Icons.download_outlined,
  'drag': Icons.drag_indicator,
  'draw': Icons.draw_outlined,
  'edit': Icons.edit_outlined,
  'email': Icons.email_outlined,
  'equalizer': Icons.equalizer_outlined,
  'error': Icons.error_outline,
  'event': Icons.event_outlined,
  'explore': Icons.explore_outlined,
  'extension': Icons.extension_outlined,
  'face': Icons.face_outlined,
  'favorite': Icons.favorite_outline,
  'feedback': Icons.feedback_outlined,
  'file': Icons.description_outlined,
  'file_copy': Icons.file_copy_outlined,
  'filter': Icons.filter_alt_outlined,
  'filter_list': Icons.filter_list_outlined,
  'fingerprint': Icons.fingerprint_outlined,
  'flag': Icons.flag_outlined,
  'flight': Icons.flight_outlined,
  'folder': Icons.folder_outlined,
  'folder_open': Icons.folder_open_outlined,
  'forum': Icons.forum_outlined,
  'fullscreen': Icons.fullscreen,
  'fullscreen_exit': Icons.fullscreen_exit,
  'functions': Icons.functions_outlined,
  'gamepad': Icons.sports_esports_outlined,
  'gavel': Icons.gavel_outlined,
  'gif': Icons.gif_box_outlined,
  'grade': Icons.grade_outlined,
  'grid': Icons.grid_view_outlined,
  'group': Icons.group_outlined,
  'handyman': Icons.handyman_outlined,
  'help': Icons.help_outline,
  'history': Icons.history_outlined,
  'home': Icons.home_outlined,
  'hourglass': Icons.hourglass_empty_outlined,
  'http': Icons.http_outlined,
  'image': Icons.image_outlined,
  'info': Icons.info_outline,
  'insights': Icons.insights_outlined,
  'inventory': Icons.inventory_2_outlined,
  'key': Icons.key_outlined,
  'keyboard': Icons.keyboard_outlined,
  'label': Icons.label_outline,
  'language': Icons.language_outlined,
  'laptop': Icons.laptop_outlined,
  'launch': Icons.launch_outlined,
  'lightbulb': Icons.lightbulb_outline,
  'link': Icons.link_outlined,
  'list': Icons.list_alt_outlined,
  'lock': Icons.lock_outline,
  'lock_open': Icons.lock_open_outlined,
  'login': Icons.login_outlined,
  'logout': Icons.logout_outlined,
  'mail': Icons.mail_outline,
  'map': Icons.map_outlined,
  'menu': Icons.menu,
  'mic': Icons.mic_outlined,
  'monitor': Icons.monitor_outlined,
  'more': Icons.more_horiz,
  'more_vert': Icons.more_vert,
  'movie': Icons.movie_outlined,
  'music': Icons.music_note_outlined,
  'new': Icons.new_releases_outlined,
  'night': Icons.nightlight_round,
  'notifications': Icons.notifications_outlined,
  'notifications_active': Icons.notifications_active_outlined,
  'notifications_off': Icons.notifications_off_outlined,
  'palette': Icons.palette_outlined,
  'pause': Icons.pause,
  'payment': Icons.payment_outlined,
  'pending': Icons.pending_outlined,
  'percent': Icons.percent_outlined,
  'person': Icons.person_outline,
  'person_add': Icons.person_add_alt_outlined,
  'pets': Icons.pets_outlined,
  'photo': Icons.photo_outlined,
  'play': Icons.play_arrow,
  'play_circle': Icons.play_circle_outline,
  'print': Icons.print_outlined,
  'privacy': Icons.privacy_tip_outlined,
  'public': Icons.public_outlined,
  'qr_code': Icons.qr_code_outlined,
  'question_answer': Icons.question_answer_outlined,
  'radio_checked': Icons.radio_button_checked,
  'radio_unchecked': Icons.radio_button_unchecked,
  'refresh': Icons.refresh,
  'remove': Icons.remove,
  'remove_circle': Icons.remove_circle_outline,
  'repeat': Icons.repeat,
  'reply': Icons.reply_outlined,
  'report': Icons.report_problem_outlined,
  'rocket': Icons.rocket_launch_outlined,
  'route': Icons.route_outlined,
  'save': Icons.save_outlined,
  'save_alt': Icons.save_alt_outlined,
  'schedule': Icons.schedule_outlined,
  'school': Icons.school_outlined,
  'science': Icons.science_outlined,
  'search': Icons.search,
  'send': Icons.send_outlined,
  'share': Icons.share_outlined,
  'shield': Icons.security_outlined,
  'shop': Icons.shopping_bag_outlined,
  'shopping_cart': Icons.shopping_cart_outlined,
  'shuffle': Icons.shuffle,
  'settings': Icons.settings_outlined,
  'star': Icons.star_outline,
  'star_half': Icons.star_half,
  'stop': Icons.stop,
  'storage': Icons.storage_outlined,
  'success': Icons.check_circle_outline,
  'sun': Icons.wb_sunny_outlined,
  'support': Icons.support_agent_outlined,
  'swap': Icons.swap_horiz_outlined,
  'sync': Icons.sync_outlined,
  'table': Icons.table_chart_outlined,
  'tag': Icons.sell_outlined,
  'task': Icons.task_alt_outlined,
  'terminal': Icons.terminal_outlined,
  'thumb_up': Icons.thumb_up_alt_outlined,
  'time': Icons.access_time_outlined,
  'today': Icons.today_outlined,
  'toggle_off': Icons.toggle_off_outlined,
  'toggle_on': Icons.toggle_on_outlined,
  'translate': Icons.translate_outlined,
  'trending_down': Icons.trending_down_outlined,
  'trending_up': Icons.trending_up_outlined,
  'tune': Icons.tune_outlined,
  'undo': Icons.undo_outlined,
  'update': Icons.update_outlined,
  'upload': Icons.upload_outlined,
  'upload_file': Icons.upload_file_outlined,
  'verified': Icons.verified_outlined,
  'video': Icons.videocam_outlined,
  'video_call': Icons.video_call_outlined,
  'visibility': Icons.visibility_outlined,
  'visibility_off': Icons.visibility_off_outlined,
  'volume_off': Icons.volume_off_outlined,
  'volume_up': Icons.volume_up_outlined,
  'vpn_key': Icons.vpn_key_outlined,
  'wallet': Icons.account_balance_wallet_outlined,
  'warning': Icons.warning_amber_rounded,
  'watch': Icons.watch_outlined,
  'web': Icons.web_outlined,
  'wifi': Icons.wifi_outlined,
  'work': Icons.work_outline,
  // Extra alias coverage for ergonomic name matching.
  'plus': Icons.add,
  'plus_circle': Icons.add_circle_outline,
  'plus_box': Icons.add_box_outlined,
  'minus': Icons.remove,
  'minus_circle': Icons.remove_circle_outline,
  'x': Icons.close,
  'x_circle': Icons.cancel_outlined,
  'cancel_circle': Icons.cancel_outlined,
  'trash': Icons.delete_outline,
  'trash_forever': Icons.delete_forever_outlined,
  'bin': Icons.delete_outline,
  'copy_clipboard': Icons.copy_outlined,
  'duplicate': Icons.copy_all_outlined,
  'clipboard': Icons.copy_outlined,
  'redo': Icons.reply_outlined,
  'fast_forward': Icons.trending_up_outlined,
  'rewind': Icons.trending_down_outlined,
  'hamburger': Icons.menu,
  'kebab': Icons.more_vert,
  'ellipsis': Icons.more_horiz,
  'ellipsis_vertical': Icons.more_vert,
  'caret_down': Icons.expand_more,
  'caret_up': Icons.expand_less,
  'caret_left': Icons.chevron_left,
  'caret_right': Icons.chevron_right,
  'chevron_down_small': Icons.expand_more,
  'chevron_up_small': Icons.expand_less,
  'house': Icons.home_outlined,
  'house_filled': Icons.home_outlined,
  'user': Icons.person_outline,
  'user_plus': Icons.person_add_alt_outlined,
  'users': Icons.group_outlined,
  'profile': Icons.person_outline,
  'avatar': Icons.person_outline,
  'gear': Icons.settings_outlined,
  'cog': Icons.settings_outlined,
  'slider': Icons.tune_outlined,
  'adjust': Icons.tune_outlined,
  'funnel': Icons.filter_alt_outlined,
  'funnel_list': Icons.filter_list_outlined,
  'favourite': Icons.favorite_outline,
  'heart': Icons.favorite_outline,
  'bookmark_outline': Icons.bookmark_outline,
  'bookmark_plus': Icons.bookmark_add_outlined,
  'pin': Icons.label_outline,
  'tag_outline': Icons.sell_outlined,
  'price_tag': Icons.sell_outlined,
  'ticket': Icons.confirmation_number_outlined,
  'label_outline': Icons.label_outline,
  'bell': Icons.notifications_outlined,
  'bell_off': Icons.notifications_off_outlined,
  'bell_active': Icons.notifications_active_outlined,
  'alert': Icons.warning_amber_rounded,
  'alert_outline': Icons.warning_amber_rounded,
  'danger': Icons.error_outline,
  'danger_outline': Icons.error_outline,
  'info_outline': Icons.info_outline,
  'question': Icons.help_outline,
  'question_outline': Icons.help_outline,
  'shield_outline': Icons.security_outlined,
  'security': Icons.security_outlined,
  'lock_outline': Icons.lock_outline,
  'unlock': Icons.lock_open_outlined,
  'unlock_outline': Icons.lock_open_outlined,
  'key_outline': Icons.key_outlined,
  'scan': Icons.qr_code_outlined,
  'qr': Icons.qr_code_outlined,
  'code_outline': Icons.code_outlined,
  'terminal_outline': Icons.terminal_outlined,
  'console': Icons.terminal_outlined,
  'braces': Icons.code_outlined,
  'database': Icons.storage_outlined,
  'server': Icons.storage_outlined,
  'cloud_done_outline': Icons.cloud_done_outlined,
  'cloud_upload_outline': Icons.cloud_upload_outlined,
  'cloud_download_outline': Icons.cloud_download_outlined,
  'upload_outline': Icons.upload_outlined,
  'download_outline': Icons.download_outlined,
  'upload_cloud': Icons.cloud_upload_outlined,
  'download_cloud': Icons.cloud_download_outlined,
  'folder_outline': Icons.folder_outlined,
  'folder_open_outline': Icons.folder_open_outlined,
  'document_text': Icons.description_outlined,
  'document_outline': Icons.description_outlined,
  'file_outline': Icons.description_outlined,
  'paperclip': Icons.attachment_outlined,
  'clip': Icons.attachment_outlined,
  'image_outline': Icons.image_outlined,
  'photo_outline': Icons.photo_outlined,
  'video_outline': Icons.videocam_outlined,
  'movie_outline': Icons.movie_outlined,
  'audio': Icons.music_note_outlined,
  'audio_outline': Icons.audiotrack_outlined,
  'music_note': Icons.music_note_outlined,
  'mic_outline': Icons.mic_outlined,
  'volume_high': Icons.volume_up_outlined,
  'volume_mute': Icons.volume_off_outlined,
  'mute': Icons.volume_off_outlined,
  'camera_outline': Icons.camera_alt_outlined,
  'camera_video': Icons.video_call_outlined,
  'phone': Icons.call_outlined,
  'phone_call': Icons.call_outlined,
  'mail_outline': Icons.mail_outline,
  'email_outline': Icons.email_outlined,
  'chat_outline': Icons.chat_bubble_outline,
  'message': Icons.chat_bubble_outline,
  'message_outline': Icons.chat_bubble_outline,
  'forum_outline': Icons.forum_outlined,
  'send_outline': Icons.send_outlined,
  'reply_outline': Icons.reply_outlined,
  'share_outline': Icons.share_outlined,
  'calendar_outline': Icons.calendar_today_outlined,
  'clock': Icons.access_time_outlined,
  'clock_outline': Icons.access_time_outlined,
  'timer': Icons.schedule_outlined,
  'schedule_outline': Icons.schedule_outlined,
  'today_outline': Icons.today_outlined,
  'event_outline': Icons.event_outlined,
  'search_outline': Icons.search,
  'zoom_plus': Icons.zoom_in_outlined,
  'zoom_minus': Icons.zoom_out_outlined,
  'fullscreen_open': Icons.fullscreen,
  'fullscreen_close': Icons.fullscreen_exit,
  'visibility_outline': Icons.visibility_outlined,
  'eye': Icons.visibility_outlined,
  'eye_off': Icons.visibility_off_outlined,
  'hidden': Icons.visibility_off_outlined,
  'star_outline': Icons.star_outline,
  'star_half_outline': Icons.star_half,
  'rating': Icons.star_outline,
  'check_outline': Icons.check,
  'checkmark': Icons.check,
  'checkmark_circle': Icons.check_circle_outline,
  'success_outline': Icons.check_circle_outline,
  'radio_on': Icons.radio_button_checked,
  'radio_off': Icons.radio_button_unchecked,
  'checkbox_on': Icons.check_box_outlined,
  'checkbox_off': Icons.check_box_outline_blank_outlined,
  'toggle_enabled': Icons.toggle_on_outlined,
  'toggle_disabled': Icons.toggle_off_outlined,
  'sparkles': Icons.auto_awesome_outlined,
  'magic': Icons.auto_awesome_outlined,
  'palette_outline': Icons.palette_outlined,
  'paint': Icons.color_lens_outlined,
  'brush': Icons.draw_outlined,
  'shape': Icons.category_outlined,
  'grid_outline': Icons.grid_view_outlined,
  'table_outline': Icons.table_chart_outlined,
  'dashboard_outline': Icons.dashboard_outlined,
  'chart_bar': Icons.bar_chart_outlined,
  'chart_line': Icons.insights_outlined,
  'insight': Icons.insights_outlined,
  'layers': Icons.layers_outlined,
  'map_outline': Icons.map_outlined,
  'route_outline': Icons.route_outlined,
  'location': Icons.place_outlined,
  'location_pin': Icons.place_outlined,
  'compass_outline': Icons.explore_outlined,
  'navigation': Icons.navigation_outlined,
  'globe': Icons.public_outlined,
  'planet': Icons.public_outlined,
  'wifi_outline': Icons.wifi_outlined,
  'bluetooth_outline': Icons.bluetooth_outlined,
  'battery': Icons.battery_full_outlined,
  'battery_outline': Icons.battery_full_outlined,
  'battery_charging_outline': Icons.battery_charging_full_outlined,
  'laptop_outline': Icons.laptop_outlined,
  'computer_outline': Icons.computer_outlined,
  'monitor_outline': Icons.monitor_outlined,
  'watch_outline': Icons.watch_outlined,
  'android_logo': Icons.android,
  'apple_logo': Icons.apple,
  'cart': Icons.shopping_cart_outlined,
  'bag': Icons.shopping_bag_outlined,
  'shop_outline': Icons.shopping_bag_outlined,
  'wallet_outline': Icons.account_balance_wallet_outlined,
  'payment_outline': Icons.payment_outlined,
  'gift': Icons.card_giftcard_outlined,
  'gift_outline': Icons.card_giftcard_outlined,
  'rocket_outline': Icons.rocket_launch_outlined,
  'launch_outline': Icons.launch_outlined,
  'sun_outline': Icons.wb_sunny_outlined,
  'moon': Icons.nightlight_round,
  'night_mode': Icons.nightlight_round,
  'light_mode': Icons.wb_sunny_outlined,
  'work_outline': Icons.work_outline,
  'briefcase': Icons.work_outline,
  'support_outline': Icons.support_agent_outlined,
  'helpdesk': Icons.support_agent_outlined,
  'bug_outline': Icons.bug_report_outlined,
  'puzzle': Icons.extension_outlined,
  'extension_outline': Icons.extension_outlined,
  'zoom_in': Icons.zoom_in_outlined,
  'zoom_out': Icons.zoom_out_outlined,
};

final Map<int, IconData> _materialIconsByCodepoint = <int, IconData>{
  for (final iconData in _iconAliases.values) iconData.codePoint: iconData,
};
