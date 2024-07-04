'''
This script exists to output a string to the terminal. The goal is to take that output, and use it 
in a powershell script later. 

Tests so far have been unsuccessful, perhaps due to a lack of knowledge on my part.
'''
tmp = []
tmp.append("This")
tmp.append("is")
tmp.append("a")
tmp.append("complete")
tmp.append("sentence.")

tmp2 = ""

for word in tmp:
	tmp2 += word

exit(word)