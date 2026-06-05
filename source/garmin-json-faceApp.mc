import Toybox.Application;
import Toybox.Lang;
import Toybox.WatchUi;

class garmin_json_faceApp extends Application.AppBase {

    function initialize() {
        AppBase.initialize();
    }

    function onStart(state as Dictionary?) as Void {
    }

    function onStop(state as Dictionary?) as Void {
    }

    function getInitialView() as [Views] or [Views, InputDelegates] {
        return [ new garmin_json_faceView() ];
    }

}

function getApp() as garmin_json_faceApp {
    return Application.getApp() as garmin_json_faceApp;
}