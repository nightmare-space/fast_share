速享启动时持续广播 $id,$messageBindPort
收到广播 sendJoinEvent


case1 
PC 端与移动端几乎同时打开

case2


A 扫描 B二维码 -> A sendJoinEvent B
B 收到消息后 -> B sendJoinEvent A

A 输入 B 的 IP <=> A 扫描 B二维码

A 通过 UPD 发现 B -> A sendJoinEvent B
B 收到消息后 -> B sendJoinEvent A
