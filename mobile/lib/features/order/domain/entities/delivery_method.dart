enum DeliveryMethod {
  courier('Курьер'),
  mail('Почта'),
  pickup('Самовывоз');

  final String label;
  const DeliveryMethod(this.label);
}
