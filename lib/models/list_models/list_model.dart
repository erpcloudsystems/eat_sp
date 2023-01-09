/// this class grantee same dataType for generic list
/// it's a list of the given type [T]
class ListModel<T> {
  final List<T> list;

  ListModel(list) : this.list = list ?? <T>[];
}
