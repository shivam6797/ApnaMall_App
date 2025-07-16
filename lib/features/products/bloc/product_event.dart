abstract class ProductEvent {}

class LoadHomeData extends ProductEvent {}            // first time
class ChangeCategory extends ProductEvent {
  final int categoryId;
  ChangeCategory(this.categoryId);
}
class RefreshHome extends ProductEvent {}
