local dfpwm = require("cc.audio.dfpwm")
local speakers = table.pack(peripheral.find("speaker"))
local speaker_calls = {}

local decoder = dfpwm.make_decoder()

function play(name)
  for i = 1, #speakers do
    speaker_calls[i] = function()
      for chunk in io.lines("./" .. name .. ".dfpwm", 16 * 1024) do
        local buffer = decoder(chunk)

        while not speakers[i].playAudio(buffer) do
          os.pullEvent("speaker_audio_empty")
        end
      end
    end
  end

  parallel.waitForAll(table.unpack(speaker_calls, 1, speakers.n))
end

while true do
  os.pullEvent("redstone")
  
  if rs.getInput("front") then
      play("no-fuel-beep")
  elseif rs.getInput("back") then
      play("fire-alarm")
  end
end
