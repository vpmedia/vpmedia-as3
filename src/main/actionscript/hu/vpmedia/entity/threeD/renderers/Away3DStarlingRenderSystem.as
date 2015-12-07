package hu.vpmedia.entity.threeD.renderers {
import away3d.core.managers.Stage3DProxy;

import hu.vpmedia.entity.core.BaseEntityNode;
import hu.vpmedia.entity.core.BaseEntityWorld;

import starling.core.Starling;

public class Away3DStarlingRenderSystem extends Away3DRenderSystem {
    private var starling:Starling;

    public function Away3DStarlingRenderSystem(world:BaseEntityWorld, stage3DProxy:Stage3DProxy) {
        super(world, stage3DProxy);
        starling = Starling.current;
    }

    override public function step(timeDelta:Number):void {
        //trace(this, "step", stage3DProxy, starling, view)
        stage3DProxy.clear();
        starling.nextFrame();
        view.render();
        stage3DProxy.present();

        for (var node:BaseEntityNode = _nodeList.head; node; node = node.next) {
            _nodeUpdateFunction(node, timeDelta); // if (!entity.disposable) nodeUpdateFunction.call(null, entity, timeDelta);
        }
    }
}
}
