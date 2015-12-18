vpmedia_commons
=======(=======

Workflow
--------

* Use ** GitFlow **
* Never commit to ** master ** branch, use ** develop ** and ** feature ** branches
 

Building
--------

Open a command line and type:

> gradle

Recommended Environment Variable Settings
-----------------------------------------

## JAVA + Scala
* JAVA_HOME=C:\Program Files\Java\jdk
* _JAVA_OPTIONS=-Xms256m -Xmx4096m
* SCALA_HOME=C:\Work\sdks\scala\2.11.0

## CI
* ANT_HOME=c:\Work\sdks\apache-ant\1.9.4
* MAVEN_HOME=C:\Work\sdks\apache-maven\3.2.2
* GRADLE_HOME=C:\Work\sdks\gradle\2.4
* GIT_HOME=c:\Work\sdks\git\1.8.3

## CI / JSTestDrive
* EXPLORER_BIN=C:\PROGRA~2\INTERN~1\iexplore.exe
* FIREFOX_BIN=c:/Work/apps/PortableApps/FirefoxPortable/FirefoxPortable.exe

## CI / Asset Generation
* FFMPEG_HOME=c:\Work\tools\ffmpeg
* TEXTURE_PACKER_HOME=c:\Work\tools\TexturePacker
* IMAGEMAGICK_HOME=c:\Work\tools\imagemagick
* PNG2ATF_HOME=c:\Work\tools\png2atf
* WEBIFY_HOME=c:\Work\tools\webify
* SPIRIT_HOME=c:\Work\tools\spirit

## C + D != E :)
* MINGW_HOME=c:\Work\sdks\mingw
* MSYS_HOME=c:\Work\sdks\mingw\msys\1.0
* DMD_HOME=c:\Work\sdks\dmd\2.063\windows

## Adobe Flash
* AIR_EXTENSION_PATH=c:\Work\sdks\adobe-air\ane
* AIR_HOME=C:\Work\sdks\adobe-air\17.0.0
* FLEX_HOME=c:\Work\sdks\apache-flex\4.12.1
* FLASHPLAYER_DEBUGGER=C:\Work\tools\flashplayer.exe
* FLASH_PLAYER_EXE=C:\Work\tools\flashplayer.exe

## Adobe CrossBridge
* FLASCC_AIR_ROOT=/cygdrive/c/Work/sdks/adobe-air/17.0.0
* FLASCC_GDB_RUNTIME=/cygdrive/c/Work/tools/flashplayer.exe
* FLASCC_ROOT=c:\Work\sdks\adobe-crossbridge\15.0.0

## Python
* PYTHONHOME=c:\Work\sdks\python\2.7.6.1\App
* PYTHONPATH=c:\Work\sdks\emscripten\python\2.7.6.1\App

## Android
* ANDROID_HOME=C:\Work\sdks\android-sdk
* ANDROID_NDK_ROOT=C:\Work\sdks\android-ndk
* ANDROID_SDK=C:\Work\sdks\android-sdk
* ANDROID_SETUP=true

## Haxe
* HAXEPATH=C:\Work\sdks\haxe\3.13
* HAXE_HOME=C:\Work\sdks\haxe\3.13
* NEKO_INSTPATH=C:\Work\sdks\neko\2.0.0\

## Web and Application Servers
* PHPBIN=C:\xampp\php\.\php.exe
* TOMCAT_HOME=C:\Work\servers\tomcat

## Media Servers
* RED5_HOME=C:\Work\servers\red5
* WMSAPP_HOME=C:\Work\servers\wowza\
* WMSCONFIG_HOME=C:\Work\servers\wowza\
* WMSINSTALL_HOME=C:\Work\servers\wowza\

## Other
* GROOVY_HOME=C:\Work\sdks\groovy\2.0.1
* EMSCRIPTEN=C:\work\sdks\emscripten

## SDK and Tooling Install Guide

### Oracle (Sun) Java SE + JDK

[Install Guide](https://www.java.com/en/download/help/index_installing.xml)

[Download JavaSE](http://www.oracle.com/technetwork/java/javase/downloads/index.html)

> Setting the **JAVA_HOME** environment variable is essential

> Setting the **%JAVA_HOME%/bin** path variable is essential

> To make sure Java is installed open a command prompt and type **java -version**

### Apache Ant

[Install Guide](https://ant.apache.org/manual/install.html#installing)

[Download Apache Ant](http://xenia.sote.hu/ftp/mirrors/www.apache.org//ant/binaries/apache-ant-1.9.4-bin.zip)

> Setting the **ANT_HOME** environment variable is essential

> Setting the **%ANT_HOME%/bin** path variable is essential

> To make sure Ant is installed open a command prompt and type **ant -version**

### Adobe AIR SDK

[Install Guide](https://www.adobe.com/devnet/air/air-sdk-download.html)

[Download AIR SDK for Windows](https://www.adobe.com/devnet/air/air-sdk-download-win.html)

[Download AIR SDK for Mac OS](https://www.adobe.com/devnet/air/air-sdk-download-mac.html)
    
> Setting the **AIR_HOME** environment variable is essential

> Setting the **%AIR_HOME%/bin** path variable is optional (do not set both FLEX and AIR SDKs!)

> To make sure AIR SDK is installed open a command prompt and type **%AIR_HOME%/bin/adt -version**

### Apache Flex SDK 

[Install Guide](https://flex.apache.org/doc-getstarted.html)

[Download and Install using FlexSDK Installer](https://flex.apache.org/installer.html)

> Setting the **FLEX_HOME** environment variable is essential

> Setting the **%FLEX_HOME%/bin** path variable is optional (do not set both FLEX and AIR SDKs!)

> To make sure Flex SDK is installed open a command prompt and type **%FLEX_HOME%/bin/mxmlc -version**

### Adobe Flash Player for Browsers

[Install Guide](https://www.adobe.com/support/flashplayer/downloads.html)
    
[Download Flash Player for Windows - Internet Explorer only](http://download.macromedia.com/pub/flashplayer/updaters/17/flashplayer_17_ax_debug.exe)

[Download Flash Player for Windows - all other browsers](http://download.macromedia.com/pub/flashplayer/updaters/17/flashplayer_17_plugin_debug.exe)

[Download Flash Player for Mac OS](http://fpdownload.macromedia.com/pub/flashplayer/updaters/17/flashplayer_17_plugin_debug.dmg)

> Note: In some systems manual setting of mm.cfg file is needed:
  http://help.adobe.com/en_US/flex/using/WS2db454920e96a9e51e63e3d11c0bf69084-7fc9.html

### Adobe Flash Player Standalone

[Install Guide](https://www.adobe.com/support/flashplayer/downloads.html)
    
[Download Flash Player Standalone for Windows](http://download.macromedia.com/pub/flashplayer/updaters/11/flashplayer_17_sa_debug.exe)

[Download Flash Player Standalone for Mac OS](http://fpdownload.macromedia.com/pub/flashplayer/updaters/11/flashplayer_17_sa_debug.app.zip)

> Setting the **FLASH_PLAYER_EXE** environment variable is essential

> Important: In Mac OS the variable must be set to the name of the executable file not the package:

    export "FLASH_PLAYER_EXE=<PATH TO DEBUG PLAYER>/Flash Player Debugger.app/Contents/MacOS/Flash Player Debugger" 

## Optional dependencies

### Adobe AIR Runtime

[Install Guide](https://get.adobe.com/air/)

[Download AIR Runtime for Windows](https://get.adobe.com/air/)

[Download AIR Runtime for Mac OS](https://get.adobe.com/air/)

[Download AIR Runtime for Android](https://get.adobe.com/air/)

### Adobe CrossBridge SDK

[Install Guide](http://www.adobe.com/devnet-docs/flascc/README.html)

[Download and Install](http://sourceforge.net/projects/crossbridge/files/)

> Setting the **FLASCC_ROOT** environment variable is essential

> To make sure CrossBridge SDK is installed open a command prompt and type **%FLASCC_ROOT%/run**

### ImageMagick

[Download ImageMagick - Windows](http://www.imagemagick.org/script/binary-releases.php#windows)

[Download ImageMagick - Mac OS X](http://www.imagemagick.org/script/binary-releases.php#macosx)

> Setting the **IMAGEMAGICK_HOME** environment variable is essential

### TexturePacker

[Download TexturePacker - Windows](http://www.codeandweb.com/texturepacker/start-download?os=win64)

[Download TexturePacker - Mac OS X](http://www.codeandweb.com/texturepacker/start-download?os=mac)

> Setting the **TEXTURE_PACKER_HOME** environment variable is essential

### FFMPEG

> Setting the **FFMPEG_HOME** environment variable is essential

Jenkins Plugins
---------------

* Analysis Collector
* BitBucket  
* Build Environment  
* Checkstyle 
* Conditional BuildStep
* Dashboard View
* GitHub    
* Gradle    
* JobConfigHistory
* Multiple SCMs    
* Naginator    
* Next Build Number    
* PMD    
* Priority Sorter
* Publish Over FTP
* Publish Over SSH
* Run Condition
* Static Code Analysis  
* ThinBackup
* Timestamper
* Version Number    
* Warnings
* Workspace Cleanup
* Youtrack  
* Credentials Binding Plugin
* Mask Passwords

License
-------

Copyright (c) 2013-2015 Andras Csizmadia
http://www.vpmedia.eu

For information about the licensing and copyright please
contact us at info@vpmedia.eu

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
