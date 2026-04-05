enum RouterEnum {
  initialLocation('/'),
  homePage('/home'),
  counterView('/counter_view'),
  helloWorldView('/hello_world_view');

  final String routeName;

  const RouterEnum(this.routeName);
}
