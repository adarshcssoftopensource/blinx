import 'package:flutter/material.dart';

class CustomToggleSwitch extends StatefulWidget {
  final String title;
  final bool value;
  final ValueChanged<bool> onChanged;
  final String? subtitle;
  final double width;
  final double height;

  const CustomToggleSwitch({
    super.key,
    required this.title,
    required this.value,
    required this.onChanged,
    this.subtitle,
    this.width = 75,
    this.height = 30,
  });

  @override
  State<CustomToggleSwitch> createState() => _CustomToggleSwitchState();
}

class _CustomToggleSwitchState extends State<CustomToggleSwitch> {
  late bool isOn = false;

  @override
  void initState() {
    super.initState();
    isOn = widget.value;
  }

  @override
  void didUpdateWidget(CustomToggleSwitch oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      isOn = widget.value;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.title,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black87,
                    fontWeight: isOn ? FontWeight.w500 : null,
                  ),
                ),
                if (widget.subtitle != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: Text(
                      widget.subtitle!,
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ),
              ],
            ),
          ),

          GestureDetector(
            onTap: () {
              setState(() => isOn = !isOn);
              widget.onChanged(isOn);
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              width: widget.width,
              height: widget.height,
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: isOn ? Colors.green : Colors.grey.shade400,
                borderRadius: BorderRadius.circular(widget.height / 2),
              ),
              child: Stack(
                children: [
                  AnimatedOpacity(
                    duration: const Duration(milliseconds: 200),
                    opacity: isOn ? 1 : 0,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Container(
                          width: 3,
                          height: 12,
                          color: Colors.white.withOpacity(0.6),
                        ),
                      ),
                    ),
                  ),

                  AnimatedOpacity(
                    duration: const Duration(milliseconds: 200),
                    opacity: isOn ? 0 : 1,
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 6),
                        child: Container(
                          width: 18,
                          height: 14,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.grey.withOpacity(0.7),
                              width: 2,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  AnimatedAlign(
                    duration: const Duration(milliseconds: 250),
                    alignment: isOn
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    child: Container(
                      width: 40,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(25),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 3,
                            offset: const Offset(0, 1),
                          ),
                        ],
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
