# DC/OS Diagnostics on Windows

## Clone and change code

```
# Clone:
git clone git@github.com:dcos/dcos-diagnostics.git
```

In dcos-diagnostics the file `cmd/daemon.go` the `getNodeInfo` function must be changed to

```
func getNodeInfo(tr http.RoundTripper) (nodeutil.NodeInfo, error) {
    var options []nodeutil.Option
    defaultStateURL := url.URL{
        Scheme: "https",
        Host:   net.JoinHostPort(dcos.DNSRecordLeader, strconv.Itoa(dcos.PortMesosMaster)),
        Path:   "/state",
    }
    if defaultConfig.FlagForceTLS {
        options = append(options, nodeutil.OptionMesosStateURL(defaultStateURL.String()))
    }
    options = append(options, nodeutil.OptionDetectIP(`C:/dcos/detect_ip.ps1`))
    return nodeutil.NewNodeInfo(util.NewHTTPClient(defaultConfig.GetHTTPTimeout(), tr), defaultConfig.FlagRole, options...)
}
```


## Compile

```
# Build:
GOOS=windows GOARCH=386 go build .
```

## Start it

Create n a Windows machine e.g. the folder `c:\dcos` and copy the following files to that folder:

- `detect_ip.ps1`
- `dcos-diagnostics.exe`
- `dcos-diagnostics-config.json`
- `dcos-diagnostics-endpoint-config.json`
- `servicelist.txt`

Service can be started via:

```
# Start a Powershell Window
$env:DCOS_VERSION="1.13.0"
.\dcos-diagnostics.exe --config dcos-diagnostics-config.json --role agent daemon
```

## Test it

```
curl http://192.168.99.101:61001/system/health/v1

{
   "units" : [
      {
         "description" : "Windows Remote Management (WinRM) service implements the WS-Management protocol for remote management. WS-Management is a standard web services protocol used for remote software and hardware management. The WinRM service listens on the network for WS-Management requests and processes them. The WinRM Service needs to be configured with a listener using winrm.cmd command line tool or through Group Policy in order for it to listen over the network. The WinRM service provides access to WMI data and enables event collection. Event collection and subscription to events require that the service is running. WinRM messages use HTTP and HTTPS as transports. The WinRM service does not depend on IIS but is preconfigured to share a port with IIS on the same machine.  The WinRM service reserves the /wsman URL prefix. To prevent conflicts with IIS, administrators should ensure that any websites hosted on IIS do not use the /wsman URL prefix.",
         "health" : 0,
         "id" : "WinRM",
         "output" : "",
         "help" : "",
         "name" : ""
      },
      {
         "output" : "",
         "help" : "",
         "name" : "Admin Router Agent",
         "description" : "exposes a unified control plane proxy for components and services using Apache2",
         "health" : 0,
         "id" : "dcos-adminrouter"
      }
   ],
   "ip" : "192.168.99.101",
   "hostname" : "WIN-51M5EPKDVFO",
   "dcos_diagnostics_version" : "dev",
   "node_role" : "agent",
   "dcos_version" : "1.13.0",
   "mesos_id" : ""
}
```
