class Car:
	
	#defining constructor
	def __init__(self, mpg):
		self.mpg = mpg #miles per gallons
		self.tankSize = 0	#tank size of a car initially zero
		self.fuelLevel = 0  #fuel level initially zero

	#setting car tank size
	def setTankSize(self, tankSize):
		self.tankSize = tankSize

	#adding gas
	def addGas(self, fuel):
		if(self.fuelLevel + fuel > self.tankSize): #checking if fuel is more than car's tank size
			self.fuelLevel = self.tankSize
			return("Fuel overflow, Gas is added successfully upto "+str(self.tankSize))
		else:	#adding fuel normally
			self.fuelLevel += fuel
			return("Fuel added successfully, Current Fuel: "+str(self.fuelLevel))

	#getting fuel level
	def getFuelLevel(self):
		return self.fuelLevel

	#car drive method
	def drive(self, mile):
		capacity = self.mpg * self.fuelLevel #calculating current capacity of car in miles
		if(capacity is 0):	#if car has no fuel and can not drive a mile
			return "Low fuel, you cannot drive with no gas."

		elif(capacity < mile):	#if capacity is less than user wants to drive
			self.fuelLevel = 0	#emptying fuel level
			return "You drove only "+str(capacity)+" miles due to low fuel. You can not drive further more on this gas."
		
		else:	#normal driving
			capacity = capacity - mile  #decreasing the capacity after driving
			self.fuelLevel = capacity / self.mpg	#calculating the remaning fuel level after driving
			return "You drove "+str(mile)+" miles. You can drive another "+str(capacity)+" miles on this gas."


#log saving function
def saveLog(input):
	f = open('LogFuel.txt','a')	#saving into a file LogFuel.txt
	f.write(input+"\n")
	f.close()


#reading FuelEffic.txt file
file = open("FuelEffic.txt","r")
lineArray = ["",""]	#defining array to get two lines from the files
i=0	#counter

for line in file:
	lineArray[i] = line #gettting the value of file into the array
	i = i+1

try:
	#splitting the line to get the exact numeric values
	mpg = int(lineArray[0].split('Miles per gallon: ')[1])	#miles per gallon
	tankSize = int(lineArray[1].split('Tank Size (in gallons): ')[1])	#tank size
except:
	#if the files have invalid format than we expected
	print("Invalid format data in FuelEffic.txt")
	exit()

#displaying FuelEffic.txt data
print("Miles per gallon: "+str(mpg))
print("Tank Size (in gallons): "+str(tankSize))

#defining new car object
mycar = Car(mpg) #car miles per gallon as defined in file
mycar.setTankSize(tankSize)	#car tank size as defined in file
#mycar.addGas(25)


#user option loop
while True:
	#user option menu priting
	print("\nWhat would you like to do: \n1. See Current Fuel Level \n2. Drive \n3. Add Gas \n4. Exit")
	try:
		#preventing if user inputs an invalid option
		option = int(input("Enter option: "))
		if option > 4 and option < 1:
			raise
	except:
		print("You entered an invalid option.\n")
		continue;
	print()	#empty line

	if option is 1:
		#See Current Fuel Level
		fuelLevel = mycar.getFuelLevel() #getting fuel
		print("Current fuel level: "+str(fuelLevel)) 
		saveLog("User Input: 1 - See Current Fuel Level") #saving to log
		saveLog("Fuel level shown: "+str(fuelLevel)+"\n")

	elif option is 2:
		try:
			#Drive
			miles = int(input("How many miles you want to drive: ")) #asking user to input for miles
			output = mycar.drive(miles)
			print(output)
			saveLog("User Input: 2 - Drive")
			saveLog("Miles to Drive: "+str(miles))
			saveLog(output+"\n")

		except:
			#if user inputs and invalid option
			print("Invalid input")

	elif option is 3:
		try:
			#Add gas
			gas = int(input("How much gas to Add: ")) #asking user to input for miles
			output = mycar.addGas(gas)
			print(output)
			saveLog("User Input: 3 - Add Gas")
			saveLog("Gas added: "+str(gas))
			saveLog(output+"\n")
		except:
			print("Invalid input")

	elif option is 4:
		#Exit
		saveLog("User Input: 4 – Exit")
		break
