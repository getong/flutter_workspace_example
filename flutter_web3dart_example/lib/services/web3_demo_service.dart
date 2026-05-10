import 'dart:convert';
import 'dart:typed_data';

import 'package:http/http.dart' as http;
import 'package:wallet/wallet.dart';
import 'package:web3dart/web3dart.dart';

import '../models/web3_demo_models.dart';

class Web3DemoService {
  Web3DemoService({
    String rpcUrl = defaultRpcUrl,
  }) : _rpcUrl = rpcUrl {
    _client = Web3Client(rpcUrl, _httpClient);
  }

  static const String defaultRpcUrl = 'https://ethereum-rpc.publicnode.com';
  static const String sampleAddress =
      '0xd8dA6BF26964aF9D7eEd9e03E53415D37aA96045';
  static const String sampleTxHash =
      '0x5c504ed2f4f7cbcfb4870a0c6b459760be1f1c3d52dcf3f4efc07c71a4c63562';
  static const String sampleTokenAddress =
      '0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48';
  static const String samplePrivateKey =
      '0x0123456789012345678901234567890123456789012345678901234567890123';
  static const String samplePersonalMessage = 'Hello from web3dart demo';

  static const String _erc20Abi = '''
[
  {
    "constant": true,
    "inputs": [],
    "name": "name",
    "outputs": [{"name": "", "type": "string"}],
    "payable": false,
    "stateMutability": "view",
    "type": "function"
  },
  {
    "constant": true,
    "inputs": [],
    "name": "symbol",
    "outputs": [{"name": "", "type": "string"}],
    "payable": false,
    "stateMutability": "view",
    "type": "function"
  },
  {
    "constant": true,
    "inputs": [],
    "name": "decimals",
    "outputs": [{"name": "", "type": "uint8"}],
    "payable": false,
    "stateMutability": "view",
    "type": "function"
  },
  {
    "constant": true,
    "inputs": [],
    "name": "totalSupply",
    "outputs": [{"name": "", "type": "uint256"}],
    "payable": false,
    "stateMutability": "view",
    "type": "function"
  },
  {
    "constant": true,
    "inputs": [{"name": "account", "type": "address"}],
    "name": "balanceOf",
    "outputs": [{"name": "", "type": "uint256"}],
    "payable": false,
    "stateMutability": "view",
    "type": "function"
  },
  {
    "anonymous": false,
    "inputs": [
      {"indexed": true, "name": "from", "type": "address"},
      {"indexed": true, "name": "to", "type": "address"},
      {"indexed": false, "name": "value", "type": "uint256"}
    ],
    "name": "Transfer",
    "type": "event"
  }
]
''';

  final String _rpcUrl;
  final http.Client _httpClient = http.Client();
  late final Web3Client _client;

  Future<List<Web3DemoSection>> loadOverview() async {
    final futures = await Future.wait([
      _networkSection(),
      _rawRpcSection(),
      _addressSection(sampleAddress),
      _erc20Section(sampleTokenAddress, sampleAddress),
      _encodingSection(sampleTokenAddress, sampleAddress),
      _walletSection(samplePrivateKey, samplePersonalMessage),
    ]);

    return futures;
  }

  Future<Web3DemoSection> inspectAddress(String rawAddress) async {
    final address = EthereumAddress.fromHex(rawAddress);
    final balance = await _client.getBalance(address);
    final txCount = await _client.getTransactionCount(address);
    final code = await _client.getCode(address);
    final storage0 = await _client.getStorage(address, BigInt.zero);

    return Web3DemoSection(
      id: 'address',
      title: 'Address Lookup',
      subtitle: 'Balance, nonce, bytecode, storage and EIP-55 formatting.',
      fields: [
        Web3DemoField(label: 'Input', value: rawAddress),
        Web3DemoField(
          label: 'EIP-55 Valid',
          value: EthereumAddress.isEip55ValidEthereumAddress(rawAddress)
              .toString(),
        ),
        Web3DemoField(label: 'Checksum', value: address.eip55With0x),
        Web3DemoField(label: 'Balance (ETH)', value: _formatEther(balance)),
        Web3DemoField(label: 'Balance (wei)', value: balance.getInWei.toString()),
        Web3DemoField(label: 'Nonce', value: txCount.toString()),
        Web3DemoField(
          label: 'Code Bytes',
          value: code.length.toString(),
        ),
        Web3DemoField(
          label: 'Storage[0]',
          value: bytesToHex(storage0, include0x: true),
        ),
      ],
      lines: [
        code.isEmpty
            ? 'This address currently looks like an EOA because no contract bytecode was returned.'
            : 'This address has deployed bytecode and behaves like a smart contract account.',
      ],
    );
  }

