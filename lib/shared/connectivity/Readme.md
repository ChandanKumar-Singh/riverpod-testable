```dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

/// ------------------------------------------------------
/// PROVIDERS WITH SIMULATION SUPPORT
/// ------------------------------------------------------

enum ConnectivityStatus {
  online,
  offline,
  transitioning;

  bool get isOnline => this == ConnectivityStatus.online;
  bool get isOffline => this == ConnectivityStatus.offline;
}

class ConnectivityState {
  final ConnectivityStatus status;
  final ConnectivityResult? lastResult;
  final DateTime lastChanged;
  final bool isSimulated;

  const ConnectivityState({
    required this.status,
    this.lastResult,
    required this.lastChanged,
    this.isSimulated = false,
  });

  ConnectivityState copyWith({
    ConnectivityStatus? status,
    ConnectivityResult? lastResult,
    DateTime? lastChanged,
    bool? isSimulated,
  }) {
    return ConnectivityState(
      status: status ?? this.status,
      lastResult: lastResult ?? this.lastResult,
      lastChanged: lastChanged ?? this.lastChanged,
      isSimulated: isSimulated ?? this.isSimulated,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ConnectivityState &&
        other.status == status &&
        other.lastResult == lastResult &&
        other.isSimulated == isSimulated;
  }

  @override
  int get hashCode => Object.hash(status, lastResult, isSimulated);
}

final connectivityProvider = StateNotifierProvider<ConnectivityNotifier, ConnectivityState>(
  (ref) => ConnectivityNotifier(),
);

class ConnectivityNotifier extends StateNotifier<ConnectivityState> {
  StreamSubscription<List<ConnectivityResult>>? _subscription;
  bool _isSimulating = false;

  ConnectivityNotifier()
      : super(
          ConnectivityState(
            status: ConnectivityStatus.transitioning,
            lastChanged: DateTime.now(),
            isSimulated: false,
          ),
        ) {
    _init();
  }

  Future<void> _init() async {
    final connectivity = Connectivity();
    
    try {
      // Initial check
      final initialResult = await connectivity.checkConnectivity();
      _updateState(initialResult, isSimulated: false);
      
      // Listen for changes
      _subscription = connectivity.onConnectivityChanged.listen(
        (results) => _updateState(results, isSimulated: false),
      );
    } catch (error) {
      // Fallback to offline state if check fails
      state = ConnectivityState(
        status: ConnectivityStatus.offline,
        lastChanged: DateTime.now(),
        isSimulated: false,
      );
    }
  }

  void _updateState(List<ConnectivityResult> results, {required bool isSimulated}) {
    if (_isSimulating && !isSimulated) return; // Don't override simulations with real data
    
    // DEBUG: Print the raw results
    print('🔌 Connectivity results: $results');
    
    // Check if ANY result indicates connectivity (fixed logic)
    final hasConnection = results.isNotEmpty && 
        results.any((result) => result != ConnectivityResult.none);
    
    print('🔌 Has connection: $hasConnection');
    
    final newStatus = hasConnection ? ConnectivityStatus.online : ConnectivityStatus.offline;
    
    // Only update if status actually changed
    if (state.status != newStatus || state.isSimulated != isSimulated) {
      state = ConnectivityState(
        status: newStatus,
        lastResult: _getPrimaryConnectivityType(results),
        lastChanged: DateTime.now(),
        isSimulated: isSimulated,
      );
      
      print('🔌 State updated: ${state.status.displayName} (simulated: $isSimulated)');
    }
  }

  // Simulation methods
  void simulateOnline() {
    _isSimulating = true;
    state = ConnectivityState(
      status: ConnectivityStatus.online,
      lastResult: ConnectivityResult.wifi,
      lastChanged: DateTime.now(),
      isSimulated: true,
    );
    print('🎭 Simulating ONLINE state');
  }

  void simulateOffline() {
    _isSimulating = true;
    state = ConnectivityState(
      status: ConnectivityStatus.offline,
      lastResult: null,
      lastChanged: DateTime.now(),
      isSimulated: true,
    );
    print('🎭 Simulating OFFLINE state');
  }

  void stopSimulation() {
    _isSimulating = false;
    final connectivity = Connectivity();
    connectivity.checkConnectivity().then((results) {
      _updateState(results, isSimulated: false);
    });
    print('🎭 Stopping simulation, returning to real state');
  }

  ConnectivityResult? _getPrimaryConnectivityType(List<ConnectivityResult> results) {
    // Filter out 'none' and get the primary connection type
    final activeConnections = results.where((r) => r != ConnectivityResult.none).toList();
    
    if (activeConnections.isEmpty) return null;
    
    // Priority order for connectivity types
    const priorityOrder = [
      ConnectivityResult.ethernet,
      ConnectivityResult.wifi,
      ConnectivityResult.mobile,
      ConnectivityResult.vpn,
      ConnectivityResult.bluetooth,
      ConnectivityResult.other,
    ];

    for (final type in priorityOrder) {
      if (activeConnections.contains(type)) return type;
    }
    
    return activeConnections.first;
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}

/// ------------------------------------------------------
/// CONNECTIVITY WATCHER WIDGET
/// ------------------------------------------------------

class ConnectivityWatcher extends ConsumerStatefulWidget {
  final Widget child;
  final Duration onlineBannerDuration;
  final bool showTransitionAnimations;
  final bool showDebugPanel;

  const ConnectivityWatcher({
    super.key,
    required this.child,
    this.onlineBannerDuration = const Duration(seconds: 3),
    this.showTransitionAnimations = true,
    this.showDebugPanel = false, // Set to true for debugging
  });

  @override
  ConsumerState<ConnectivityWatcher> createState() => _ConnectivityWatcherState();
}

class _ConnectivityWatcherState extends ConsumerState<ConnectivityWatcher>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _slideAnimation;
  late Animation<double> _fadeAnimation;

  BannerState _currentBannerState = BannerState.hidden;
  Timer? _autoHideTimer;
  ConnectivityStatus? _previousStatus;

  @override
  void initState() {
    super.initState();
    
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _slideAnimation = Tween<double>(
      begin: -80.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    _autoHideTimer?.cancel();
    super.dispose();
  }

  void _handleConnectivityChange(ConnectivityState state) {
    print('🔄 Handling connectivity change: ${state.status.displayName}');
    
    // Don't process if status hasn't changed
    if (_previousStatus == state.status) return;
    
    _previousStatus = state.status;
    _autoHideTimer?.cancel();

    switch (state.status) {
      case ConnectivityStatus.online:
        _showOnlineBanner();
      case ConnectivityStatus.offline:
        _showOfflineBanner();
      case ConnectivityStatus.transitioning:
        // Do nothing, wait for final state
        break;
    }
  }

  void _showOnlineBanner() {
    print('🟢 Showing ONLINE banner');
    if (_currentBannerState == BannerState.online) return;
    
    _currentBannerState = BannerState.online;
    _animateBannerShow();
    
    // Auto-hide after duration
    _autoHideTimer = Timer(widget.onlineBannerDuration, _animateBannerHide);
  }

  void _showOfflineBanner() {
    print('🔴 Showing OFFLINE banner');
    if (_currentBannerState == BannerState.offline) return;
    
    _currentBannerState = BannerState.offline;
    _animateBannerShow();
    
    // Don't auto-hide offline banner
    _autoHideTimer?.cancel();
  }

  void _animateBannerShow() {
    print('🎬 Animating banner show');
    if (widget.showTransitionAnimations) {
      _animationController.forward();
    } else {
      // Ensure banner is visible even without animations
      setState(() {});
    }
  }

  void _animateBannerHide() {
    print('🎬 Animating banner hide');
    if (widget.showTransitionAnimations) {
      _animationController.reverse().then((_) {
        if (mounted) {
          setState(() => _currentBannerState = BannerState.hidden);
        }
      });
    } else {
      setState(() => _currentBannerState = BannerState.hidden);
    }
  }

  BannerConfig _getBannerConfig() {
    return switch (_currentBannerState) {
      BannerState.online => BannerConfig(
          message: 'Back Online 🌐',
          backgroundColor: Colors.green,
          icon: Icons.wifi_rounded,
          iconColor: Colors.white,
          showClose: false,
        ),
      BannerState.offline => BannerConfig(
          message: 'No Internet Connection ❌',
          backgroundColor: Colors.redAccent,
          icon: Icons.wifi_off_rounded,
          iconColor: Colors.white,
          showClose: true,
        ),
      BannerState.hidden => BannerConfig(
          message: '',
          backgroundColor: Colors.transparent,
          icon: Icons.error,
          iconColor: Colors.transparent,
          showClose: false,
        ),
    };
  }

  @override
  Widget build(BuildContext context) {
    final connectivityState = ref.watch(connectivityProvider);
    
    // Handle connectivity changes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _handleConnectivityChange(connectivityState);
    });

    final bannerConfig = _getBannerConfig();
    final isBannerVisible = _currentBannerState != BannerState.hidden;

    return Stack(
      children: [
        // Main content
        Column(
          children: [
            Expanded(child: widget.child),
            if (widget.showDebugPanel) 
              ConnectivityDebugPanel(connectivityState: connectivityState),
          ],
        ),
        
        // Connectivity banner
        if (isBannerVisible) 
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: AnimatedBuilder(
              animation: widget.showTransitionAnimations 
                  ? Listenable.merge([_slideAnimation, _fadeAnimation])
                  : const AlwaysStoppedAnimation(1.0),
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(0, widget.showTransitionAnimations 
                      ? _slideAnimation.value 
                      : 0.0),
                  child: Opacity(
                    opacity: widget.showTransitionAnimations 
                        ? _fadeAnimation.value 
                        : 1.0,
                    child: child,
                  ),
                );
              },
              child: _ConnectivityBanner(
                config: bannerConfig,
                onClose: _currentBannerState == BannerState.offline 
                    ? _animateBannerHide 
                    : null,
              ),
            ),
          ),
      ],
    );
  }
}

/// ------------------------------------------------------
/// SUPPORTING WIDGETS
/// ------------------------------------------------------

enum BannerState {
  online,
  offline,
  hidden,
}

class BannerConfig {
  final String message;
  final Color backgroundColor;
  final IconData icon;
  final Color iconColor;
  final bool showClose;

  const BannerConfig({
    required this.message,
    required this.backgroundColor,
    required this.icon,
    required this.iconColor,
    required this.showClose,
  });
}

class _ConnectivityBanner extends StatelessWidget {
  final BannerConfig config;
  final VoidCallback? onClose;

  const _ConnectivityBanner({
    required this.config,
    this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Container(
        margin: const EdgeInsets.all(12),
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        decoration: BoxDecoration(
          color: config.backgroundColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: config.backgroundColor.withOpacity(0.3),
              blurRadius: 16,
              offset: const Offset(0, 4),
              spreadRadius: 0,
            ),
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Icon
            Icon(
              config.icon,
              color: config.iconColor,
              size: 20,
            ),
            
            const SizedBox(width: 12),
            
            // Message
            Expanded(
              child: Text(
                config.message,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  height: 1.2,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            
            // Close button (only for offline banner)
            if (config.showClose && onClose != null) ...[
              const SizedBox(width: 8),
              GestureDetector(
                onTap: onClose,
                behavior: HitTestBehavior.opaque,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.close_rounded,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// ------------------------------------------------------
/// DEBUG PANEL WITH SIMULATION BUTTONS
/// ------------------------------------------------------

class ConnectivityDebugPanel extends ConsumerWidget {
  final ConnectivityState connectivityState;

  const ConnectivityDebugPanel({
    super.key,
    required this.connectivityState,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(connectivityProvider.notifier);
    
    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          const Row(
            children: [
              Icon(Icons.bug_report, color: Colors.orange, size: 16),
              SizedBox(width: 8),
              Text(
                'Connectivity Debug Panel',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 12),
          
          // Status info
          _DebugInfoRow(
            label: 'Status',
            value: connectivityState.status.displayName,
            color: connectivityState.isOnline ? Colors.green : Colors.red,
          ),
          _DebugInfoRow(
            label: 'Connection Type',
            value: connectivityState.connectionType,
            color: Colors.blue,
          ),
          _DebugInfoRow(
            label: 'Simulated',
            value: connectivityState.isSimulated ? 'Yes' : 'No',
            color: connectivityState.isSimulated ? Colors.orange : Colors.grey,
          ),
          _DebugInfoRow(
            label: 'Last Changed',
            value: connectivityState.lastChanged.toString().split('.')[0],
            color: Colors.purple,
          ),
          
          const SizedBox(height: 16),
          
          // Simulation buttons
          const Text(
            'Simulation Controls:',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
          ),
          
          const SizedBox(height: 8),
          
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () => notifier.simulateOnline(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.wifi, size: 16),
                      SizedBox(width: 4),
                      Text('Simulate Online'),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ElevatedButton(
                  onPressed: () => notifier.simulateOffline(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.wifi_off, size: 16),
                      SizedBox(width: 4),
                      Text('Simulate Offline'),
                    ],
                  ),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 8),
          
          ElevatedButton(
            onPressed: () => notifier.stopSimulation(),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 8),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.refresh, size: 16),
                SizedBox(width: 4),
                Text('Stop Simulation'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DebugInfoRow extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _DebugInfoRow({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Text(
            '$label:',
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 12,
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: color.withOpacity(0.5)),
            ),
            child: Text(
              value,
              style: TextStyle(
                color: color,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// ------------------------------------------------------
/// EXTENSIONS
/// ------------------------------------------------------

extension ConnectivityStateExtensions on ConnectivityState {
  bool get isOnline => status == ConnectivityStatus.online;
  bool get isOffline => status == ConnectivityStatus.offline;
  bool get isTransitioning => status == ConnectivityStatus.transitioning;
  
  String get connectionType {
    return switch (lastResult) {
      ConnectivityResult.wifi => 'WiFi',
      ConnectivityResult.mobile => 'Mobile',
      ConnectivityResult.ethernet => 'Ethernet',
      ConnectivityResult.bluetooth => 'Bluetooth',
      ConnectivityResult.vpn => 'VPN',
      ConnectivityResult.other => 'Other',
      _ => 'None',
    };
  }
}

extension ConnectivityStatusExtensions on ConnectivityStatus {
  String get displayName {
    return switch (this) {
      ConnectivityStatus.online => 'Online',
      ConnectivityStatus.offline => 'Offline',
      ConnectivityStatus.transitioning => 'Checking...',
    };
  }
}
```

## Usage:

```dart
void main() {
  runApp(
    ProviderScope(
      child: ConnectivityWatcher(
        onlineBannerDuration: Duration(seconds: 3),
        showTransitionAnimations: true,
        showDebugPanel: true, // Set to true to see debug panel
        child: OrderEntryApp(),
      ),
    ),
  );
}
```

## Key Features:

### 🎭 **Simulation Controls**
- **Simulate Online** - Force online state
- **Simulate Offline** - Force offline state  
- **Stop Simulation** - Return to real connectivity state

### 🔍 **Debug Panel**
- Real-time status monitoring
- Connection type display
- Simulation state indicator
- Timestamp tracking

### 🐛 **Debug Logging**
- Console logs for every state change
- Raw connectivity results printing
- Banner state transitions

### ✅ **Expected Behavior**
- **Online** → Green "Back Online 🌐" banner (auto-hides after 3s)
- **Offline** → Red "No Internet Connection ❌" banner (stays until online)

## Test Steps:

1. **Enable debug panel** by setting `showDebugPanel: true`
2. **Use simulation buttons** to test both states
3. **Check console logs** for detailed debugging
4. **Verify banner behavior** matches expectations