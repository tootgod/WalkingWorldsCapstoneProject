class_name EquipmentItemGenerator
extends Node

const RANDEQUARRAY:Array[GlobalData.equipmentType] = [GlobalData.equipmentType.WEAPON,GlobalData.equipmentType.ARMOR,GlobalData.equipmentType.ACCESSORY]

var rng:RandomNumberGenerator = RandomNumberGenerator.new()
var randNameArray:Array = ["Chana","Nyla","Keshon","Martin","Rylee","Dominique","Payton","Jan","Amaris","Ian","Mohammed","Declan","Stone","Aiden","Graham","Jamil","Caroline","Augustus","Shira","Easton","Bilal","Eunice","Leeann","Margaret","Robin","Kala","Garret","Patricia","Leonardo","Brant","Giavanna","Jarrett","Karl","Greyson","Jailene","Hailey","Lynn","Tristan","Armani","Karah","Jaycob","Kameryn","Estefany","Tristen","Janine","Lorraine","Joy","Clark","Tatum","Lara","Siera","Yulisa","Kenton","Makenzie","Tayler","Beverly","Tomas","Danny","Justyn","Leigha","Virginia","Byron","Dale","Celina","Tiffani","Keyon","Tatyanna","Ingrid","Adrianne","Yessica","Jamir","Melinda","Corrina","Nallely","Muhammad","Alia","Deshaun","Lane","Roberto","Stefan","Cale","Nyasia","Alisa","Tionna","Yehuda","Kamron","Lucero","Trever","Nathen","Trace","Keanu","Noah","Savannah","Sincere","Lyric","Ryan","Ashlyn","Shelby","Franco","Mireya","Jaydon","Gisselle","Astrid","Caleigh","Konnor","Rey","Keara","Unique","Lianna","Jean","Nelson","Franchesca","Aimee","Steven","Dylon","Aylin","Estevan","Derrick","Jarred","Kenny","Keyanna","Terrell","Darrius","Ethan","Parker","Chyanne","Cannon","Tahj","Gabrielle","Averie","Estefani","Cherokee","Breanne","Dane","Stetson","Roger","Aracely","Jacy","Lola","Kyndal","Asa","Frederick","Shiann","Leia","Mason","Mohamed","Kendall","Nathaly","Autumn","Nevin","Baby","Briar","Jerod","Demetrius","Layton","Anderson","Jacie","Nathanael","Raegan","Daren","Jerry","Jodi","Julie","Kailee","Dustin","Long","Marcos","Summer","Rafael","Julian","Kelton","Madelyn","Madison","Elian","Clifton","Zaira","Haley","Rhonda","Richard","Lydia","Devon","Nestor","Emerald","Kerry","Dangelo","Sommer","Blanca","Anissa","Bradley","Natalie","Hugo","Jon","Shay","Holden","Stewart","Makaila","Calista","Noa","Riley","Rochelle","Jayvon","Ismael","Alfonso","Hana","Waylon","Casey","Kameron","Zackery","Divya","Trystan","Marvin","Deion","Micah","Jalyn","Cortez","Trayvon","Randi","Destin","Bill","Sanjana","Carter","Dalila","Eileen","Elijah","Jackie","Jesus","Nia","Anton","Anastacia","Marlen","Janice","Lamont","Dayana","Ajay","Jim","Mona","Maximillian","Christin","Octavia","Treasure","Leonel","Julianna","Demonte","Breonna","Lars","Magdalena","Hugh","Demi","Aliana","Maryam","Stevie","John","Margarita","Carli","Mina","Tariq","Camilla","Alora","Obed","Nayely","Adriana","Dorothy","Imani","Lyle","Prince","Darwin","Travis","Jett","Rachelle","Grecia","Uriel","Jayda","Halley","Rocky","Luke","Joshua","Abagail","Messiah","Gideon","Jaime","Zakary","Sarai","Frances","Devonte","Chauncey","Quentin","Abrianna","Dominik","Tyrique","Jaya","Jakob","Kristi","Sadie","Ronnie","Quinn","Justine","Jaidyn","Alex","Giovanny","Alton","Ken","Holly","Wilfredo","Eliseo","Cesar","Sydnie","Graciela","Kianna","Savanna","Jaci","Rocco","Savion","Juan","Daryl","Brynne","Dion","Mariel","Jordyn","Rocio","Emilio","Luther","Gregorio","Mckinley","Brayden","Alea","Dusty","Cordell","Azaria","Kristina","Terrence","Lewis","Jaylynn","Kaylyn","Jovany","Camren","Zackary","Jaylyn","Ezekiel","Amari","Blair","Clifford","Julien","Grady","Francesco","Mikel","Justin","Daijah","Raina","Adam","Shyanne","Elaina","Keila","Rhea","Kiya","Zoe","Hector","Shaniya","Luca","Aliyah","Orlando","Dashawn","Lucille","Duncan","Ray","Kenya","Javon","Johan","Carson","Lacie","Broderick","Giancarlo","Jana","Warren","Aiyanna","Demarco","Camryn","Trey","Garett","Dario","Myron","Corey","Aya","Finn","Lucia","Jajuan","Addison","Alma","Abbigail","Jensen","Alycia","Erykah","Thea","Keagan","Katlyn","Dominic","Kaley","Makena","Martha","Stephanie","Marlee","Thaddeus","Dawn","Pedro","Ellis","Brooks","Travion","Lilliana","Derek","Ericka","Gunner","Sandy","Kaylynn","Lacy","Adriel","Karime","Cyrus","Faith","Yolanda","Dasia","Alvaro","Ralph","Judah","Maurice","Selene","Darion","Isaak","Raymond","Tommy","Rico","Francis","Mariela","Coral","Presley","Clayton","Damian","Karen","Bryant","Randy","Alvin","Renae","Laisha","Conrad","Eden","Harold","Carolina","Salvador","Mario","Griffin","Sebastien","Brandan","Elyssa","Simone","Isiah","Riya","Elisabeth","Sam","Rahul","Jacey","Elliot","Ronald","Keana","Anna","Ty","Stanley","River","Chancellor","Brandon","Maribel","Junior","Karlee","Jaylan","Litzy","Darrien","Sandra","Angelique","Melia","Bobby","Rasheed","Jorden","Samara","Alecia","Jadon","Devin","Kylan","Tyla","Silvia","Crystal","Cameryn","Charlize","Kaylen","Cathryn","Ben","Rogelio","Uriah","Amberly","Shawna","Teresa","Ariella","Trae","Reuben","Siena","Candace","Maxine","Simon","Aden","Fredrick","Jadah","Samira","Jorge","Fernando","Heidy","Shianne","Roman","Rowan","Mikaela","Noemi","Ayana","Galilea","Braedon","Gissel","Codey","William","Donavon","Zayne","Magaly","Payne","Kimberlee","Whitney","Randolph","Seth","Ivonne","Jeremiah","Jessenia","Audra","Eddie","Vaughn","Sonny","Vladimir","Tatiana","Katelin","Ester","Triston","Kaylah","Shayne","Trevion","Devonta","Sonya","Breanna","Khalil","Karly","Kinley","Bernadette","Kevon","Elliott","Jimmie","Dalia","Breeanna","Hayli","Keven","Emmalee","Kaila","Shamar","Peter","Reed","Erika","Marc","Darian","Tristin","Rosemary","Donovan","Diane","Aaron","Shana","Houston","Devan","Shanna","Cory","Timmy","Edmund","Marcelo","Terra","Yousef","Jalynn","Gonzalo","Christine","Julia","Damien","Kalob","Benjamin","Alejandro","Susannah","Marisa","Alonso","Pamela","Hannah","Kelsie","Chandler","Abraham","Alejandra","Antoinette","Jonah","Alexandrea","Alexia","Madalynn","Araceli","Keith","Myra","Aron","Tyrone","Issac","Tianna","Jenna","Josef","Jazmine","Trinity","Alexandria","Sienna","Joana","Kaytlyn","Willie","Yasmeen","Morgan","Mayra","Klarissa","Marcus","Treyvon","Harrison","Cristopher","Serena","Jenifer","Hasan","Bryanna","Imari","Ayanna","Claudio","Kristin","Trisha","Selena","Moshe","Emily","Maddison","Dezmond","Domenic","Talon","Trista","Izabella","Monserrat","Montana","Joseph","Terence","Katlin","Yamile","Enrique","Daysha","Jackson","Aliza","Ezra","Dalton","Rose","Elvin","Santino","Jesse","Juancarlos","Drew","Kallie","Curtis","Maxwell","Alexzander","Kacey","Johnnie","Cody","Kirsten","Federico","Carina","Dominick","Adonis","Ameer","Zahra","Josiah","London","Devlin","Marian","Britton","Acacia","Gabriel","Josefina","Francisca","Tyson","Cloe","Cristofer","Kaiya","Steve","Mackenzi","Landen","Ashtyn","Hayden","Quinten","Krystal","Meaghan","Kirstyn","Avery","Cassie","Carlo","Niko","Ashton","Arely","Omari","Danica","Jackeline","Jelani","Chassidy","Keegan","Lora","Megan","Diego","Emmanuel","Star","Marcel","Delilah","Karina","Bailey","Deana","Weston","Irvin","Andrea","Zara","Jamaal","Coleman","Kalee","Ibrahim","Kiana","Jill","Nicholas","Gianni","Jesenia","Cassidy","Abigayle","Ariel","Isabella","Kobe","Bruno","Haleigh","Jaden","Elias","Joslyn","Bryon","Liza","Quinlan","Layne","Naomi","Aspen","Brendan","Tye","Annabel","Stacie","Claudia","Keenan","Pablo","Amalia","Ali","Ernest","Alyse","Darnell","Tyquan","Dylan","Ansley","Ahmed","Asha","Saul","Zain","Jade","Alfred","Anjali","Tayla","Tucker","Edna","Makala","Lukas","Aidan","Anders","Jaeden","Caylee","Jenny","Ramsey","Reese","Alysa","Ruben","Gary","Dejon","Lance","Yaquelin","Hudson","Shaylee","Hamza","Abel","Erin","Jazmyne","Melody","Jolene","Cori","Notnamed","Leigh","Giovanni","Amaya","Liana","Kourtney","Ammon","Jayme","Lisbeth","Santana","Jevon","Sahil","Harry","Raelyn","Jedidiah","Maverick","Destiny","Taniya","Princess","Cassandra","Jaquan","Serenity","Dorien","America","Zachariah","Jaiden","Marlon","Joel","Norma","Ivanna","Chelsie","Lila","Cristian","Alfredo","Dajuan","Mitchell","Phoenix","Jazlynn","Skye","Larissa","Kristine","Katelynn","Kaylee","Baylee","Kian","Keely","Gretchen","Robert","Ezequiel","Jolie","Leah","Laila","Katya","Carlton","Omar","Odalys","Nikolas","Jacklyn","Juliann","Mickayla","Shannon","Heriberto","Fabian","Evelyn","Rayshawn","Armando","Tylor","Matthew","Yulissa","Caden","Donnell","Harlie","Elena","Stuart","Mackenzie","Courtney","Brookelyn","Emely","Rene","Mikaila","Francesca","Fernanda","Deontae","Wesley","Daylon","Ann","Leif","Alberto","Laken","Liberty","Lisette","Catherine","Edwin","Floyd","Levi","Shea","Anahi","Haily","Jared","Jaxson","Jazmyn","Quinton","Salvatore","Aric","Sonja","Brynn","Bryana","Mallory","Tiffany","Harvey","Katherine","Markus","Lorenzo","Hillary","Holland","Hassan","Jovanny","Tasha","Rashawn","Joseline","Axel","Jamie","June","Jayden","Darrion","Genesis","Lizeth","Jude","Earl","Paxton","Deandre","Benito","Luna","Monica","Malorie","Kahlil","Dora","Arjun","Jayleen","Catalina","Rashad","Valencia","Lucas","Sidney","Brenna","Sawyer","Keon","Moira","Mariano","Arman","Chloe","Piper","Jayla","Kobi","Bernardo","Oriana","Nico","Donte","Marco","Winston","Derick","Martina","Deshawn","Romeo","Briza","Maxim","Jonathon","Kenyon","Gannon","Demetria","Markell","Gerardo","Kasey","Scarlett","Mikayla","Vincenzo","Denise","Kaya","Rick","Kearra","Jericho","Thalia","Kali","Jaron","Shelton","Haven","Izaiah","Leanne","Tess","Rosario","Precious","Ciera","Julio","Juanita","Joe","Logan","Nehemiah","Brent","Destany","Juliette"]