  Future<Web3DemoSection> inspectToken(
    String tokenAddress,
    String ownerAddress,
  ) async {
    final token = EthereumAddress.fromHex(tokenAddress);
    final owner = EthereumAddress.fromHex(ownerAddress);
    final contract = _erc20Contract(token);

    final name = (await _client.call(
      contract: contract,
      function: contract.function('name'),
      params: const [],
    ))
        .first as String;
    final symbol = (await _client.call(
      contract: contract,
      function: contract.function('symbol'),
      params: const [],
    ))
        .first as String;
    final decimalsRaw = (await _client.call(
      contract: contract,
      function: contract.function('decimals'),
      params: const [],
    ))
        .first as BigInt;
    final totalSupplyRaw = (await _client.call(
      contract: contract,
      function: contract.function('totalSupply'),
      params: const [],
    ))
        .first as BigInt;
    final balanceRaw = (await _client.call(
      contract: contract,
      function: contract.function('balanceOf'),
      params: [owner],
    ))
        .first as BigInt;

    final transferEvent = contract.event('Transfer');
    final logs = await _client.getLogs(
      FilterOptions.events(
        contract: contract,
        event: transferEvent,
        fromBlock: BlockNum.exact(
          (await _client.getBlockNumber()) - 20,
        ),
        toBlock: const BlockNum.current(),
      ),
    );

    final decodedPreview = logs.take(2).map((event) {
      final decoded = transferEvent.decodeResults(
        event.topics ?? const [],
        event.data ?? '0x',
      );
      return 'from ${(decoded[0] as EthereumAddress).eip55With0x} '
          'to ${(decoded[1] as EthereumAddress).eip55With0x} '
          'value ${_formatTokenAmount(decoded[2] as BigInt, decimalsRaw.toInt())}';
    }).toList();

    return Web3DemoSection(
      id: 'erc20',
      title: 'ERC20 Contract Reads',
      subtitle: 'Use ABI + DeployedContract + call + event decoding.',
      fields: [
        Web3DemoField(label: 'Token', value: token.eip55With0x),
        Web3DemoField(label: 'Holder', value: owner.eip55With0x),
        Web3DemoField(label: 'Name', value: name),
        Web3DemoField(label: 'Symbol', value: symbol),
        Web3DemoField(label: 'Decimals', value: decimalsRaw.toString()),
        Web3DemoField(
          label: 'Total Supply',
          value: _formatTokenAmount(totalSupplyRaw, decimalsRaw.toInt()),
        ),
        Web3DemoField(
          label: 'Holder Balance',
          value: _formatTokenAmount(balanceRaw, decimalsRaw.toInt()),
        ),
        Web3DemoField(
          label: 'Recent Transfer Logs',
          value: logs.length.toString(),
        ),
      ],
      lines: decodedPreview.isEmpty
          ? const ['No recent transfer logs were returned in the sampled block range.']
          : decodedPreview,
    );
  }

