function onLogin(cid)
	if getPlayerGroupId(cid) == 1 and getPlayerStorageValue(cid, 50000) == -1 then
		setPlayerStorageValue(cid, initStorages.graduation, "Academy Student")

		----------------------------------------------------------------
			doPlayerAddItem(cid, 12558, 1)
			doPlayerAddItem(cid, 12685, 1)
			doPlayerAddItem(cid, 2399, 2)
			doPlayerAddItem(cid, 1987, 1)
			local b = doPlayerAddItem(cid, 11394, 1) -- menu
			local b1 = doAddContainerItem(b, 12988, 1) -- Emoticon
			doAddContainerItem(b1, 11389, 8)
			local skills = doAddContainerItem(b, 13004, 1) -- Skills
			doAddContainerItem(skills, 11389, 5)
			local b2 = doAddContainerItem(b, 11400, 1) -- CMDS
			doAddContainerItem(b2, 11428, 1)
			doAddContainerItem(b2, 12888, 1)
			doAddContainerItem(b2, 11391, 1)
			doAddContainerItem(b2, 11392, 1)
			doAddContainerItem(b2, 11393, 1)
            local b3 = doAddContainerItem(b, 11390, 1) -- Jutsu
			local c11 = doAddContainerItem(b3, 12849, 1) -- Kuchyose
            local c12 = doAddContainerItem(c11, 12855, 1) -- Manda
			doAddContainerItem(c12, 11389, 4)
			local c13 = doAddContainerItem(c11, 12861, 1) -- Katsuyu
			doAddContainerItem(c13, 11389, 4)
			local c14 = doAddContainerItem(c11, 12846, 1) -- Gama
			doAddContainerItem(c14, 11389, 4)
			local c15 = doAddContainerItem(c11, 12862, 1) -- Ninken
			doAddContainerItem(c15, 11389, 4)
			local b14 = doAddContainerItem(b3, 11459, 1) -- Genjutsu
			doAddContainerItem(b14, 13448, 1) -- Jushibari
			doAddContainerItem(b14, 13447, 1) -- Nehan Shōja
			doAddContainerItem(b14, 13446, 1) -- Kokuangyou
			doAddContainerItem(b14, 13445, 1) -- Kaen
			doAddContainerItem(b14, 13444, 1) -- Kanashibari
			doAddContainerItem(b14, 13443, 1) -- Kokuangyou
			doAddContainerItem(b14, 13442, 1) -- Hanachiri Nuko
			doAddContainerItem(b14, 13441, 1) -- Utakata
            local b5 = doAddContainerItem(b3, 11427, 1) -- Ninjutsu
			local d5 = doAddContainerItem(b5, 12858, 1) -- Kinjutsu
			doAddContainerItem(d5, 11389, 8)
			local d4 = doAddContainerItem(b5, 12863, 1) -- Doton
			doAddContainerItem(d4, 11389, 8)
            local b8 = doAddContainerItem(b5, 11421, 1) -- Katon
			doAddContainerItem(b8, 13334, 1) -- Karyuu Endan
			doAddContainerItem(b8, 13333, 1) -- Gouryuuka
			doAddContainerItem(b8, 13332, 1) -- Ryuuka
			doAddContainerItem(b8, 13331, 1) -- Karyuudan
			doAddContainerItem(b8, 13330, 1) -- Shiruko
			doAddContainerItem(b8, 13329, 1) -- Housenka
			doAddContainerItem(b8, 13328, 1) -- Goukakyuu
			doAddContainerItem(b8, 13327, 1) -- Endan
			local d3 = doAddContainerItem(b5, 12854, 1) -- Suiton
			doAddContainerItem(d3, 11389, 8)
			local d2 = doAddContainerItem(b5, 12848, 1) -- Fuuton
			doAddContainerItem(d2, 13425, 1) -- Kazekiri no Jutsu
			doAddContainerItem(d2, 13424, 1) -- Reppushou
			doAddContainerItem(d2, 13423, 1) -- Shinkuu Gyoku
			doAddContainerItem(d2, 13422, 1) -- Suiran Reppu
			doAddContainerItem(d2, 13421, 1) -- Toppa no Jutsu
			doAddContainerItem(d2, 13420, 1) -- Daitoppa
			doAddContainerItem(d2, 13419, 1) -- Shinkuha
			doAddContainerItem(d2, 13418, 1) -- Juuha Shou no Yaiba
			local d1 = doAddContainerItem(b5, 12843, 1) -- Raiton
			doAddContainerItem(d1, 13417, 1) -- Kirin
			doAddContainerItem(d1, 13416, 1) -- Raikiri Nirentutsu
			doAddContainerItem(d1, 13415, 1) -- Chidori Nagashi
			doAddContainerItem(d1, 13414, 1) -- Raikiri
			doAddContainerItem(d1, 13413, 1) -- Raiton - Sandaa Saaburu
			doAddContainerItem(d1, 13412, 1) -- Raiton - Sandaa Saaburu
			doAddContainerItem(d1, 13411, 1) -- Raiton - Sandaa Saaburu
			doAddContainerItem(d1, 13410, 1) -- Raiton Hiraishin
			local b14 = doAddContainerItem(b5, 11470, 1) -- Medicinal
			doAddContainerItem(b14, 13402, 1) -- Chakra no mesu
			doAddContainerItem(b14, 13401, 1) -- Ranshinshou
			doAddContainerItem(b14, 13400, 1) -- Chyute no jutsu
			doAddContainerItem(b14, 13399, 1) -- Inyu Shometsu
			doAddContainerItem(b14, 13398, 1) -- Chakra Kuuin Jutsu
			doAddContainerItem(b14, 13397, 1) -- Saikan Chuushutsu no Jutsu
			doAddContainerItem(b14, 13396, 1) -- Shousen no Jutsu
			doAddContainerItem(b14, 13395, 1) -- Icha Shushon
			local b12 = doAddContainerItem(b5, 11469, 1) -- Ninpou
			doAddContainerItem(b12, 13380, 1) -- Mizu Kinobori
			doAddContainerItem(b12, 13379, 1) -- Kinobori
			doAddContainerItem(b12, 13378, 1) -- Kai
			doAddContainerItem(b12, 13377, 1) -- Kawarimi
			local b13 = doAddContainerItem(b12, 12734, 1) -- Bunshin Container
			doAddContainerItem(b13, 13382, 1) -- VirarBunshin
			doAddContainerItem(b13, 13381, 1) -- RemoveBunshin
			doAddContainerItem(b13, 13376, 1) -- Bunshin
			doAddContainerItem(b12, 13375, 1) -- Henge
			doAddContainerItem(b12, 13393, 1) -- Kakuremino
			doAddContainerItem(b12, 13394, 1) -- Chakra Ryu
