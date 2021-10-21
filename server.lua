-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONEXÃO
-----------------------------------------------------------------------------------------------------------------------------------------
src = {}
Tunnel.bindInterface("vrp_business",src)
vCLIENT = Tunnel.getInterface("vrp_business")
-----------------------------------------------------------------------------------------------------------------------------------------
-- PREPARES
-----------------------------------------------------------------------------------------------------------------------------------------
vRP._prepare("nav/get_business","SELECT * FROM nav_business WHERE shop_id = @shop_id AND owner = @owner")
vRP._prepare("nav/get_allbusiness","SELECT * FROM nav_business WHERE shop_id = @shop_id")
vRP._prepare("nav/check_business","SELECT * FROM nav_business WHERE user_id = @user_id AND shop_id = @shop_id AND owner = 1")
vRP._prepare("nav/use_business","SELECT * FROM nav_business WHERE user_id = @user_id AND shop_id = @shop_id")
vRP._prepare("nav/add_invest","UPDATE nav_business SET capital = capital + @capital WHERE user_id = @user_id AND shop_id = @shop_id")
vRP._prepare("nav/add_launded","UPDATE nav_business SET launded = launded + @launded WHERE user_id = @user_id AND shop_id = @shop_id")
vRP._prepare("nav/del_business","DELETE FROM nav_business WHERE shop_id = @shop_id")
vRP._prepare("nav/rem_permission","DELETE FROM nav_business WHERE shop_id = @shop_id AND user_id = @user_id")
vRP._prepare("nav/put_business","INSERT IGNORE INTO nav_business(user_id,shop_id,capital,launded,timelap,owner) VALUES(@user_id,@shop_id,@capital,@launded,@timelap,@owner)")
vRP._prepare("nav/res_business","UPDATE nav_business SET launded = 0, timelap = @timelap WHERE user_id = @user_id AND shop_id = @shop_id")
vRP._prepare("nav/count_business","SELECT COUNT(*) as qtd FROM nav_business WHERE shop_id = @shop_id")
vRP._prepare("nav/check_business2","SELECT * FROM nav_business WHERE owner = 1")
-----------------------------------------------------------------------------------------------------------------------------------------
-- SHOPLIST
-----------------------------------------------------------------------------------------------------------------------------------------
local shoplist = { -- price,max,minium,start,maxium,name,socios
	[1] = { 750000,500000,80,90,"Loja de Departamento",2 },
	[2] = { 750000,500000,80,90,"Loja de Departamento",2 },
	[3] = { 750000,500000,80,90,"Loja de Departamento",2 },
	[4] = { 750000,500000,80,90,"Loja de Departamento",2 },
	[5] = { 750000,500000,80,90,"Loja de Departamento",2 },
	[6] = { 750000,500000,80,90,"Loja de Departamento",2 },
	[7] = { 750000,500000,80,90,"Loja de Departamento",2 },
	[8] = { 750000,500000,80,90,"Loja de Departamento",2 },
	[9] = { 750000,500000,80,90,"Loja de Departamento",2 },
	[10] = { 750000,500000,80,90,"Loja de Departamento",2 },
	[11] = { 750000,500000,80,90,"Loja de Departamento",2 },
	[12] = { 750000,500000,80,90,"Loja de Departamento",2 },
	[13] = { 750000,500000,80,90,"Loja de Departamento",2 },
	[14] = { 750000,500000,80,90,"Loja de Departamento",2 },
	[15] = { 750000,500000,80,90,"Loja de Departamento",2 },
	[16] = { 750000,500000,80,90,"Loja de Departamento",2 },
	[17] = { 750000,500000,80,90,"Loja de Departamento",2 },
	[18] = { 750000,500000,80,90,"Loja de Departamento",2 },
	[19] = { 750000,500000,80,90,"Loja de Departamento",2 },
	[20] = { 750000,500000,80,90,"Loja de Departamento",2 },
	[21] = { 600000,350000,80,90,"Loja de Roupas",2 },
	[22] = { 600000,350000,80,90,"Loja de Roupas",2 },
	[23] = { 600000,350000,80,90,"Loja de Roupas",2 },
	[24] = { 600000,350000,80,90,"Loja de Roupas",2 },
	[25] = { 600000,350000,80,90,"Loja de Roupas",2 },
	[26] = { 600000,350000,80,90,"Loja de Roupas",2 },
	[27] = { 600000,350000,80,90,"Loja de Roupas",2 },
	[28] = { 600000,350000,80,90,"Loja de Roupas",2 },
	[29] = { 600000,350000,80,90,"Loja de Roupas",2 },
	[30] = { 600000,350000,80,90,"Loja de Roupas",2 },
	[31] = { 600000,350000,80,90,"Loja de Roupas",2 },
	[32] = { 600000,350000,80,90,"Loja de Roupas",2 },
	[33] = { 600000,350000,80,90,"Loja de Roupas",2 },
	[34] = { 600000,350000,80,90,"Loja de Roupas",2 },
	[35] = { 1000000,750000,80,90,"Loja de Armamentos",2 },
	[36] = { 1000000,750000,80,90,"Loja de Armamentos",2 },
	[37] = { 1000000,750000,80,90,"Loja de Armamentos",2 },
	[38] = { 1000000,750000,80,90,"Loja de Armamentos",2 },
	[39] = { 1000000,750000,80,90,"Loja de Armamentos",2 },
	[40] = { 1000000,750000,80,90,"Loja de Armamentos",2 },
	[41] = { 1000000,750000,80,90,"Loja de Armamentos",2 },
	[42] = { 1000000,750000,80,90,"Loja de Armamentos",2 },
	[43] = { 1000000,750000,80,90,"Loja de Armamentos",2 },
	[44] = { 1000000,750000,80,90,"Loja de Armamentos",2 },
	[45] = { 1000000,750000,80,90,"Loja de Armamentos",2 },
	[46] = { 850000,600000,80,90,"Salão de Beleza",2 },
	[47] = { 850000,600000,80,90,"Salão de Beleza",2 },
	[48] = { 850000,600000,80,90,"Salão de Beleza",2 },
	[49] = { 850000,600000,80,90,"Salão de Beleza",2 },
	[50] = { 850000,600000,80,90,"Salão de Beleza",2 },
	[51] = { 850000,600000,80,90,"Salão de Beleza",2 },
	[52] = { 850000,600000,80,90,"Salão de Beleza",2 },
	[53] = { 1250000,1000000,80,90,"Loja de Tatuagens",2 },
	[54] = { 1250000,1000000,80,90,"Loja de Tatuagens",2 },
	[55] = { 1250000,1000000,80,90,"Loja de Tatuagens",2 },
	[56] = { 1250000,1000000,80,90,"Loja de Tatuagens",2 },
	[57] = { 1250000,1000000,80,90,"Loja de Tatuagens",2 },
	[58] = { 1250000,1000000,80,90,"Loja de Tatuagens",2 },
	[59] = { 2000000,1500000,80,90,"Posto de Gasolina",2 },
	[60] = { 2000000,1500000,80,90,"Posto de Gasolina",2 },
	[61] = { 2000000,1500000,80,90,"Posto de Gasolina",2 },
	[62] = { 2000000,1500000,80,90,"Posto de Gasolina",2 },
	[63] = { 2000000,1500000,80,90,"Posto de Gasolina",2 },
	[64] = { 2000000,1500000,80,90,"Posto de Gasolina",2 },
	[65] = { 2000000,1500000,80,90,"Posto de Gasolina",2 },
	[66] = { 2000000,1500000,80,90,"Posto de Gasolina",2 },
	[67] = { 2000000,1500000,80,90,"Posto de Gasolina",2 },
	[68] = { 2000000,1500000,80,90,"Posto de Gasolina",2 },
	[69] = { 2000000,1500000,80,90,"Posto de Gasolina",2 },
	[70] = { 2000000,1500000,80,90,"Posto de Gasolina",2 },
	[71] = { 2000000,1500000,80,90,"Posto de Gasolina",2 },
	[72] = { 2000000,1500000,80,90,"Posto de Gasolina",2 },
	[73] = { 2000000,1500000,80,90,"Posto de Gasolina",2 },
	[74] = { 2000000,1500000,80,90,"Posto de Gasolina",2 },
	[75] = { 2000000,1500000,80,90,"Posto de Gasolina",2 },
	[76] = { 2000000,1500000,80,90,"Posto de Gasolina",2 },
	[77] = { 2000000,1500000,80,90,"Posto de Gasolina",2 },
	[78] = { 2000000,1500000,80,90,"Posto de Gasolina",2 },
	[79] = { 2000000,1500000,80,90,"Posto de Gasolina",2 },
	[80] = { 2000000,1500000,80,90,"Posto de Gasolina",2 },
	[81] = { 2000000,1500000,80,90,"Posto de Gasolina",2 },
	[82] = { 2000000,1500000,80,90,"Posto de Gasolina",2 },
	[83] = { 2000000,1500000,80,90,"Posto de Gasolina",2 },
	[84] = { 2000000,1500000,80,90,"Posto de Gasolina",2 },
	[85] = { 2000000,1500000,80,90,"Posto de Gasolina",2 },
	[86] = { 5000000,3000000,80,90,"Bar",3 },
	[87] = { 5000000,3000000,97,99,"Vanilla",9},
	[88] = { 5000000,3000000,80,90,"Bar",3 },
	[89] = { 5000000,3000000,80,90,"Bar",3 },
	[90] = { 5000000,3000000,80,90,"Bar",3 },
	[91] = { 1000000,750000,80,90,"Loja de Armamentos",2 },
	[92] = { 1000000,750000,80,90,"Loja de Armamentos",2 },
	[93] = { 1000000,750000,80,90,"Loja de Armamentos",2 },
	[94] = {350000,100000,80,90,"Camelô",2 },
 [95] = {350000,100000,80,90,"Camelô",2 },
 [96] = {350000,100000,80,90,"Camelô",2 },
 [97] = {350000,100000,80,90,"Camelô",2 },
 [98] = {350000,100000,80,90,"Camelô",2 },
 [99] = {350000,100000,80,90,"Camelô",2 },
 [100] = {350000,100000,80,90,"Camelô",2 },
 [101] = {350000,100000,80,90,"Camelô",2 },
 [102] = {350000,100000,80,90,"Camelô",2 },
 [103] = {350000,100000,80,90,"Camelô",2 },
 [104] = {350000,100000,80,90,"Camelô",2 },
 [105] = {350000,100000,80,90,"Camelô",2 },
 [106] = {350000,100000,80,90,"Camelô",2 },
 [107] = {350000,100000,80,90,"Camelô",2 },
 [108] = {350000,100000,80,90,"Camelô",2 },
 [109] = {350000,100000,80,90,"Camelô",2 },
 [110] = {350000,100000,80,90,"Camelô",2 },
 [111] = {350000,100000,80,90,"Camelô",2 },
 [112] = {350000,100000,80,90,"Camelô",2 },
 [113] = {350000,100000,80,90,"Camelô",2 },
 [114] = {350000,100000,80,90,"Camelô",2 },
 [115] = {350000,100000,80,90,"Camelô",2 },
 [116] = {350000,100000,80,90,"Camelô",2 },
 [117] = {350000,100000,80,90,"Camelô",2 },
 [118] = {350000,100000,80,90,"Camelô",2 },
 [119] = {350000,100000,80,90,"Camelô",2 },
 [120] = {350000,100000,80,90,"Camelô",2 },
 [121] = {350000,100000,80,90,"Camelô",2 },
 [122] = {350000,100000,80,90,"Camelô",2 },
 [123] = {350000,100000,80,90,"Camelô",2 },
 [124] = {350000,100000,80,90,"Camelô",2 },
 [125] = {350000,100000,80,90,"Camelô",2 },
 [126] = {350000,100000,80,90,"Camelô",2 },
 [127] = { 300000,150000,80,90,"Cannabis Store",2 },
 [128] = { 1700000,1250000,80,90,"Pescado Rojo",2 },
 [129] = { 1700000,1250000,80,90,"Pipeline INN",2 },
 [130] = { 1700000,1250000,80,90,"Spitroasters Meathouse",2 },
 [131] = { 1700000,1250000,80,90,"Clappers",2 },
 [132] = { 1700000,1250000,80,90,"Casey's Dinner",2 },
 [133] = { 1700000,1250000,80,90,"Taco Bomb",2 },
 [134] = { 1700000,1250000,80,90,"Hookies",2 },
 [135] = { 1700000,1250000,80,90,"Bayview Lodge",2 },
 [136] = { 1700000,1250000,80,90,"Pearl's Seafood",2 },
 [137] = { 1700000,1250000,80,90,"Lumac Restaurant",2 },
 [138] = { 1700000,1250000,80,90,"La Spada",2 },
 [139] = { 1800000,1300000,80,90,"Oficina",2 },
 [140] = { 1800000,1300000,80,90,"Oficina",2 },
 [141] = { 1800000,1300000,80,90,"Oficina",2 },
 [142] = { 1800000,1300000,80,90,"Oficina",2 },
 [143] = { 1800000,1300000,80,90,"Oficina",2 },
 [144] = { 1800000,1300000,80,90,"Oficina",2 },
 [145] = { 1800000,1300000,80,90,"Oficina",2 },
 [146] = { 1800000,1300000,80,90,"Oficina",2 },
 [147] = { 5000000,3000000,80,90,"Koi Spa",2 },
 [148] = { 300000,150000,80,90,"Lavanderia",2 },
 [149] = { 300000,150000,80,90,"Porncrackers",2 },
 [150] = { 300000,150000,80,90,"Loja de Penhores",2 },
 [151] = { 300000,150000,80,90,"Save-a-Cent",2 },
 [152] = { 300000,150000,80,90,"Save-a-Cent",2 },
 [153] = { 300000,150000,80,90,"Save-a-Cent",2 },
 [154] = { 300000,150000,80,90,"Save-a-Cent",2 },
 [155] = { 300000,150000,80,90,"Vinewood Pawn",2 },
 [156] = { 5000000,3000000,80,90,"You Tool",2 },
 [157] = { 5000000,3000000,80,90,"MEGA MALL",2 },
 [158] = { 1800000,1300000,80,90,"Farmacia",2 },
 [159] = { 1800000,1300000,80,90,"Farmacia",2 },
 [160] = { 1800000,1300000,80,90,"Farmacia",2 },
 [161] = { 800000,550000,80,90,"Lanchonete",2 },
 [162] = { 800000,550000,80,90,"Lanchonete",2 },
 [163] = { 800000,550000,80,90,"Lanchonete",2 },
 [164] = { 800000,550000,80,90,"Park Jung",2 },
 [165] = { 800000,550000,80,90,"Taco Farmer",2 },
 [166] = { 800000,550000,80,90,"Taco Farmer",2 },
 [167] = { 800000,550000,80,90,"Long Pig",2 },
 [168] = { 800000,550000,80,90,"Hearty Taco",2 },
 [169] = { 800000,550000,80,90,"Bishop's Chicken",2 },
 [170] = { 800000,550000,80,90,"Bishop's Chicken",2 },
 [171] = { 800000,550000,80,90,"Muscle Peach",2 },
 [172] = { 800000,550000,80,90,"La Vaca Loca",2 },
 [173] = { 1700000,1250000,80,90,"Lucky Plucker",2 },
 [174] = { 1700000,1250000,80,90,"Chilli House",2 },
 [175] = { 800000,550000,80,90,"Aguilla Burrito",2 },
 [176] = { 800000,550000,80,90,"China Buffet",2 },
 [177] = { 800000,550000,80,90,"Cluckin'Bell",2 },
 [178] = { 800000,550000,80,90,"Chihuahua HotDogs",2 },
 [179] = { 1700000,1250000,80,90,"Wraps Fresh",2 },
 [180] = { 800000,550000,80,90,"Chido Taqueria",2 },
 [181] = { 1700000,1250000,80,90,"Burguer shot",2 },
 [182] = { 800000,550000,80,90,"Liberty Style Pizza",2 },
 [183] = { 800000,550000,80,90,"Pizza This",2 },
 [184] = { 1700000,1250000,80,90,"Lucky Plucker",2 },
 [185] = { 3000000,2000000,80,90,"SHO Noodle",2 },
 [186] = { 1700000,1250000,80,90,"Mom's Pie",2 },
 [187] = { 1700000,1250000,80,90,"Hang Ten",2 },
 [188] = { 3000000,2000000,80,90,"Snr.Burns",2 },
 [189] = { 10000000,6000000,80,90,"M&M Seguros",2 },
 [190] = { 10000000,6000000,80,90,"Pacific Bluffs",2 },
 [191] = { 10000000,6000000,80,90,"Clube de Tenis",2 },
 [192] = { 10000000,6000000,80,90,"Soyle Tecidos",2 },
 [193] = { 10000000,6000000,80,90,"Korean Plaza",2 },
 [194] = { 5000000,3000000,80,90,"Bean Machine Cafe",2 },
 [195] = { 850000,600000,80,90,"Bean Machine Cafe",2 },
 [196] = { 850000,600000,80,90,"Bean Machine Cafe",2 },
 [197] = { 850000,600000,80,90,"Bean Machine Cafe",2 },
 [198] = { 850000,600000,80,90,"Bean Machine Cafe",2 },
 [199] = { 850000,600000,80,90,"Bean Machine Cafe",2 },
 [200] = { 850000,600000,80,90,"Bean Machine Cafe",2 },
 [201] = { 850000,600000,80,90,"Bean Machine Cafe",2 },
 [202] = { 850000,600000,80,90,"Bean Machine Cafe",2 },
 [203] = { 850000,600000,80,90,"Bean Machine Cafe",2 },
 [204] = { 850000,600000,80,90,"Bean Machine Cafe",2 },
 [205] = { 850000,600000,80,90,"Little Teapot",2 },
 [206] = { 850000,600000,80,90,"Jamaican Roast",2 }
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- BUYBUSINESS
-----------------------------------------------------------------------------------------------------------------------------------------
function src.buyBusiness(shopid)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id and parseInt(shopid) > 0 and not vRP.searchReturn(source,user_id) and shopid ~= 999 then
		local business = vRP.query("nav/get_business",{ shop_id = parseInt(shopid), owner = 1 })
		if business[1] ~= nil then
			TriggerClientEvent("Notify",source,"negado","<b>"..shoplist[shopid][5].."</b> já possui um proprietário.",8000)
		else
			if vRP.tryFullPayment(user_id,parseInt(shoplist[shopid][1])) then
				vRP.execute("nav/put_business",{ user_id = parseInt(user_id), shop_id = parseInt(shopid), capital = parseInt(shoplist[shopid][2]*0.1), launded = 0, timelap = parseInt(os.time()), owner = 1 })
				TriggerClientEvent("Notify",source,"sucesso","Compra da <b>"..shoplist[shopid][5].."</b> concluída.",8000)
			else
				TriggerClientEvent("Notify",source,"negado","Dinheiro insuficiente.",8000)
			end
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- SELLBUSINESS
-----------------------------------------------------------------------------------------------------------------------------------------
function src.sellBusiness(shopid)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id and parseInt(shopid) > 0 and not vRP.searchReturn(source,user_id) and shopid ~= 999 then
		local business = vRP.query("nav/check_business",{ user_id = parseInt(user_id), shop_id = parseInt(shopid) })
		if business[1] and business[1] ~= nil then
			vRP.giveMoney(user_id,parseInt(shoplist[shopid][1]*0.7))
			vRP.execute("nav/del_business",{ shop_id = parseInt(shopid) })
			TriggerClientEvent("Notify",source,"sucesso","Venda da <b>"..shoplist[shopid][5].."</b> concluída.",8000)
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- LAUNDBUSINESS
-----------------------------------------------------------------------------------------------------------------------------------------
function src.laundBusiness(shopid,launded)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id and parseInt(shopid) > 0 and not vRP.searchReturn(source,user_id) then
		if shopid == 999 then
			if parseInt(launded) > 0 then
				local random = math.random(50,60)
				if vRP.tryGetInventoryItem(user_id,"dinheirosujo",parseInt(launded)) then
					vRP.giveMoney(user_id,parseInt(launded*("0."..random)))
					TriggerClientEvent("Notify",source,"sucesso","Lavagem de <b>$"..vRP.format(parseInt(launded)).." dólares</b> concluído e recebido <b>$"..vRP.format(parseInt(launded*("0."..random))).." dólares</b>.",8000)
				else
					TriggerClientEvent("Notify",source,"negado","Dinheiro sujo insuficiente.",8000)
				end
			end
		else
			local business = vRP.query("nav/use_business",{ user_id = parseInt(user_id), shop_id = parseInt(shopid) })
			if business[1] and business[1] ~= nil then
				local permBuss = vRP.query("nav/get_business",{ shop_id = parseInt(shopid), owner = 1 })
				if parseInt(os.time()) >= parseInt(permBuss[1].timelap+24*3*60*60) then
					vRP.execute("nav/res_business",{ user_id = parseInt(permBuss[1].user_id), timelap = parseInt(os.time()), shop_id = parseInt(shopid) })
				end
				if parseInt(launded) > 0 and parseInt(launded) <= parseInt(permBuss[1].capital-permBuss[1].launded) then
					local random = math.random(parseInt(shoplist[shopid][3]),parseInt(shoplist[shopid][4]))
					if vRP.tryGetInventoryItem(user_id,"dinheirosujo",parseInt(launded)) then
						vRP.giveMoney(user_id,parseInt(launded*("0."..random)))
						vRP.execute("nav/add_launded",{ user_id = parseInt(permBuss[1].user_id), launded = parseInt(launded), shop_id = parseInt(shopid) })
						TriggerClientEvent("Notify",source,"sucesso","Lavagem de <b>$"..vRP.format(parseInt(launded)).." dólares</b> concluído e recebido <b>$"..vRP.format(parseInt(launded*("0."..random))).." dólares</b>.",8000)
					else
						TriggerClientEvent("Notify",source,"negado","Dinheiro sujo insuficiente.",8000)
					end
				else
					TriggerClientEvent("Notify",source,"negado","Capital insuficiente.",8000)
				end
			end
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- INVESTBUSINESS
-----------------------------------------------------------------------------------------------------------------------------------------
function src.investBusiness(shopid,invest)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id and parseInt(shopid) > 0 and not vRP.searchReturn(source,user_id) and shopid ~= 999 then
		local business = vRP.query("nav/use_business",{ user_id = parseInt(user_id), shop_id = parseInt(shopid) })
		if business[1] and business[1] ~= nil and parseInt(invest) >= 2 then
			local permBuss = vRP.query("nav/get_business",{ shop_id = parseInt(shopid), owner = 1 })
			if parseInt(permBuss[1].capital+(invest*0.3)) <= parseInt(shoplist[shopid][2]) then
				if vRP.tryGetInventoryItem(user_id,"dinheirosujo",parseInt(invest)) then
					vRP.execute("nav/add_invest",{ user_id = parseInt(permBuss[1].user_id), capital = parseInt(invest*0.3), shop_id = parseInt(shopid) })
					TriggerClientEvent("Notify",source,"sucesso","Investimento de <b>$"..vRP.format(parseInt(invest*0.3)).."</b> concluído.",8000)
				else
					TriggerClientEvent("Notify",source,"negado","Dinheiro sujo insuficiente.",8000)
				end
			else
				TriggerClientEvent("Notify",source,"importante","A empresa atingiu o limite de <b>$"..vRP.format(parseInt(shoplist[shopid][2])).." dólares</b> em seus investimentos.",8000)
			end
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- OVERBUSINESS
-----------------------------------------------------------------------------------------------------------------------------------------
function src.overBusiness(shopid,card)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id and parseInt(shopid) > 0 and not vRP.searchReturn(source,user_id) and shopid ~= 999 then
		local business = vRP.query("nav/use_business",{ user_id = parseInt(user_id), shop_id = parseInt(shopid) })
		if business[1] and business[1] ~= nil then
			local permBuss = vRP.query("nav/get_business",{ shop_id = parseInt(shopid), owner = 1 })
			if parseInt(permBuss[1].capital) >= parseInt(shoplist[shopid][2]) then
				if tostring(card) == "blue" or tostring(card) == "yellow" or tostring(card) == "green" then
					if vRP.tryGetInventoryItem(user_id,"dinheirosujo",300000) and vRP.tryGetInventoryItem(user_id,tostring(card).."card",3) then
						vRP.execute("nav/add_invest",{ user_id = parseInt(permBuss[1].user_id), capital = 100000, shop_id = parseInt(shopid) })
						TriggerClientEvent("Notify",source,"sucesso","Investimento de <b>$100.000</b> usando <b>3x Blue Card</b> concluído.",8000)
					else
						TriggerClientEvent("Notify",source,"negado","Requisito necessário insuficiente.",8000)
					end
				end
			else
				TriggerClientEvent("Notify",source,"negado","A empresa precisa estar com o investimento no <b>máximo</b> ou <b>superior</b>.",8000)
			end
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHECKBUSINESS
-----------------------------------------------------------------------------------------------------------------------------------------
function src.checkBusiness(shopid)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id and parseInt(shopid) > 0 and not vRP.searchReturn(source,user_id) and shopid ~= 999 then
		local business = vRP.query("nav/use_business",{ user_id = parseInt(user_id), shop_id = parseInt(shopid) })
		if business[1] and business[1] ~= nil then
			local allPerms = vRP.query("nav/get_allbusiness",{ shop_id = parseInt(shopid) })
			local permissoes = ""
			for k,v in pairs(allPerms) do
				local identity = vRP.getUserIdentity(v.user_id)
				if identity then
					permissoes = permissoes.."<b>Nome:</b> "..identity.name.." "..identity.firstname.."   -   <b>Passaporte:</b> "..v.user_id
					if k ~= #allPerms then
						permissoes = permissoes.."<br>"
					end
				end
			end

			local bussInfo = vRP.query("nav/get_business",{ shop_id = parseInt(shopid), owner = 1 })

			if parseInt(os.time()) <= parseInt(bussInfo[1].timelap+24*3*60*60) then
				TriggerClientEvent("Notify",source,"importante","<b>Capital Geral:</b> $"..vRP.format(parseInt(bussInfo[1].capital)).."<br><b>Capital Purificado:</b> $"..vRP.format(parseInt(bussInfo[1].launded)).."<br><b>Investimento Máximo:</b> $"..vRP.format(parseInt(shoplist[shopid][2])).."<br>Reinicialização em "..vRPclient.getTimeFunction(source,parseInt(86400*3-(os.time()-bussInfo[1].timelap))).."<br><br>"..permissoes,30000)
			else
				TriggerClientEvent("Notify",source,"importante","<b>Capital Geral:</b> $"..vRP.format(parseInt(bussInfo[1].capital)).."<br><b>Capital Purificado:</b> "..vRP.format(parseInt(bussInfo[1].launded)).."<br><b>Investimento Máximo:</b> $"..vRP.format(parseInt(shoplist[shopid][2])).."<br><br>"..permissoes,30000)
			end
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- INFOBUSINESS
-----------------------------------------------------------------------------------------------------------------------------------------
function src.infoBusiness(shopid)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id and parseInt(shopid) > 0 and not vRP.searchReturn(source,user_id) and shopid ~= 999 then
		local business = vRP.query("nav/get_business",{ shop_id = parseInt(shopid), owner = 1 })
		if business[1] and business[1] ~= nil then
			local identity = vRP.getUserIdentity(parseInt(business[1].user_id))
			if identity then
				TriggerClientEvent("Notify",source,"importante","<b>Proprietário:</b> "..identity.name.." "..identity.firstname,8000)
			end
		else
			TriggerClientEvent("Notify",source,"aviso","<b>Valor:</b> $"..vRP.format(parseInt(shoplist[shopid][1])),8000)
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- ADDBUSINESS
-----------------------------------------------------------------------------------------------------------------------------------------
function src.addBusiness(shopid,nuserid)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id and parseInt(shopid) > 0 and not vRP.searchReturn(source,user_id) and shopid ~= 999 then
		local business = vRP.query("nav/check_business",{ user_id = parseInt(user_id), shop_id = parseInt(shopid) })
		if business[1] and business[1] ~= nil then
			local countBuss = vRP.query("nav/count_business",{ shop_id = parseInt(shopid) })
			if parseInt(countBuss[1].qtd) >= parseInt(shoplist[shopid][6]) then
				TriggerClientEvent("Notify",source,"negado","<b>"..shoplist[shopid][5].."</b> atingiu o máximo de sócios.",10000)
				return
			else
				vRP.execute("nav/put_business",{ user_id = parseInt(nuserid), shop_id = parseInt(shopid), capital = 0, launded = 0, timelap = 0, owner = 0 })
				local identity = vRP.getUserIdentity(parseInt(nuserid))
				if identity then
					TriggerClientEvent("Notify",source,"sucesso","Sociedade adicionada para <b>"..identity.name.." "..identity.firstname.."</b>.",10000)
				end
			end
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- REMBUSINESS
-----------------------------------------------------------------------------------------------------------------------------------------
function src.remBusiness(shopid,nuserid)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id and parseInt(shopid) > 0 and not vRP.searchReturn(source,user_id) and shopid ~= 999 then
		local business = vRP.query("nav/check_business",{ user_id = parseInt(user_id), shop_id = parseInt(shopid) })
		if business[1] and business[1] ~= nil then
			local permList = vRP.query("nav/use_business",{ user_id = parseInt(nuserid), shop_id = parseInt(shopid) })
			if permList[1] then
				vRP.execute("nav/rem_permission",{ shop_id = parseInt(shopid), user_id = parseInt(nuserid) })
				local identity = vRP.getUserIdentity(parseInt(nuserid))
				if identity then
					TriggerClientEvent("Notify",source,"sucesso","Sociedade removida de <b>"..identity.name.." "..identity.firstname.."</b>.",10000)
				end
			end
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- TRANSBUSINESS
-----------------------------------------------------------------------------------------------------------------------------------------
function src.transBusiness(shopid,nuserid)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id and parseInt(shopid) > 0 and not vRP.searchReturn(source,user_id) and shopid ~= 999 then
		local business = vRP.query("nav/check_business",{ user_id = parseInt(user_id), shop_id = parseInt(shopid) })
		if business[1] and business[1] ~= nil then
			local identity = vRP.getUserIdentity(parseInt(nuserid))
			if identity then
				local ok = vRP.request(source,"Transferir a <b>"..tostring(shoplist[shopid][5]).."</b> para <b>"..identity.name.." "..identity.firstname.."</b>?",30)
				if ok then
					vRP.execute("nav/del_business",{ shop_id = parseInt(shopid) })
					vRP.execute("nav/put_business",{ user_id = parseInt(nuserid), shop_id = parseInt(shopid), capital = parseInt(business[1].capital), launded = parseInt(business[1].launded), timelap = parseInt(business[1].timelap), owner = 1 })
					TriggerClientEvent("Notify",source,"importante","Transferiu a <b>"..tostring(shoplist[shopid][5]).."</b> para <b>"..identity.name.." "..identity.firstname.."</b>.",10000)
				end
			end
		end
	end
end