func generateRandomEquipment(itemRank:int) -> Equipment:
	var newEquipment:Equipment = Equipment.new()
	newEquipment.itemName = randNameArray.pick_random()
	newEquipment.weaponRank = itemRank
	newEquipment.equipType = RANDEQUARRAY.pick_random()
	
	if newEquipment.equipType == GlobalData.equipmentType.WEAPON:
		newEquipment = _genWeapon(newEquipment)
	elif newEquipment.equipType == GlobalData.equipmentType.ARMOR:
		newEquipment = _genArmor(newEquipment)
	elif newEquipment.equipType == GlobalData.equipmentType.ACCESSORY:
		newEquipment = _genAccessory(newEquipment)
	
	
	return newEquipment

func _genWeapon(newEquipment:Equipment) -> Equipment:
	
	var weaponTypes:Array[String]=["sword","wand","bow"]
	var type:String = weaponTypes.pick_random()
	
	match type:
		"sword":
			newEquipment = _genSword(newEquipment)
		"wand":
			newEquipment = _genWand(newEquipment)
		"bow":
			newEquipment = _genBow(newEquipment)
			
	return newEquipment
	

func _genSword(newEquipment:Equipment) -> Equipment:
	newEquipment.bonusDefense = rng.randi_range(-15,25)
	newEquipment.bonusMaxHealth = rng.randi_range(-10,45)
	newEquipment.bonusMaxMana = rng.randi_range(-10,20)
	newEquipment.bonusWillpower = rng.randi_range(-10,5)
	newEquipment.bonusStrength = rng.randi_range(10,35)
	newEquipment.bonusIntelligence = rng.randi_range(-25,15)
	newEquipment.bonusSpeed = rng.randi_range(-10,20)
	newEquipment.bonusLuck = rng.randi_range(2,10)
	
	var spriteArray:Array = [preload("res://Assets/TempAssets/ItemAssets/Cutlass.png"),preload("res://Assets/TempAssets/ItemAssets/Knife.png"),
	preload("res://Assets/TempAssets/ItemAssets/Spear.png"),preload("res://Assets/TempAssets/ItemAssets/Sword.png"),
	preload("res://Assets/TempAssets/ItemAssets/SwordCurved.png"),preload("res://Assets/TempAssets/ItemAssets/Trident.png")]
	
	newEquipment.sprite = spriteArray.pick_random()
	var cost1:MaterialCost = MaterialCost.new()
	cost1.material = preload("res://Resources/MaterialItems/Iron.tres")
	cost1.amount = rng.randi_range(1,5) + newEquipment.weaponRank * 3
	newEquipment.costArray.append(cost1)
	var cost2:MaterialCost = MaterialCost.new()
	cost2.material = preload("res://Resources/MaterialItems/Wood.tres")
	cost2.amount = rng.randi_range(1,3) + newEquipment.weaponRank * 2
	newEquipment.costArray.append(cost2)
	var cost3:MaterialCost = MaterialCost.new()
	if newEquipment.weaponRank > 1:
		cost3.material = preload("res://Resources/MaterialItems/HeartWood.tres")
		cost3.amount = rng.randi_range(1,3) + newEquipment.weaponRank * 1
		newEquipment.costArray.append(cost3)
		
	
	return newEquipment

