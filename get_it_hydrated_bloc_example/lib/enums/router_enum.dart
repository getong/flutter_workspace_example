enum RouterEnum {
  initialLocation('/'),
  counterView('/counter_view'),
  helloWorldView('/hello_world_view');

  final String routeName;

  const RouterEnum(this.routeName);
}
