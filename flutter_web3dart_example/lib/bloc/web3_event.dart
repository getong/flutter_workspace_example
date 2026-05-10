abstract class Web3Event {
  const Web3Event();
}

class LoadWeb3Overview extends Web3Event {
  const LoadWeb3Overview();
}

class InspectAddressRequested extends Web3Event {
  const InspectAddressRequested(this.address);

  final String address;
}

class InspectTokenRequested extends Web3Event {
  const InspectTokenRequested({
    required this.tokenAddress,
    required this.ownerAddress,
  });

  final String tokenAddress;
  final String ownerAddress;
}

class DemonstrateEncodingRequested extends Web3Event {
  const DemonstrateEncodingRequested({
    required this.tokenAddress,
    required this.recipientAddress,
  });

  final String tokenAddress;
  final String recipientAddress;
}

class InspectWalletRequested extends Web3Event {
  const InspectWalletRequested({
    required this.privateKey,
    required this.message,
  });

  final String privateKey;
  final String message;
}