func _genWand(newEquipment:Equipment) -> Equipment:
	newEquipment.bonusDefense = rng.randi_range(-10,5)
	newEquipment.bonusMaxHealth = rng.randi_range(-10,35)
	newEquipment.bonusMaxMana = rng.randi_range(-10,45)
	newEquipment.bonusWillpower = rng.randi_range(-15,25)
	newEquipment.bonusStrength = rng.randi_range(-25,15)
	newEquipment.bonusIntelligence = rng.randi_range(10,35)
	newEquipment.bonusSpeed = rng.randi_range(-10,20)
	newEquipment.bonusLuck = rng.randi_range(2,10)
	
	var spriteArray:Array = [preload("res://Assets/TempAssets/ItemAssets/StaffCurled.png"),
	preload("res://Assets/TempAssets/ItemAssets/StaffHoly.png"),preload("res://Assets/TempAssets/ItemAssets/StaffNature.png")]
	newEquipment.sprite = spriteArray.pick_random()
	var cost1:MaterialCost = MaterialCost.new()
	cost1.material = preload("res://Resources/MaterialItems/Wood.tres")
	cost1.amount = rng.randi_range(1,5) + newEquipment.weaponRank * 3
	newEquipment.costArray.append(cost1)
	var cost2:MaterialCost = MaterialCost.new()
	cost2.material = preload("res://Resources/MaterialItems/Vines.tres")
	cost2.amount = rng.randi_range(1,3) + newEquipment.weaponRank * 2
	newEquipment.costArray.append(cost2)
	var cost3:MaterialCost = MaterialCost.new()
	if newEquipment.weaponRank > 1:
		cost3.material = preload("res://Resources/MaterialItems/MagicSphere.tres")
		cost3.amount = rng.randi_range(1,3) + newEquipment.weaponRank * 1
		newEquipment.costArray.append(cost3)
	return newEquipment
	
