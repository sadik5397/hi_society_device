import 'package:flutter/material.dart';
import 'package:hi_society_device/component/system_setting_tile.dart';
import 'package:hi_society_device/theme/padding_margin.dart';
import '../../api/i18n.dart';
import '../../component/app_bar.dart';
import 'package:app_settings/app_settings.dart';

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
            systemSettingTile(context: context, title: "Wifi", icon: Icons.wifi, onTap: () => AppSettings.openWIFISettings()),
            systemSettingTile(context: context, title: "Mobile Data", icon: Icons.network_cell_rounded, onTap: () => AppSettings.openDataRoamingSettings()),
            systemSettingTile(context: context, title: "App Setting", icon: Icons.app_settings_alt_rounded, onTap: () => AppSettings.openAppSettings()),
            systemSettingTile(context: context, title: "GPS & Location", icon: Icons.gps_fixed_rounded, onTap: () => AppSettings.openLocationSettings()),
            systemSettingTile(context: context, title: "Security", icon: Icons.security_rounded, onTap: () => AppSettings.openSecuritySettings()),
            systemSettingTile(context: context, title: "Bluetooth", icon: Icons.bluetooth_audio, onTap: () => AppSettings.openBluetoothSettings()),
            systemSettingTile(context: context, title: "Time & Date", icon: Icons.calendar_month_rounded, onTap: () => AppSettings.openDateSettings()),
            systemSettingTile(context: context, title: "Display", icon: Icons.brightness_4_rounded, onTap: () => AppSettings.openDisplaySettings()),
            systemSettingTile(context: context, title: "Sound & Volume", icon: Icons.volume_up_rounded, onTap: () => AppSettings.openSoundSettings()),
            systemSettingTile(context: context, title: "Notification", icon: Icons.notifications_active_rounded, onTap: () => AppSettings.openNotificationSettings()),
            systemSettingTile(context: context, title: "Device Storage", icon: Icons.storage_rounded, onTap: () => AppSettings.openInternalStorageSettings()),
            systemSettingTile(context: context, title: "Battery", icon: Icons.battery_6_bar_rounded, onTap: () => AppSettings.openBatteryOptimizationSettings()),
            systemSettingTile(context: context, title: "Mobile Data APN", icon: Icons.lte_plus_mobiledata, onTap: () => AppSettings.openAPNSettings())
          ])),
    );
  }
}
