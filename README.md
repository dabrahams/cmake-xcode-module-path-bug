# Demonstrates a bug in CMake's Xcode generator with add_subdirectory and Swift modules

This command works fine:

```
cmake -G Ninja -S . -B .ninja-build && cmake --build .ninja-build
```

This one, which declares all the targets at the top level, works fine:

```
cmake -G Xcode -D WORKS_FINE -S . -B .xcode-build0 && cmake --build .xcode-build0
```

This one fails:

```
cmake -G Xcode -S . -B .xcode-build && cmake --build .xcode-build
```

The error is 

```
/Users/dave/Documents/WIP/cmake-xcode-module-path-bug/Lib1/Lib1.swift:1:8: error: no such module 'Lib2'
import Lib2
       ^
...

The following build commands failed:
	SwiftEmitModule normal arm64 Emitting\ module\ for\ Lib1 (in target 'Lib1' from project 'demo')
	SwiftCompile normal arm64 /Users/dave/Documents/WIP/cmake-xcode-module-path-bug/Lib1/Lib1.swift (in target 'Lib1' from project 'demo')
	SwiftCompile normal arm64 Compiling\ Lib1.swift /Users/dave/Documents/WIP/cmake-xcode-module-path-bug/Lib1/Lib1.swift (in target 'Lib1' from project 'demo')
(3 failures)
```

The failing command follows.  It is no surprise that it can't find Lib2. The module file `Lib2.swiftmodule` is in `.xcode-build/Lib2/Debug` and `.xcode-build/build/Lib2.build/Debug/Objects-normal/arm64`
but neither is a `-I` option to this command.

```
/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/swift-frontend -c -primary-file /Users/dave/Documents/WIP/cmake-xcode-module-path-bug/Lib1/Lib1.swift -emit-dependencies-path /Users/dave/Documents/WIP/cmake-xcode-module-path-bug/.xcode-build/build/Lib1.build/Debug/Objects-normal/arm64/Lib1.d -emit-const-values-path /Users/dave/Documents/WIP/cmake-xcode-module-path-bug/.xcode-build/build/Lib1.build/Debug/Objects-normal/arm64/Lib1.swiftconstvalues -emit-reference-dependencies-path /Users/dave/Documents/WIP/cmake-xcode-module-path-bug/.xcode-build/build/Lib1.build/Debug/Objects-normal/arm64/Lib1.swiftdeps -serialize-diagnostics-path /Users/dave/Documents/WIP/cmake-xcode-module-path-bug/.xcode-build/build/Lib1.build/Debug/Objects-normal/arm64/Lib1.dia -target arm64-apple-macos14.2 -Xllvm -aarch64-use-tbi -enable-objc-interop -stack-check -sdk /Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX14.2.sdk -I /Users/dave/Documents/WIP/cmake-xcode-module-path-bug/.xcode-build/Lib1/Debug -I /Users/dave/Documents/WIP/cmake-xcode-module-path-bug/.xcode-build/Lib2 -F /Users/dave/Documents/WIP/cmake-xcode-module-path-bug/.xcode-build/Lib1/Debug -no-color-diagnostics -g -swift-version 4 -enforce-exclusivity\=checked -Onone -serialize-debugging-options -const-gather-protocols-file /Users/dave/Documents/WIP/cmake-xcode-module-path-bug/.xcode-build/build/Lib1.build/Debug/Objects-normal/arm64/Lib1_const_extract_protocols.json -enable-bare-slash-regex -empty-abi-descriptor -validate-clang-modules-once -clang-build-session-file /var/folders/wg/wvvfbgl96f727hzqdtpfrrl80000gn/C/org.llvm.clang/ModuleCache.noindex/Session.modulevalidation -Xcc -working-directory -Xcc /Users/dave/Documents/WIP/cmake-xcode-module-path-bug -resource-dir /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/swift -enable-anonymous-context-mangled-names -Xcc -ivfsstatcache -Xcc /var/folders/wg/wvvfbgl96f727hzqdtpfrrl80000gn/C/com.apple.DeveloperTools/15.2-15C500b/Xcode/SDKStatCaches.noindex/macosx14.2-23C53-df0db8920d7ae99241a1bc0f08d2dced.sdkstatcache -Xcc -I/Users/dave/Documents/WIP/cmake-xcode-module-path-bug/.xcode-build/build/Lib1.build/Debug/swift-overrides.hmap -Xcc -I/Users/dave/Documents/WIP/cmake-xcode-module-path-bug/.xcode-build/Lib1/Debug/include -Xcc -I/Users/dave/Documents/WIP/cmake-xcode-module-path-bug/.xcode-build/Lib2 -Xcc -I/Users/dave/Documents/WIP/cmake-xcode-module-path-bug/.xcode-build/build/Lib1.build/Debug/DerivedSources-normal/arm64 -Xcc -I/Users/dave/Documents/WIP/cmake-xcode-module-path-bug/.xcode-build/build/Lib1.build/Debug/DerivedSources/arm64 -Xcc -I/Users/dave/Documents/WIP/cmake-xcode-module-path-bug/.xcode-build/build/Lib1.build/Debug/DerivedSources -Xcc -DCMAKE_INTDIR\=\"Debug\" -module-name Lib1 -frontend-parseable-output -disable-clang-spi -target-sdk-version 14.2 -target-sdk-name macosx14.2 -external-plugin-path /Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX14.2.sdk/usr/lib/swift/host/plugins\#/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX14.2.sdk/usr/bin/swift-plugin-server -external-plugin-path /Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX14.2.sdk/usr/local/lib/swift/host/plugins\#/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX14.2.sdk/usr/bin/swift-plugin-server -external-plugin-path /Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/usr/lib/swift/host/plugins\#/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/usr/bin/swift-plugin-server -external-plugin-path /Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/usr/local/lib/swift/host/plugins\#/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/usr/bin/swift-plugin-server -plugin-path /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/swift/host/plugins -plugin-path /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/local/lib/swift/host/plugins -parse-as-library -o /Users/dave/Documents/WIP/cmake-xcode-module-path-bug/.xcode-build/build/Lib1.build/Debug/Objects-normal/arm64/Lib1.o -index-unit-output-path /Lib1.build/Debug/Objects-normal/arm64/Lib1.o
```

The CMake project's Swift Package Manager translation is in
`Package.swift`. Opening that file in Xcode and building there works,
and `swift build` works.
