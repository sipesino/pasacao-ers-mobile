import 'dart:convert';

class Operation {
  String? operation_id;
  String? incident_id;
  String? external_agency_id;
  String? dispatcher_id;
  String? account_id;
  String? etd_base;
  String? eta_scene;
  String? etd_scene;
  String? eta_hospital;
  String? etd_hospital;
  String? eta_base;
  String? receivingFacility;
  Operation({
    this.operation_id,
    this.incident_id,
    this.external_agency_id,
    this.dispatcher_id,
    this.account_id,
    this.etd_base,
    this.eta_scene,
    this.etd_scene,
    this.eta_hospital,
    this.etd_hospital,
    this.eta_base,
    this.receivingFacility,
  });

  Operation copyWith({
    String? operation_id,
    String? incident_id,
    String? external_agency_id,
    String? dispatcher_id,
    String? account_id,
    String? etd_base,
    String? eta_scene,
    String? etd_scene,
    String? eta_hospital,
    String? etd_hospital,
    String? eta_base,
    String? receivingFacility,
  }) {
    return Operation(
      operation_id: operation_id ?? this.operation_id,
      incident_id: incident_id ?? this.incident_id,
      external_agency_id: external_agency_id ?? this.external_agency_id,
      dispatcher_id: dispatcher_id ?? this.dispatcher_id,
      account_id: account_id ?? this.account_id,
      etd_base: etd_base ?? this.etd_base,
      eta_scene: eta_scene ?? this.eta_scene,
      etd_scene: etd_scene ?? this.etd_scene,
      eta_hospital: eta_hospital ?? this.eta_hospital,
      etd_hospital: etd_hospital ?? this.etd_hospital,
      eta_base: eta_base ?? this.eta_base,
      receivingFacility: receivingFacility ?? this.receivingFacility,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'operation_id': operation_id,
      'incident_id': incident_id,
      'external_agency_id': external_agency_id,
      'dispatcher_id': dispatcher_id,
      'account_id': account_id,
      'etd_base': etd_base,
      'eta_scene': eta_scene,
      'etd_scene': etd_scene,
      'eta_hospital': eta_hospital,
      'etd_hospital': etd_hospital,
      'eta_base': eta_base,
      'receivingFacility': receivingFacility,
    };
  }

  factory Operation.fromMap(Map<String, dynamic> map) {
    return Operation(
      operation_id: map['operation_id'],
      incident_id: map['incident_id'],
      external_agency_id: map['external_agency_id'],
      dispatcher_id: map['dispatcher_id'],
      account_id: map['account_id'],
      etd_base: map['etd_base'],
      eta_scene: map['eta_scene'],
      etd_scene: map['etd_scene'],
      eta_hospital: map['eta_hospital'],
      etd_hospital: map['etd_hospital'],
      eta_base: map['eta_base'],
      receivingFacility: map['receivingFacility'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Operation.fromJson(String source) =>
      Operation.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Operation(operation_id: $operation_id, incident_id: $incident_id, external_agency_id: $external_agency_id, dispatcher_id: $dispatcher_id, account_id: $account_id, etd_base: $etd_base, eta_scene: $eta_scene, etd_scene: $etd_scene, eta_hospital: $eta_hospital, etd_hospital: $etd_hospital, eta_base: $eta_base, receivingFacility: $receivingFacility)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Operation &&
        other.operation_id == operation_id &&
        other.incident_id == incident_id &&
        other.external_agency_id == external_agency_id &&
        other.dispatcher_id == dispatcher_id &&
        other.account_id == account_id &&
        other.etd_base == etd_base &&
        other.eta_scene == eta_scene &&
        other.etd_scene == etd_scene &&
        other.eta_hospital == eta_hospital &&
        other.etd_hospital == etd_hospital &&
        other.eta_base == eta_base &&
        other.receivingFacility == receivingFacility;
  }

  @override
  int get hashCode {
    return operation_id.hashCode ^
        incident_id.hashCode ^
        external_agency_id.hashCode ^
        dispatcher_id.hashCode ^
        account_id.hashCode ^
        etd_base.hashCode ^
        eta_scene.hashCode ^
        etd_scene.hashCode ^
        eta_hospital.hashCode ^
        etd_hospital.hashCode ^
        eta_base.hashCode ^
        receivingFacility.hashCode;
  }
}
