'''Python will guess what your random number is.'''
DEBUG = False

def welcome():
    print('\n\n\nHi! Welcome to the game!\n\n\n')
    will_the_player_play_the_game = input('\n\n\nShall we begin?\n\n\n')

def ask_for_lower_limit():
    lower_limit=input('\nWhat\'s your bottom number?')
    return int(lower_limit)

def ask_for_higher_limit():
    higher_limit=input('\nWhat\'s your top number?')
    return int(higher_limit)

def initial_guess(lower_limit , higher_limit):
    
