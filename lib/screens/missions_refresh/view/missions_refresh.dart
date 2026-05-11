import 'package:blinx_mobile/screens/authentication/sign_in/view/sign_in_screen.dart';
import 'package:blinx_mobile/utils/screens/image_constants.dart';
import 'package:blinx_mobile/utils/screens/string_constants.dart';
import 'package:flutter/material.dart';

class MissionsRefreshScreen extends StatelessWidget {
  const MissionsRefreshScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        surfaceTintColor: Colors.white,

        backgroundColor: Colors.white,

        elevation: 0,

        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },

          child: Center(
            child: SizedBox(
              width: 15,

              height: 15,

              child: Image.asset(
                CommonUi.setPngIcon("left_vector"),

                fit: BoxFit.contain,
              ),
            ),
          ),
        ),

        title: const Text(
          AppConstants.missionDetailTitle,

          style: TextStyle(
            fontSize: 14,

            fontWeight: FontWeight.w500,

            color: Colors.black,
          ),
        ),

        centerTitle: true,
      ),

      body: Column(
        children: [
          const SizedBox(height: 0),

          const Divider(height: 1, thickness: 1, color: Color(0xFFE0E0E0)),

          SizedBox(
            height: 36,

            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,

                children: const [
                  Icon(
                    Icons.refresh,

                    size: 12,

                    fontWeight: FontWeight.w500,

                    color: Color(0xFF51585C),
                  ),

                  SizedBox(width: 6),

                  Text(
                    AppConstants.pullToRefresh,

                    style: TextStyle(
                      fontSize: 12,

                      fontWeight: FontWeight.w500,

                      color: Color(0xFF51585C),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const Divider(height: 1, thickness: 1, color: Color(0xFFE0E0E0)),

          Expanded(
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,

                children: [
                  CircleAvatar(
                    radius: 50,

                    backgroundColor: const Color(0xFFE0E0E0),

                    child: Image.asset(
                      CommonUi.setPngIcon("frame"),

                      width: 101,

                      height: 101,

                      fit: BoxFit.contain,
                    ),
                  ),

                  const SizedBox(height: 20),

                  const Text(
                    AppConstants.noMissionsAvailableTitle,

                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                  ),

                  const SizedBox(height: 8),

                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 40),

                    child: Text(
                      AppConstants.noMissionsAvailableDesc,

                      textAlign: TextAlign.center,

                      style: TextStyle(
                        fontSize: 12,

                        fontWeight: FontWeight.w400,

                        color: Color(0xFF000000),

                        height: 1.4,
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  SizedBox(
                    width: 156,

                    height: 46,

                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,

                          MaterialPageRoute(builder: (_) => SignInScreen()),
                        );
                      },

                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2A73EA),

                        elevation: 0,

                        padding: const EdgeInsets.fromLTRB(24, 12, 24, 12),

                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100),
                        ),
                      ),

                      child: const Text(
                        AppConstants.refreshList,

                        style: TextStyle(
                          fontSize: 18,

                          fontWeight: FontWeight.w600,

                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
