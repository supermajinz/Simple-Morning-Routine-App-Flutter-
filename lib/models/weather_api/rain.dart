class Rain {
	double? h;

	Rain({this.h});

	factory Rain.fromJson(Map<String, dynamic> json) => Rain(
				h: (json['1h'] as num?)?.toDouble(),
			);

	Map<String, dynamic> toJson() => {
				'1h': h,
			};
}
