# Dans_Fines
 Fine System for RedEM:RP <br>
 Using Redem_policejob to give fines. <br>
 
 # Installation
 Insert dans_fines.sql into your database. <br>
 Add ```ensure dans_fines``` to your server.cfg <br>
 Follow the below steps for correct usage! <br>
 
 # Using this script
 To add more fines, navigate to config.lua, and insert the new fine in the respective category. <br>
 
 Current Functions are: <br>
 giveFineMenu() - This menu allows the player to give the closest player a fine. <br>
 viewFineMenu() - This menu shows the player his current fines, and allows him to pay them. <br>
 
 To use the menus you will need to plug it into an existing menu. I have converted my policejob to use menu_base, but I am sure the premise is the same for warmenu. <br>
 Example: <br>
 
 ```
 This would be located in your client.lua of policejob, in the F4 Menu for player interaction.
 
 elseif(data.current.value == 'fine') then
  exports['dans_fines']:giveFineMenu() -- This export opens the giveFineMenu function from dans_fines
  menu.close()
 end
 ```
 
 To check your fines, you'll also need to plug it into an existing menu. I have created my own AIOMenu that connects random menus, but you can plug this in wherever you see fit. <br>
 
 ```
 This would be located in a client.lua of your choosing.
 
 elseif(data.current.value == 'fines') then
  exports['dans_fines']:viewFineMenu() -- This export opens the viewFineMenu function from dans_fines
  menu.close()
 end
 ```
 
 There are 2 test keybinds that can be used to view the menus without plugging them into anything. <br>
 To enable them, go to dans_fines -> client.lua, and from line 7 to 16, uncomment those lines. <br>
 Keybinds are: Left Arrow to open giveFineMenu(), Right Arrow to open viewFineMenu() <br>
 
 # Required Resources
RedEM:RP is required <br>
Forum Post -> https://forum.cfx.re/t/redem-roleplay-gamemode-the-roleplay-gamemode-for-redm/915043 <br>
Github -> https://github.com/RedEM-RP/redem_roleplay <br>

Currently policejob is not a requirement, as there is no check to ensure the user is actually a Sheriff. <br>

# Known Bugs
Only a singular bug exists too my knowledge, and it occurs when the player views their fine menu and doesn't have any actual fines. There is only a client print in the console, so nothing game breaking at all.

# Credits
Thank you to RedEM and RedEM:RP <br>
RedEM:RP Discord -> https://discord.gg/JS82WmQ7nG <br>
