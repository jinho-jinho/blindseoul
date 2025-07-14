class BlindwalkDto {
  final int sidewalkId;
  final int subId;
  final double latMin;
  final double lonMin;
  final double latMax;
  final double lonMax;
  final String rnNm;
  final String brllBlkKndCode;
  final String cnstrctYy;

  BlindwalkDto({
    required this.sidewalkId,
    required this.subId,
    required this.latMin,
    required this.lonMin,
    required this.latMax,
    required this.lonMax,
    required this.rnNm,
    required this.brllBlkKndCode,
    required this.cnstrctYy,
  });

  factory BlindwalkDto.fromJson(Map<String, dynamic> json) {
    return BlindwalkDto(
      sidewalkId: json['sidewalkId'],
      subId: json['subId'],
      latMin: json['latMin'].toDouble(),
      lonMin: json['lonMin'].toDouble(),
      latMax: json['latMax'].toDouble(),
      lonMax: json['lonMax'].toDouble(),
      rnNm: json['rnNm'],
      brllBlkKndCode: json['brllBlkKndCode'] ?? '',
      cnstrctYy: json['cnstrctYy'] ?? '',
    );
  }
}
