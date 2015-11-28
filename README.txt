------------------------------------------
PROJECT #4 - SCRIPTURE MAP
------------------------------------------

User Feedback:
	- The user suggested showing distance between two annotations on the map to better put the information in perspective.
	- Displaying a chronological timeline of a chapter was also suggested. When you went to a chapter, displaying a chronological graph of significant events to enhance context for the selected chapter.

Extra Credit:
	- I implemented 3D touch on the ChaptersVC. This allows the user to quickly peek at the annotations within a chapter, or lack thereof, then pop straight into a map view with the annotations still visible.
	- Originally I wanted to implement this functionality in the web view, within the scriptures themselves, so the user could peek at a single annotation's location without jumping into the map view completely. However, after spending 2 hours on this, I realized that working with the webview, at least in 3D touch, was too difficult without available documentation on best practices. As a result, I decided to go with the alternative using the ChaptersVC.