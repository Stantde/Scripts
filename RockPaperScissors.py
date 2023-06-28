#'''Rock, paper, scissors game
 
import random

CHOICES = ('Rock', 'Paper', 'Scissors')

playerScore, computerScore = 0,0

#Decide whether or not to start the game.
def startGame(playerResponse =''):
    print('Welcome to Rock, Paper, Scissors!\n')
    #How to play
    #Prompt to play
    print()
    acceptableResponse = 'Y','N'
    while playerResponse not in acceptableResponse:
        playerResponse = input('Would you like to play a round? Please enter Y or N\n')
        
        #yes no or other
    if playerResponse == 'Y':
        return True
    else:
        return False

#Display the current score    
def scoreCard():
    print('The current score is:\n Player: ' + str(playerScore) + '\nComputer: ' + str(computerScore))

#Let the game commence!
def playGame():
    computerChoice = computerTurn()
    playerChoice = playerTurn()
    winner = compare(playerChoice,computerChoice)
    return winner
#Easy task
def computerTurn():
    return CHOICES[random.randint(0,2)]
#The challenge
def playerTurn(playerResponse =''):
    while playerResponse not in CHOICES:
        playerResponse = input('Choose Rock, Paper, or Scissors\n')
    return playerResponse

#And the winner is....!
def compare(playerChoice,computerChoice):
    pc = (playerChoice,computerChoice)
    print('The player chose: '+pc[0]+'\nThe computer chose: '+pc[1]+'\n')
    if pc[0] == pc[1]:
        print('This match is a draw!\n')
        return 2
    elif 'Rock' in pc:
        if 'Paper' in pc:
            return pc.index('Paper')
        else:
            return pc.index('Rock')
    else:
        return pc.index('Scissors')
            
    return 
#add a point to the winner's score
def updateScoreCard(w,localPlayerScore,localComputerScore):

    if w == 0:
        print('The Player Won!\n')
        return localPlayerScore + 1,localComputerScore
    elif w == 1:
        print('The Computer Won!\n')
        return localPlayerScore,localComputerScore + 1
    return localPlayerScore , localComputerScore

#close the program
def endGame():
    return


#__main__
while startGame():
#    winner = playGame() #0 is player wins, 1 is pc wins, else 2? for draw?
    playerScore, computerScore = updateScoreCard(playGame(),playerScore,computerScore) #Can i shrink this down?
    scoreCard()
endGame()