func _genBow(newEquipment:Equipment) -> Equipment:
	newEquipment.bonusDefense = rng.randi_range(-15,15)
	newEquipment.bonusMaxHealth = rng.randi_range(-10,25)
	newEquipment.bonusMaxMana = rng.randi_range(-10,25)
	newEquipment.bonusWillpower = rng.randi_range(-15,15)
	newEquipment.bonusStrength = rng.randi_range(5,20)
	newEquipment.bonusIntelligence = rng.randi_range(5,20)
	newEquipment.bonusSpeed = rng.randi_range(5,50)
	newEquipment.bonusLuck = rng.randi_range(5,25)
	
	var spriteArray:Array = [preload("res://Assets/TempAssets/ItemAssets/Crossbow.png"),preload("res://Assets/TempAssets/ItemAssets/CrossbowBlue.png")]
	newEquipment.sprite = spriteArray.pick_random()
	var cost1:MaterialCost = MaterialCost.new()
	cost1.material = preload("res://Resources/MaterialItems/Vines.tres")
	cost1.amount = rng.randi_range(1,5) + newEquipment.weaponRank * 3
	newEquipment.costArray.append(cost1)
	var cost2:MaterialCost = MaterialCost.new()
	cost2.material = preload("res://Resources/MaterialItems/Iron.tres")
	cost2.amount = rng.randi_range(1,3) + newEquipment.weaponRank * 2
	newEquipment.costArray.append(cost2)
	var cost3:MaterialCost = MaterialCost.new()
	if newEquipment.weaponRank > 1:
		cost3.material = preload("res://Resources/MaterialItems/Gold.tres")
		cost3.amount = rng.randi_range(1,3) + newEquipment.weaponRank * 1
		newEquipment.costArray.append(cost3)
	return newEquipment


