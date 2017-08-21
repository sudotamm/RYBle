# RYBle
基于CoreBluetooth库封装的BleCentral服务类，使用block的方式简化了蓝牙启动、扫描、配对及数据更新的回调流程。

### Integrate in your project
use cocoapods:
```
pod 'RYBle'
```
or carthage:
```
github "sudotamm/RYBle"
```

### How to use

1. Initial ble central manager

```
      RYBleManager.sharedManager.bleInit(completion: nil) { state in
            print( state.description)
            // Deal with ble error status
        }
```
2. Scan ble devices

```
            RYBleManager.sharedManager.scan(services: services, discoverBlock: { discoverys in
                // Callback when device discovered
            }, completionBlock: {
                // Callback when scan process stoped
            }, errorBlock: { state in
                // Callback when error occurred in scan service and character progress
            })
```

3. Connect with ble device and received updated value from characters.

```
        RYBleManager.sharedManager.connect(peripheral: peripheral, connected: {
                // Callback when device connect succeed
        }, updateValue: { character in
                // Callback when character value updated
        }) { bleError in
                // Callback when error occurred in connect and update character process
        }
```

### Example
Clone or download this repository and then open ***.xcworkspace** file when pod dependencies installed.


