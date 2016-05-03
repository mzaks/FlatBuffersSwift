java -jar fbsCG.jar -fbs FlatBuffersPerformanceTestDesktop/bench.fbs -out FlatBuffersPerformanceTestDesktop/bench.swift -lang swift -lib exclude
java -jar fbsCG.jar -fbs Example/contacts.fbs -out Example/contactList.swift -lang swift -lib include
java -jar fbsCG.jar -fbs Example/contacts.fbs -out FlatBuffersSwiftTests/contactList.swift -lang swift -lib import