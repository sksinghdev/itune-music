# itune-music

Supported devices.==  All Android devices & iOS devices "UI Tested on Samsung S8"

Supported features. == Search music by iTune api and play music

Requirements to build the app.== Android Stuido or visual Studio to deploy this app and added these pub files in pubspcae.yaml to pars data from json and make UI.
  provider: 4.1.2
  audioplayers: ^0.15.1
  http: 0.12.1
  google_fonts: ^1.1.0
  flutter_vector_icons: ^0.2.1
  flutter_spinkit: ^2.1.0
  flutter_launcher_icons: ^0.7.5
  
  
  



Build a Music Player App in Flutter
Use the iTunes affiliate API to develop a simple music player app that lets you search by artist and displays the search results on the screen. When a song is selected from the list, the song should start to play.
The app needs to work on an Android simulator. Shown below is how the music player should look on a mobile screen.




Requirements
Each song’s title, artist, album and album art should be displayed.
When we tap a song, a media player should show up at the bottom of the screen and start to play the preview for that song. The media player may be something as simple as a toggling play or pause button, however, it should pop-up at the bottom of the screen and on top of the list as shown. All the other controls shown are optional.
The media player should only show once a song is clicked and should stay on the screen from that point onwards and should be reused for any subsequent song played.
When a song is being played, you must provide some indicator in the list item that the song is being played.


You can stop playback if a new search is performed, however the preference is for the song to keep playing.
If you stop playback when a new search is performed, you must hide the media player till a song is selected.
You should include the necessary tests for a mobile app.


