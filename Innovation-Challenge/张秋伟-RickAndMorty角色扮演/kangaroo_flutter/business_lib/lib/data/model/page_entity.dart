
class PageEntity {
  int currentPage;
  int pageSize;
  int totalCount;

  PageEntity(this.currentPage, this.pageSize,
      this.totalCount);

  factory PageEntity.fromJson(Map<String, dynamic> json) => _$PageEntityFromJson(json);
  Map<String, dynamic> toJson() => _$PageEntityToJson(this);

}

PageEntity _$PageEntityFromJson(Map<String, dynamic> json) => PageEntity(
  json['currentPage'] as int,
  json['pageSize'] as int,
  json['totalCount'] as int,
);

Map<String, dynamic> _$PageEntityToJson(PageEntity instance) =>
    <String, dynamic>{
      'currentPage': instance.currentPage,
      'pageSize': instance.pageSize,
      'totalCount': instance.totalCount,
    };
