/*
 * Copyright (c) 2008-2009 the original author or authors
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */
package org.as3commons.logging.setup.target {

import flash.desktop.NativeApplication;
import flash.events.Event;
import flash.events.EventDispatcher;
import flash.events.IEventDispatcher;
import flash.events.IOErrorEvent;
import flash.events.OutputProgressEvent;
import flash.filesystem.File;
import flash.filesystem.FileMode;
import flash.filesystem.FileStream;

import org.as3commons.logging.api.ILogTarget;
import org.as3commons.logging.util.LogMessageFormatter;

/**
 * <code>AirFileTarget</code> logs statements to a log file on the hard disk.
 *
 * <p>For air application files you might want to store your log on the local
 * File system. It is stored in a extended log format which should be possible
 * to be read with common log file parsers.
 * </p>
 *
 * <p>Per application startup and at the turn of every day it will change to a
 * new file named with the date of that day and containing the application
 * startup number if started more than once.
 * The file will be named using the <code>SWF_URL</code>.
 * </p>
 *
 * <listing>LOGGER_FACTORY.setup = new SimpleTargetSetup( new AirFileTarget );</listing>
 *
 * @author Martin Heidegger
 * @since 2.0
 * @see org.as3commons.logging.util.SWFInfo#init()
 * @see http://www.w3.org/TR/WD-logfile.html
 */
public final class AirFileTarget extends EventDispatcher implements ILogTarget {

    /**
     * Dispatched when the file is closed after disposing.
     * This gets called every time a stream is disposed.
     *
     * @eventType flash.event.Event.COMPLETE
     * @see #dispose()
     */
    [Event(name="complete", type="flash.events.Event")]

    /** Default file pattern to be used for new files. */
    public static const DEFAULT_FILE_PATTERN:String =
            File.applicationStorageDirectory.resolvePath("{file}-{date}.log").nativePath;

    /** Expression to find the position of {date} in the path pattern. */
    private static const DATE:RegExp = /{date}/g;

    /** Expression to find the position of {file} in the path pattern. */
    private static const FILE:RegExp = /{file}/g;

    /*FDT_IGNORE*/
    /** Month names to stringify the date */
    private static const MONTHS:Array = [ "JAN", "FEB", "MAR", "APR", "MAY",
        "JUN", "JUL", "AUG", "SEP", "OCT",
        "NOV", "DEC" ];
    /*FDT_IGNORE*/

    /** Pattern used to generate the files. */
    private var _filePattern:String;

    /** Files to write the log statement. */
    private var _file:File;

    /** Stream to write out. */
    private var _stream:FileStream;

    /** Date of the former log statement, used to make sure to know if the day changed. */
    private var _formerDate:Number = -1;

    // Not customizable since the log-file header would need to adapt
    private const _formatter:LogMessageFormatter =
            new LogMessageFormatter("{logTime} {logLevel} {name}{atPerson} \"{message_dqt}\"");

    private const ERR_STR:String = "[SWF url not initialized. Please call SWFInfo.init(stage).]";

    /**
     * Since the output of the files is merely
     *
     * @param filePattern Pattern to be used to generate the output files.
     */
    public function AirFileTarget(filePattern:String = null) {
        this.filePattern = filePattern;
    }

    public function set filePattern(filePattern:String):void {
        _filePattern = filePattern || DEFAULT_FILE_PATTERN;
        var newFileName:String = createFileName(new Date());
        if (_file && _file.name != newFileName) {
            dispose();
        }
    }

    /**
     * @inheritDoc
     */
    public function log(name:String, shortName:String, level:int, timeStamp:Number, message:String, params:*, person:String, context:String, shortContext:String):void {
        // TODO: Use another way to verify the date-change. This one is
        // not super performant.
        // Note: using the timestamp of the log statment
        // might be a good idea but its implementation has to be able to take
        // into account that the timeStamp can switch to days before and after
        // the former log statement.
        var date:Date;
        if (!_file || !_file.exists || (date = new Date()).dateUTC != _formerDate) {

            dispose();
            if (date == null) {
                date = new Date();
            }
            if (!_stream) {
                _stream = new FileStream();
                _stream.addEventListener(IOErrorEvent.IO_ERROR, onFileStreamIOError, false, 0, true);
                _stream.addEventListener(OutputProgressEvent.OUTPUT_PROGRESS, disposeFinished, false, 0, true);
            }
            _formerDate = date.dateUTC;
            _file = new File(createFileName(date));
            _stream.openAsync(_file, FileMode.APPEND);
            NativeApplication.nativeApplication.addEventListener(Event.EXITING, dispose, false, 0, true);
            /*FDT_IGNORE*/
            var descriptor:XML = NativeApplication.nativeApplication.applicationDescriptor;
            var ns:Namespace = descriptor.namespace();
            _stream.writeUTFBytes("#Version: 1.0\n" +
                    "#Software: " + descriptor.ns::name + " v"
                    + descriptor.ns::version + " (running in Adobe Air "
                    + NativeApplication.nativeApplication.runtimeVersion
                    + ", publisherID: " + NativeApplication.nativeApplication.publisherID
                    + " )\n" +
                    "#Date: " + date.dateUTC + "-" + MONTHS[ date.monthUTC ]
                    + "-" + date.fullYearUTC + " " + date.hoursUTC
                    + ":" + date.minutesUTC + ":" + date.secondsUTC
                    + "." + date.millisecondsUTC + "\n" +
                    "#Fields: time x-method x-name x-comment\n");
            /*FDT_IGNORE*/
        }

        const formattedMessage:String = _formatter.format(name, shortName, level, timeStamp, message,
                params, person, context, shortContext)
                + "\n";
        try {
            _stream.writeUTFBytes(formattedMessage);
        } catch (error:Error) {
            // swallow Error #2029: This URLStream object does not have a stream opened.
        }
        trace(formattedMessage);
    }

    /**
     * Closes the file and streams open.
     *
     * @param event parameter to make it possible to add this method as event listener
     */
    public function dispose(event:Event = null):void {
        if (_file) {
            _stream.close();
            _stream = null;
            _file.cancel();
            _file = null;
            NativeApplication.nativeApplication.removeEventListener("exiting", dispose);
        }
    }

    /**
     * Sends out the complete event if the disposal is finished.
     *
     * @param event Event that informs about the file to be closed.
     */
    private function disposeFinished(event:Event):void {
        if (event.target == _stream) {
            dispatchEvent(new Event(Event.COMPLETE));
        } else {
            IEventDispatcher(event.target).removeEventListener(
                    OutputProgressEvent.OUTPUT_PROGRESS, disposeFinished);
        }
    }

    /**
     * FileStream IOError Handler
     */
    private function onFileStreamIOError(event:IOErrorEvent):void {
        // swallow silently
    }

    /**
     * Generates a file name for the files that should be to output.
     *
     * @param date Date of the output file.
     * @param no Number of the file (-1 means it should not add a number)
     * @return Name for the file created using the file pattern.
     */
    private function createFileName(date:Date):String {
        const yearName:String = date.fullYearUTC.toString();
        const monthName:String = addLeadingZero((date.monthUTC + 1).toString());
        const dayName:String = addLeadingZero(date.dateUTC.toString());
        const hourName:String = addLeadingZero(date.hoursUTC.toString());
        const minuteName:String = addLeadingZero(date.minutesUTC.toString());

        const SEP:String = "-";
        //var dateString:String = yearName + DOT + monthName + DOT + dayName + DOT + hourName + DOT + minuteName;
        var dateString:String = yearName + SEP + monthName + SEP + dayName;
        var file:String = "logs/log";
        return _filePattern.replace(DATE, dateString).replace(FILE, file);
    }

    private function addLeadingZero(value:String):String {
        if (value.length == 1) {
            value = "0" + value;
        }
        return value;
    }
}
}