------------------------------------------------------------------			
			if getPlayerVocation(cid) == 5 then -- Uchiha
			local b9 = doAddContainerItem(b3, 11448, 1) -- Uchiha Jutsu
			local b10 = doAddContainerItem(b9, 11445, 1) --Doujutsu
			local b11 = doAddContainerItem(b10, 11477, 1)
			doAddContainerItem(b11, 13368,1) -- Mangekyou Sharingan
			doAddContainerItem(b10, 13342,1) -- Sharingan Nv3
			doAddContainerItem(b10, 13341,1) -- Sharingan Nv2
			doAddContainerItem(b10, 13340,1) -- Sharingan Nv1
								setPlayerStorageValue(cid, 50000, 1)
			return true

-----------------------------------------------------------
			elseif getPlayerVocation(cid) == 3 then -- Aburame
			local b9 = doAddContainerItem(b3, 11395, 1) -- Aburame Jutsu
			doAddContainerItem(b9, 13389, 1) -- Mushidama
			doAddContainerItem(b9, 13388, 1) -- Arare
			doAddContainerItem(b9, 13387, 1) -- Tsumoji
			doAddContainerItem(b9, 13386, 1) -- Mushikame
			doAddContainerItem(b9, 13385, 1) -- Yajiri
			doAddContainerItem(b9, 13384, 1) -- Mushi Bunshin
			local b10 = doAddContainerItem(b9, 12221, 1) -- Kikkaichu Jutsu
			doAddContainerItem(b10, 13391,1) -- Return
			doAddContainerItem(b10, 13390,1) -- Kikkais
			doAddContainerItem(b10, 13392,1) -- Search
			doAddContainerItem(b9, 13383, 1) -- Bashira
								setPlayerStorageValue(cid, 50000, 1)
			return true
			
------------------------------------------------------------------			
			elseif getPlayerVocation(cid) == 4 then -- Hyuuga
			local a9 = doAddContainerItem(b3, 11401, 1) -- Hyuuga Jutsu
			doAddContainerItem(a9, 13335, 1) -- Shiten Kuushou
			doAddContainerItem(a9, 13338, 1) -- Hasengeki
			doAddContainerItem(a9, 13339, 1) -- Kaiten
			doAddContainerItem(a9, 13337, 1) -- Kuushou
			doAddContainerItem(a9, 13336, 1) -- Hiasangi
            local a10 = doAddContainerItem(a9, 11402, 1)
			local a11 = doAddContainerItem(a10, 11403, 1)
			doAddContainerItem(a11, 13345, 1) -- hakke hyakunijuuhachishou
			doAddContainerItem(a11, 13344, 1) -- hakke rokujuuyonshou
			doAddContainerItem(a11, 13343, 1) -- hakke sanjuunishou
			doAddContainerItem(a10, 11431, 1) -- Search Off
			doAddContainerItem(a10, 11430, 1) -- Byakugan Search
			doAddContainerItem(a10, 11429, 1) -- Byakugan
				setPlayerStorageValue(cid, 50000, 1)
			return true
			