func _genArmor(newEquipment:Equipment) -> Equipment:
	var armorTypes:Array[String]=["metal","magic"]
	var type:String = armorTypes.pick_random()
	
	match type:
		"metal":
			newEquipment = _genMetal(newEquipment)
		"magic":
			newEquipment = _genMagic(newEquipment)
		
	return newEquipment

func _genMetal(newEquipment:Equipment):
	newEquipment.bonusDefense = rng.randi_range(10,35)
	newEquipment.bonusMaxHealth = rng.randi_range(10,45)
	newEquipment.bonusMaxMana = rng.randi_range(-10,20)
	newEquipment.bonusWillpower = rng.randi_range(-10,5)
	newEquipment.bonusStrength = rng.randi_range(-15,15)
	newEquipment.bonusIntelligence = rng.randi_range(-25,5)
	newEquipment.bonusSpeed = rng.randi_range(-10,20)
	newEquipment.bonusLuck = rng.randi_range(2,10)
	
	var spriteArray:Array = [preload("res://Assets/TempAssets/ItemAssets/ArmorBlue.png"), preload("res://Assets/TempAssets/ItemAssets/ArmorGreen.png"), preload("res://Assets/TempAssets/ItemAssets/ArmorHeavy.png"), preload("res://Assets/TempAssets/ItemAssets/ArmorIron.png")]
	newEquipment.sprite = spriteArray.pick_random()
	var cost1:MaterialCost = MaterialCost.new()
	cost1.material = preload("res://Resources/MaterialItems/Iron.tres")
	cost1.amount = rng.randi_range(1,5) + newEquipment.weaponRank * 3
	newEquipment.costArray.append(cost1)
	var cost2:MaterialCost = MaterialCost.new()
	cost2.material = preload("res://Resources/MaterialItems/Wood.tres")
	cost2.amount = rng.randi_range(1,3) + newEquipment.weaponRank * 2
	newEquipment.costArray.append(cost2)
	var cost3:MaterialCost = MaterialCost.new()
	if newEquipment.weaponRank > 1:
		cost3.material = preload("res://Resources/MaterialItems/Gold.tres")
		cost3.amount = rng.randi_range(1,3) + newEquipment.weaponRank * 1
		newEquipment.costArray.append(cost3)
	return newEquipment
	

