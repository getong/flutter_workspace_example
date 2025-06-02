abstract class Web3State {}

class Web3Initial extends Web3State {}

class Web3Loading extends Web3State {}

class Web3Connected extends Web3State {
  final String networkName;
  Web3Connected(this.networkName);
}

class Web3BalanceLoaded extends Web3State {
  final String balance;
  final String address;
  Web3BalanceLoaded(this.balance, this.address);
}

class Web3Error extends Web3State {
  final String message;
  Web3Error(this.message);
}
