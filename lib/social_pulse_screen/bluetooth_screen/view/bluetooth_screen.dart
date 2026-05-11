import 'package:blinx_mobile/social_pulse_screen/bluetooth_screen/controller/bluetooth_controller.dart';
import 'package:blinx_mobile/utils/screens/string_constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BluetoothPopup extends StatelessWidget {
  BluetoothPopup({super.key});

  final BluetoothController bluetoothController =
      Get.isRegistered<BluetoothController>()
      ? Get.find<BluetoothController>()
      : Get.put(BluetoothController());

  static bool _isSwitchLocked = false;

  Future<void> _handleBluetoothToggle(bool val) async {
    if (_isSwitchLocked) return;

    _isSwitchLocked = true;

    await bluetoothController.toggleBluetooth(val);

    await Future.delayed(const Duration(seconds: 3));

    _isSwitchLocked = false;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 15),
      alignment: Alignment.topCenter,
      child: Padding(
        padding: EdgeInsets.only(
          top: MediaQuery.of(context).size.height * 0.35,
        ),
        child: Obx(
          () => Container(
            width: 372,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // TOP ROW — icon + text + toggle
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 20,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.bluetooth,
                        size: 26,
                        color: Colors.black,
                      ),

                      const SizedBox(width: 16),

                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              AppConstants.bluetoothTitle,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              ),
                            ),

                            SizedBox(height: 4),

                            Text(
                              AppConstants.bluetoothDescription,
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w400,
                                color: Color(0xFF9E9E9E),
                                height: 1.4,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(width: 12),

                      Switch(
                        value: bluetoothController.isBluetoothOn.value,
                        onChanged: _handleBluetoothToggle,
                        activeColor: Colors.white,
                        activeTrackColor: const Color(0xFF34C759),
                        inactiveThumbColor: Colors.white,
                        inactiveTrackColor: const Color(0xFFE5E5EA),
                      ),
                    ],
                  ),
                ),

                // DIVIDER + LIST
                if (bluetoothController.isBluetoothOn.value) ...[
                  const Divider(height: 1, color: Color(0xFFF0F0F0)),

                  bluetoothController.isScanning.value
                      ? const Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 16,
                          ),
                          child: Row(
                            children: [
                              SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Color(0xFF34C759),
                                ),
                              ),

                              SizedBox(width: 10),

                              Text(
                                AppConstants.findingNearbyBlinxUsers,
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Color(0xFF9E9E9E),
                                ),
                              ),
                            ],
                          ),
                        )
                      : bluetoothController.nearbyBlinxUsers.isEmpty
                      ? const Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 16,
                          ),
                          child: Text(
                            AppConstants.noNearbyBlinxUsersFound,
                            style: TextStyle(
                              fontSize: 13,
                              color: Color(0xFF9E9E9E),
                            ),
                          ),
                        )
                      : SizedBox(
                          height: 180,
                          child: ListView.separated(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            shrinkWrap: true,
                            itemCount:
                                bluetoothController.nearbyBlinxUsers.length,
                            separatorBuilder: (_, __) => const Divider(
                              height: 1,
                              color: Color(0xFFF0F0F0),
                              indent: 56,
                            ),
                            itemBuilder: (context, index) {
                              final user =
                                  bluetoothController.nearbyBlinxUsers[index];

                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 10,
                                ),
                                child: Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 18,
                                      backgroundColor: const Color(0xFFF0F0F0),
                                      backgroundImage: user.profilePic != null
                                          ? NetworkImage(user.profilePic!)
                                          : null,
                                      child: user.profilePic == null
                                          ? const Icon(
                                              Icons.person,
                                              size: 18,
                                              color: Color(0xFF9E9E9E),
                                            )
                                          : null,
                                    ),

                                    const SizedBox(width: 12),

                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            user.name,
                                            style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.black,
                                            ),
                                          ),

                                          if (user.distance != null)
                                            Text(
                                              "${user.distance!.toStringAsFixed(0)}${AppConstants.metersAway}",
                                              style: const TextStyle(
                                                fontSize: 12,
                                                color: Color(0xFF9E9E9E),
                                              ),
                                            ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
