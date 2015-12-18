::
::=BEGIN CLOSED LICENSE
::
:: Copyright (c) 2013-2014 Andras Csizmadia
:: http://www.vpmedia.eu
::
:: For information about the licensing and copyright please
:: contact us at info@vpmedia.eu
::
:: THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
:: IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
:: FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
:: AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
:: LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
:: OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
:: THE SOFTWARE.
::
::=END CLOSED LICENSE
::

:: @usage: dump-p12 gradlefx gradlefx
:: @see: http://docs.oracle.com/javase/7/docs/technotes/tools/windows/keytool.html

:: Echo off and begin localisation of Environment Variables
@ECHO OFF & SETLOCAL

:: Prepare the Command Processor
VERIFY errors 2>nul
SETLOCAL ENABLEEXTENSIONS
IF ERRORLEVEL 1 ECHO Warning: Unable to enable extensions.
SETLOCAL ENABLEDELAYEDEXPANSION

:: Save base directory
PUSHD %CD%
::PUSHD %~dp0

:: Set title
TITLE %~n0

:: STARTUP
keytool -list -keystore %1.p12 -storetype pkcs12 -v -storepass %2
GOTO :EXIT

:: SHUTDOWN
:EXIT
POPD
ENDLOCAL
PAUSE
EXIT /B 0 
GOTO :EOF