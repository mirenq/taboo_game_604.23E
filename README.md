# Group:
- 604.23E

# Students:
- Ali Abbasov
- Rasul Hacili
- Rasul Aliyev
- Mahdi Taebi

# Project:
- Taboo game

# Setup instructions:
- When files are in IDE/Code Editor, run in the terminal ```flutter pub get``` to download all dependencies from ```pubspec.yaml``` file, then just run the program by ```flutter run -d chrome```.
- P.S. This project was designed only for web, so it could have undetermined behavior on other platforms, it's recommended to run only on web.

# Navigation:
- On home page you have "Start Game", "Instructions", "View History" buttons.
- "Instruction" button will show you basic rules for the game.
- In "View History" there will be previous games, which are stored round by round.
- "Start Game" will navigate to Game Setup page, where first you enter names of team, and then you enter names of team members selecting each team individually, then you select number of rounds and press "Start Game" (not the same button as before) which will navigate to the Game Page.

# Game Rules:
- One of the team members have to try to give a clue for his other team members, and one of the team members of opposing team have to check if the player said a taboo word or not. 
- In game 1 round is meant to go through all of the players once, and each player will have 30 seconds.
- At the end of the final round results will be shown.
- Then the results can be viewed in "View History". 