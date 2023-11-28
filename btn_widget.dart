class ButtonWidget extends StatefulWidget {
  // Thuộc tính giá trị của nút
  final String value;
  // Chế độ kiểm tra của nút (cho chế độ dark/light)
  final bool modeCheck;
  // Key để truy cập trạng thái của InputWidget từ ngoại vi 
  final GlobalKey<InputWidgetState> inputWidgetKey;

  // Constructor của ButtonWidget, nhận các tham số bắt buộc
  const ButtonWidget({
    Key? key,
    required this.value,
    required this.modeCheck,
    required this.inputWidgetKey,
  }) : super(key: key);

  // Override phương thức createState để tạo ra trạng thái của ButtonWidget
  @override
  State<ButtonWidget> createState() => _ButtonWidgetState();
}

class _ButtonWidgetState extends State<ButtonWidget> {
  // Biến kiểm soát trạng thái khi nút được nhấn
  bool isPressed = false;

  // Lấy đối tượng của CalculateController sử dụng GetX
  var controller = Get.find<CalculateController>();

  // Phương thức build để xây dựng giao diện của ButtonWidget
  @override
  Widget build(BuildContext context) {
    // Màu của nút xóa
    const deletebutton = Colors.red;
    // Màu của nút xóa toàn bộ
    const clearbutton = Color.fromARGB(255, 101, 244, 54);
    // Màu của nút biểu thức
    const expressionbutton = Color.fromARGB(255, 244, 165, 54);

    // Màu nền của nút khi ấn và không ấn cho cả chế độ dark/light
    Color darkBtnBgColor = isPressed
        ? Colors.lightBlueAccent
        : const Color.fromARGB(255, 47, 57, 70);
    Color lightBtnBgColor = isPressed
        ? Colors.lightBlueAccent
        : const Color.fromARGB(255, 255, 255, 255);

    // Widget Listener để lắng nghe sự kiện khi người dùng nhấn và nhả nút
    return Listener(
      // Sự kiện khi ngón tay nhả nút
      onPointerUp: (_) => setState(() {
        // Kiểm tra giá trị của nút và thực hiện các hành động tương ứng
        [Btn.del].contains(widget.value)
            ? controller.deleteBtnAction()
            : [Btn.clr].contains(widget.value)
                ? controller.clearInputAndOutput()
                : [Btn.calculate].contains(widget.value)
                    ? controller.equalPressed()
                    : controller.onBtnTapped(widget.value);
        // Đặt trạng thái của nút là không được nhấn
        isPressed = false;
        // Cập nhật trạng thái của InputWidget thông qua GlobalKey
        widget.inputWidgetKey.currentState?.changeState();
      }),
      // Sự kiện khi ngón tay đặt lên nút
      onPointerDown: (_) => setState(() {
        // Đặt trạng thái của nút là được nhấn
        isPressed = true;
      }),
      // Widget chứa nút, sử dụng AnimatedContainer để có hiệu ứng khi thay đổi trạng thái
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        margin: const EdgeInsets.fromLTRB(2, 3, 2, 3),
        decoration: BoxDecoration(
          // Màu nền của nút dựa vào chế độ dark/light và trạng thái nhấn
          color: widget.modeCheck ? darkBtnBgColor : lightBtnBgColor,
          shape: BoxShape.circle,
          // Hiệu ứng bóng đổ cho nút
          boxShadow: [
            BoxShadow(
              color:
                  widget.modeCheck ? Colors.black54 : Colors.blueGrey.shade200,
              spreadRadius: 1,
              blurRadius: 15,
              offset: const Offset(4, 4), // Thay đổi vị trí bóng đổ
            ),
            BoxShadow(
              color: widget.modeCheck ? Colors.blueGrey.shade700 : Colors.white,
              spreadRadius: 0.5,
              blurRadius: 15,
              offset: const Offset(-4, -4), // Thay đổi vị trí bóng đổ
            ),
          ],
        ),
        // Widget hiển thị nội dung của nút
        child: Center(
          child: Text(
            widget.value,
            style: TextStyle(
              // Màu của văn bản dựa vào giá trị của nút
              color: [Btn.del].contains(widget.value)
                  ? deletebutton
                  : [Btn.clr].contains(widget.value)
                      ? clearbutton
                      : [
                          Btn.open,
                          Btn.close,
                          Btn.multiply,
                          Btn.add,
                          Btn.subtract,
                          Btn.divide,
                          Btn.calculate,
                        ].contains(widget.value)
                          ? expressionbutton
                          : widget.modeCheck
                              ? DarkColors.btnTextColor
                              : LightColors.btnTextColor,
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
          ),
        ),
      ),
    );
  }
}
