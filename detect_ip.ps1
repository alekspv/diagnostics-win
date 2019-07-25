# this is a dirty prototyping hack and will not work in a real cluster
(Invoke-WebRequest -uri "http://ifconfig.me/ip").Content
