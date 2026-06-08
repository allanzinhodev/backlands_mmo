-- Exame Chunin completo feito por Vitor Bertolucci.
-- Favor nao postar nem compartilhar este codigo.
-- Favor manter esses comentarios quando for utilizar o codigo.
-- 17/05/2014

exame = {
    
    player_positions = {
        {{x = 2936, y = 1967, z = 7}, {x = 2936, y = 1969, z = 7}, {x = 2936, y = 1971, z = 7}}, -- Posicoes dos players para puxar a alavanca e ir pra arena de x1s
        {{x = 2941, y = 1976, z = 7}, {x = 2946, y = 1976, z = 7}, {x = 2945, y = 1976, z = 7}},
        {{x = 2950, y = 1971, z = 7}, {x = 2950, y = 1969, z = 7}, {x = 2950, y = 1967, z = 7}},
        {{x = 2945, y = 1962, z = 7}, {x = 2943, y = 1962, z = 7}, {x = 2941, y = 1962, z = 7}}
    },
    scroll_positions = {
        {{x = 2937, y = 1968, z = 7}, {x = 2967, y = 1970, z = 7}}, -- Posicoes que os scrols devem ficar para puxar a alavanca e ir pra arena de x1s 
        {{x = 2942, y = 1975, z = 7}, {x = 2944, y = 1975, z = 7}},
        {{x = 2949, y = 1970, z = 7}, {x = 2949, y = 1968, z = 7}},
        {{x = 2944, y = 1963, z = 7}, {x = 2942, y = 1963, z = 7}}
    },
    
    scroll_id = {11650, 11649}, -- Ids dos scrolss (1 elemento = primeira posicao ^ e 2 elemento = segunda posicao ^)
    arena_2_pos = {x = 2934, y = 1969, z = 6}, -- Pos da arena que tem os x1s (pra onde vao quando puxam a alavanca)
    
    arena_pos_1 = {x = 2942, y = 1974, z = 5}, -- Pos da arena que acontece o x1 (Pos do primeiro oponente)
    arena_pos_2 = {x = 2942, y = 1966, z = 5}, -- Pos da arena q acontece o x1 (Pos do segundo oponente)
    
    positions = {                     -- As 12 entradas da floresta
        {pos = {x = 2975, y = 1818, z = 7}, id = 11650}, 
        {pos = {x = 2785, y = 1944, z = 7}, id = 11649},
        {pos = {x = 2804, y = 2066, z = 7}, id = 11650},
        {pos = {x = 2852, y = 2100, z = 7}, id = 11649},
        {pos = {x = 2934, y = 2111, z = 7}, id = 11650}, 
        {pos = {x = 3096, y = 2004, z = 7}, id = 11649},
        {pos = {x = 3093, y = 1888, z = 7}, id = 11650},
        {pos = {x = 3049, y = 1844, z = 7}, id = 11649}, 
        {pos = {x = 2994, y = 1897, z = 7}, id = 11650}, 
        {pos = {x = 2842, y = 2018, z = 7}, id = 11649}, 
        {pos = {x = 2956, y = 2068, z = 7}, id = 11650}, 
        {pos = {x = 3023, y = 1944, z = 7}, id = 11649}
    },
    
    team_storage = 1928198,
    
    storage_x1 = 1884201,
}

function getFighters()
    local sto = getGlobalStorageValue(2381121)
    return sto < 0 and 0 or sto
end