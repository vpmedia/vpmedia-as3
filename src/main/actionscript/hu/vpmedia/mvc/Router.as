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
import flash.system.System;

/**
 * @inheritDoc
 */
public final class Router extends BaseRouter {

    /**
     * @private
     */
    private var target:IBaseView;

    /**
     * @private
     */
    private var model:BaseModel;

    //----------------------------------
    //  Constructor
    //----------------------------------

    /**
     * Router
     *
     * @param model
     * @param target
     * @param routes
     */
    public function Router(model:BaseModel, target:IBaseView, routes:Array = null) {
        super();
        this.target = target;
        this.model = model;
        addRoutes(routes);
    }

    //----------------------------------
    //  View States
    //----------------------------------

    /**
     * @private
     */
    override protected function doTransition():void {
        const item:RouterStateVO = _nextStateQueue[0];
        const currentState:String = item.currentState;
        if (item.type == RouterStateVO.EXIT_CALLBACK) {
            signal.dispatch(BaseViewSignalTypes.TRANSITION_OUT_START, currentState);
            const view:BaseView = _viewStateMap[currentState];
            if(view)
                view.transitionOut();
            else
                viewTransitionOutHandler();
        } else if (item.type == RouterStateVO.ENTER_CALLBACK) {
            nextState(currentState);
        }
    }

    /**
     * @private
     */
    override protected function nextState(url:String):void {
        // check for existing view with the same id
        if (_viewStateMap[url]) {
            return;
        }
        // analyze path
        const currentState:RouterItem = _urlStateMap[url];
        // check for null view
        if(!currentState.view) {
            viewTransitionInHandler();
            return;
        }
        const currentStateView:BaseView = new currentState.view(model);
        // create model
        if (currentState.model) {
            const currentStateModel:BaseModel = new currentState.model();
            currentStateView.model = currentStateModel;
        }
        // create controller
        if (currentState.controller) {
            const currentStateController:BaseController = new currentState.controller(currentStateView, currentStateView.model);
            currentStateView.controller = currentStateController;
        }
        // create mediator
        if (currentState.mediator) {
            // tricky: mediator stays in memory because the inspected view is part of a display list.
            const currentStateMediator:BaseMediator = new currentState.mediator(currentStateView);
        }
        // add to view state map
        _viewStateMap[url] = currentStateView;
        // check for existing parent view or attach to root
        const parentPath:String = RouterUtil.getParentPath(url);
        if (_viewStateMap[parentPath]) {
            currentStateView.parentView = _viewStateMap[parentPath];
        }
        else {
            currentStateView.parentView = target;
        }
        // add to display list
        currentStateView.parentView.content.addChild(currentStateView);
        // attach signal handlers
        currentStateView.signalSet.transitionInComplete.addOnce(viewTransitionInHandler);
        currentStateView.signalSet.transitionOutComplete.addOnce(viewTransitionOutHandler);
        // notify subscribers
        signal.dispatch(BaseViewSignalTypes.TRANSITION_IN_START, url);
        // start transition
        currentStateView.transitionIn();
    }

    /**
     * @private
     */
    override protected function clearState(url:String):void {
        if (_viewStateMap[url]) {
            // remove current view
            var view:BaseView = _viewStateMap[url];
            if (view.parent && view.parent.contains(view)) {
                view.parent.removeChild(view);
            }
            view = null;
            // remove from map
            _viewStateMap[url] = null;
            delete _viewStateMap[url];
            // run garbage collection if needed
            //System.pauseForGCIfCollectionImminent();
        } else {
            LOG.debug("View not found to clear: " + url);
        }
    }


    /**
     * Get the current view object
     */
    public function get currentView():BaseView {
        return _viewStateMap[_nextStateURL];
    }
}
}
