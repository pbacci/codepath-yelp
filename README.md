### Yelp client

A simple iOS 7 Yelp client. It allows you to search Yelp for businesses in San Francisco, with the option to sort and filter the results. It also displays the business locations on a map.

Time spent: 14-16 hours

##Completed user stories
####Search results page
 * [x] Required: Table rows should be dynamic height according to the content height
 * [x] Required: Custom cells should have the proper Auto Layout constraints
 * [x] Required: Search bar should be in the navigation bar (doesn't have to expand to show location like the real Yelp app does).

####Filter page
 * [x] Required: The filters you should actually have are: category, sort (best match, distance, highest  rated), radius (meters), deals (on/off).
 * [x] Required: The filters table should be organized into sections as in the mock.
 * [x] Required: You can use the default UISwitch for on/off states.
 * [x] Required: Radius filter should expand as in the real Yelp app
 * [x] Required: Categories should show a subset of the full list with a "See All" row to expand.
 * [x] Required: Clicking on the "Search" button should dismiss the filters page and trigger the search   w/ the new filter settings.

###Known issues

 * Scrolling up and down in the main table view causes the layout to mess up. Unfortunately I did not get to figure why this is happening in time (Resolved thanks to Tim)
 * In general, I ran out of time so the code is definitely messier than I'd like it to be

###Walkthrough

![Walkthrough](yelp.gif)
