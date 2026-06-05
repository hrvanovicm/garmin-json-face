import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;
import Toybox.Weather;

class garmin_json_faceView extends WatchUi.WatchFace {

    function initialize() {
        WatchFace.initialize();
    }

    function onLayout(dc as Dc) as Void {
        setLayout(Rez.Layouts.WatchFace(dc));
    }

    function onShow() as Void {}

    function onUpdate(dc as Dc) as Void {

        var now = System.getClockTime();

        //24h
        var timeString = Lang.format(
            "$1$:$2$",
            [now.hour.format("%02d"), now.min.format("%02d")]
        );

       
        //date
        var days = ["Sun","Mon","Tue","Wed","Thu","Fri","Sat"];
        var months = ["Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"];

        var today = Toybox.Time.Gregorian.info(Time.now(), Time.FORMAT_SHORT);
        var dateString = today.day + ". " +
                            months[today.month - 1] + ", " +
                            days[today.day_of_week - 1]; // Note: day_of_week is 1-7 (Sun-Sat)

        // where is the sun
        var sunriseMin = 6 * 60;   // 06:00
        var sunsetMin  = 18 * 60;  // 18:00

        var nowMin = now.hour * 60 + now.min;

        var isNight = (nowMin < sunriseMin || nowMin > sunsetMin);

        var nightString;
        var diff;

        if (isNight) {
            diff = sunriseMin - nowMin;
            if (diff < 0) {
                diff += 1440;
            }
            nightString = diff + "m";
        } else {
            diff = sunsetMin - nowMin;
            if (diff < 0) {
                diff += 1440;
            }
            nightString = diff + "m";
        }

        // weaDa
        var wthString = "N/A";

        var weather = Weather.getCurrentConditions();

        if (weather != null) {
            var condition = weather.condition;
            var temp = weather.temperature;

            var label = "N/A";

            if (condition == Weather.CONDITION_CLEAR) {
                label = "Sun";
            } else if (condition == Weather.CONDITION_PARTLY_CLOUDY) {
                label = "Partly";
            } else if (condition == Weather.CONDITION_CLOUDY) {
                label = "Oblacno";
            } else if (condition == Weather.CONDITION_RAIN) {
                label = "Rain";
            } else if (condition == Weather.CONDITION_SNOW) {
                label = "Snow";
            } else if (condition == Weather.CONDITION_THUNDERSTORMS) {
                label = "Storm";
            }

            wthString = label + ", " + temp.format("%2d") + "C";
        }

        // notifications und evento
        var notifCount = 0;
        var eventCount = 0;

        var settings = System.getDeviceSettings();
        if (settings != null) {
            notifCount = settings.notificationCount;
        }
        
        var stats = System.getSystemStats();
        var batteryLevel = stats.battery;

        var msgString = eventCount + "e, " + notifCount + "n, " + batteryLevel.toNumber() + "%";

  
        var jsonText = "";
        jsonText += "> " + nightString + ",\n";
        jsonText += "> " + msgString + "\n";
        jsonText += "> " + dateString + ",\n";
        jsonText += "> " + wthString + ",\n";


        var view = View.findDrawableById("TimeLabel") as Text;
        view.setText(jsonText);

        var cmdView = View.findDrawableById("CommandLabel") as Text;
        cmdView.setText("</>");

         var firstBracket = View.findDrawableById("FirstBracket") as Text;
        firstBracket.setText("$: " + timeString);

            var secondBracked = View.findDrawableById("SecondBracket") as Text;
        secondBracked.setText("mike@localhost");

        View.onUpdate(dc);
    }

    function onHide() as Void {}

    function onExitSleep() as Void {}

    function onEnterSleep() as Void {}
}