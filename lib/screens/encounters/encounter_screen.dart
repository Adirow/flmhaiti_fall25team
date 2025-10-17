import 'package:flutter/material.dart';
import 'package:flmhaiti_fall25team/encounter/encounter.dart';

class EncounterScreen extends StatelessWidget {
  final String? patientId;
  final String? providerId;
  final String? clinicId;
  final String? encounterId;

  const EncounterScreen({
    super.key,
    this.patientId,
    this.providerId,
    this.clinicId,
    this.encounterId,
  });

  @override
  Widget build(BuildContext context) {
    return NewEncounterScreen(
      patientId: patientId,
      providerId: providerId,
      clinicId: clinicId,
      encounterId: encounterId,
    );
  }
}