----------------------------------------------------------------			
		elseif getPlayerVocation(cid) == 1 then -- Maito
		     local c9 = doAddContainerItem(b3, 12844, 1)-- Maito Jutsu
			doAddContainerItem(c9, 13353, 1) -- Gouriki Senpuu
			doAddContainerItem(c9, 13352, 1) -- Dai Senpuu
			doAddContainerItem(c9, 13354, 1) -- Omote Renge
			doAddContainerItem(c9, 13351, 1) -- Dinamic Entry
			doAddContainerItem(c9, 13350, 1) -- Senpuu
			local c10 = doAddContainerItem(c9, 11484, 1) -- hacimon tonkou
			doAddContainerItem(c10, 13409, 1) -- Shimon
			doAddContainerItem(c10, 13408, 1) --Kyoumon
			doAddContainerItem(c10, 13407, 1) -- Keimon
			doAddContainerItem(c10, 13406, 1) -- Tomon
			doAddContainerItem(c10, 13405, 1) -- Shomon
			doAddContainerItem(c10, 13404, 1) -- Seimon
			doAddContainerItem(c10, 13403, 1) -- Kyumon
			doAddContainerItem(c10, 13356, 1) -- Kaimon
						setPlayerStorageValue(cid, 50000, 1)
			return true

----------------------------------------------------------
	elseif getPlayerVocation(cid) == 6 then -- Nara
		     local c9 = doAddContainerItem(b3, 12864, 1)-- NaraJutsu 
			doAddContainerItem(c9, 13433, 1) -- Kageyose no Jutsu
			doAddContainerItem(c9, 13431, 1) -- Kagemane Shuriken no Jutsu
			doAddContainerItem(c9, 13430, 1) -- Kage Nui
			doAddContainerItem(c9, 13428, 1) -- Kubi Shibari
			local c10 = doAddContainerItem(c9, 12869, 1) -- Kagemane container
			doAddContainerItem(c10, 13432, 1) -- Triplicate Kagemane
			doAddContainerItem(c10, 13429, 1) -- Duplicate Kagemane
			doAddContainerItem(c10, 13426, 1) -- Kagemane
			doAddContainerItem(c10, 13449, 1)			
						setPlayerStorageValue(cid, 50000, 1)
			return true
			
----------------------------------------------------------			
	elseif getPlayerVocation(cid) == 7 then -- Akimichi
          local d9 = doAddContainerItem(b3, 12850, 1)-- Akimichi Jutsu
			doAddContainerItem(d9, 13364, 1) -- Choudan Bakugeki
			doAddContainerItem(d9, 13367, 1) -- Tongarashigan
			doAddContainerItem(d9, 13363, 1) -- Bubun Baika No Jutsu
			doAddContainerItem(d9, 13362, 1) -- Mizudan Suisha
			doAddContainerItem(d9, 13361, 1) -- Harite Chou
			doAddContainerItem(d9, 13360, 1) -- Omoni
			doAddContainerItem(d9, 13359, 1) -- Chou Baika
			doAddContainerItem(d9, 13366, 1) -- Karengan
			doAddContainerItem(d9, 13358, 1) -- Nikudan Hari Sensha
			doAddContainerItem(d9, 13365, 1) -- Horengan
			doAddContainerItem(d9, 13357, 1) -- Nikudan Sensha						
					setPlayerStorageValue(cid, 50000, 1)
			return true	
---------------------------------------------------------

	elseif getPlayerVocation(cid) == 2 then -- Inuzuka
			local pet = doPlayerAddItem(cid, 13434, 1)
			doAddContainerItem(pet, 13438, 1) -- Moko Taiko
			doAddContainerItem(pet, 13437, 1) -- Scratch
			doAddContainerItem(pet, 13436, 1) -- Bite
			doAddContainerItem(pet, 13435, 1) -- Dynamic Marking
            local e9 = doAddContainerItem(b3, 12859, 1)-- Inuzuka Jutsu
			doAddContainerItem(e9, 13373, 1) -- Garouga
			doAddContainerItem(e9, 13374, 1) -- Soutorou
			doAddContainerItem(e9, 13372, 1) -- Gatsuuga
			doAddContainerItem(e9, 13371, 1) -- Juujin Bunshin
			doAddContainerItem(e9, 13370, 1) -- Shykiaku no Jutsu
			doAddContainerItem(e9, 13369, 1) -- Tsuuga
			local e10 = doAddContainerItem(e9, 12783, 1)-- PET	
            doAddContainerItem(e10, 12793, 1) -- rest
			doAddContainerItem(e10, 12792, 1) -- back
			doAddContainerItem(e10, 12791, 1) -- go	
			
				setPlayerStorageValue(cid, 50000, 1)
			end

						setPlayerStorageValue(cid, 50000, 1)
			return true
		end

		if getPlayerStorageValue(cid, 50000) == 1 and getPlayerVocation(cid) == 6 then
			local bag1 = getContainerItem(getPlayerSlotItem(cid, 10).uid, 0).uid
			local bag2 = getContainerItem(bag1, 0).uid
			local bag3 = getContainerItem(bag2, 0).uid
			doAddContainerItem(bag3, 12225)
			doPlayerSendCancel(cid, "O Seu Kagemane foi atualizado")
			setPlayerStorageValue(cid, 50000, 2)
		end	

		return true
	end
	