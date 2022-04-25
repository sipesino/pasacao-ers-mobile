import 'dart:convert';

import 'package:pers/src/models/incident_report.dart';

class Operation {
  String? operation_id;
  String? external_agency_id;
  String? dispatcher_id;
  String? account_id;
  String? etd_base;
  String? eta_scene;
  String? etd_scene;
  String? eta_hospital;
  String? etd_hospital;
  String? eta_base;
  String? receiving_facility;
  IncidentReport? report;

  Operation({
    this.operation_id,
    this.external_agency_id,
    this.dispatcher_id,
    this.account_id,
    this.etd_base,
    this.eta_scene,
    this.etd_scene,
    this.eta_hospital,
    this.etd_hospital,
    this.eta_base,
    this.receiving_facility,
    this.report,
  });

  Map<String, dynamic> toMap() {
    return {
      'operation_id': operation_id,
      'external_agency_id': external_agency_id,
      'dispatcher_id': dispatcher_id,
      'account_id': account_id,
      'etd_base': etd_base,
      'eta_scene': eta_scene,
      'etd_scene': etd_scene,
      'eta_hospital': eta_hospital,
      'etd_hospital': etd_hospital,
      'eta_base': eta_base,
      'receiving_facility': receiving_facility,
      'report': report,
    };
  }

  factory Operation.fromMap(Map<String, dynamic> map) {
    return Operation(
      operation_id: map['operation_id'],
      external_agency_id: map['external_agency_id'],
      dispatcher_id: map['dispatcher_id'],
      account_id: map['account_id'],
      etd_base: map['etd_base'],
      eta_scene: map['eta_scene'],
      etd_scene: map['etd_scene'],
      eta_hospital: map['eta_hospital'],
      etd_hospital: map['etd_hospital'],
      eta_base: map['eta_base'],
      receiving_facility: map['receiving_facility'],
      report: map['report'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Operation.fromJson(String source) =>
      Operation.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Operation(operation_id: $operation_id, external_agency_id: $external_agency_id, dispatcher_id: $dispatcher_id, account_id: $account_id, etd_base: $etd_base, eta_scene: $eta_scene, etd_scene: $etd_scene, eta_hospital: $eta_hospital, etd_hospital: $etd_hospital, eta_base: $eta_base, receiving_facility: $receiving_facility, incident_report: ${report.toString()})';
  }

  @override
  int get hashCode {
    return operation_id.hashCode ^
        external_agency_id.hashCode ^
        dispatcher_id.hashCode ^
        account_id.hashCode ^
        etd_base.hashCode ^
        eta_scene.hashCode ^
        etd_scene.hashCode ^
        eta_hospital.hashCode ^
        etd_hospital.hashCode ^
        eta_base.hashCode ^
        receiving_facility.hashCode ^
        report.hashCode;
  }
}
