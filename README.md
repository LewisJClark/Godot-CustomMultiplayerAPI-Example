# Godot-CustomMultiplayerAPI-Example
An example project showing how to use the CustomMultiplayerAPI to have a Server and Client in the same Godot app.

This app is not meant to be a perfect or even good example of how to make a chatroom/networked app! Apologies for any mistakes or bad practises, this was a quick Sunday afternoon project. 

If you have any questions or recommendations, please message me on Reddit, u/Nipth.

## The App
To see the app working, I suggest exporting the project to whatever platform you're working on. Once you have an executeable, launch several instances of it and follow these steps:
* In one instance, click 'Host' to start hosting a server.
* In the same instance enter 'localhost' in the IP edit and whatever name you want in the name edit.
* Press 'Connect' and you should see some messages appear in the chat log.
* In the other instances of the app follow the same steps but do NOT press the 'Host' button.
* These instances will connect to the first and you should be able to send messages ala any text messaging program!

I haven't bothered to validate the IP or Name edits, so expect some weird behaviour/crashes if these are left blank or filled with garbage.