  Future<Web3DemoSection> demonstrateEncoding(
    String tokenAddress,
    String recipientAddress,
  ) async {
    final token = EthereumAddress.fromHex(tokenAddress);
    final recipient = EthereumAddress.fromHex(recipientAddress);
    final contract = _erc20Contract(token);
    final transfer = ContractFunction(
      'transfer',
      const [
        FunctionParameter('to', AddressType()),
        FunctionParameter('value', UintType()),
      ],
      outputs: const [
        FunctionParameter('success', BoolType()),
      ],
      mutability: StateMutability.nonPayable,
    );

    final encodedCall = transfer.encodeCall([
      recipient,
      BigInt.from(1234567),
    ]);
    final callRawResult = await _client.callRaw(
      contract: token,
      data: contract.function('symbol').encodeCall(const []),
    );
    final decodedSymbol = contract.function('symbol').decodeReturnValues(callRawResult);
    final tx = Transaction.callContract(
      contract: contract,
      function: transfer,
      parameters: [recipient, BigInt.from(1234567)],
      maxGas: 90000,
      nonce: 0,
      gasPrice: EtherAmount.fromInt(EtherUnit.gwei, 20),
      value: EtherAmount.zero(),
    );
    final estimatedGas = await _client.estimateGas(
      to: token,
      data: tx.data,
    );

    return Web3DemoSection(
      id: 'encoding',
      title: 'ABI Encoding And Gas',
      subtitle: 'Encode contract calldata and estimate gas before sending.',
      fields: [
        Web3DemoField(label: 'Function Signature', value: transfer.encodeName()),
        Web3DemoField(
          label: 'Selector',
          value: bytesToHex(transfer.selector, include0x: true),
        ),
        Web3DemoField(
          label: 'Encoded Calldata',
          value: bytesToHex(
            encodedCall,
            include0x: true,
            padToEvenLength: true,
          ),
        ),
        Web3DemoField(label: 'callRaw(symbol)', value: callRawResult),
        Web3DemoField(
          label: 'Manual Decode',
          value: decodedSymbol.first.toString(),
        ),
        Web3DemoField(label: 'Estimated Gas', value: estimatedGas.toString()),
        Web3DemoField(
          label: 'Unsigned Legacy Tx',
          value: bytesToHex(
            tx.getUnsignedSerialized(chainId: 1),
            include0x: true,
            padToEvenLength: true,
          ),
        ),
      ],
      lines: const [
        'This section demonstrates local ABI encoding and gas estimation without broadcasting a transaction.',
      ],
    );
  }

  Future<Web3DemoSection> inspectWallet(
    String privateKeyHex,
    String message,
  ) async {
    final credentials = EthPrivateKey.fromHex(privateKeyHex);
    final messageHash = keccakUtf8(message);
    final signatureBytes = credentials.signPersonalMessageToUint8List(
      Uint8List.fromList(utf8.encode(message)),
    );
    final transaction = Transaction(
      to: EthereumAddress.fromHex(sampleAddress),
      nonce: 7,
      maxGas: 21000,
      gasPrice: EtherAmount.fromInt(EtherUnit.gwei, 20),
      value: EtherAmount.inWei(BigInt.from(1000000000000000)),
    );
    final signedTx = signTransactionRaw(transaction, credentials, chainId: 1);

    return Web3DemoSection(
      id: 'wallet',
      title: 'Wallet And Signing',
      subtitle: 'Private key to address, personal message signing, raw transaction signing.',
      fields: [
        Web3DemoField(label: 'Private Key', value: privateKeyHex),
        Web3DemoField(
          label: 'Derived Address',
          value: credentials.address.eip55With0x,
        ),
        Web3DemoField(
          label: 'Public Key',
          value: bytesToHex(
            credentials.encodedPublicKey,
            include0x: true,
            padToEvenLength: true,
          ),
        ),
        Web3DemoField(label: 'Message', value: message),
        Web3DemoField(
          label: 'keccak256(message)',
          value: bytesToHex(
            messageHash,
            include0x: true,
            padToEvenLength: true,
          ),
        ),
        Web3DemoField(
          label: 'Personal Signature',
          value: bytesToHex(
            signatureBytes,
            include0x: true,
            padToEvenLength: true,
          ),
        ),
        Web3DemoField(
          label: 'Signed Raw Tx',
          value: bytesToHex(
            signedTx,
            include0x: true,
            padToEvenLength: true,
          ),
        ),
      ],
      lines: const [
        'The private key in this demo is public and only used to show local signing APIs.',
      ],
    );
  }

