import 'dart:math';
import 'package:flutter/material.dart';
import 'package:testable/features/ai_control/matrix/matrix_models.dart';

class MatrixSimulationService {
  final List<ModelProfile> _biases = [
    const ModelProfile(
      id: 'gpt-4-turbo',
      name: 'GPT-4 Turbo',
      provider: 'OpenAI',
      costPerMillionTokens: 30.0,
      latencyMs: 450,
      capabilityScore: 0.86,
      color: Color(0xFF10A37F),
        metrics: []
    ),
    const ModelProfile(
      id: 'haiku',
      name: 'Claude 3 Haiku',
      provider: 'Anthropic',
      costPerMillionTokens: 0.25,
      latencyMs: 150,
      capabilityScore: 0.72,
      color: Color(0xFFE3886D),
        metrics: []
    ),
    const ModelProfile(
      id: 'sonnet',
      name: 'Claude 3.5 Sonnet',
      provider: 'Anthropic',
      costPerMillionTokens: 3.0,
      latencyMs: 350,
      capabilityScore: 0.88,
      color: Color(0xFFD97757),
        metrics: []
    ),
    const ModelProfile(
      id: 'gemini-pro',
      name: 'Gemini 1.5 Pro',
      provider: 'Google',
      costPerMillionTokens: 3.5,
      latencyMs: 420,
      capabilityScore: 0.90,
      color: Color(0xFF4285F4),
        metrics: []
    ),
    const ModelProfile(
      id: 'gemini-flash',
      name: 'Gemini 1.5 Flash',
      provider: 'Google',
      costPerMillionTokens: 0.1,
      latencyMs: 120,
      capabilityScore: 0.78,
      color: Color(0xFF34A853),
        metrics: []
    ),
    const ModelProfile(
      id: 'llama-3-70b',
      name: 'Llama 3 70B',
      provider: 'Local',
      costPerMillionTokens: 0.8,
      latencyMs: 280,
      capabilityScore: 0.82,
      color: Color(0xFF0668E1),
    metrics: []

    ),
  ];

  Future<List<ModelProfile>> getModelProfiles() async {
    return _biases;
  }

  Future<OptimizationInsight?> analyzeModel(ModelProfile current) async {
    final allModels = await getModelProfiles();

    ModelProfile? bestCandidate;
    double maxScore = -1.0;

    for (final candidate in allModels) {
      if (candidate.id == current.id) continue;

      if (candidate.costPerMillionTokens >= current.costPerMillionTokens)
        continue;
      if (current.capabilityScore - candidate.capabilityScore > 0.05) continue;

      final costRatio =
          current.costPerMillionTokens / candidate.costPerMillionTokens;
      final speedRatio = current.latencyMs / candidate.latencyMs;

      final score = costRatio * speedRatio;

      if (score > maxScore) {
        maxScore = score;
        bestCandidate = candidate;
      }
    }

    if (bestCandidate != null) {
      final savingPerc =
          1 -
          (bestCandidate.costPerMillionTokens / current.costPerMillionTokens);

      return OptimizationInsight(
        modelId: current.id,
        title: 'Optimize ${current.name}',
        description:
            'Switching to ${bestCandidate.name} reduces cost by ${(savingPerc * 100).toStringAsFixed(0)}% while maintaining quality.',
        recommendation: 'Use ${bestCandidate.name} for lower-latency tasks.',
        potentialSavingsPerc: savingPerc,
      );
    }

    return null;
  }
}