func _genMagic(newEquipment:Equipment):
	newEquipment.bonusDefense = rng.randi_range(-10,5)
	newEquipment.bonusMaxHealth = rng.randi_range(10,45)
	newEquipment.bonusMaxMana = rng.randi_range(-10,20)
	newEquipment.bonusWillpower = rng.randi_range(10,35)
	newEquipment.bonusStrength = rng.randi_range(-25,5)
	newEquipment.bonusIntelligence = rng.randi_range(-15,15)
	newEquipment.bonusSpeed = rng.randi_range(-10,20)
	newEquipment.bonusLuck = rng.randi_range(2,10)
	
	var spriteArray:Array = ["res://Assets/TempAssets/ItemAssets/CloakBlue.png", "res://Assets/TempAssets/ItemAssets/CloakGreen.png", "res://Assets/TempAssets/ItemAssets/CloakRed.png", "res://Assets/TempAssets/ItemAssets/CloakWing.png",
	preload("res://Assets/TempAssets/ItemAssets/RobeBlue.png"), preload("res://Assets/TempAssets/ItemAssets/RobeRed.png"), preload("res://Assets/TempAssets/ItemAssets/RobesGreen.png")]
	newEquipment.sprite = spriteArray.pick_random()
	var cost1:MaterialCost = MaterialCost.new()
	cost1.material = preload("res://Resources/MaterialItems/Vines.tres")
	cost1.amount = rng.randi_range(1,5) + newEquipment.weaponRank * 3
	newEquipment.costArray.append(cost1)
	var cost2:MaterialCost = MaterialCost.new()
	cost2.material = preload("res://Resources/MaterialItems/Wood.tres")
	cost2.amount = rng.randi_range(1,3) + newEquipment.weaponRank * 2
	newEquipment.costArray.append(cost2)
	var cost3:MaterialCost = MaterialCost.new()
	if newEquipment.weaponRank > 1:
		cost3.material = preload("res://Resources/MaterialItems/MagicSphere.tres")
		cost3.amount = rng.randi_range(1,3) + newEquipment.weaponRank * 1
		newEquipment.costArray.append(cost3)
	return newEquipment
	
