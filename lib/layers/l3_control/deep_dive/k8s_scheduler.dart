import 'dart:math';
import 'package:flutter/material.dart';
import 'package:testable/ui/shared/glass_container.dart';

class K8sSchedulerSimulator extends StatefulWidget {
  const K8sSchedulerSimulator({super.key});

  @override
  State<K8sSchedulerSimulator> createState() => _K8sSchedulerSimulatorState();
}

class _K8sSchedulerSimulatorState extends State<K8sSchedulerSimulator> {
  // Nodes
  final List<_Node> _nodes = [
    _Node("worker-1", 4, 16), // name, cpu cores, ram gb
    _Node("worker-2", 4, 16),
    _Node("gpu-node-1", 8, 32, label: "GPU"),
  ];

  // Pending Pods Queue
  final List<_Pod> _pendingPods = [];

  final Random _rnd = Random();

  void _addPod(String type) {
    if (type == "web")
      _pendingPods.add(_Pod("nginx-${_rnd.nextInt(999)}", 1, 2, Colors.blue));
    if (type == "db")
      _pendingPods.add(
        _Pod("redis-${_rnd.nextInt(999)}", 2, 4, Colors.redAccent),
      );
    if (type == "ai")
      _pendingPods.add(
        _Pod(
          "ollama-${_rnd.nextInt(999)}",
          4,
          16,
          Colors.purpleAccent,
          needsGpu: true,
        ),
      );
    setState(() {});
  }

