import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:hi_society_device/component/system_setting_tile.dart';
import 'package:hi_society_device/theme/padding_margin.dart';

import '../../api/i18n.dart';
import '../../component/app_bar.dart';

class SystemSettings extends StatefulWidget {
  const SystemSettings({Key? key, required this.isBN}) : super(key: key);
  final bool isBN;

  @override
  State<SystemSettings> createState() => _SystemSettingsState();
}

class _SystemSettingsState extends State<SystemSettings> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            appBar: primaryAppBar(context: context, title: i18n_systemSettings(widget.isBN)),
            body: ListView(padding: primaryPadding * 2, children: [
              systemSettingTile(context: context, title: "Wifi", icon: Icons.wifi, onTap: () => AppSettings.openAppSettings(type: AppSettingsType.wifi)),
              systemSettingTile(context: context, title: "Mobile Data", icon: Icons.network_cell_rounded, onTap: () => AppSettings.openAppSettings(type: AppSettingsType.wireless)),
              systemSettingTile(context: context, title: "App Setting", icon: Icons.app_settings_alt_rounded, onTap: () => AppSettings.openAppSettings(type: AppSettingsType.settings)),
              systemSettingTile(context: context, title: "GPS & Location", icon: Icons.gps_fixed_rounded, onTap: () => AppSettings.openAppSettings(type: AppSettingsType.location)),
              systemSettingTile(context: context, title: "Security", icon: Icons.security_rounded, onTap: () => AppSettings.openAppSettings(type: AppSettingsType.security)),
              systemSettingTile(context: context, title: "Bluetooth", icon: Icons.bluetooth_audio, onTap: () => AppSettings.openAppSettings(type: AppSettingsType.bluetooth)),
              systemSettingTile(context: context, title: "Time & Date", icon: Icons.calendar_month_rounded, onTap: () => AppSettings.openAppSettings(type: AppSettingsType.date)),
              systemSettingTile(context: context, title: "Display", icon: Icons.brightness_4_rounded, onTap: () => AppSettings.openAppSettings(type: AppSettingsType.display)),
              systemSettingTile(context: context, title: "Sound & Volume", icon: Icons.volume_up_rounded, onTap: () => AppSettings.openAppSettings(type: AppSettingsType.sound)),
              systemSettingTile(context: context, title: "Notification", icon: Icons.notifications_active_rounded, onTap: () => AppSettings.openAppSettings(type: AppSettingsType.notification)),
              systemSettingTile(context: context, title: "Device Storage", icon: Icons.storage_rounded, onTap: () => AppSettings.openAppSettings(type: AppSettingsType.internalStorage)),
              systemSettingTile(context: context, title: "Battery", icon: Icons.battery_6_bar_rounded, onTap: () => AppSettings.openAppSettings(type: AppSettingsType.batteryOptimization)),
              systemSettingTile(context: context, title: "Mobile Data APN", icon: Icons.lte_plus_mobiledata, onTap: () => AppSettings.openAppSettings(type: AppSettingsType.apn))
            ])));
  }
}
