------------------------------------------
PROJECT #5 - NETWORKING & USER INPUT
------------------------------------------


Notes:
	Custom Map View:
		- This map view adopts the values placed in the text field after any one of the UITextFields ends editing. While there is very little validation to ensure that the the numbers are actually valid (and not some other form of text), it will ensure that the textfield is either a valid number or set it to 0 when the values are plugged into the map or passed to the delegate view controller. 

		- Additionally, some polish was added so that the map view was easy to use (keyboard automatically hides on map's scroll, the spell correction bar above the keyboard is forced hidden for extra space, and the viewLat and viewLong are automatically populated when the latitude and longitude are updated, to avoid incorrect viewLat and viewLong).

		- This map also adopts the current location of the map, if the map detail view is visible (iPhone 6 Plus).

	GeocodeSuggestionVC:
		- While I could've set up the tabbing feature where the you can tab from one box to the other, I found that the "Done"/"Return" buttons were perfect for dismissin the keyboard. Particularly on smaller phones, it's important that the keyboard disappear when the user was done with a field, because then they were able to see the custom map view that I added.

User Feedback:
	
Extra Credit:
	- Instead of only passing the values from the detail view controller, I created a custom map that lives inside the GeocodeSuggestionViewController. This map enables the user to dynamically interact with the values they're inputing and either see where their new values take the on the map, or work backwards and set the values basedo on where the map view is at that time. Cool eh? :)
