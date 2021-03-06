package models;

import com.google.gson.JsonArray;
import com.google.gson.JsonElement;
import com.google.gson.JsonObject;
import org.joda.time.DateTime;
import play.libs.WS;

import java.text.MessageFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

public class Activity {
    // template matches this API: GET /repos/:owner/:repo/events
    public static final String GITHUB_ACTIVITY_URL_TEMPLATE = "https://api.github.com/repos/{0}/{1}/events";

    public DateTime mostRecentCommit;
    public int numberOfCommits;
    public int numberOfCommitsInLastHour;
    public int numberOfCommitsInLastThreeHours;
    public int numberOfCommitsSinceStartOfEvent;
    public List<Integer> commitsPerHour;
    
    private String owner;
    private String repo;

    public Activity(String owner, String repo) {
        this.owner = owner;
        this.repo = repo;
        this.numberOfCommits = 0;
        this.numberOfCommitsInLastHour = 0;
        this.numberOfCommitsInLastThreeHours = 0;
        this.numberOfCommitsSinceStartOfEvent = 0;
        this.commitsPerHour = new ArrayList<Integer>(Arrays.asList(0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0));
    }

    public void update() {
        String url = MessageFormat.format(GITHUB_ACTIVITY_URL_TEMPLATE, owner, repo);
        WS.HttpResponse result = WS.url(url).get();
        JsonElement contentJson = result.getJson();

        if (contentJson.isJsonArray()) {
            JsonArray jsonArray = contentJson.getAsJsonArray();

            for (JsonElement githubEventJson: jsonArray) {
                JsonObject gitHubEventObject = githubEventJson.getAsJsonObject();
                JsonElement createdAtElement = gitHubEventObject.get("created_at");
//                System.out.println(createdAtElement.getAsString());

                DateTime dateTime = new DateTime(createdAtElement.getAsString());
                updateFieldsFrom(dateTime);
            }
        }
    }
    
    public String getGraph() {
    	update();
    	return new Graph(commitsPerHour).graph;
    }

    private void updateFieldsFrom(DateTime commitDateTime) {
        if (mostRecentCommit == null) {
            mostRecentCommit = commitDateTime;
        }

        DateTime now = DateTime.now();
        DateTime oneHourAgo = now.minusHours(1);
        DateTime threeHoursAgo = now.minusHours(3);
        DateTime startOfEvent = Event.getEvent().startTime;

        commitsPerHour.set(commitDateTime.getHourOfDay(), commitsPerHour.get(commitDateTime.getHourOfDay())+1);
       
        if (commitDateTime.isAfter(oneHourAgo)) {
            numberOfCommitsInLastHour++;
        }
        if (commitDateTime.isAfter(threeHoursAgo)) {
            numberOfCommitsInLastThreeHours++;
        }
        if (commitDateTime.isAfter(startOfEvent)) {
            numberOfCommitsSinceStartOfEvent++;
        }

        numberOfCommits++;
    }
}
