# DC/OS Diagnostics on Windows

## Compile

```
# Clone:
git clone git@github.com:dcos/dcos-diagnostics.git

# Build:
GOOS=windows GOARCH=386 go build .
```

## Start it

```
# Start a Powershell Window
.\dcos-diagnostics.exe --config dcos-diagnostics-config.json daemon
```

## Test it

```
curl http://localhost:61001/system/health/v1
```
