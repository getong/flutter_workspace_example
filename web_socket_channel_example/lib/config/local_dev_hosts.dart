const Set<String> localDevTlsHosts = {'127.0.0.1', 'localhost', '10.0.2.2'};

bool isLocalDevTlsHost(String host) => localDevTlsHosts.contains(host);
