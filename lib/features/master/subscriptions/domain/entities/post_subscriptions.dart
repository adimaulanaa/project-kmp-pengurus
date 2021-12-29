class PostSubscriptions {
  PostSubscriptions(
      {this.id,
      this.name,
      this.description,
      this.amount,
      this.effectiveDateString,
      this.subscriptionCategory,
      this.isActive});

  String? id;
  String? name;
  String? description;
  int? amount;
  String? effectiveDateString;
  String? subscriptionCategory;
  bool? isActive;
}
