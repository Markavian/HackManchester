package controllers;

import data.EventData;
import play.*;
import play.mvc.*;

import java.util.*;

public class Event extends Controller {

    public static void get() {
        EventData eventData = new EventData();
//        renderJSON(eventData);

        renderJSON("{ startTime: " + eventData.startTime.toString() + "}");
    }
}
