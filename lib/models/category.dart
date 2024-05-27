class Category {
  final String? categoryName;
  final String? categoryImage;


  Category({
    this.categoryName,
    this.categoryImage,

  });

  factory Category.fromJson(Map<String, dynamic> json) => Category(
    categoryName: json['categoryname']?.toString(),
    categoryImage: json['categoryimage']?.toString(),

  );
}
