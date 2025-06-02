abstract class Web3Event {}

class ConnectToNetwork extends Web3Event {}

class GetBalance extends Web3Event {
  final String address;
  GetBalance(this.address);
}