  void _schedulePod(_Pod pod) {
    // Bin Packing Logic
    bool scheduled = false;
    for (var node in _nodes) {
      if (node.hasCapacity(pod)) {
        // GPU Constraint Check
        if (pod.needsGpu && node.label != "GPU") continue;

        setState(() {
          node.addPod(pod);
          _pendingPods.remove(pod);
          scheduled = true;
        });
        break;
      }
    }

    if (!scheduled) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Scheduling Failed: Insufficient Resources or Taints",
            style: TextStyle(color: Colors.white),
          ),
          duration: Duration(milliseconds: 500),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text(
          "L3: K8S SCHEDULER",
          style: TextStyle(letterSpacing: 1.5, fontSize: 13),
        ),
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          // Pending Queue (Top)
          Container(
            height: 120,
            padding: const EdgeInsets.all(16),
            color: Colors.white10,
            child: Row(
              children: [
                const RotatedBox(
                  quarterTurns: 3,
                  child: Text(
                    "PENDING QUEUE",
                    style: TextStyle(color: Colors.white38, fontSize: 10),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _pendingPods.length,
                    itemBuilder: (context, index) {
                      final pod = _pendingPods[index];
                      // Use LongPressDraggable so user can scroll the list without accidentally dragging
                      return LongPressDraggable<_Pod>(
                        data: pod,
                        feedback: _buildPodCard(pod, isDragging: true),
                        childWhenDragging: Opacity(
                          opacity: 0.5,
                          child: _buildPodCard(pod),
                        ),
                        child: GestureDetector(
                          onTap: () => _schedulePod(pod),
                          child: _buildPodCard(pod),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: _nodes
                    .map(
                      (node) => Expanded(
                        child: DragTarget<_Pod>(
                          onAccept: (pod) {
                            if (node.hasCapacity(pod)) {
                              if (pod.needsGpu && node.label != "GPU") {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      "Error: Pod requires GPU Node!",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                                return;
                              }
                              setState(() {
                                node.addPod(pod);
                                _pendingPods.remove(pod);
                              });
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    "Error: Node Out of Resources!",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          },
                          builder: (context, candidateData, rejectedData) {
                            return _buildNodeColumn(
                              node,
                              candidateData.isNotEmpty,
                            );
                          },
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
          ),

          // Controls
          GlassContainer(
            child: Wrap(
              alignment: WrapAlignment.spaceEvenly,
              spacing: 8.0,
              runSpacing: 8.0,
              children: [
                _buildAddButton("Deploy NGINX", Icons.web, Colors.blue, "web"),
                _buildAddButton(
                  "Deploy Redis",
                  Icons.storage,
                  Colors.redAccent,
                  "db",
                ),
                _buildAddButton(
                  "Deploy Ollama",
                  Icons.psychology,
                  Colors.purpleAccent,
                  "ai",
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildNodeColumn(_Node node, bool isHovered) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: isHovered ? Colors.white24 : Colors.white10,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isHovered ? Colors.white : Colors.transparent,
        ),
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(8),
            color: Colors.black26,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      // Prevent overflow
                      child: Text(
                        node.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (node.label != null)
                      Container(
                        padding: const EdgeInsets.all(2),
                        color: Colors.cyan,
                        child: Text(
                          node.label!,
                          style: const TextStyle(
                            fontSize: 8,
                            color: Colors.black,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 4),
                _buildBar("CPU", node.usedCpu, node.totalCpu, Colors.blue),
                const SizedBox(height: 2),
                _buildBar("RAM", node.usedRam, node.totalRam, Colors.orange),
              ],
            ),
          ),

          // Pod List
          Expanded(
            child: ListView.builder(
              itemCount: node.pods.length,
              itemBuilder: (context, index) {
                final pod = node.pods[index];
                return Container(
                  margin: const EdgeInsets.all(4),
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: pod.color.withOpacity(0.2),
                    border: Border.all(color: pod.color),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.widgets, size: 12, color: pod.color),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          pod.name,
                          style: const TextStyle(
                            fontSize: 10,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.close,
                          size: 12,
                          color: Colors.white54,
                        ),
                        onPressed: () => setState(() => node.removePod(pod)),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBar(String label, int used, int total, Color color) {
    double pct = used / total;
    return Row(
      children: [
        SizedBox(
          width: 24,
          child: Text(
            label,
            style: const TextStyle(fontSize: 8, color: Colors.white54),
          ),
        ),
        Expanded(
          child: LinearProgressIndicator(
            value: pct,
            backgroundColor: Colors.white10,
            valueColor: AlwaysStoppedAnimation(pct > 1.0 ? Colors.red : color),
          ),
        ),
      ],
    );
  }

  Widget _buildPodCard(_Pod pod, {bool isDragging = false}) {
    return Container(
      width: 120,
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.black,
        border: Border.all(color: pod.color),
        borderRadius: BorderRadius.circular(8),
        boxShadow: isDragging
            ? [BoxShadow(color: pod.color, blurRadius: 10)]
            : [],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            pod.name,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            "CPU: ${pod.reqCpu} Core",
            style: const TextStyle(color: Colors.white54, fontSize: 10),
          ),
          Text(
            "RAM: ${pod.reqRam} GB",
            style: const TextStyle(color: Colors.white54, fontSize: 10),
          ),
          if (pod.needsGpu)
            const Text(
              "REQUIRES GPU",
              style: TextStyle(
                color: Colors.cyan,
                fontSize: 8,
                fontWeight: FontWeight.bold,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildAddButton(
    String label,
    IconData icon,
    Color color,
    String type,
  ) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: color.withOpacity(0.2),
        foregroundColor: color,
      ),
      onPressed: () => _addPod(type),
      icon: Icon(icon, size: 16),
      label: Text(label, style: const TextStyle(fontSize: 10)),
    );
  }
}

class _Node {
  final String name;
  final int totalCpu;
  final int totalRam;
  final String? label; // e.g. "GPU"

  int usedCpu = 0;
  int usedRam = 0;
  List<_Pod> pods = [];

  _Node(this.name, this.totalCpu, this.totalRam, {this.label});

  bool hasCapacity(_Pod pod) {
    return (usedCpu + pod.reqCpu <= totalCpu) &&
        (usedRam + pod.reqRam <= totalRam);
  }

  void addPod(_Pod pod) {
    pods.add(pod);
    usedCpu += pod.reqCpu;
    usedRam += pod.reqRam;
  }

  void removePod(_Pod pod) {
    pods.remove(pod);
    usedCpu -= pod.reqCpu;
    usedRam -= pod.reqRam;
  }
}

class _Pod {
  final String name;
  final int reqCpu;
  final int reqRam;
  final Color color;
  final bool needsGpu;

  _Pod(
    this.name,
    this.reqCpu,
    this.reqRam,
    this.color, {
    this.needsGpu = false,
  });
}
