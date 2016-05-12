java -jar fbsCG.jar -fbs FlatBuffersPerformanceTestDesktop/bench.fbs -out FlatBuffersPerformanceTestDesktop/bench.swift -lang swift -lib exclude
java -jar fbsCG.jar -fbs Example/contacts.fbs -out Example/contactList.swift -lang swift -lib include
java -jar fbsCG.jar -fbs Example/contacts.fbs -out FlatBuffersSwiftTests/contactList.swift -lang swift -lib import
java -jar fbsCG.jar -fbs Example/sample_binary/monster.fbs -out Example/sample_binary/monster.swift -lang swift -lib import