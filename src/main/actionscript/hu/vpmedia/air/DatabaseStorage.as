/*
 * =BEGIN CLOSED LICENSE
 *
 * Copyright (c) 2014 Andras Csizmadia
 * http://www.vpmedia.eu
 *
 * For information about the licensing and copyright please
 * contact Andras Csizmadia at andras@vpmedia.eu
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 *
 * =END CLOSED LICENSE
 */

package hu.vpmedia.air {
import flash.data.SQLConnection;
import flash.data.SQLMode;
import flash.data.SQLResult;
import flash.data.SQLStatement;
import flash.events.SQLErrorEvent;
import flash.events.SQLEvent;
import flash.filesystem.File;
import flash.utils.ByteArray;

import org.osflash.signals.ISignal;
import org.osflash.signals.Signal;

/**
 * TBD
 */
public class DatabaseStorage {

    //----------------------------------
    //  Public variables
    //----------------------------------

    /**
     * TBD
     */
    public var queried:ISignal = new Signal(SQLResult);

    /**
     * TBD
     */
    public var failed:ISignal = new Signal(SQLErrorEvent);

    //----------------------------------
    //  Private variables
    //----------------------------------

    /**
     * @private
     */
    private var fileName:String;

    /**
     * @private
     */
    private var password:String;

    /**
     * @private
     */
    private var salt:String;

    /**
     * @private
     */
    private var databaseFile:File;

    /**
     * @private
     */
    private var isCreateDatabase:Boolean;

    /**
     * @private
     */
    private var connection:SQLConnection;

    //----------------------------------
    //  Private static variables
    //----------------------------------

    /**
     * @private
     */
    private static const WEAK_PWD_ERR:String = "The password must be 8-32 characters long. It must contain at least one lowercase letter, at least one uppercase letter, and at least one number or symbol.";

    /**
     * @private
     */
    private static const GENERATOR:EncryptionKeyGenerator = new EncryptionKeyGenerator();


    //----------------------------------
    //  Constructor
    //----------------------------------

    /**
     * Constructor
     */
    public function DatabaseStorage() {
    }

    //----------------------------------
    //  API
    //----------------------------------

    /**
     * Initialize the service
     */
    public function initialize(fileName:String, pwd:String, slt:String):void {
        if (!SQLConnection.isSupported) {
            failed.dispatch(new SQLErrorEvent("Not supported"));
            return;
        }
        if (!GENERATOR.validateStrongPassword(pwd)) {
            failed.dispatch(new SQLErrorEvent(WEAK_PWD_ERR));
            return;
        }
        this.fileName = fileName;
        this.password = pwd;
        this.salt = slt;
        connection = new SQLConnection();
        databaseFile = File.applicationStorageDirectory.resolvePath(fileName);
        isCreateDatabase = !databaseFile.exists;
        const encryptionKey:ByteArray = GENERATOR.getEncryptionKey(password, salt);
        connection.addEventListener(SQLEvent.OPEN, onConnectionOpen, false, 0, true);
        connection.addEventListener(SQLErrorEvent.ERROR, onConnectionError, false, 0, true);
        connection.openAsync(databaseFile, SQLMode.CREATE, null, false, 1024, encryptionKey);
    }

    /**
     * Runs query on the database.
     */
    public function query(sql:String):void {
        var statement:SQLStatement = new SQLStatement();
        statement.sqlConnection = connection;
        statement.text = sql;
        statement.addEventListener(SQLEvent.RESULT, onConnectionResult, false, 0, true);
        statement.addEventListener(SQLErrorEvent.ERROR, onConnectionError, false, 0, true);
        statement.execute();
    }

    /**
     * Closes database connection.
     */
    public function close():void {
        connection.close();
    }

    //----------------------------------
    //  Event Handlers
    //----------------------------------

    /**
     * @private
     */
    private function onConnectionOpen(event:SQLEvent):void {
        connection.removeEventListener(SQLEvent.OPEN, onConnectionOpen);
        connection.removeEventListener(SQLErrorEvent.ERROR, onConnectionError);
    }

    /**
     * @private
     */
    private function onConnectionResult(event:SQLEvent):void {
        const statement:SQLStatement = SQLStatement(event.target);
        statement.removeEventListener(SQLEvent.RESULT, onConnectionResult);
        statement.removeEventListener(SQLErrorEvent.ERROR, onConnectionError);
        const result:SQLResult = statement.getResult();
        queried.dispatch(result);
    }

    /**
     * @private
     */
    private function onConnectionError(event:SQLErrorEvent):void {
        if (event.target is SQLStatement) {
            const statement:SQLStatement = SQLStatement(event.target);
            statement.removeEventListener(SQLEvent.RESULT, onConnectionResult);
            statement.removeEventListener(SQLErrorEvent.ERROR, onConnectionError);
        }
        failed.dispatch(event);
    }
}
}