  Future<Web3DemoSection> _networkSection() async {
    final clientVersion = await _client.getClientVersion();
    final networkId = await _client.getNetworkId();
    final listening = await _client.isListeningForNetwork();
    final peerCount = await _client.getPeerCount();
    final protocolVersion = await _client.getEtherProtocolVersion();
    final syncing = await _client.getSyncStatus();
    final gasPrice = await _client.getGasPrice();
    final blockNumber = await _client.getBlockNumber();
    final blockInfo = await _client.getBlockInformation();
    final feeHistory = await _client.getFeeHistory(
      5,
      atBlock: const BlockNum.current(),
      rewardPercentiles: const [25, 50, 75],
    );

    return Web3DemoSection(
      id: 'network',
      title: 'Network Overview',
      subtitle: 'Demonstrates node, chain, block, gas and fee APIs.',
      fields: [
        Web3DemoField(label: 'RPC', value: _rpcUrl),
        Web3DemoField(label: 'Client Version', value: clientVersion),
        Web3DemoField(label: 'Network ID', value: networkId.toString()),
        Web3DemoField(label: 'Listening', value: listening.toString()),
        Web3DemoField(label: 'Peer Count', value: peerCount.toString()),
        Web3DemoField(
          label: 'Protocol Version',
          value: protocolVersion.toString(),
        ),
        Web3DemoField(label: 'Latest Block', value: blockNumber.toString()),
        Web3DemoField(
          label: 'Block Timestamp',
          value: blockInfo.timestamp.toIso8601String(),
        ),
        Web3DemoField(
          label: 'Base Fee',
          value: blockInfo.baseFeePerGas == null
              ? 'Not supported'
              : '${_formatGwei(blockInfo.baseFeePerGas!)} gwei',
        ),
        Web3DemoField(
          label: 'Gas Price',
          value: '${_formatGwei(gasPrice)} gwei',
        ),
      ],
      lines: [
        syncing.isSyncing
            ? 'Node sync progress: ${syncing.currentBlock}/${syncing.finalBlock} starting from ${syncing.startingBlock}.'
            : 'Node reports that it is not currently syncing.',
        'Fee history oldest block: ${feeHistory['oldestBlock']}.',
        'Fee history base fees: ${(feeHistory['baseFeePerGas'] as List<dynamic>).take(3).join(', ')}',
        'The typed helpers here come from `Web3Client` and already wrap several raw JSON-RPC methods.',
      ],
    );
  }

  Future<Web3DemoSection> _rawRpcSection() async {
    final chainIdHex = await _client.makeRPCCall<String>('eth_chainId');
    final blockHex = await _client.makeRPCCall<String>('eth_blockNumber');
    final sha3 = await _client.makeRPCCall<String>('web3_sha3', [
      bytesToHex(
        Uint8List.fromList(utf8.encode('web3dart-demo')),
        include0x: true,
        padToEvenLength: true,
      ),
    ]);

    return Web3DemoSection(
      id: 'raw-rpc',
      title: 'Raw RPC Helper',
      subtitle: 'Demonstrates `makeRPCCall` for methods without a typed wrapper.',
      fields: [
        Web3DemoField(label: 'eth_chainId', value: chainIdHex),
        Web3DemoField(label: 'eth_blockNumber', value: blockHex),
        Web3DemoField(label: 'web3_sha3', value: sha3),
      ],
      lines: [
        'This is useful when you want to stay inside web3dart but call a JSON-RPC method directly.',
        'Decoded chain id: ${hexToInt(chainIdHex)}.',
      ],
    );
  }

  Future<Web3DemoSection> _addressSection(String rawAddress) {
    return inspectAddress(rawAddress);
  }

  Future<Web3DemoSection> _erc20Section(
    String tokenAddress,
    String ownerAddress,
  ) {
    return inspectToken(tokenAddress, ownerAddress);
  }

  Future<Web3DemoSection> _encodingSection(
    String tokenAddress,
    String recipientAddress,
  ) {
    return demonstrateEncoding(tokenAddress, recipientAddress);
  }

  Future<Web3DemoSection> _walletSection(
    String privateKey,
    String message,
  ) {
    return inspectWallet(privateKey, message);
  }

  DeployedContract _erc20Contract(EthereumAddress tokenAddress) {
    return DeployedContract(
      ContractAbi.fromJson(_erc20Abi, 'ERC20'),
      tokenAddress,
    );
  }

  String _formatEther(EtherAmount amount) {
    final value = amount.getValueInUnit(EtherUnit.ether);
    return value.toStringAsFixed(value >= 1 ? 6 : 12);
  }

  String _formatGwei(EtherAmount amount) {
    return amount.getValueInUnit(EtherUnit.gwei).toStringAsFixed(3);
  }

  String _formatTokenAmount(BigInt rawValue, int decimals) {
    if (decimals == 0) {
      return rawValue.toString();
    }

    final digits = rawValue.toString().padLeft(decimals + 1, '0');
    final integerPart = digits.substring(0, digits.length - decimals);
    final decimalPart = digits.substring(digits.length - decimals);
    final trimmedDecimalPart = decimalPart.replaceFirst(RegExp(r'0+$'), '');
    if (trimmedDecimalPart.isEmpty) {
      return integerPart;
    }
    return '$integerPart.$trimmedDecimalPart';
  }

  Future<void> dispose() async {
    _httpClient.close();
    await _client.dispose();
  }
}
