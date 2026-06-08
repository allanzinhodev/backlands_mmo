HOTKEY = 'Ctrl+X'
MAP_SHADERS = {
["Default"] =  { name = 'Default', frag = 'shaders/default.frag'},
["Bloom"] = { name = 'Bloom', frag = 'shaders/bloom.frag' , time = 5000 },
["Inverted"] = { name = 'Inverted', frag = 'shaders/inverted.frag'},
["Infrared"] = { name = 'Infrared', frag = 'shaders/infrared.frag'},
["Sepia"] = { name = 'Sepia', frag ='shaders/sepia.frag' },
["Grayscale"] = { name = 'Grayscale', frag ='shaders/grayscale.frag', time = 5000 },
  { name = 'Pulse', frag = 'shaders/pulse.frag' },
   { name = 'Noise', frag = 'shaders/noise.frag' },
  { name = 'Old Tv', frag = 'shaders/oldtv.frag' },
  { name = 'Fog', frag = 'shaders/fog.frag', tex1 = 'images/clouds.png' },
  { name = 'Party', frag = 'shaders/party.frag' },
["Radial Blur"] = { name = 'Radial Blur', frag ='shaders/radialblur.frag'},
  { name = 'Zomg', frag ='shaders/zomg.frag' },
  { name = 'Heat', frag ='shaders/heat.frag' },
["Teste1"] = { name = 'teste1', frag ='shaders/teste1.frag', time = 20000  },
}

ITEM_SHADERS = {
  { name = 'Fake 3D', vert = 'shaders/fake3d.vert' }
}

shadersPanel = nil

function init()
  g_ui.importStyle('shaders.otui')

  --g_keyboard.bindKeyDown(HOTKEY, toggle)

  shadersPanel = g_ui.createWidget('ShadersPanel', modules.game_interface.getMapPanel())
  shadersPanel:hide()

  local mapComboBox = shadersPanel:getChildById('mapComboBox')
  mapComboBox.onOptionChange = function(combobox, option)
    local map = modules.game_interface.getMapPanel()
    map:setMapShader(g_shaders.getShader(option))
  end

  if not g_graphics.canUseShaders() then return end

  for _i,opts in pairs(MAP_SHADERS) do
    local shader = g_shaders.createFragmentShader(opts.name, opts.frag)

    if opts.tex1 then
      shader:addMultiTexture(opts.tex1)
    end
    if opts.tex2 then
      shader:addMultiTexture(opts.tex2)
    end

    mapComboBox:addOption(opts.name)
  end

  local map = modules.game_interface.getMapPanel()
  map:setMapShader(g_shaders.getShader('Default'))
end

ProtocolGame.registerExtendedOpcode(124, function (protocol, opcode, buffer) 
	local map = modules.game_interface.getMapPanel()
    map:setMapShader(g_shaders.getShader(buffer))
end)

 
function terminate()
  g_keyboard.unbindKeyDown(HOTKEY)
  shadersPanel:destroy()
end

function toggle()
  shadersPanel:setVisible(not shadersPanel:isVisible())
end
