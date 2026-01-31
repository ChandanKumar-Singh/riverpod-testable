import 'package:flutter/material.dart';
import 'package:testable/features/ai_control/matrix/matrix_models.dart';

class MatrixSimulationService {
  List<ModelProfile> getModelProfiles() {
    return [
      const ModelProfile(
        id: 'gpt-4o',
        name: 'GPT-4o',
        provider: 'OpenAI',
        costPerMillionTokens: 15.0,
        latencyMs: 850,
        capabilityScore: 0.98,
        color: Color(0xFF10A37F),
        metrics: [
          InferenceMetric(
            model: ModelProfile(
              id: 'gpt-4o',
              name: 'GPT-4o',
              provider: 'OpenAI',
              costPerMillionTokens: 15.0,
              latencyMs: 850,
              capabilityScore: 0.98,
              color: Color(0xFF10A37F),
              metrics: [],
            ),
            avgLatencyMs: 850,
            costPerMillionTokens: 15.0,
            throughputTokensSec: 1000,
            reliability: 0.98,
          ),
        ],
      ),
      const ModelProfile(
        id: 'claude-3-5',
        name: 'Claude 3.5 Sonnet',
        provider: 'Anthropic',
        costPerMillionTokens: 12.0,
        latencyMs: 720,
        capabilityScore: 0.96,
        color: Color(0xFFD97757),
        metrics: [],
      ),
      const ModelProfile(
        id: 'llama-3-70b',
        name: 'Llama 3 70B',
        provider: 'Meta',
        costPerMillionTokens: 0.80,
        latencyMs: 450,
        capabilityScore: 0.92,
        color: Color(0xFF0668E1),
          metrics: []
      ),
      const ModelProfile(
        id: 'gemini-1-5',
        name: 'Gemini 1.5 Pro',
        provider: 'Google',
        costPerMillionTokens: 7.0,
        latencyMs: 1100,
        capabilityScore: 0.95,
        color: Color(0xFF4285F4),
        metrics: [],
      ),
      const ModelProfile(
        id: 'mistral-large',
        name: 'Mistral Large 2',
        provider: 'Mistral',
        costPerMillionTokens: 4.0,
        latencyMs: 600,
        capabilityScore: 0.90,
        color: Color(0xFFFFFFFF),
        metrics: [],
      ),
      const ModelProfile(
        id: 'phi-3-med',
        name: 'Phi-3 Medium',
        provider: 'Microsoft',
        costPerMillionTokens: 0.15,
        latencyMs: 120,
        capabilityScore: 0.78,
        color: Color(0xFF00A4EF),
        metrics: [],
      ),
    ];
  }

  List<OptimizationInsight> getInsights() {
    return [
      const OptimizationInsight(
        modelId: 'gpt-4o',
        title: 'ROUTING LATENCY SPIKE',
        description: 'US-East traffic is seeing 40% higher latency on GPT-4o.',
        recommendation: 'Switch non-critical support flows to Llama-3-70B.',
        potentialSavingsPerc: 0.35,
      ),
      const OptimizationInsight(
        modelId: 'mistral-large',
        title: 'UNDERUTILIZED CAPACITY',
        description: 'Mistral Large 2 reserved instances are at 12% load.',
        recommendation: 'Re-target batch processing jobs to Mistral.',
        potentialSavingsPerc: 0.15,
      ),
    ];
  }
}
