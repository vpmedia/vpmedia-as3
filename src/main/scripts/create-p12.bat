::
::=BEGIN CLOSED LICENSE
::
:: Copyright (c) 2013-2014 Docmet Systems
:: http://www.docmet.com
::
:: For information about the licensing and copyright please
:: contact us at info@docmet.com
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

:: @usage: create-p12 gradlefx gradlefx
:: @see: http://help.adobe.com/en_US/AIR/1.5/devappshtml/WS5b3ccc516d4fbf351e63e3d118666ade46-7f74.html

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
adt -certificate -cn "com.docmet.air" -ou "LTD" -o "Docmet Systems" -c "HU" -validityPeriod 10 2048-RSA %1.p12 %2
GOTO :EXIT

:: SHUTDOWN
:EXIT
POPD
ENDLOCAL
PAUSE
EXIT /B 0 
GOTO :EOF