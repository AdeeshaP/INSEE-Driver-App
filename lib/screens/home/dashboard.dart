import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:insee_driver_app/screens/view-details/completd_deliveries_view.dart';
import 'package:insee_driver_app/screens/view-details/in-transit_delivery_view.dart';
import 'package:insee_driver_app/screens/view-details/pending_deliveries_details.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:insee_driver_app/dimensions/responsive.dart';
import 'package:insee_driver_app/screens/contact-us/contact_us.dart';
import 'package:insee_driver_app/screens/options_screen.dart';
import 'package:insee_driver_app/screens/profile/profile_screen.dart';
import 'package:insee_driver_app/screens/settings/settings.dart';
import 'package:intl/intl.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key, required this.driverCode});
  final String driverCode;

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final DateFormat dateFormat = DateFormat('dd MMM yyyy');
  final DateFormat timeFormat = DateFormat('HH:mm');
  List<dynamic> tasks1 = [];
  List<dynamic> tasks2 = [];
  List<dynamic> tasks3 = [];
  bool isLoading = true;
  // bool _isFadingOut = false;
  Timer? _inactivityTimer;
  Timer? _countdownTimer;
  bool _showOverlay = false;
  int _countdown = 5;
  Map<String, dynamic> pendingMeta = {};
  Map<String, dynamic> inTransitMeta = {};

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void initState() {
    super.initState();
    _initJsonFiles();
    _tabController = TabController(length: 3, vsync: this);

    loadCompletedTasksForDriver();
    //  loadPendingTasksForDriver();
    //  loadInTransitTasksForDriver();
    _resetInactivityTimer();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _inactivityTimer?.cancel();
    _countdownTimer?.cancel();
    super.dispose();
  }

  Future<void> _initJsonFiles() async {
    await _ensureLocalJsonExists(
        'driver_pending_tasks.json', 'assets/json/driver_pending_tasks.json');
    await _ensureLocalJsonExists('driver_intransit_tasks.json',
        'assets/json/driver_intransit_tasks.json');

    await loadPendingTasksForDriver();
    await loadInTransitTasksForDriver();
  }

  Future<File> _ensureLocalJsonExists(String fileName, String assetPath) async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/$fileName');

    if (!await file.exists()) {
      final jsonStr = await rootBundle.loadString(assetPath);
      await file.writeAsString(jsonStr);
    }

    return file;
  }

  Future<void> loadPendingTasksForDriver() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/driver_pending_tasks.json');
    final jsonData = json.decode(await file.readAsString());

    setState(() {
      tasks1 = jsonData['pending_orders'];
    });
  }

  Future<void> loadInTransitTasksForDriver() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/driver_intransit_tasks.json');
    final jsonData = json.decode(await file.readAsString());

    setState(() {
      tasks3 = jsonData['intransit_orders'];
    });
  }

  Future<void> loadCompletedTasksForDriver() async {
    await Future.delayed(Duration(seconds: 1));

    final String jsonString = await DefaultAssetBundle.of(context)
        .loadString('assets/json/driver_completed_tasks.json');
    final data = json.decode(jsonString);

    setState(() {
      tasks2 = data['completed_orders'];
      isLoading = false;
    });
  }

  // Side Menu Bar Options
  List<String> _menuOptions = [
    'Settings',
    'Contact Us',
    'Logout',
  ];

  // --------- Side Menu Bar Navigation ---------- //
  void choiceAction(String choice) {
    if (choice == _menuOptions[0]) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) {
          return SettingsScreen();
        }),
      );
    } else if (choice == _menuOptions[1]) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) {
          return ContactUsScreen();
        }),
      );
    } else if (choice == _menuOptions[2]) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) {
          return OptionsScreen();
        }),
        (Route<dynamic> route) => false,
      );
    }
  }


  void _logout() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => OptionsScreen()),
    );
  }

  void _resetInactivityTimer() {
    _inactivityTimer?.cancel();
    _inactivityTimer = Timer(Duration(minutes: 5), () {
      // After 10s of inactivity, start logout countdown
      _startLogoutCountdown();
    });
  }

  void _startLogoutCountdown() {
    setState(() {
      _showOverlay = true;
      _countdown = 5;
    });

    _countdownTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_countdown > 1) {
        setState(() {
          _countdown--;
        });
      } else {
        _countdownTimer?.cancel();
        _logout();
      }
    });
  }

  void _onUserInteraction() {
    if (_showOverlay) {
      // If countdown is running, cancel it & remove overlay
      _countdownTimer?.cancel();
      setState(() {
        _showOverlay = false;
      });
    }
    _resetInactivityTimer();
  }
  
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        SystemNavigator.pop();
      },
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: _onUserInteraction,
        onPanDown: (_) => _onUserInteraction(),
        child: Scaffold(
          appBar: AppBar(
            leading: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset(
                'assets/images/eagle.png',
              ),
            ),
            backgroundColor: Colors.white,
            elevation: 1,
            title: Text(
              "INSEE Delivery",
              style: TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
            centerTitle: true,
            actions: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 5.0),
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => DriverProfileScreen(),
                      ),
                    );
                  },
                  child: CircleAvatar(
                    radius: 18,
                    backgroundColor: Colors.red.shade200,
                    child: Icon(
                      Icons.person,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              Container(
                width: 40,
                child: PopupMenuButton<String>(
                  iconColor: Colors.red.shade400,
                  onSelected: choiceAction,
                  itemBuilder: (BuildContext context) {
                    return _menuOptions.map((String choice) {
                      return PopupMenuItem<String>(
                        value: choice,
                        child: Text(
                          choice,
                          style: TextStyle(
                            fontSize: Responsive.isMobileSmall(context)
                                ? 15
                                : Responsive.isMobileMedium(context) ||
                                        Responsive.isMobileLarge(context)
                                    ? 16
                                    : Responsive.isTabletPortrait(context)
                                        ? size.width * 0.03
                                        : size.width * 0.02,
                          ),
                        ),
                      );
                    }).toList();
                  },
                ),
              )
            ],
          ),
          backgroundColor: Colors.white,
          body: Stack(
            children: [
              Column(
                children: [
                  // Driver stats section
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          spreadRadius: 1,
                          blurRadius: 5,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Hello, Driver",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF333333),
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          "Today, ${dateFormat.format(DateTime.now())}",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        SizedBox(height: 20),
                        Row(
                          children: [
                            _buildStatCard(
                              title: "Total\nDeliveries",
                              value: "10",
                              icon: Icons.local_shipping,
                              color: Color(0xFFE53935),
                            ),
                            // _buildStatCard(
                            //   title: "This \nMonth",
                            //   value: "18",
                            //   icon: Icons.calendar_month,
                            //   color: Color(0xFF1976D2),
                            // ),
                            SizedBox(width: 16),
                            _buildStatCard(
                              title: "Pending\nDeliveries",
                              value: "7",
                              icon: Icons.pending_actions,
                              color: Color(0xFFFF9800),
                            ),
                            SizedBox(width: 16),
                            _buildStatCard(
                              title: "Completed\nDeliveries",
                              value: "3",
                              icon: Icons.done_outline,
                              color: Color.fromARGB(255, 105, 238, 116),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // Tab bar
                  Container(
                    color: Colors.white,
                    padding: EdgeInsets.only(top: 10),
                    child: TabBar(
                      controller: _tabController,
                      labelColor: Color(0xFFE53935),
                      unselectedLabelColor: Colors.grey.shade600,
                      indicatorColor: Color(0xFFE53935),
                      indicatorWeight: 3,
                      tabs: [
                        Tab(text: "PENDING \nORDERS"),
                        Tab(text: "IN-TRANSIT \nORDERS"),
                        Tab(text: "COMPLETED \nORDERS"),
                      ],
                    ),
                  ),

                  // Tab content
                  Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        // Pending orders tab
                        // _buildOrdersList(isPending: true),
                        _buildPendingOrdersList(),
                        // _buildOrdersList(isPending: false),
                        _buildInTransitOrdersList(),
                        // Completed orders tab
                        _buildCompletedOrdersList(),
                      ],
                    ),
                  ),
                ],
              ),
              // Dark overlay with countdown
              if (_showOverlay)
                AnimatedOpacity(
                  duration: Duration(milliseconds: 500),
                  opacity: 0.9,
                  child: Container(
                    color: Colors.black,
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CircularProgressIndicator(
                            value: _countdown / 5,
                            color: Colors.red,
                          ),
                          SizedBox(height: 20),
                          Text(
                            "$_countdown",
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 40,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.2)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  icon,
                  color: color,
                  size: 20,
                ),
                SizedBox(width: 6),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade700,
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPendingOrdersList() {
    Size size = MediaQuery.of(context).size;

    return Container(
      height: size.height * 0.75,
      child: isLoading
          ? Center(
              child: CircularProgressIndicator(
              color: Colors.amber,
            ))
          : RefreshIndicator(
              onRefresh: loadPendingTasksForDriver,
              child: ListView.builder(
                padding: EdgeInsets.all(16),
                itemCount: tasks1.length,
                itemBuilder: (context, index) {
                  // final task = tasks1[index];
                  // return _buildTaskCard(task, "pending");
                  if (index >= tasks1.length) return SizedBox(); // safeguard
                  final task = tasks1[index];
                  return _buildTaskCard(task, "pending");
                },
              ),
            ),
    );
  }

  Widget _buildInTransitOrdersList() {
    Size size = MediaQuery.of(context).size;

    return Container(
      height: size.height * 0.75,
      child: isLoading
          ? Center(
              child: CircularProgressIndicator(
              color: Colors.amber,
            ))
          : RefreshIndicator(
              onRefresh: loadInTransitTasksForDriver,
              child: ListView.builder(
                padding: EdgeInsets.all(16),
                itemCount: tasks3.length,
                itemBuilder: (context, index) {
                  // final task = tasks3[index];
                  // return _buildTaskCard(task, "inprogress");
                  if (index >= tasks3.length) return SizedBox(); // safeguard
                  final task = tasks3[index];
                  return _buildTaskCard(task, "inprogress");
                },
              ),
            ),
    );
  }

  Widget _buildCompletedOrdersList() {
    Size size = MediaQuery.of(context).size;

    return Container(
      height: size.height * 0.75,
      child: isLoading
          ? Center(
              child: CircularProgressIndicator(
              color: Colors.amber,
            ))
          : RefreshIndicator(
              onRefresh: loadCompletedTasksForDriver,
              child: ListView.builder(
                padding: EdgeInsets.all(16),
                itemCount: tasks2.length,
                itemBuilder: (context, index) {
                  final task = tasks2[index];
                  return _buildTaskCard(task, "completed");
                },
              ),
            ),
    );
  }


  Future<void> _navigateToPendingDetails(Map<String, dynamic> task) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PendingDeliveryDetailsScreen(
          task: task,
          licenceNo: widget.driverCode,
          pendingOrders: tasks1,
          intransitOrders: tasks3,
        ),
      ),
    );

    if (result != null && result is String) {
      final acknowledgedOrderId = result;
      final item = tasks1.firstWhere(
        (e) => e['id'] == acknowledgedOrderId,
        orElse: () => {},
      );

      if (item.isNotEmpty) {
        setState(() {
          tasks1.remove(item);
          tasks3.add(item);
        });

        final dir = await getApplicationDocumentsDirectory();
        final pendingFile = File('${dir.path}/driver_pending_tasks.json');
        final inTransitFile = File('${dir.path}/driver_intransit_tasks.json');

        await pendingFile
            .writeAsString(json.encode({'pending_orders': tasks1}));
        await inTransitFile
            .writeAsString(json.encode({'intransit_orders': tasks3}));

        await loadPendingTasksForDriver();
        await loadInTransitTasksForDriver();
      }
    }
  }

  Widget _buildTaskCard(Map<String, dynamic> task, String status) {
    return GestureDetector(
      onTap: () {
        status == "pending"
            // ? Navigator.push(
            //     context,
            //     MaterialPageRoute(
            //       builder: (context) => PendingDeliveryDetailsScreen(
            //         task: task,
            //         licenceNo: widget.driverCode,
            //         pendingOrders: tasks1,
            //         intransitOrders: tasks3,
            //       ),
            //     ),
            //   )
            ? _navigateToPendingDetails(task)
            : status == "completed"
                ? Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CompletedDeliveryDetailsScreen(
                          task: task, driverCode: widget.driverCode),
                    ),
                  )
                : Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => InTransitDeliveryDetailsScreen(
                          task: task, driverCode: widget.driverCode),
                    ),
                  );
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 2,
              blurRadius: 0,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            // Order header
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: status == "pending"
                    ? Color(0xFFFFF8E1)
                    : status == "completed"
                        ? Color(0xFFE8F5E9)
                        : Color.fromARGB(255, 185, 218, 250),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    task['id'],
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: status == "pending"
                          ? Color(0xFFFFB74D)
                          : status == "completed"
                              ? Color(0xFF66BB6A)
                              // : Color.fromARGB(255, 16, 76, 243),
                              : Color(0xFF42A5F5),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      task['status'],
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Order content
            Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.business,
                        size: 16,
                        color: Color(0xFF757575),
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          task['customerInfo']['name'],
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        size: 16,
                        color: Color(0xFF757575),
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          '${task['deliveryLocation']['address']}, ${task['deliveryLocation']['city']}',
                          style: TextStyle(
                            color: Colors.grey.shade700,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.category,
                            size: 16,
                            color: Color(0xFFE53935),
                          ),
                          SizedBox(width: 4),
                          Text(
                            task['cementLoad']['type'],
                            style: TextStyle(
                              color: Color(0xFFE53935),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.scale,
                            size: 16,
                            color: Color(0xFF757575),
                          ),
                          SizedBox(width: 4),
                          Text(
                            "${task['cementLoad']['weight']} kg",
                            style: TextStyle(
                              color: Colors.grey.shade700,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.access_time,
                            size: 16,
                            color: Color(0xFF757575),
                          ),
                          SizedBox(width: 4),
                          Text(
                            timeFormat.format(
                                DateTime.parse(task['estimatedDeliveryTime'])),
                            style: TextStyle(
                              color: Colors.grey.shade700,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Order footer
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(12),
                  bottomRight: Radius.circular(12),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    dateFormat
                        .format(DateTime.parse(task['estimatedDeliveryTime'])),
                    style: TextStyle(
                      color: Colors.grey.shade600,
                    ),
                  ),
                  Text(
                    "Tap for details",
                    style: TextStyle(
                      color: Color(0xFFE53935),
                      fontWeight: FontWeight.w500,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