func _genAccessory(newEquipment:Equipment) -> Equipment:
	var matArray:Array = [preload("res://Resources/MaterialItems/Gemstone.tres"), preload("res://Resources/MaterialItems/Gold.tres"), preload("res://Resources/MaterialItems/HeartWood.tres"), preload("res://Resources/MaterialItems/Iron.tres"), preload("res://Resources/MaterialItems/MagicSphere.tres"), preload("res://Resources/MaterialItems/Vines.tres"), preload("res://Resources/MaterialItems/Wood.tres")]
	newEquipment.bonusDefense = rng.randi_range(-15,30)
	newEquipment.bonusMaxHealth = rng.randi_range(-15,30)
	newEquipment.bonusMaxMana = rng.randi_range(-15,30)
	newEquipment.bonusWillpower = rng.randi_range(-15,30)
	newEquipment.bonusStrength = rng.randi_range(-15,30)
	newEquipment.bonusIntelligence = rng.randi_range(-15,30)
	newEquipment.bonusSpeed = rng.randi_range(-15,30)
	newEquipment.bonusLuck = rng.randi_range(-15,30)
	
	var spriteArray:Array = [preload("res://Assets/TempAssets/ItemAssets/Beads.png"), preload("res://Assets/TempAssets/ItemAssets/Book.png"),
	preload("res://Assets/TempAssets/ItemAssets/GemBlue.png"), preload("res://Assets/TempAssets/ItemAssets/GemRed.png"),
	preload("res://Assets/TempAssets/ItemAssets/Orb.png"),"res://Assets/TempAssets/ItemAssets/RibbonBlue.png",
	preload("res://Assets/TempAssets/ItemAssets/RibbonGreen.png"), preload("res://Assets/TempAssets/ItemAssets/RibbonOrange.png"),
	preload("res://Assets/TempAssets/ItemAssets/RibbonPink.png"), preload("res://Assets/TempAssets/ItemAssets/RibbonWhite.png"), preload("res://Assets/TempAssets/ItemAssets/RibbonYellow.png"),
	preload("res://Assets/TempAssets/ItemAssets/RingBlue.png"), preload("res://Assets/TempAssets/ItemAssets/RingSmall.png"), preload("res://Assets/TempAssets/ItemAssets/RingSmallBlue.png"),
	preload("res://Assets/TempAssets/ItemAssets/Scroll.png"),preload("res://Assets/TempAssets/ItemAssets/Top.png")]
	
	newEquipment.sprite = spriteArray.pick_random()
	var cost1:MaterialCost = MaterialCost.new()
	cost1.material = matArray.pick_random()
	cost1.amount = rng.randi_range(1,5) + newEquipment.weaponRank * 3
	newEquipment.costArray.append(cost1)
	var cost2:MaterialCost = MaterialCost.new()
	if newEquipment.weaponRank > 1:
		cost2.material = matArray.pick_random()
		cost2.amount = rng.randi_range(1,3) + newEquipment.weaponRank * 2
		newEquipment.costArray.append(cost2)
	var cost3:MaterialCost = MaterialCost.new()
	if newEquipment.weaponRank > 2:
		cost3.material = matArray.pick_random()
		cost3.amount = rng.randi_range(1,3) + newEquipment.weaponRank * 1
		newEquipment.costArray.append(cost3)
	return newEquipment
