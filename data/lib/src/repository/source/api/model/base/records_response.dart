import 'package:freezed_annotation/freezed_annotation.dart';

part 'records_response.freezed.dart';
part 'records_response.g.dart';

@Freezed(genericArgumentFactories: true)
sealed class RecordsListResponse<T> with _$RecordsListResponse<T> {
  const RecordsListResponse._();
  const factory RecordsListResponse({
    @JsonKey(name: 'records') List<T>? records,
    @JsonKey(name: 'page') int? page,
    @JsonKey(name: 'offset') int? offset,
    @JsonKey(name: 'total') int? total,
    @JsonKey(name: 'next') int? next,
    @JsonKey(name: 'prev') int? prev,
  }) = _RecordsListResponse;

  factory RecordsListResponse.fromJson(
          Map<String, dynamic> json, T Function(Object?) fromJsonT) =>
      _$RecordsListResponseFromJson(json, fromJsonT);
}
