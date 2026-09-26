PRD: BR Explorer UI Prototype (Kotlin Multiplatform)
Objective:
Build a modern, declarative UI prototype for the BR Explorer app using Compose Multiplatform. The focus is on clean architecture, smooth state transitions, and a polished user experience. The agent will reference provided legacy screenshots for business logic context but must generate a modern material/custom design.

Screen 1: OTP Login Flow
Goal: A frictionless, bug-free authentication screen that handles network latency gracefully.

UI Components:

Header: App Logo and "Welcome to BR Explorer" typography.

Phone Input: Text field with a fixed country code prefix (+880).

OTP Input: A row of 4 to 6 distinct text boxes for PIN entry that automatically advance focus.

Primary Action: A full-width "Verify & Login" button with a built-in circular loading state.

Secondary Action: "Resend Code" text button (disabled with a countdown timer initially).

Agent Instructions: Implement robust state hoisting. Ensure the UI clearly reflects Idle, Loading, Success, and Error (e.g., invalid OTP) states.

Screen 2: Smart Home Dashboard
Goal: A proactive, centralized hub that prioritizes immediate journey planning and high-frequency actions.

UI Components:

Header: Greeting text and a subtle user avatar/notification bell.

Journey Planner Card (Elevated):

"From Station" input field.

"To Station" input field.

Vertical swap icon button between the two fields.

"Date" selector field.

"Search Trains" primary button.

Quick Actions Row: Horizontally scrollable or evenly weighted grid of icons (Live Tracking, Train Schedules, Fare Calculator).

Live Status Snippet: A small card showing an active or recently searched trip (e.g., a train marker showing "On Time").

Bottom Navigation Bar: Persistent across root screens. Items: Home (Active), Search, Live Map, Profile.

Agent Instructions: Use standard Compose Scaffold for the Bottom Navigation. The Journey Planner Card should have a slight elevation/shadow to stand out against the background color.

Screen 3: Train Search & Schedule Results (Integrated Map View)
Goal: Display complex scheduling data alongside live geographic tracking without overwhelming the user.

UI Components:

Top App Bar: Displays the queried route (e.g., "Dhaka → Chuadanga") and the selected date. Back navigation button.

Background View (Map): A map component taking up the upper half or background of the screen. Include a polyline for the train route and a custom marker indicating the live train position.

Bottom Sheet / Draggable List (Foreground):

A swipeable bottom sheet containing the search results.

Result Cards (List Items): Each card represents a train schedule. Needs to display: Train Name/Number, Departure Time, Estimated Arrival Time, and a row of available ticket classes with base fares.

Live Indicator: A visual tag (e.g., a pulsing green dot) on cards where the train is currently active on the route.

Agent Instructions: Implement a BottomSheetScaffold or custom draggable state. The map should remain interactive behind the bottom sheet. Use placeholder mock data for the train schedules and map markers to demonstrate the layout.