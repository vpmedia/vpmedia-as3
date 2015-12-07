/*
 * =BEGIN CLOSED LICENSE
 *
 * Copyright (c) 2013-2014 Andras Csizmadia
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
package hu.vpmedia.mvc {
/**
 * The model is the element that stores the data that is used in the MVC triad.
 * The model can be as simple as storing one primitive value such as a string,
 * yet it can also store extremely complex structures of data.
 * The defining aspects of the model are that it acts as a storehouse for data
 * and that it exists independently of the view and the controller.
 * The model should never have a reference to the view or the controller.
 * This is absolutely essential to the functioning of the MVC pattern because
 * the model's independence is what creates the flexibility in the MVC pattern.
 * If a model has a reference to a view or controller then it is tightly coupled,
 * and it is specific to a particular type of controller and/or view. However,
 * if the model communicates without having to have references to specific types
 * of controllers or views then it can be used with many different types of controllers
 * and views.
 */
public interface IBaseModel {

}
}
