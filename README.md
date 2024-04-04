# Demonstrates a bug in CMake (or possibly xcodebuild).

This command works fine:

```
cmake -G Ninja -S . -B .ninja-build && cmake --build .ninja-build
```

This one fails:

```
cmake -G Xcode -S . -B .xcode-build && cmake --build .xcode-build
```

The error is 

```
/tmp/y/Lib1.swift:1:29: error: no such module 'RealModule'
@_implementationOnly import RealModule
...

The following build commands failed:
	SwiftEmitModule normal arm64 Emitting\ module\ for\ Lib1 (in target 'Lib1' from project 'demo')
	SwiftCompile normal arm64 /tmp/y/Lib1.swift (in target 'Lib1' from project 'demo')
	SwiftCompile normal arm64 Compiling\ Lib1.swift /tmp/y/Lib1.swift (in target 'Lib1' from project 'demo')
(3 failures)
```

The failing command follows.  It is no surprise that it can't find RealModule. The module file `RealModule.swiftmodule` is in `/tmp/y/.xcode-build/lib/Debug` and `.xcode-build/build/RealModule.build/Debug/Objects-normal/arm64/` but neither is a `-I` option to this command.  The closest is `-I /tmp/y/.xcode-build/Debug`, which is an empty directory (suggesting that it is wrong and `/tmp/y/.xcode-build/lib/Debug` was intended).

```
/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/swift-frontend -c -primary-file /tmp/y/Lib1.swift -emit-dependencies-path /tmp/y/.xcode-build/build/Lib1.build/Debug/Objects-normal/arm64/Lib1.d -emit-const-values-path /tmp/y/.xcode-build/build/Lib1.build/Debug/Objects-normal/arm64/Lib1.swiftconstvalues -emit-reference-dependencies-path /tmp/y/.xcode-build/build/Lib1.build/Debug/Objects-normal/arm64/Lib1.swiftdeps -serialize-diagnostics-path /tmp/y/.xcode-build/build/Lib1.build/Debug/Objects-normal/arm64/Lib1.dia -target arm64-apple-macos14.2 -Xllvm -aarch64-use-tbi -enable-objc-interop -stack-check -sdk /Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX14.2.sdk -I /tmp/y/.xcode-build/Debug -I /tmp/y/.xcode-build/swift -I /tmp/y/.xcode-build/_deps/swiftnumerics-src/Sources/_NumericsShims/include -F /tmp/y/.xcode-build/Debug -no-color-diagnostics -g -swift-version 4 -enforce-exclusivity\=checked -Onone -serialize-debugging-options -const-gather-protocols-file /tmp/y/.xcode-build/build/Lib1.build/Debug/Objects-normal/arm64/Lib1_const_extract_protocols.json -enable-bare-slash-regex -empty-abi-descriptor -validate-clang-modules-once -clang-build-session-file /var/folders/wg/wvvfbgl96f727hzqdtpfrrl80000gn/C/org.llvm.clang/ModuleCache.noindex/Session.modulevalidation -Xcc -working-directory -Xcc /tmp/y -resource-dir /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/swift -enable-anonymous-context-mangled-names -Xcc -ivfsstatcache -Xcc /var/folders/wg/wvvfbgl96f727hzqdtpfrrl80000gn/C/com.apple.DeveloperTools/15.2-15C500b/Xcode/SDKStatCaches.noindex/macosx14.2-23C53-df0db8920d7ae99241a1bc0f08d2dced.sdkstatcache -Xcc -I/tmp/y/.xcode-build/build/Lib1.build/Debug/swift-overrides.hmap -Xcc -I/tmp/y/.xcode-build/Debug/include -Xcc -I/tmp/y/.xcode-build/swift -Xcc -I/tmp/y/.xcode-build/_deps/swiftnumerics-src/Sources/_NumericsShims/include -Xcc -I/tmp/y/.xcode-build/build/Lib1.build/Debug/DerivedSources-normal/arm64 -Xcc -I/tmp/y/.xcode-build/build/Lib1.build/Debug/DerivedSources/arm64 -Xcc -I/tmp/y/.xcode-build/build/Lib1.build/Debug/DerivedSources -Xcc -DCMAKE_INTDIR\=\"Debug\" -module-name Lib1 -frontend-parseable-output -disable-clang-spi -target-sdk-version 14.2 -target-sdk-name macosx14.2 -external-plugin-path /Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX14.2.sdk/usr/lib/swift/host/plugins\#/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX14.2.sdk/usr/bin/swift-plugin-server -external-plugin-path /Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX14.2.sdk/usr/local/lib/swift/host/plugins\#/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX14.2.sdk/usr/bin/swift-plugin-server -external-plugin-path /Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/usr/lib/swift/host/plugins\#/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/usr/bin/swift-plugin-server -external-plugin-path /Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/usr/local/lib/swift/host/plugins\#/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/usr/bin/swift-plugin-server -plugin-path /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/swift/host/plugins -plugin-path /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/local/lib/swift/host/plugins -parse-as-library -o /tmp/y/.xcode-build/build/Lib1.build/Debug/Objects-normal/arm64/Lib1.o -index-unit-output-path /Lib1.build/Debug/Objects-normal/arm64/Lib1.o
```

The CMake project's Swift Package Manager translation is in
`Package.swift`. Opening that file in Xcode and building there works,
and `swift build` works.

**Note:** [swift-numerics](https://github.com/apple/swift-numerics) (which see) does some questionable things with global module path settings in its top-level CMakeLists.txt that may be triggering the problem, but presumably if the ninja generator can handle those things, the Xcode generator should be able to also.
