import 'package:flutter/material.dart';

class ModelProfile {
  final String id;
  final String name;
  final String provider;
  final double costPerMillionTokens;
  final double latencyMs;
  final double capabilityScore;
  final Color color;
  final List<InferenceMetric> metrics;

  const ModelProfile({
    required this.id,
    required this.name,
    required this.provider,
    required this.costPerMillionTokens,
    required this.latencyMs,
    required this.capabilityScore,
    required this.color,
    required this.metrics,
  });
}

class OptimizationInsight {
  final String modelId;
  final String title;
  final String description;
  final String recommendation;
  final double potentialSavingsPerc;

  const OptimizationInsight({
    required this.modelId,
    required this.title,
    required this.description,
    required this.recommendation,
    required this.potentialSavingsPerc,
  });
}

class InferenceMetric {
  final ModelProfile model;
  final double avgLatencyMs;
  final double costPerMillionTokens;
  final double throughputTokensSec;
  final double reliability;
  final InferenceMetric? projectedMetric;

  const InferenceMetric({
    required this.model,
    required this.avgLatencyMs,
    required this.costPerMillionTokens,
    required this.throughputTokensSec,
    required this.reliability,
    this.projectedMetric,
  });
}
